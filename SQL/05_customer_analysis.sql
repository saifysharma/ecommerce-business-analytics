-- CUSTOMER ANALYSIS --

-- How many unique customers do we have, and how are they distributed across countries?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

SELECT
country,
COUNT(DISTINCT customer_id) as unique_customers
FROM customers
GROUP BY country
ORDER BY unique_customers DESC;

-- How has customer acquisition (new signups) changed over time?
SELECT
DATE_FORMAT(signup_date,'%Y-%m') as month,
COUNT(customer_id) as new_signups
FROM customers
GROUP BY DATE_FORMAT(signup_date,'%Y-%m')
ORDER BY month;

-- Who are the Top 10 customers by revenue?
WITH Customer_Revenue AS
(
 SELECT c.customer_id,
 c.name,
 SUM(o.total_usd) as revenue
 FROM customers c JOIN 
 orders o on 
 c.customer_id = o.customer_id
 GROUP BY c.customer_id,c.name
 ),
  Customer_Rank as
(  
  SELECT 
  customer_id, name,
  revenue,
  RANK() OVER(Order By revenue Desc) as cnk
  FROM Customer_Revenue
  )
  SELECT * FROM 
  Customer_Rank 
  WHERE cnk<=10;
  
-- Who are the most frequent purchasers?
    SELECT
    c.customer_id,c.name,
    COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY
    c.customer_id,
    c.name
    ORDER BY total_orders DESC;
    
-- How are customers distributed across High, Medium, and Low Customer Lifetime Value (CLV) segments?
WITH Customer_CLV AS
(
SELECT 
c.customer_id,c.name,
SUM(total_usd) as CLV
FROM customers c JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
)
SELECT 
CASE
WHEN CLV < 200 THEN 'Low CLV'
WHEN CLV BETWEEN 200 AND 500 THEN 'Medium CLV'
ELSE 'High CLV'
END AS CLV_Segment,
COUNT(customer_id) AS total_customers
FROM Customer_CLV
GROUP BY CLV_Segment;

-- What percentage of customers are repeat customers?
WITH Customer_Orders AS
(
SELECT 
customer_id,
COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY customer_id
),
Customer_Segments AS
(
SELECT
CASE 
WHEN Total_Orders >= 2 THEN 'Repeat Customers'
ELSE 'Normal Customers'
END AS customer_segment
FROM Customer_Orders
)
SELECT
customer_segment,
COUNT(*) AS customers,
ROUND(COUNT(*) * 100.0/ SUM(COUNT(*)) OVER(),2) AS percentage
FROM Customer_Segments
GROUP BY customer_segment;
