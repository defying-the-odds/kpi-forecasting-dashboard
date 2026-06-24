-- ================================================
-- Customer Analysis
-- Project: Business Performance KPI Forecasting
-- Dataset: Global Superstore (2011-2014)
-- ================================================

-- Query 11: Customer Lifetime Value by Segment
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

-- Query 12: Repeat Purchase Rate by Segment
WITH customer_orders AS (
    SELECT 
        [Customer ID],
        Segment,
        COUNT(DISTINCT [Order ID]) as total_orders
    FROM global_superstore_orders
    GROUP BY [Customer ID], Segment
)
SELECT 
    Segment,
    COUNT(*) as total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) as repeat_customers,
    ROUND(CAST(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS FLOAT) / 
        COUNT(*) * 100, 2) as repeat_rate_pct
FROM customer_orders
GROUP BY Segment
ORDER BY repeat_rate_pct DESC;

-- Query 13: Top 20 Customers by Revenue
SELECT 
    [Customer ID],
    [Customer Name],
    Segment,
    Market,
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(SUM(Sales), 2) as total_revenue,
    ROUND(SUM(Profit), 2) as total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) as margin_pct
FROM global_superstore_orders
GROUP BY [Customer ID], [Customer Name], Segment, Market
ORDER BY total_revenue DESC
LIMIT 20;

-- Query 14: Average Order Value by Segment and Market (Top 15)
WITH order_totals AS (
    SELECT 
        [Order ID],
        Segment,
        Market,
        SUM(Sales) as order_value
    FROM global_superstore_orders
    GROUP BY [Order ID], Segment, Market
)
SELECT 
    Segment,
    Market,
    COUNT(DISTINCT [Order ID]) as total_orders,
    ROUND(AVG(order_value), 2) as avg_order_value,
    ROUND(SUM(order_value), 2) as total_revenue
FROM order_totals
GROUP BY Segment, Market
ORDER BY avg_order_value DESC
LIMIT 15;

-- Query 15: New vs Returning Customers by Year
WITH first_purchase AS (
    SELECT 
        [Customer ID],
        MIN(strftime('%Y', [Order Date])) as first_year
    FROM global_superstore_orders
    GROUP BY [Customer ID]
),
yearly_customers AS (
    SELECT 
        strftime('%Y', o.[Order Date]) as year,
        o.[Customer ID],
        f.first_year
    FROM global_superstore_orders o
    JOIN first_purchase f ON o.[Customer ID] = f.[Customer ID]
    GROUP BY year, o.[Customer ID]
)
SELECT 
    year,
    COUNT(DISTINCT [Customer ID]) as total_customers,
    SUM(CASE WHEN year = first_year THEN 1 ELSE 0 END) as new_customers,
    SUM(CASE WHEN year != first_year THEN 1 ELSE 0 END) as returning_customers,
    ROUND(CAST(SUM(CASE WHEN year != first_year THEN 1 ELSE 0 END) AS FLOAT) / 
        COUNT(DISTINCT [Customer ID]) * 100, 2) as returning_rate_pct
FROM yearly_customers
GROUP BY year
ORDER BY year;
