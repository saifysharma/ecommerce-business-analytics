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
