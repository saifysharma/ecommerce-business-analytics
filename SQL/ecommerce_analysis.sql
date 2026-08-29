CREATE DATABASE Ecommerce_Analysis;
USE Ecommerce_Analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    country CHAR(2) NOT NULL,
    age INT CHECK (age >= 0),
    signup_date DATE,
    marketing_opt_in BOOLEAN NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    price_usd DECIMAL(10,2) NOT NULL,
    cost_usd DECIMAL(10,2) NOT NULL,
    margin_usd DECIMAL(10,2) NOT NULL
);

CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    device VARCHAR(20) NOT NULL,
    source VARCHAR(30) NOT NULL,
    country CHAR(2) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_time DATETIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    discount_pct INT NOT NULL,
    subtotal_usd DECIMAL(10,2) NOT NULL,
    total_usd DECIMAL(10,2) NOT NULL,
    country CHAR(2) NOT NULL,
    device VARCHAR(20) NOT NULL,
    source VARCHAR(30) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    unit_price_usd DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    line_total_usd DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


CREATE TABLE events (
    event_id INT PRIMARY KEY,
    session_id INT NOT NULL,
    timestamp DATETIME NOT NULL,
    event_type VARCHAR(30) NOT NULL,
    product_id INT,
    qty INT,
    cart_size INT,
    payment VARCHAR(30),
    discount_pct INT,
    amount_usd DECIMAL(10,2),

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_time DATETIME NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

select * from customers;
select * from products;
select * from sessions;
select * from orders;
select * from events;
select * from reviews;
select * from order_items;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE sessions;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE events;
DESCRIBE reviews;


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

-- PRODUCT ANALYSIS ---

-- Which products generate the highest revenue?
-- TOP 10 Products By Revenue
SELECT 
p.product_id,p.category,p.name,
SUM(oi.line_total_usd) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id,p.category,p.name
ORDER BY revenue DESC LIMIT 10;

-- Bottom 10 Products By Revenue
SELECT 
p.product_id,p.category,p.name,
SUM(oi.line_total_usd) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id,p.category,p.name
ORDER BY revenue ASC LIMIT 10;

-- Which product categories contribute the most revenue?
SELECT
p.category,
SUM(oi.line_total_usd) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Which products sell the highest number of units?
SELECT 
p.category,p.name,
SUM(quantity) AS Total_Units
FROM products p 
JOIN order_items oi
on p.product_id = oi.product_id
GROUP BY p.category,p.name
ORDER BY Total_Units DESC
LIMIT 10;

-- Which products generate the highest total profit?
SELECT 
p.category,p.name,
SUM(p.margin_usd*oi.quantity) AS Total_Profit
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category,p.name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Which products have the highest profit margin?
SELECT
category,name,
ROUND((margin_usd/price_usd)*100,2) AS profit_margin
FROM products
ORDER BY profit_margin DESC
LIMIT 10;

-- Which products contribute the most to overall revenue? (Revenue Contribution %)
WITH Product_Revenue AS
(
 SELECT p.category,p.name,
 SUM(oi.line_total_usd) AS revenue
 FROM products p 
 JOIN order_items oi
 ON p.product_id = oi.product_id
 GROUP BY p.category,p.name
 )
  SELECT
  category, name,
  revenue,
  ROUND((revenue*100/ SUM(revenue) OVER()),2) as revenue_contribution_pct
  FROM Product_Revenue
  ORDER BY revenue_contribution_pct DESC
  LIMIT 10;
  

-- MARKETING ANALYSIS --

-- Which traffic source brings the highest number of website sessions?
SELECT
source,
COUNT(session_id) AS Total_Sessions
FROM sessions
GROUP BY source
ORDER BY Total_Sessions DESC;

-- Which traffic source has the highest conversion rate?
WITH Session_Count AS
(
 SELECT
 source,
 COUNT(session_id) AS Total_Sessions
 FROM sessions
 GROUP BY source
 ),
  Order_Count AS
  (
   SELECT 
   source,
   COUNT(order_id) AS Total_Orders
   FROM orders
   GROUP BY source
   )
SELECT
s.source,s.Total_Sessions,
o.Total_Orders,
ROUND((o.Total_Orders*100.0/s.Total_Sessions),2) as Conversion_Rate
FROM Session_Count s 
JOIN Order_Count o
on s.source = o.source
ORDER BY Conversion_Rate DESC;

-- Which devices generate the highest conversion rate?
WITH Device_Count AS
(
 SELECT
 device,
 COUNT(session_id) AS Total_Sessions
 FROM sessions
 GROUP BY device
 ),
  Order_Count AS
  (
   SELECT 
   device,
   COUNT(order_id) AS Total_Orders
   FROM orders
   GROUP BY device
   )
SELECT
s.device,s.Total_Sessions,
o.Total_Orders,
ROUND((o.Total_Orders*100.0/s.Total_Sessions),2) as Conversion_Rate
FROM Device_Count s
JOIN Order_Count o
on s.device = o.device
ORDER BY Conversion_Rate DESC;

-- Which countries have the highest website-to-purchase conversion rate?
WITH Country_Count AS
(
 SELECT
 country,
 COUNT(session_id) AS Total_Sessions
 FROM sessions
 GROUP BY country
 ),
  Order_Count AS
  (
   SELECT 
   country,
   COUNT(order_id) AS Total_Orders
   FROM orders
   GROUP BY country
   )
SELECT
s.country,s.Total_Sessions,
o.Total_Orders,
ROUND((o.Total_Orders*100.0/s.Total_Sessions),2) as Conversion_Rate
FROM Country_Count s
JOIN Order_Count o
on s.country = o.country
ORDER BY Conversion_Rate DESC;


-- FUNNEL ANALYSIS --

-- How many Sessions, Product Views, Add-to-Cart events, Checkout events, and Purchases occurred?
  SELECT 'Sessions' AS Stage,COUNT(*) AS Total
  FROM sessions
  
  UNION ALL
  
  SELECT 'Page Views',COUNT(*) FROM
  events WHERE event_type ='page_view'
  
  UNION ALL
  
  SELECT 'Add to Cart',COUNT(*) FROM
  events WHERE event_type = 'add_to_cart'
  
  UNION ALL
  
  SELECT 'Checkout',COUNT(*) FROM
  events WHERE event_type = 'checkout'
  
  UNION ALL
  
  SELECT 'Purchase',COUNT(*) FROM
  events WHERE event_type = 'purchase';
  
  
-- What is the conversion rate between each funnel stage?

WITH Funnel AS
(
    SELECT
        event_type,
        COUNT(*) AS total_events
    FROM events
    GROUP BY event_type
)

SELECT
ROUND(
    (SELECT total_events
     FROM Funnel
     WHERE event_type = 'add_to_cart') * 100.0
    /
    (SELECT total_events
     FROM Funnel
     WHERE event_type = 'page_view')
,2) AS View_To_Cart,

ROUND(
    (SELECT total_events
     FROM Funnel
     WHERE event_type = 'checkout') * 100.0
    /
    (SELECT total_events
     FROM Funnel
     WHERE event_type = 'add_to_cart')
,2) AS Cart_To_Checkout,

ROUND(
    (SELECT total_events
     FROM Funnel
     WHERE event_type = 'purchase') * 100.0
    /
    (SELECT total_events
     FROM Funnel
     WHERE event_type = 'checkout')
,2) AS Checkout_To_Purchase;

-- At which stage do customers drop off the most?

WITH Funnel AS
(
    SELECT
        event_type,
        COUNT(*) AS total_events
    FROM events
    GROUP BY event_type
)

SELECT

ROUND(
100 -
(
(SELECT total_events FROM Funnel WHERE event_type='add_to_cart')*100.0
/
(SELECT total_events FROM Funnel WHERE event_type='page_view')
),2) AS View_To_Cart_Dropoff,

ROUND(
100 -
(
(SELECT total_events FROM Funnel WHERE event_type='checkout')*100.0
/
(SELECT total_events FROM Funnel WHERE event_type='add_to_cart')
),2) AS Cart_To_Checkout_Dropoff,

ROUND(
100 -
(
(SELECT total_events FROM Funnel WHERE event_type='purchase')*100.0
/
(SELECT total_events FROM Funnel WHERE event_type='checkout')
),2) AS Checkout_To_Purchase_Dropoff;


-- Which products receive many views but very few purchases?
WITH Product_Views AS
(
 SELECT product_id,
 COUNT(*) as total_views 
 FROM events
 WHERE event_type ='page_view'
 GROUP BY product_id
 ),
  Product_Purchases AS
  (
   SELECT product_id,
   SUM(quantity) as total_purchases
   FROM order_items
   GROUP BY product_id
   )
   SELECT 
   p.category,
   p.name,
   pv.total_views,
   pp.total_purchases,
   ROUND((pp.total_purchases *100.0/pv.total_views),2) AS purchase_rate
   FROM products p
   JOIN Product_Views pv
   ON p.product_id =pv.product_id
   JOIN Product_Purchases pp
   ON p.product_id = pp.product_id
   WHERE pv.total_views >= 500
   ORDER BY purchase_rate ASC
   LIMIT 10;
   
   
 -- What is the average cart size before purchase?
SELECT
ROUND(AVG(cart_size),2) AS avg_cart_size
FROM events
WHERE event_type ='checkout';

-- CUSTOMER SATISFACTION ANALYSIS --

-- Which products have the highest and lowest average ratings?
-- Highest Rated Products
SELECT
p.category,
p.name,
COUNT(r.review_id) AS total_reviews,
ROUND(AVG(r.rating),2) AS average_rating
FROM products p
JOIN reviews r
ON p.product_id = r.product_id
GROUP BY p.product_id,
p.category,p.name
HAVING COUNT(r.review_id) >= 5
ORDER BY average_rating DESC
LIMIT 10;

-- Lowest Rated Products 
SELECT
p.category,
p.name,
COUNT(r.review_id) AS total_reviews,
ROUND(AVG(r.rating),2) AS average_rating
FROM products p
JOIN reviews r
ON p.product_id = r.product_id
GROUP BY p.product_id,
p.category,p.name
HAVING COUNT(r.review_id) >= 5
ORDER BY average_rating ASC
LIMIT 10;

-- Is there a relationship between product ratings and sales performance?
WITH Product_Rating AS
(
 SELECT product_id,
 ROUND(AVG(rating),2) as average_rating,
 COUNT(*) AS total_reviews
 FROM reviews
 GROUP BY product_id
 ),
 Product_Sales AS
 (
  SELECT product_id,
  SUM(quantity) AS units_sold
  FROM order_items
  GROUP BY product_id
  )
  SELECT 
  p.category,p.name,
  pr.average_rating,
  pr.total_reviews,
  ps.units_sold
  FROM products p
  JOIN Product_Rating pr
  ON p.product_id = pr.product_id
  JOIN Product_Sales ps
  ON p.product_id = ps.product_id
  ORDER BY 
  ps.units_sold DESC limit 20;

  
   



