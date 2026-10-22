using System;
using WebApplication1.Models;

namespace WebApplication1.Helpers
{
    /// <summary>
    /// Shared view-helper methods used by both AdminPortal and CustomerPortal pages.
    /// </summary>
    public static class BoxFactoryHelpers
    {
        /// <summary>Returns the CSS badge class for a given order status string.</summary>
        public static string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "confirmed";
            switch (status.ToLower())
            {
                case "confirmed":     return "confirmed";
                case "in production": return "in-production";
                case "quality check": return "quality-check";
                case "dispatched":    return "dispatched";
                case "delivered":     return "delivered";
                case "pending":       return "pending";
                default:              return "confirmed";
            }
        }

        /// <summary>Returns the CSS badge class for an inventory level string.</summary>
        public static string GetLevelClass(string level)
        {
            if (string.IsNullOrEmpty(level)) return "ok";
            switch (level.ToLower())
            {
                case "good": return "good";
                case "low":  return "low";
                default:     return "ok";
            }
        }

        /// <summary>Returns a short human-readable spec string (e.g. "5 Ply &middot; 150 GSM").</summary>
        public static string GetSpecsText(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return $"{spec.Ply} &middot; {spec.GSM}";
            return "5 Ply &middot; 150 GSM";
        }

        /// <summary>Returns spec summary identical to GetSpecsText (retained for template compatibility).</summary>
        public static string GetSpecSummary(object specsObj)
        {
            return GetSpecsText(specsObj);
        }

        /// <summary>Returns a formatted dimensions string (e.g. "Dimensions: 40&times;30&times;25 cm").</summary>
        public static string GetSpecDimensions(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return $"Dimensions: {spec.DimensionsFormatted}";
            return "Dimensions: 40&times;30&times;25 cm";
        }

        /// <summary>Returns the BaseRatePerBox as a whole-number string.</summary>
        public static string GetSpecRate(object specsObj)
        {
            if (specsObj is BoxSpecification spec)
                return spec.BaseRatePerBox.ToString("0");
            return "48";
        }

        /// <summary>Formats a DateTime object as "dd MMM yyyy".</summary>
        public static string FormatDate(object dtObj)
        {
            if (dtObj is DateTime dt)
                return dt.ToString("dd MMM yyyy");
            return "18 Oct 2026";
        }
    }
}
