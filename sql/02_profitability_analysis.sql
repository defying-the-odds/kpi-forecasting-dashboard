-- ================================================
-- Profitability Analysis
-- Project: Business Performance KPI Forecasting
-- Dataset: Global Superstore (2011-2014)
-- ================================================

-- Query 6: Gross Margin by Month
SELECT 
    strftime('%Y-%m', [Order Date]) as month,
    ROUND(SUM(Sales), 2) as monthly_revenue,
    ROUND(SUM(Profit), 2) as monthly_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as gross_margin_pct
FROM global_superstore_orders
GROUP BY month
ORDER BY month;

-- Query 7: Gross Margin by Sub-Category (Lowest First)
SELECT 
    Category,
    [Sub-Category],
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as gross_margin_pct
FROM global_superstore_orders
GROUP BY Category, [Sub-Category]
ORDER BY gross_margin_pct ASC;

-- Query 8: Gross Margin by Market with Average Discount
SELECT 
    Market,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as gross_margin_pct,
    ROUND(AVG(Discount)*100, 2) as avg_discount_pct
FROM global_superstore_orders
GROUP BY Market
ORDER BY gross_margin_pct ASC;

-- Query 9: Loss Leaders (Negative Profit Sub-Categories)
SELECT 
    [Sub-Category],
    Category,
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
GROUP BY [Sub-Category], Category
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- Query 10: Discount Impact on Profit
SELECT 
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.1 THEN '1-10%'
        WHEN Discount <= 0.2 THEN '11-20%'
        WHEN Discount <= 0.3 THEN '21-30%'
        WHEN Discount <= 0.4 THEN '31-40%'
        ELSE '40%+'
    END as discount_bucket,
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
GROUP BY discount_bucket
ORDER BY margin_pct DESC;
