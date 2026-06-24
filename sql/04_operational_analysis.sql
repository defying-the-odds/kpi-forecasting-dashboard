-- ================================================
-- Operational Analysis
-- Project: Business Performance KPI Forecasting
-- Dataset: Global Superstore (2011-2014)
-- ================================================

-- Query 16: Order Fulfillment Time Overall
SELECT 
    ROUND(AVG(julianday([Ship Date]) - julianday([Order Date])), 1) as avg_fulfillment_days,
    MIN(CAST(julianday([Ship Date]) - julianday([Order Date]) AS INTEGER)) as min_days,
    MAX(CAST(julianday([Ship Date]) - julianday([Order Date]) AS INTEGER)) as max_days,
    COUNT(DISTINCT [Order ID]) as total_orders
FROM global_superstore_orders
WHERE [Ship Date] IS NOT NULL;

-- Query 17: Fulfillment Time by Ship Mode
SELECT 
    [Ship Mode],
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(AVG(julianday([Ship Date]) - julianday([Order Date])), 1) as avg_fulfillment_days,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
WHERE [Ship Date] IS NOT NULL
GROUP BY [Ship Mode]
ORDER BY avg_fulfillment_days ASC;

-- Query 18: Fulfillment Time by Market
SELECT 
    Market,
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(AVG(julianday([Ship Date]) - julianday([Order Date])), 1) as avg_fulfillment_days,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
WHERE [Ship Date] IS NOT NULL
GROUP BY Market
ORDER BY avg_fulfillment_days DESC;

-- Query 19: Note — No orders exceeded 7 days fulfillment time
-- Maximum fulfillment time in dataset is 7 days (confirmed via Query 16)
-- This indicates consistent, reliable fulfillment across all markets

-- Query 20: Return Rate by Category
SELECT 
    o.Category,
    COUNT(DISTINCT o.[Order ID]) as total_orders,
    COUNT(DISTINCT r.[Order ID]) as returned_orders,
    ROUND(CAST(COUNT(DISTINCT r.[Order ID]) AS FLOAT) / 
        COUNT(DISTINCT o.[Order ID]) * 100, 2) as return_rate_pct,
    ROUND(SUM(o.Sales), 2) as total_revenue
FROM global_superstore_orders o
LEFT JOIN global_superstore_returns r ON o.[Order ID] = r.[Order ID]
GROUP BY o.Category
ORDER BY return_rate_pct DESC;
