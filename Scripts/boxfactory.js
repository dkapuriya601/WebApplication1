/**
 * BoxFactory Management System - Client Application Engine
 * Reproduces the exact Figma interactions, data flows, and UI states.
 */

(function () {
  'use strict';

  // Master State
  var state = {
    screen: 'role-select', // 'role-select', 'admin-login', 'customer-login', 'admin-portal', 'customer-portal'
    adminTab: 'dashboard', // 'dashboard', 'orders', 'inventory', 'customers'
    customerTab: 'home',   // 'home', 'place-order', 'track-order', 'my-orders'
    orderSearchQuery: '',
    orderStatusFilter: 'All',
    customerSearchQuery: '',
    customerSegmentFilter: 'All',
    inventoryTab: 'raw',   // 'raw', 'finished'
    activeCustomerId: 'CUST-001',
    customers: [],
    orders: [],
    rawMaterials: [],
    finishedStock: [],
    machines: [],
    // New Order Modal Form State
    newOrderForm: {
      type: 'repeat', // 'repeat' or 'new-company'
      customerId: '',
      companyName: '',
      city: '',
      contactPerson: '',
      email: '',
      ply: '5 Ply',
      gsm: '150 GSM',
      length: 40,
      width: 30,
      height: 25,
      rate: 48,
      quantity: 100,
      notes: ''
    }
  };

  // Initialize Data
  function initData() {
    var stored = localStorage.getItem('boxfactory_state_v1');
    if (stored) {
      try {
        var parsed = JSON.parse(stored);
        state.customers = parsed.customers || [];
        state.orders = parsed.orders || [];
        state.rawMaterials = parsed.rawMaterials || [];
        state.finishedStock = parsed.finishedStock || [];
        state.machines = parsed.machines || [];
      } catch (e) {
        console.error('Error parsing stored state', e);
      }
    }

    // Fallback or seed from server preloaded data
    if (!state.customers.length && window.preloadedBoxData) {
      state.customers = window.preloadedBoxData.customers || [];
      state.orders = window.preloadedBoxData.orders || [];
      state.rawMaterials = window.preloadedBoxData.rawMaterials || [];
      state.finishedStock = window.preloadedBoxData.finishedStock || [];
      state.machines = window.preloadedBoxData.machines || [];
      saveState();
    }
  }

  function saveState() {
    localStorage.setItem('boxfactory_state_v1', JSON.stringify({
      customers: state.customers,
      orders: state.orders,
      rawMaterials: state.rawMaterials,
      finishedStock: state.finishedStock,
      machines: state.machines
    }));
  }

  // Toast Notification
  function showToast(message) {
    var toast = document.getElementById('toastNotification');
    if (!toast) return;
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(function () {
      toast.classList.remove('show');
    }, 3200);
  }

  // Navigation Switcher
  function switchScreen(screenName) {
    state.screen = screenName;
    document.querySelectorAll('.screen-view').forEach(function (el) {
      el.classList.remove('active-screen');
    });

    var target = document.getElementById('screen-' + screenName);
    if (target) {
      target.classList.add('active-screen');
    }

    // Update preview nav buttons
    document.querySelectorAll('.preview-nav-btn').forEach(function (btn) {
      btn.classList.remove('active', 'active-purple');
      var targetAttr = btn.getAttribute('data-target-screen');
      var targetTab = btn.getAttribute('data-target-tab');

      if (targetAttr === screenName) {
        if (targetTab) {
          if ((screenName === 'admin-portal' && state.adminTab === targetTab) ||
              (screenName === 'customer-portal' && state.customerTab === targetTab)) {
            btn.classList.add(screenName === 'admin-portal' ? 'active' : 'active-purple');
          }
        } else {
          btn.classList.add(screenName === 'customer-login' ? 'active-purple' : 'active');
        }
      }
    });

    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  function switchAdminTab(tabName) {
    state.adminTab = tabName;
    document.querySelectorAll('#screen-admin-portal .portal-tab-content').forEach(function (el) {
      el.style.display = 'none';
    });

    var targetContent = document.getElementById('admin-tab-' + tabName);
    if (targetContent) {
      targetContent.style.display = 'block';
    }

    document.querySelectorAll('#screen-admin-portal .sidebar-nav-item').forEach(function (nav) {
      nav.classList.toggle('active', nav.getAttribute('data-tab') === tabName);
    });

    // Update topbar title
    var titleEl = document.getElementById('adminPageTitle');
    if (titleEl) {
      var titles = {
        'dashboard': 'Dashboard',
        'orders': 'Orders',
        'inventory': 'Inventory',
        'customers': 'Customers'
      };
      titleEl.textContent = titles[tabName] || 'Admin Portal';
    }

    renderAdminPortal();
  }

  function switchCustomerTab(tabName) {
    state.customerTab = tabName;
    document.querySelectorAll('#screen-customer-portal .portal-tab-content').forEach(function (el) {
      el.style.display = 'none';
    });

    var targetContent = document.getElementById('customer-tab-' + tabName);
    if (targetContent) {
      targetContent.style.display = 'block';
    }

    document.querySelectorAll('#screen-customer-portal .sidebar-nav-item').forEach(function (nav) {
      nav.classList.toggle('active', nav.getAttribute('data-tab') === tabName);
    });

    // Update topbar title
    var titleEl = document.getElementById('customerPageTitle');
    if (titleEl) {
      var titles = {
        'home': 'Home',
        'place-order': 'Place Order',
        'track-order': 'Track Order',
        'my-orders': 'My Orders'
      };
      titleEl.textContent = titles[tabName] || 'Customer Portal';
    }

    renderCustomerPortal();
  }

  // Render Admin Dashboard
  function renderAdminDashboard() {
    var tbody = document.getElementById('adminRecentOrdersTbody');
    if (!tbody) return;

    var recentOrders = state.orders.slice(0, 5);
    var html = '';

    recentOrders.forEach(function (o) {
      var statusClass = getStatusClass(o.Status);
      html += '<tr>' +
        '<td><span class="order-id-link">' + escapeHtml(o.Id) + '</span></td>' +
        '<td><div class="order-company-title">' + escapeHtml(o.CompanyName) + '</div></td>' +
        '<td><strong>' + Number(o.Quantity).toLocaleString() + '</strong></td>' +
        '<td><span class="badge-status ' + statusClass + '">' + escapeHtml(o.Status) + '</span></td>' +
      '</tr>';
    });

    tbody.innerHTML = html;

    // Render Machines
    var machinesContainer = document.getElementById('adminMachinesList');
    if (machinesContainer && state.machines) {
      var mHtml = '';
      state.machines.forEach(function (m) {
        var statusBadgeClass = 'badge-running';
        var fillClass = 'running';
        if (m.Status.toLowerCase() === 'idle') {
          statusBadgeClass = 'badge-idle';
          fillClass = 'idle';
        } else if (m.Status.toLowerCase() === 'maintenance') {
          statusBadgeClass = 'badge-maintenance';
          fillClass = 'maintenance';
        }

        mHtml += '<div class="machine-item-card">' +
          '<div class="machine-header-row">' +
            '<span class="machine-name">' + escapeHtml(m.Name) + '</span>' +
            '<span class="badge-machine ' + statusBadgeClass + '">' + escapeHtml(m.Status) + '</span>' +
          '</div>' +
          '<div class="machine-metric-subtext">' + escapeHtml(m.SpeedMetric) + '</div>' +
          '<div class="machine-progress-track">' +
            '<div class="machine-progress-fill ' + fillClass + '" style="width: ' + m.ProgressPercent + '%;"></div>' +
          '</div>' +
        '</div>';
      });
      machinesContainer.innerHTML = mHtml;
    }
  }

  // Render Admin Orders
  function renderAdminOrders() {
    var tbody = document.getElementById('adminAllOrdersTbody');
    if (!tbody) return;

    var filtered = state.orders.filter(function (o) {
      var matchesSearch = !state.orderSearchQuery ||
        o.Id.toLowerCase().indexOf(state.orderSearchQuery.toLowerCase()) !== -1 ||
        o.CompanyName.toLowerCase().indexOf(state.orderSearchQuery.toLowerCase()) !== -1;

      var matchesStatus = state.orderStatusFilter === 'All' ||
        o.Status.toLowerCase() === state.orderStatusFilter.toLowerCase();

      return matchesSearch && matchesStatus;
    });

    var html = '';
    filtered.forEach(function (o) {
      var statusClass = getStatusClass(o.Status);
      var specText = o.Specs ? (o.Specs.Ply + ' · ' + o.Specs.GSM + '<br/><span class="box-spec-subtext">' + o.Specs.DimensionsFormatted + '</span>') : 'Standard Spec';
      var firstOrderBadge = o.IsFirstOrder ? '<span class="badge-status first-order-badge" style="margin-left: 6px;">FIRST ORDER</span>' : '';
      var placedIcon = o.PlacedBy === 'Admin' ? '🛠 Admin' : '👤 Customer';
      var dueDateText = o.DueDate ? formatDate(o.DueDate) : '18 Oct 2026';

      html += '<tr>' +
        '<td><span class="order-id-link">' + escapeHtml(o.Id) + '</span>' + firstOrderBadge + '</td>' +
        '<td><div class="order-company-title">' + escapeHtml(o.CompanyName) + '</div></td>' +
        '<td>' + specText + '</td>' +
        '<td><strong>' + Number(o.Quantity).toLocaleString() + '</strong></td>' +
        '<td><strong>\u20B9' + Number(o.TotalPrice).toLocaleString('en-IN') + '</strong></td>' +
        '<td><span style="font-size: 12px; color: #475569;">' + placedIcon + '</span></td>' +
        '<td>' +
          '<select class="form-control-input" style="padding: 4px 8px; font-size: 11px; width: auto; font-weight: 600;" onchange="window.BoxApp.updateOrderStatus(\'' + o.Id + '\', this.value)">' +
            getStatusOptionsHtml(o.Status) +
          '</select>' +
        '</td>' +
        '<td><span style="font-size: 12px; color: #64748b;">' + dueDateText + '</span></td>' +
        '<td>' +
          '<button class="btn-table-action" onclick="window.BoxApp.viewOrderInvoice(\'' + o.Id + '\')">View</button>' +
        '</td>' +
      '</tr>';
    });

    if (!filtered.length) {
      html = '<tr><td colspan="9" style="text-align:center; padding: 32px; color: #94a3b8;">No orders found matching the filter criteria.</td></tr>';
    }

    tbody.innerHTML = html;
  }

  // Render Admin Inventory
  function renderAdminInventory() {
    var rawTbody = document.getElementById('inventoryRawMaterialsTbody');
    var finTbody = document.getElementById('inventoryFinishedStockTbody');

    if (rawTbody) {
      var rHtml = '';
      state.rawMaterials.forEach(function (item) {
        var levelBadge = 'badge-running';
        if (item.Level.toLowerCase() === 'low') levelBadge = 'badge-maintenance';
        else if (item.Level.toLowerCase() === 'ok') levelBadge = 'badge-idle';

        rHtml += '<tr>' +
          '<td><strong>' + escapeHtml(item.Sku) + '</strong><br/><span style="font-size:12px; color:#64748b;">' + escapeHtml(item.Name) + '</span></td>' +
          '<td><strong>' + Number(item.StockQty).toLocaleString() + ' ' + item.Unit + '</strong></td>' +
          '<td>' + Number(item.ReorderAt).toLocaleString() + ' ' + item.Unit + '</td>' +
          '<td><span class="badge-machine ' + levelBadge + '">' + escapeHtml(item.Level) + '</span></td>' +
          '<td>' + escapeHtml(item.Supplier) + '</td>' +
          '<td><button class="btn-table-action" onclick="window.BoxApp.restockModal(\'' + item.Sku + '\')">+ Restock</button></td>' +
        '</tr>';
      });
      rawTbody.innerHTML = rHtml;
    }

    if (finTbody) {
      var fHtml = '';
      state.finishedStock.forEach(function (fin) {
        fHtml += '<tr>' +
          '<td><strong>' + escapeHtml(fin.ItemCode) + '</strong><br/><span style="font-size:12px; color:#64748b;">' + escapeHtml(fin.Description) + '</span></td>' +
          '<td>' + escapeHtml(fin.BoxSpecs) + '</td>' +
          '<td><strong>' + Number(fin.AvailableQty).toLocaleString() + ' boxes</strong></td>' +
          '<td>' + Number(fin.ReservedQty).toLocaleString() + ' (' + escapeHtml(fin.ReservedFor) + ')</td>' +
          '<td>' + escapeHtml(fin.Pallets) + '</td>' +
          '<td><span class="badge-status completed">' + escapeHtml(fin.Status) + '</span></td>' +
        '</tr>';
      });
      finTbody.innerHTML = fHtml;
    }
  }

  // Render Admin Customers
  function renderAdminCustomers() {
    var grid = document.getElementById('adminCustomersGrid');
    if (!grid) return;

    var filtered = state.customers.filter(function (c) {
      var matchesSearch = !state.customerSearchQuery ||
        c.Name.toLowerCase().indexOf(state.customerSearchQuery.toLowerCase()) !== -1 ||
        c.City.toLowerCase().indexOf(state.customerSearchQuery.toLowerCase()) !== -1;

      var matchesSegment = state.customerSegmentFilter === 'All' ||
        c.Segment.toLowerCase() === state.customerSegmentFilter.toLowerCase();

      return matchesSearch && matchesSegment;
    });

    var html = '';
    filtered.forEach(function (c) {
      html += '<div class="customer-card-item" onclick="window.BoxApp.viewCustomerDetail(\'' + c.Id + '\')">' +
        '<div class="customer-card-top">' +
          '<div style="display:flex; align-items:center; gap: 12px;">' +
            '<div class="customer-avatar-box" style="background-color: ' + (c.AvatarColor || '#0d9488') + ';">' + escapeHtml(c.AvatarInitials || 'CO') + '</div>' +
            '<div>' +
              '<div class="customer-card-name">' + escapeHtml(c.Name) + '</div>' +
              '<div class="customer-card-city">' + escapeHtml(c.City) + '</div>' +
            '</div>' +
          '</div>' +
          '<span class="badge-machine badge-running">Active</span>' +
        '</div>' +
        '<div class="customer-card-badges">' +
          '<span class="badge-segment">' + escapeHtml(c.Segment) + '</span>' +
        '</div>' +
        '<div class="customer-card-stats-row">' +
          '<div>' +
            '<div class="stat-sub-label">Orders</div>' +
            '<div class="stat-sub-val">' + c.TotalOrders + '</div>' +
          '</div>' +
          '<div style="text-align: right;">' +
            '<div class="stat-sub-label">Total Spent</div>' +
            '<div class="stat-sub-val">' + (c.TotalSpentFormatted || ('\u20B9' + Math.round(c.TotalSpent / 1000) + 'K')) + '</div>' +
          '</div>' +
        '</div>' +
      '</div>';
    });

    if (!filtered.length) {
      html = '<div style="grid-column: 1/-1; text-align:center; padding: 40px; color: #94a3b8;">No customers match the selected filter.</div>';
    }

    grid.innerHTML = html;
  }

  // Render Customer Portal
  function renderCustomerPortal() {
    var customer = state.customers.find(function (c) { return c.Id === state.activeCustomerId; }) || state.customers[0];
    if (!customer) return;

    // Update Banner Info
    var welcomeCustName = document.getElementById('custWelcomeName');
    if (welcomeCustName) welcomeCustName.textContent = customer.Name;

    var custIdTag = document.getElementById('custIdTag');
    if (custIdTag) custIdTag.textContent = customer.Id + ' | ' + customer.City;

    // Filter customer orders
    var myOrders = state.orders.filter(function (o) {
      return o.CustomerId === customer.Id || o.CompanyName.toLowerCase() === customer.Name.toLowerCase();
    });

    var activeCount = myOrders.filter(function (o) {
      return o.Status.toLowerCase() !== 'delivered';
    }).length;

    var custStatOrders = document.getElementById('custStatOrders');
    if (custStatOrders) custStatOrders.textContent = myOrders.length;

    var custStatActive = document.getElementById('custStatActive');
    if (custStatActive) custStatActive.textContent = activeCount;

    // Render Saved Specs on Customer Home
    var spec = customer.DefaultSpec;
    if (spec) {
      if (document.getElementById('custSpecPly')) document.getElementById('custSpecPly').textContent = spec.Ply;
      if (document.getElementById('custSpecGsm')) document.getElementById('custSpecGsm').textContent = spec.GSM;
      if (document.getElementById('custSpecDims')) document.getElementById('custSpecDims').textContent = spec.DimensionsFormatted;
      if (document.getElementById('custSpecRate')) document.getElementById('custSpecRate').textContent = '\u20B9' + spec.BaseRatePerBox + '/box';

      // Saved spec alert banner on Place Order
      if (document.getElementById('placeOrderSpecInline')) {
        document.getElementById('placeOrderSpecInline').textContent = spec.Ply + ' · ' + spec.GSM + ' · ' + spec.DimensionsFormatted;
      }
      if (document.getElementById('summaryBoxType')) document.getElementById('summaryBoxType').textContent = spec.Ply;
      if (document.getElementById('summaryBoxGsm')) document.getElementById('summaryBoxGsm').textContent = spec.GSM;
      if (document.getElementById('summaryBoxSize')) document.getElementById('summaryBoxSize').textContent = spec.DimensionsFormatted;
      if (document.getElementById('summaryBoxRate')) document.getElementById('summaryBoxRate').textContent = '\u20B9' + spec.BaseRatePerBox + '/box';
    }

    // Render Recent Order in Customer Home
    var recentTbody = document.getElementById('custRecentOrderTbody');
    if (recentTbody) {
      var rHtml = '';
      var latest = myOrders.slice(0, 2);
      latest.forEach(function (o) {
        rHtml += '<tr>' +
          '<td><strong>' + escapeHtml(o.Id) + '</strong></td>' +
          '<td><strong>\u20B9' + Number(o.TotalPrice).toLocaleString('en-IN') + '</strong></td>' +
          '<td><span class="badge-status ' + getStatusClass(o.Status) + '">' + escapeHtml(o.Status) + '</span></td>' +
        '</tr>';
      });
      recentTbody.innerHTML = rHtml || '<tr><td colspan="3" style="text-align:center; color:#94a3b8;">No recent orders</td></tr>';
    }

    // Render All Orders in My Orders (Page 5 Bottom)
    var allTbody = document.getElementById('custAllOrdersTbody');
    if (allTbody) {
      var aHtml = '';
      myOrders.forEach(function (o) {
        var specText = o.Specs ? (o.Specs.Ply + ' · ' + o.Specs.GSM) : '5 Ply · 150 GSM';
        var repeatBadge = o.IsRepeatOrder ? '<span class="badge-status first-order-badge" style="background:#ede9fe; color:#6d28d9; border-color:#ddd6fe; margin-left:6px;">REPEAT ORDER</span>' : '';
        var placedDate = o.PlacedDate ? formatDate(o.PlacedDate) : '12 Oct 2026';
        var etaText = o.Status.toLowerCase() === 'delivered' ? 'Delivered' : (o.ETA || '20 Oct 2026');

        aHtml += '<tr>' +
          '<td><span class="order-id-link">' + escapeHtml(o.Id) + '</span>' + repeatBadge + '</td>' +
          '<td>' + specText + '</td>' +
          '<td><strong>' + Number(o.Quantity).toLocaleString() + '</strong></td>' +
          '<td><strong>\u20B9' + Number(o.TotalPrice).toLocaleString('en-IN') + '</strong></td>' +
          '<td><span style="font-size: 12px; color: #64748b;">' + placedDate + '</span></td>' +
          '<td><span style="font-size: 12px; font-weight:600; color: #334155;">' + etaText + '</span></td>' +
          '<td><span class="badge-status ' + getStatusClass(o.Status) + '">' + escapeHtml(o.Status) + '</span></td>' +
          '<td><button class="btn-table-action" onclick="window.BoxApp.viewOrderInvoice(\'' + o.Id + '\')">Receipt</button></td>' +
        '</tr>';
      });
      allTbody.innerHTML = aHtml;
    }

    // Update Place Order Summary calculation
    updatePlaceOrderSummary();

    // Render Active Order Tracking (Page 5 Middle)
    renderActiveOrderTracking(myOrders);
  }

  function renderActiveOrderTracking(myOrders) {
    var card = document.getElementById('custTrackingCardContainer');
    if (!card) return;

    var activeOrder = myOrders.find(function (o) { return o.Id === 'ORD-1041'; }) ||
                      myOrders.find(function (o) { return o.Status.toLowerCase() !== 'delivered'; }) ||
                      myOrders[0];

    if (!activeOrder) {
      card.innerHTML = '<div style="text-align:center; padding: 30px; color:#94a3b8;">No active orders found to track.</div>';
      return;
    }

    var step = activeOrder.StatusStep || 2;
    var stepsDef = [
      { num: 1, label: 'Order Confirmed' },
      { num: 2, label: 'In Production' },
      { num: 3, label: 'Quality Check' },
      { num: 4, label: 'Dispatched' },
      { num: 5, label: 'Delivered' }
    ];

    var stepperHtml = '<div class="timeline-stepper">';
    stepsDef.forEach(function (s) {
      var stateClass = '';
      var icon = s.num;
      if (s.num < step) {
        stateClass = 'completed';
        icon = '✓';
      } else if (s.num === step) {
        stateClass = 'active';
        icon = '●';
      }
      stepperHtml += '<div class="step-node-item ' + stateClass + '">' +
        '<div class="step-circle">' + icon + '</div>' +
        '<div class="step-label">' + s.label + '</div>' +
      '</div>';
    });
    stepperHtml += '</div>';

    var html = '<div class="active-order-tracking-card">' +
      '<div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">' +
        '<div>' +
          '<h3 style="font-size:18px; font-weight:700; color:#0f172a;">' + escapeHtml(activeOrder.Id) + '</h3>' +
          '<div style="font-size:13px; color:#64748b; margin-top:2px;">' + (activeOrder.Specs ? activeOrder.Specs.Ply : '5 Ply') + ' • ' + Number(activeOrder.Quantity).toLocaleString() + ' boxes • ' + (activeOrder.DueDate ? formatDate(activeOrder.DueDate) : '18 Oct 2026') + '</div>' +
        '</div>' +
        '<span class="badge-status ' + getStatusClass(activeOrder.Status) + '" style="font-size: 13px; padding: 4px 12px;">' + escapeHtml(activeOrder.Status) + '</span>' +
      '</div>' +
      stepperHtml +
      '<div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:16px; margin-top:20px; font-size:13px; display:grid; grid-template-columns: repeat(3, 1fr); gap:16px;">' +
        '<div><span style="color:#64748b; font-size:11px; display:block;">Production Line</span><strong>Cutter A & Printer 1</strong></div>' +
        '<div><span style="color:#64748b; font-size:11px; display:block;">Estimated Dispatch</span><strong>' + (activeOrder.ETA || '20 Oct 2026') + '</strong></div>' +
        '<div><span style="color:#64748b; font-size:11px; display:block;">Carrier</span><strong>Apex Express Cargo</strong></div>' +
      '</div>' +
    '</div>';

    card.innerHTML = html;
  }

  function updatePlaceOrderSummary() {
    var qtyInput = document.getElementById('placeOrderQtyInput');
    if (!qtyInput) return;

    var qty = parseInt(qtyInput.value, 10) || 0;
    var customer = state.customers.find(function (c) { return c.Id === state.activeCustomerId; }) || state.customers[0];
    var rate = customer && customer.DefaultSpec ? customer.DefaultSpec.BaseRatePerBox : 48;
    var total = qty * rate;

    var qtySummary = document.getElementById('summaryBoxQty');
    if (qtySummary) qtySummary.textContent = Number(qty).toLocaleString() + ' boxes';

    var totalSummary = document.getElementById('summaryTotalVal');
    if (totalSummary) totalSummary.textContent = '\u20B9' + Number(total).toLocaleString('en-IN');
  }

  function renderAdminPortal() {
    renderAdminDashboard();
    renderAdminOrders();
    renderAdminInventory();
    renderAdminCustomers();
  }

  // Helpers
  function getStatusClass(status) {
    if (!status) return 'in-production';
    var s = status.toLowerCase();
    if (s.indexOf('prod') !== -1) return 'in-production';
    if (s.indexOf('disp') !== -1) return 'dispatched';
    if (s.indexOf('comp') !== -1 || s.indexOf('deliv') !== -1) return 'completed';
    if (s.indexOf('plan') !== -1 || s.indexOf('conf') !== -1) return 'planning';
    if (s.indexOf('check') !== -1 || s.indexOf('qc') !== -1) return 'quality-check';
    return 'in-production';
  }

  function getStatusOptionsHtml(currentStatus) {
    var statuses = ['Confirmed', 'In Production', 'Quality Check', 'Dispatched', 'Delivered'];
    var html = '';
    statuses.forEach(function (s) {
      var sel = s.toLowerCase() === currentStatus.toLowerCase() ? ' selected' : '';
      html += '<option value="' + s + '"' + sel + '>' + s + '</option>';
    });
    return html;
  }

  function formatDate(d) {
    var date = new Date(d);
    if (isNaN(date.getTime())) return d;
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return date.getDate() + ' ' + months[date.getMonth()] + ' ' + date.getFullYear();
  }

  function escapeHtml(str) {
    if (str === null || str === undefined) return '';
    return String(str).replace(/[&<>"']/g, function (m) {
      return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' })[m];
    });
  }

  // Public API for Window
  window.BoxApp = {
    // Navigation
    showScreen: function (name) {
      switchScreen(name);
    },
    showAdminTab: function (tab) {
      switchScreen('admin-portal');
      switchAdminTab(tab);
    },
    showCustomerTab: function (tab) {
      switchScreen('customer-portal');
      switchCustomerTab(tab);
    },

    // Login Actions
    loginAsAdmin: function (email, pass) {
      showToast('Welcome, Factory Manager! Admin access granted.');
      switchScreen('admin-portal');
      switchAdminTab('dashboard');
    },
    loginAsCustomer: function (email, pass) {
      showToast('Welcome back, Apex Logistics! Portal loaded.');
      switchScreen('customer-portal');
      switchCustomerTab('home');
    },
    quickFillAdmin: function () {
      var e = document.getElementById('adminLoginEmail');
      var p = document.getElementById('adminLoginPassword');
      if (e) e.value = 'admin@boxfactory.in';
      if (p) p.value = 'admin123';
      showToast('Admin demo credentials populated!');
    },
    quickFillCustomer: function () {
      var e = document.getElementById('customerLoginEmail');
      var p = document.getElementById('customerLoginPassword');
      if (e) e.value = 'logistics@apex.com';
      if (p) p.value = 'apex123';
      showToast('Customer demo credentials populated!');
    },
    togglePassword: function (inputId) {
      var input = document.getElementById(inputId);
      if (input) {
        input.type = input.type === 'password' ? 'text' : 'password';
      }
    },

    // Filter Handlers
    setOrderStatusFilter: function (status) {
      state.orderStatusFilter = status;
      document.querySelectorAll('#ordersFilterPills .filter-pill-btn').forEach(function (btn) {
        btn.classList.toggle('active', btn.getAttribute('data-status') === status);
      });
      renderAdminOrders();
    },
    handleOrderSearch: function (val) {
      state.orderSearchQuery = val;
      renderAdminOrders();
    },
    setCustomerSegmentFilter: function (segment) {
      state.customerSegmentFilter = segment;
      document.querySelectorAll('#customersFilterPills .filter-pill-btn').forEach(function (btn) {
        btn.classList.toggle('active', btn.getAttribute('data-segment') === segment);
      });
      renderAdminCustomers();
    },
    handleCustomerSearch: function (val) {
      state.customerSearchQuery = val;
      renderAdminCustomers();
    },
    setInventoryTab: function (tab) {
      state.inventoryTab = tab;
      document.querySelectorAll('.inventory-tab-btn').forEach(function (b) {
        b.classList.toggle('active', b.getAttribute('data-inv-tab') === tab);
      });
      document.getElementById('inventoryRawMaterialsSection').style.display = tab === 'raw' ? 'block' : 'none';
      document.getElementById('inventoryFinishedStockSection').style.display = tab === 'finished' ? 'block' : 'none';
    },

    // Status Update
    updateOrderStatus: function (orderId, newStatus) {
      var order = state.orders.find(function (o) { return o.Id === orderId; });
      if (order) {
        order.Status = newStatus;
        switch (newStatus.toLowerCase()) {
          case 'confirmed': order.StatusStep = 1; break;
          case 'in production': order.StatusStep = 2; break;
          case 'quality check': order.StatusStep = 3; break;
          case 'dispatched': order.StatusStep = 4; break;
          case 'delivered': order.StatusStep = 5; break;
        }
        saveState();
        renderAdminPortal();
        renderCustomerPortal();
        showToast('Order ' + orderId + ' updated to ' + newStatus);
      }
    },

    // New Order Modals (Step 1, Step 2a, Step 2b)
    openNewOrderModal: function () {
      document.getElementById('modalNewOrderStep1').classList.add('modal-open');
    },
    closeModal: function (modalId) {
      var m = document.getElementById(modalId);
      if (m) m.classList.remove('modal-open');
    },
    selectOrderType: function (type) {
      window.BoxApp.closeModal('modalNewOrderStep1');
      if (type === 'repeat') {
        window.BoxApp.openRepeatOrderModal();
      } else {
        window.BoxApp.openFirstOrderModal();
      }
    },
    openRepeatOrderModal: function () {
      var select = document.getElementById('repeatOrderCompanySelect');
      if (select) {
        var opts = '<option value="">-- choose company --</option>';
        state.customers.forEach(function (c) {
          opts += '<option value="' + c.Id + '">' + escapeHtml(c.Name) + '</option>';
        });
        select.innerHTML = opts;
      }
      document.getElementById('repeatOrderSpecPreview').style.display = 'none';
      document.getElementById('repeatOrderQty').value = '100';
      document.getElementById('repeatOrderTotal').textContent = 'Total: \u20B94,800';
      document.getElementById('modalRepeatOrder').classList.add('modal-open');
    },
    handleRepeatCompanyChange: function (custId) {
      var preview = document.getElementById('repeatOrderSpecPreview');
      var customer = state.customers.find(function (c) { return c.Id === custId; });
      if (customer && customer.DefaultSpec) {
        var spec = customer.DefaultSpec;
        preview.style.display = 'block';
        preview.innerHTML = '<strong>' + escapeHtml(customer.Name) + ' Saved Spec:</strong> ' +
          spec.Ply + ' · ' + spec.GSM + ' · ' + spec.DimensionsFormatted + ' (Rate: \u20B9' + spec.BaseRatePerBox + '/box)';
        window.BoxApp.updateRepeatOrderPrice();
      } else {
        preview.style.display = 'none';
      }
    },
    updateRepeatOrderPrice: function () {
      var custId = document.getElementById('repeatOrderCompanySelect').value;
      var qty = parseInt(document.getElementById('repeatOrderQty').value, 10) || 0;
      var customer = state.customers.find(function (c) { return c.Id === custId; });
      var rate = customer && customer.DefaultSpec ? customer.DefaultSpec.BaseRatePerBox : 48;
      var total = qty * rate;
      document.getElementById('repeatOrderTotal').textContent = 'Total: \u20B9' + Number(total).toLocaleString('en-IN');
    },
    submitRepeatOrder: function () {
      var custId = document.getElementById('repeatOrderCompanySelect').value;
      if (!custId) {
        alert('Please select a company to continue.');
        return;
      }
      var qty = parseInt(document.getElementById('repeatOrderQty').value, 10) || 100;
      var notes = document.getElementById('repeatOrderNotes').value;
      var customer = state.customers.find(function (c) { return c.Id === custId; });
      var spec = customer.DefaultSpec || { Ply: '5 Ply', GSM: '150 GSM', DimensionsFormatted: '40×30×25 cm', BaseRatePerBox: 48 };

      var newId = 'ORD-' + (1042 + state.orders.length);
      var newOrder = {
        Id: newId,
        CustomerId: customer.Id,
        CompanyName: customer.Name,
        Specs: spec,
        Quantity: qty,
        UnitPrice: spec.BaseRatePerBox,
        TotalPrice: qty * spec.BaseRatePerBox,
        PlacedBy: 'Admin',
        PlacedDate: new Date().toISOString(),
        DueDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        ETA: 'In 5-7 days',
        Status: 'In Production',
        StatusStep: 2,
        IsFirstOrder: false,
        IsRepeatOrder: true,
        Notes: notes
      };

      state.orders.unshift(newOrder);
      customer.TotalOrders += 1;
      customer.TotalSpent += newOrder.TotalPrice;
      saveState();

      window.BoxApp.closeModal('modalRepeatOrder');
      renderAdminPortal();
      renderCustomerPortal();
      showToast('Repeat order ' + newId + ' placed for ' + customer.Name + '!');
    },

    openFirstOrderModal: function () {
      document.getElementById('modalFirstOrder').classList.add('modal-open');
      window.BoxApp.calculateFirstOrderPrice();
    },
    selectPlyOption: function (ply) {
      state.newOrderForm.ply = ply;
      document.querySelectorAll('#firstOrderPlyGroup .segmented-ply-btn').forEach(function (btn) {
        btn.classList.toggle('active', btn.getAttribute('data-ply') === ply);
      });
      window.BoxApp.calculateFirstOrderPrice();
    },
    calculateFirstOrderPrice: function () {
      var ply = state.newOrderForm.ply || '5 Ply';
      var rate = 48;
      if (ply.indexOf('3') !== -1) rate = 32;
      else if (ply.indexOf('7') !== -1) rate = 68;

      var qty = parseInt(document.getElementById('firstOrderQty').value, 10) || 100;
      var total = qty * rate;
      var totalEl = document.getElementById('firstOrderTotalPreview');
      if (totalEl) totalEl.textContent = 'Total: \u20B9' + Number(total).toLocaleString('en-IN');
    },
    submitFirstOrder: function () {
      var companyName = document.getElementById('firstOrderCompanyName').value.trim();
      var city = document.getElementById('firstOrderCity').value.trim() || 'Mumbai, MH';
      var contact = document.getElementById('firstOrderContact').value.trim() || 'Manager';
      var email = document.getElementById('firstOrderEmail').value.trim() || 'contact@company.com';

      if (!companyName) {
        alert('Please enter company name.');
        return;
      }

      var ply = state.newOrderForm.ply || '5 Ply';
      var gsm = document.getElementById('firstOrderGsm').value;
      var l = parseFloat(document.getElementById('firstOrderL').value) || 40;
      var w = parseFloat(document.getElementById('firstOrderW').value) || 30;
      var h = parseFloat(document.getElementById('firstOrderH').value) || 25;
      var qty = parseInt(document.getElementById('firstOrderQty').value, 10) || 100;
      var notes = document.getElementById('firstOrderNotes').value;

      var rate = ply.indexOf('3') !== -1 ? 32 : (ply.indexOf('7') !== -1 ? 68 : 48);

      var newCustId = 'CUST-00' + (state.customers.length + 1);
      var parts = companyName.split(' ');
      var initials = parts.length > 1 ? (parts[0][0] + parts[1][0]).toUpperCase() : companyName.substring(0, 2).toUpperCase();

      var newCust = {
        Id: newCustId,
        Name: companyName,
        City: city,
        ContactPerson: contact,
        Email: email,
        Phone: '+91 98000 00000',
        Address: companyName + ' Facility, ' + city,
        Segment: 'Mid-Market',
        Status: 'Active',
        TotalOrders: 1,
        TotalSpent: qty * rate,
        TotalSpentFormatted: '\u20B9' + Math.round((qty * rate) / 1000) + 'K',
        AvatarInitials: initials,
        AvatarColor: '#0d9488',
        DefaultSpec: {
          Ply: ply,
          GSM: gsm,
          Length: l,
          Width: w,
          Height: h,
          BaseRatePerBox: rate,
          DimensionsFormatted: l + '×' + w + '×' + h + ' cm',
          SummaryFormatted: ply + ' · ' + gsm + ' / ' + l + '×' + w + '×' + h + ' cm'
        }
      };

      state.customers.push(newCust);

      var newOrderId = 'ORD-' + (1042 + state.orders.length);
      var newOrder = {
        Id: newOrderId,
        CustomerId: newCustId,
        CompanyName: companyName,
        Specs: newCust.DefaultSpec,
        Quantity: qty,
        UnitPrice: rate,
        TotalPrice: qty * rate,
        PlacedBy: 'Admin',
        PlacedDate: new Date().toISOString(),
        DueDate: new Date(Date.now() + 7 * 86400000).toISOString(),
        ETA: 'In 5-7 days',
        Status: 'Confirmed',
        StatusStep: 1,
        IsFirstOrder: true,
        IsRepeatOrder: false,
        Notes: notes
      };

      state.orders.unshift(newOrder);
      saveState();

      window.BoxApp.closeModal('modalFirstOrder');
      renderAdminPortal();
      showToast('Created new company ' + companyName + ' and Order ' + newOrderId + '!');
    },

    // Customer Place Order Action
    submitCustomerOrder: function () {
      var qtyInput = document.getElementById('placeOrderQtyInput');
      var qty = parseInt(qtyInput.value, 10) || 100;
      var notes = document.getElementById('placeOrderNotes').value;
      var address = document.getElementById('placeOrderAddress').value;
      var contact = document.getElementById('placeOrderPhone').value;

      var customer = state.customers.find(function (c) { return c.Id === state.activeCustomerId; }) || state.customers[0];
      var spec = customer.DefaultSpec || { Ply: '5 Ply', GSM: '150 GSM', DimensionsFormatted: '40×30×25 cm', BaseRatePerBox: 48 };

      var newId = 'ORD-' + (1042 + state.orders.length);
      var newOrder = {
        Id: newId,
        CustomerId: customer.Id,
        CompanyName: customer.Name,
        Specs: spec,
        Quantity: qty,
        UnitPrice: spec.BaseRatePerBox,
        TotalPrice: qty * spec.BaseRatePerBox,
        PlacedBy: 'Customer',
        PlacedDate: new Date().toISOString(),
        DueDate: new Date(Date.now() + 6 * 86400000).toISOString(),
        ETA: 'Est. 5-7 days',
        Status: 'In Production',
        StatusStep: 2,
        IsFirstOrder: false,
        IsRepeatOrder: true,
        Notes: notes,
        DeliveryAddress: address,
        ContactNumber: contact
      };

      state.orders.unshift(newOrder);
      customer.TotalOrders += 1;
      customer.TotalSpent += newOrder.TotalPrice;
      saveState();

      renderCustomerPortal();
      renderAdminPortal();
      showToast('Order ' + newId + ' placed successfully! Sent to production.');
      switchCustomerTab('track-order');
    },

    // Restock Modal
    restockModal: function (sku) {
      var item = state.rawMaterials.find(function (m) { return m.Sku === sku; });
      if (!item) return;

      var amount = prompt('Restock ' + item.Name + ' (' + item.Sku + ')\nEnter quantity to add (' + item.Unit + '):', '500');
      if (amount && !isNaN(parseFloat(amount))) {
        var addVal = parseFloat(amount);
        item.StockQty += addVal;
        if (item.StockQty >= item.ReorderAt * 1.5) item.Level = 'Good';
        else if (item.StockQty >= item.ReorderAt) item.Level = 'OK';
        saveState();
        renderAdminInventory();
        showToast('Restocked ' + item.Sku + ' with +' + addVal + ' ' + item.Unit + '!');
      }
    },

    // Customer Detail Modal
    viewCustomerDetail: function (custId) {
      var c = state.customers.find(function (cust) { return cust.Id === custId; });
      if (!c) return;

      var spec = c.DefaultSpec || { Ply: '5 Ply', GSM: '150 GSM', DimensionsFormatted: '40×30×25 cm', BaseRatePerBox: 48 };
      var html = '<div style="display:flex; align-items:center; gap:14px; margin-bottom:16px;">' +
        '<div class="customer-avatar-box" style="background-color:' + (c.AvatarColor || '#0d9488') + '; width:50px; height:50px; font-size:18px;">' + escapeHtml(c.AvatarInitials) + '</div>' +
        '<div>' +
          '<h3 style="font-size:20px; font-weight:700;">' + escapeHtml(c.Name) + '</h3>' +
          '<div style="font-size:13px; color:#64748b;">' + escapeHtml(c.City) + ' • ' + escapeHtml(c.Segment) + '</div>' +
        '</div>' +
      '</div>' +
      '<div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:10px; padding:16px; margin-bottom:16px;">' +
        '<div style="font-size:11px; font-weight:700; color:#64748b; text-transform:uppercase; margin-bottom:8px;">Saved Box Specification</div>' +
        '<div style="font-size:15px; font-weight:700; color:#0f172a;">' + spec.Ply + ' · ' + spec.GSM + '</div>' +
        '<div style="font-size:13px; color:#475569; margin-top:2px;">Dimensions: ' + spec.DimensionsFormatted + ' | Standard Rate: \u20B9' + spec.BaseRatePerBox + '/box</div>' +
      '</div>' +
      '<div style="font-size:13px; margin-bottom:16px;">' +
        '<div><strong>Contact:</strong> ' + escapeHtml(c.ContactPerson || 'Primary Contact') + '</div>' +
        '<div><strong>Email:</strong> ' + escapeHtml(c.Email) + '</div>' +
        '<div><strong>Total Orders:</strong> ' + c.TotalOrders + ' | <strong>Total Spent:</strong> ' + (c.TotalSpentFormatted || ('\u20B9' + c.TotalSpent)) + '</div>' +
      '</div>' +
      '<div style="display:flex; justify-content:flex-end;">' +
        '<button class="btn-primary-teal" style="width:auto; padding:8px 18px;" onclick="window.BoxApp.closeModal(\'modalGeneric\')">Close</button>' +
      '</div>';

      document.getElementById('genericModalTitle').textContent = 'Customer Profile';
      document.getElementById('genericModalBody').innerHTML = html;
      document.getElementById('modalGeneric').classList.add('modal-open');
    },

    // Invoice Modal
    viewOrderInvoice: function (orderId) {
      var o = state.orders.find(function (ord) { return ord.Id === orderId; });
      if (!o) return;

      var spec = o.Specs || { Ply: '5 Ply', GSM: '150 GSM', DimensionsFormatted: '40×30×25 cm' };
      var html = '<div style="border-bottom:1px solid #e2e8f0; padding-bottom:16px; margin-bottom:16px; display:flex; justify-content:space-between; align-items:flex-start;">' +
        '<div>' +
          '<div style="font-size:18px; font-weight:800; color:#0f172a;">BoxFactory Packaging Ltd.</div>' +
          '<div style="font-size:12px; color:#64748b;">Industrial Area Phase II, Maharashtra, India</div>' +
        '</div>' +
        '<div style="text-align:right;">' +
          '<span class="badge-status ' + getStatusClass(o.Status) + '">' + escapeHtml(o.Status) + '</span>' +
          '<div style="font-size:13px; font-weight:700; margin-top:4px;">' + escapeHtml(o.Id) + '</div>' +
        '</div>' +
      '</div>' +
      '<div style="font-size:13px; margin-bottom:16px;">' +
        '<div><strong>Billed To:</strong> ' + escapeHtml(o.CompanyName) + '</div>' +
        '<div><strong>Placed By:</strong> ' + escapeHtml(o.PlacedBy) + ' on ' + (o.PlacedDate ? formatDate(o.PlacedDate) : '12 Oct 2026') + '</div>' +
        '<div><strong>Delivery Address:</strong> ' + escapeHtml(o.DeliveryAddress || 'On file') + '</div>' +
      '</div>' +
      '<table class="data-table" style="margin-bottom:16px;">' +
        '<thead><tr><th>Description</th><th>Qty</th><th>Rate</th><th style="text-align:right;">Amount</th></tr></thead>' +
        '<tbody><tr>' +
          '<td>Corrugated Box (' + spec.Ply + ', ' + spec.GSM + ')<br/><span style="font-size:11px; color:#64748b;">' + spec.DimensionsFormatted + '</span></td>' +
          '<td>' + Number(o.Quantity).toLocaleString() + '</td>' +
          '<td>\u20B9' + o.UnitPrice + '</td>' +
          '<td style="text-align:right;"><strong>\u20B9' + Number(o.TotalPrice).toLocaleString('en-IN') + '</strong></td>' +
        '</tr></tbody>' +
      '</table>' +
      '<div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid #e2e8f0; padding-top:12px;">' +
        '<div style="font-size:12px; color:#64748b;">Includes 18% GST & Shipping</div>' +
        '<div style="font-size:18px; font-weight:800; color:#0f172a;">Total: \u20B9' + Number(o.TotalPrice).toLocaleString('en-IN') + '</div>' +
      '</div>' +
      '<div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">' +
        '<button class="btn-secondary-outline" onclick="window.print()">Print Receipt</button>' +
        '<button class="btn-primary-teal" style="width:auto; padding:8px 18px;" onclick="window.BoxApp.closeModal(\'modalGeneric\')">Done</button>' +
      '</div>';

      document.getElementById('genericModalTitle').textContent = 'Order Receipt & Invoice';
      document.getElementById('genericModalBody').innerHTML = html;
      document.getElementById('modalGeneric').classList.add('modal-open');
    },

    // Reset All Data to Figma Defaults
    resetAllData: function () {
      localStorage.removeItem('boxfactory_state_v1');
      if (window.preloadedBoxData) {
        state.customers = window.preloadedBoxData.customers || [];
        state.orders = window.preloadedBoxData.orders || [];
        state.rawMaterials = window.preloadedBoxData.rawMaterials || [];
        state.finishedStock = window.preloadedBoxData.finishedStock || [];
        state.machines = window.preloadedBoxData.machines || [];
      }
      saveState();
      renderAdminPortal();
      renderCustomerPortal();
      showToast('Reset state to original Figma design data.');
    }
  };

  function bindInteractiveInputs() {
    var placeOrderQty = document.getElementById('placeOrderQtyInput');
    if (placeOrderQty) {
      placeOrderQty.removeEventListener('input', updatePlaceOrderSummary);
      placeOrderQty.addEventListener('input', updatePlaceOrderSummary);
    }

    var repeatOrderQty = document.getElementById('repeatOrderQty');
    if (repeatOrderQty) {
      repeatOrderQty.removeEventListener('input', window.BoxApp.updateRepeatOrderPrice);
      repeatOrderQty.addEventListener('input', window.BoxApp.updateRepeatOrderPrice);
    }

    var firstOrderQty = document.getElementById('firstOrderQty');
    if (firstOrderQty) {
      firstOrderQty.removeEventListener('input', window.BoxApp.calculateFirstOrderPrice);
      firstOrderQty.addEventListener('input', window.BoxApp.calculateFirstOrderPrice);
    }
  }

  // DOM Loaded Event
  document.addEventListener('DOMContentLoaded', function () {
    initData();
    renderAdminPortal();
    renderCustomerPortal();
    bindInteractiveInputs();

    // ASP.NET UpdatePanel integration
    if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
      Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        initData();
        bindInteractiveInputs();
      });
    }
  });

})();
