-- ================================================
-- SQL Views
-- Project: Business Performance KPI Forecasting
-- Dataset: Global Superstore (2011-2014)
-- ================================================

-- View 1: Monthly Revenue
CREATE VIEW vw_monthly_revenue AS
SELECT 
    strftime('%Y-%m', [Order Date]) as month,
    ROUND(SUM(Sales), 2) as monthly_revenue,
    ROUND(SUM(Profit), 2) as monthly_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
GROUP BY month
ORDER BY month;

-- View 2: Gross Margin by Sub-Category
CREATE VIEW vw_gross_margin_by_category AS
SELECT 
    Category,
    [Sub-Category],
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as gross_margin_pct,
    ROUND(AVG(Discount)*100, 2) as avg_discount_pct
FROM global_superstore_orders
GROUP BY Category, [Sub-Category]
ORDER BY gross_margin_pct ASC;

-- View 3: Customer Lifetime Value by Segment
CREATE VIEW vw_clv_by_segment AS
WITH customer_totals AS (
    SELECT 
        [Customer ID],
        Segment,
        ROUND(SUM(Sales), 2) as total_spent,
        COUNT(DISTINCT [Order ID]) as total_orders
    FROM global_superstore_orders
    GROUP BY [Customer ID], Segment
)
SELECT 
    Segment,
    COUNT(DISTINCT [Customer ID]) as total_customers,
    ROUND(AVG(total_spent), 2) as avg_clv,
    ROUND(AVG(total_orders), 2) as avg_orders_per_customer,
    ROUND(SUM(total_spent), 2) as total_revenue
FROM customer_totals
GROUP BY Segment
ORDER BY avg_clv DESC;

-- View 4: Fulfillment Time by Market and Ship Mode
CREATE VIEW vw_fulfillment_time AS
SELECT 
    Market,
    [Ship Mode],
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(AVG(julianday([Ship Date]) - julianday([Order Date])), 1) as avg_fulfillment_days,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
WHERE [Ship Date] IS NOT NULL
GROUP BY Market, [Ship Mode]
ORDER BY avg_fulfillment_days DESC;

-- View 5: Return Rates by Category and Market
CREATE VIEW vw_return_rates AS
SELECT 
    o.Category,
    o.Market,
    COUNT(DISTINCT o.[Order ID]) as total_orders,
    COUNT(DISTINCT r.[Order ID]) as returned_orders,
    ROUND(CAST(COUNT(DISTINCT r.[Order ID]) AS FLOAT) / 
        COUNT(DISTINCT o.[Order ID]) * 100, 2) as return_rate_pct,
    ROUND(SUM(o.Sales), 2) as total_revenue
FROM global_superstore_orders o
LEFT JOIN global_superstore_returns r ON o.[Order ID] = r.[Order ID]
GROUP BY o.Category, o.Market
ORDER BY return_rate_pct DESC;
