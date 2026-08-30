--  SALES PERFORMANCE ANALYSIS ---

-- What are the Total Revenue, Total Orders, and Average Order Value
SELECT 
SUM(total_usd) as Total_Revenue,
Count(*) as Total_Orders,
Avg(total_usd) as Avg_order_value
FROM orders;

-- How has monthly revenue changed over time?
WITH Monthly_Sales As
(
SELECT 
DATE_FORMAT(order_time,'%Y-%m') as month,
SUM(total_usd) as revenue
FROM orders
GROUP BY 
DATE_FORMAT(order_time,'%Y-%m')
)
SELECT month,revenue,
LAG(revenue) OVER(order by month ) as previous_month_revenue,
revenue - LAG(revenue) OVER(order by month) as revenue_change 
FROM Monthly_Sales;

-- Which months generated the highest and lowest revenue?
WITH Monthly_Revenue AS
(
SELECT
DATE_FORMAT(order_time,'%Y-%m') as month,
SUM(total_usd) as revenue
FROM orders
GROUP BY 
DATE_FORMAT(order_time,'%Y-%m')
)
(
SELECT 
'Lowest Revenue' as Type,
month,
revenue
FROM Monthly_Revenue
ORDER BY revenue ASC limit 1
)
UNION ALL
(
SELECT
'Highest Revenue' as Type,
month,
revenue
FROM Monthly_Revenue
ORDER BY revenue DESC limit 1
);

-- Which countries generate the highest revenue?
SELECT 
country,
SUM(total_usd) as revenue
FROM orders
GROUP BY country
ORDER BY revenue DESC;

-- Which payment methods are most frequently used?
SELECT 
payment_method,
COUNT(*) as total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- How do discounts affect order values?
SELECT
discount_pct,
Avg(total_usd) as Avg_order_value
FROM orders
GROUP BY discount_pct
ORDER BY discount_pct;

-- Which devices generate the highest revenue?
SELECT
device,
SUM(total_usd) as revenue
FROM orders
GROUP BY device
ORDER BY revenue DESC;

-- Which traffic sources generate the highest revenue?
SELECT
source,
SUM(total_usd) as revenue
FROM orders
GROUP BY source
ORDER BY revenue DESC;
