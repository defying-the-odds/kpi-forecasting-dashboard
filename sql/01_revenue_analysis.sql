-- ================================================
-- Revenue Analysis
-- Project: Business Performance KPI Forecasting
-- Dataset: Global Superstore (2011-2014)
-- ================================================

-- Query 1: Monthly Revenue Trend
SELECT 
    strftime('%Y-%m', [Order Date]) as month,
    ROUND(SUM(Sales), 2) as monthly_revenue,
    ROUND(SUM(Profit), 2) as monthly_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
GROUP BY month
ORDER BY month;

-- Query 2: Revenue by Category
SELECT 
    Category,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct,
    COUNT(DISTINCT [Order ID]) as total_orders
FROM global_superstore_orders
GROUP BY Category
ORDER BY total_revenue DESC;

-- Query 3: Revenue by Market
SELECT 
    Market,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct,
    COUNT(DISTINCT [Order ID]) as total_orders
FROM global_superstore_orders
GROUP BY Market
ORDER BY total_revenue DESC;

-- Query 4: Revenue by Customer Segment
SELECT 
    Segment,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct,
    COUNT(DISTINCT [Order ID]) as total_orders
FROM global_superstore_orders
GROUP BY Segment
ORDER BY total_revenue DESC;

-- Query 5: Rolling 3-Month Average Revenue
WITH monthly AS (
    SELECT 
        strftime('%Y-%m', [Order Date]) as month,
        ROUND(SUM(Sales), 2) as monthly_revenue
    FROM global_superstore_orders
    GROUP BY month
)
SELECT 
    month,
    monthly_revenue,
    ROUND(AVG(monthly_revenue) OVER (
        ORDER BY month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) as rolling_3mo_avg
FROM monthly
ORDER BY month;
