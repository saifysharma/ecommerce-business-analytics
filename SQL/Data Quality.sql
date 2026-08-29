-- DATA QUALITY ANALYSIS 
-- Q1 How many records are present in each table?
SELECT 'customers' as table_name, COUNT(*) as total_records 
FROM customers
UNION ALL
SELECT 'products', COUNT(*)
FROM products
UNION ALL
SELECT 'sessions', COUNT(*)
FROM sessions
UNION ALL
SELECT 'orders' , COUNT(*)
FROM orders
UNION ALL
SELECT 'order_items', COUNT(*)
FROM order_items
UNION ALL
SELECT 'events', COUNT(*)
FROM events
UNION ALL
SELECT 'reviews' , COUNT(*)
FROM reviews;

-- Q2. Are there any duplicate primary keys in each table?
SELECT  
customer_id
FROM customers
GROUP BY customer_id
HAVING Count(*)>1;

SELECT 
product_id
FROM products
GROUP BY product_id
HAVING Count(*)>1;

SELECT 
session_id
FROM sessions
GROUP BY session_id
HAVING Count(*)>1;

SELECT 
order_id
FROM orders
GROUP BY order_id
HAVING Count(*)>1;

SELECT 
event_id
FROM events
GROUP BY event_id
HAVING Count(*)>1;

SELECT
review_id
FROM reviews
GROUP BY review_id
HAVING Count(*)>1;

-- Q3. Are there any missing values in important columns?
SELECT * FROM customers
WHERE customer_id IS NULL
OR name IS NULL
OR email IS NULL
OR country IS NULL
OR age IS NULL
OR signup_date IS NULL;

SELECT * FROM products
WHERE product_id IS NULL
OR category IS NULL
OR price_usd IS NULL
OR cost_usd IS NULL;

SELECT * FROM  sessions
WHERE session_id IS NULL
OR customer_id IS NULL
OR start_time IS NULL
OR device IS NULL
OR source IS NULL;

SELECT * FROM orders
WHERE order_id IS NULL
OR customer_id IS NULL
OR order_time IS NULL
OR payment_method IS NULL
OR total_usd IS NULL;

SELECT * FROM order_items
WHERE order_id IS NULL
OR product_id IS NULL
OR unit_price_usd IS NULL
OR quantity IS NULL
OR line_total_usd IS NULL;

SELECT * FROM events
WHERE event_id IS NULL
OR session_id IS NULL
OR timestamp IS NULL
OR event_type IS NULL;

SELECT * FROM reviews
WHERE review_id IS NULL
OR order_id IS NULL
OR product_id IS NULL
OR rating IS NULL
OR review_text IS NULL
OR review_time IS NULL;

-- Are there any invalid values (negative prices, quantities, ratings, discounts, etc.)?
SELECT  * From customers
WHERE age < 0;

SELECT * From products
WHERE price_usd < 0
OR cost_usd < 0;

SELECT * From orders
WHERE total_usd < 0;

SELECT * From order_items
WHERE unit_price_usd < 0
OR quantity <= 0
OR line_total_usd < 0;

SELECT * FROM events
WHERE qty < 0
OR cart_size < 0
OR discount_pct < 0
OR discount_pct > 100
OR amount_usd < 0;

SELECT * FROM reviews
WHERE rating < 1
OR rating > 5;

-- Are the relationships between tables valid? (Check foreign key integrity.)
SELECT *
FROM sessions s
LEFT JOIN customers c
ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT *
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT *
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT *
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
