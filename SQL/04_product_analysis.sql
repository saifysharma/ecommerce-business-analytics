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
