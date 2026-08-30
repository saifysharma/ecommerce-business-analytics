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
