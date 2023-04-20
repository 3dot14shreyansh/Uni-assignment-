
-- Table 1 : ORDER_DELIVERY_STATUS

-- Creating table structure
CREATE TABLE ORDER_DELIVERY_STATUS
 (
  CREATEDAT          DATETIME NOT NULL,
  USER               VARCHAR(15) NOT NULL,
  ORDERID            VARCHAR(20) NOT NULL,
  ORDER_STATUS ENUM  ('SUCCESS', 'FAILED') NOT NULL,
  ORDER_VALUE        DECIMAL(10,2) NOT NULL,
  ORDER_TIME         DATETIME NOT NULL,
  DISPATCH_TIME      DATETIME,
  DELIVERY_TIME      DATETIME
);

-- Inserting values in table 1
INSERT INTO ORDER_DELIVERY_STATUS (CREATEDAT, USER, ORDERID, ORDER_STATUS, ORDER_VALUE, ORDER_TIME, DISPATCH_TIME, DELIVERY_TIME)
VALUES
('2023-03-24 14:16:08.014', 'U190700758579', '01232324625141', 'SUCCESS', 231, '2023-02-04 14:16:08.014', '2023-02-04 14:36:23.314', '2023-02-04 14:48:14.134'),
('2023-04-20 18:15:59.757', 'U646676718541', '011500462514887', 'FAILED', 349, '2023-03-20 18:15:59.757', NULL, NULL),
('2023-04-19 18:15:59.757', 'U646676718541', '011500462514887', 'SUCCESS', 349, '2023-03-20 18:15:59.757', NULL, NULL),
('2023-04-18 12:34:36.280', 'U625531195136', '0444100385783', 'SUCCESS', 764, '2023-03-04 12:34:36.280', '2023-03-04 12:55:19.280', '2023-03-04 13:19:20.810'),
('2023-04-17 12:34:36.280', 'U625531195136', '0444100385783', 'SUCCESS', 764, '2023-03-04 12:34:36.280', '2023-03-04 12:55:19.280', '2023-03-04 13:19:20.810'),
('2023-04-19 12:34:36.280', 'U625531195136', '0444100385783', 'SUCCESS', 764, '2023-03-04 12:34:36.280', '2023-03-04 12:55:19.280', '2023-03-04 13:19:20.810'),
('2023-04-16 17:25:27.842', 'U467553267383', '09605167892082', 'FAILED', 238, '2023-03-16 17:25:27.842', '2023-03-16 17:40:22.121', '2023-03-16 17:53:34.855'),
('2023-04-01 14:25:42.051', 'U993673261796', '0414284010976', 'SUCCESS', 126, '2023-03-01 14:25:42.051', '2023-03-01 14:32:12.231', '2023-03-01 14:52:43.726');





-- Table 2 : ORDER_CITY_RESTAURANT 

-- Creating table structure
CREATE TABLE ORDER_CITY_RESTAURANT 
(
  ORDERID      VARCHAR(20) NOT NULL,
  CITY         VARCHAR(50) NOT NULL,
  RESTAURANTS  VARCHAR(50) NOT NULL
);

-- Inserting values in table 2
INSERT INTO ORDER_CITY_RESTAURANT (ORDERID, CITY, RESTAURANTS)
VALUES
('01232324625141', 'Delhi', 'Prime Mart'),
('011500462514887', 'Bengaluru', 'Shyam Ji Chole Bhature'),
('0444100385783', 'Chennai', 'Sangeetha Res.'),
('09605167892082', 'Bengaluru', 'Polar Bear'),
('0414284010976', 'Mumbai', 'Dominos');





-- Table 3 : ORDER_DETAILS 

-- Creating table structure
CREATE TABLE ORDER_DETAILS 
(
  ORDERID         VARCHAR(20) NOT NULL,
  ORDER_ITEMID    VARCHAR(15) NOT NULL,
  ORDER_TYPE ENUM ('Food', 'Groceries') NOT NULL,
  ORDER_CATEGORY  VARCHAR(50) NOT NULL
);

-- Inserting values in table 3
INSERT INTO ORDER_DETAILS (ORDERID, ORDER_ITEMID, ORDER_TYPE, ORDER_CATEGORY)
VALUES
('01232324625141', '00ID35435435', 'Groceries', 'Soap'),
('01232324625141', '00ID23243332', 'Groceries', 'Cold Drinks'),
('011500462514887', '00ID21312323', 'Food', 'Chole Bhature'),
('0444100385783', '00ID56434276', 'Food', 'Dosa'),
('0444100385783', '00ID78787234', 'Food', 'Executive Thali'),
('09605167892082', '00ID09203223', 'Food', 'Sundaes'),
('0414284010976', '00ID09908981', 'Food', 'Pizza');




-- Solutions


/* 
Question 1 :
Day on Day numbers for - Orders, Order Value, Users, Successful Orders, Successful Order Value, Successful Number of Users.
*/

-- Soultion 1.1 : Day on Day numbers for - Orders
SELECT 
  DATE(CREATEDAT) AS date,
  COUNT(ORDERID) AS total_orders
FROM
  ORDER_DELIVERY_STATUS
GROUP BY
  DATE(CREATEDAT)
ORDER BY
  DATE(CREATEDAT);

-- Soultion 1.2 : Day on Day numbers for - Order Value
SELECT 
  DATE(CREATEDAT) AS date,
  SUM(ORDER_VALUE) AS total_order_value
FROM
  ORDER_DELIVERY_STATUS
GROUP BY
  DATE(CREATEDAT)
ORDER BY
  DATE(CREATEDAT);

-- Solution 1.3 : Day on Day numbers for - Users:
SELECT 
  DATE(CREATEDAT) AS date,
  COUNT(DISTINCT USER) AS unique_users
FROM
  ORDER_DELIVERY_STATUS
GROUP BY
  DATE(CREATEDAT)
ORDER BY
  DATE(CREATEDAT);

-- Solution 1.4 : Day on Day numbers for - Successful Orders:
SELECT 
  DATE(CREATEDAT) AS date,
  COUNT(CASE WHEN ORDER_STATUS = 'SUCCESS' THEN ORDERID END) AS successful_orders
FROM
  ORDER_DELIVERY_STATUS
GROUP BY
  DATE(CREATEDAT)
ORDER BY
  DATE(CREATEDAT);

-- Solution 1.5 : Day on Day numbers for - Successful Order Value:
SELECT 
  DATE(CREATEDAT) AS date,
  SUM(CASE WHEN ORDER_STATUS = 'SUCCESS' THEN ORDER_VALUE END) AS successful_order_value
FROM
  ORDER_DELIVERY_STATUS
GROUP BY
  DATE(CREATEDAT)
ORDER BY
  DATE(CREATEDAT);

-- Solution 1.6 : Day on Day numbers for - Successful Number of Users
SELECT 
  DATE(CREATEDAT) AS date,
  COUNT(DISTINCT CASE WHEN ORDER_STATUS = 'SUCCESS' THEN USER END) AS successful_unique_users
FROM
  ORDER_DELIVERY_STATUS
GROUP BY
  DATE(CREATEDAT)
ORDER BY
  DATE(CREATEDAT);





-- Question 2 : Define City Level favorite Restaurant.

-- Solution 2.1 : City Level favorite Restaurant - Today
WITH today_orders AS (
  SELECT
    ocr.CITY,
    ocr.RESTAURANTS,
    COUNT(*) AS total_orders,
    RANK() OVER (PARTITION BY ocr.CITY ORDER BY COUNT(*) DESC) AS rank_orders
  FROM
    ORDER_DELIVERY_STATUS ods
    JOIN ORDER_CITY_RESTAURANT ocr ON ods.ORDERID = ocr.ORDERID
  WHERE
    DATE(ods.CREATEDAT) = CURRENT_DATE
  GROUP BY
    ocr.CITY, ocr.RESTAURANTS
)
SELECT
  CITY,
  RESTAURANTS
FROM
  today_orders
WHERE
  rank_orders = 1
ORDER BY
  CITY, RESTAURANTS;

-- Solution 2.2 : City Level favorite Restaurant - Last 7 days
WITH last_7_days_orders AS (
  SELECT
    ocr.CITY,
    ocr.RESTAURANTS,
    COUNT(*) AS total_orders,
    RANK() OVER (PARTITION BY ocr.CITY ORDER BY COUNT(*) DESC) AS rank_orders
  FROM
    ORDER_DELIVERY_STATUS ods
    JOIN ORDER_CITY_RESTAURANT ocr ON ods.ORDERID = ocr.ORDERID
  WHERE
    DATE(ods.CREATEDAT) BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) AND CURRENT_DATE
  GROUP BY
    ocr.CITY, ocr.RESTAURANTS
)
SELECT
  CITY,
  RESTAURANTS
FROM
  last_7_days_orders
WHERE
  rank_orders = 1
ORDER BY
  CITY, RESTAURANTS;

-- Solution 2.3 : City Level favorite Restaurant - Last month
WITH last_month_orders AS (
  SELECT
    ocr.CITY,
    ocr.RESTAURANTS,
    COUNT(*) AS total_orders,
    RANK() OVER (PARTITION BY ocr.CITY ORDER BY COUNT(*) DESC) AS rank_orders
  FROM
    ORDER_DELIVERY_STATUS ods
    JOIN ORDER_CITY_RESTAURANT ocr ON ods.ORDERID = ocr.ORDERID
  WHERE
    DATE(ods.CREATEDAT) BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE
  GROUP BY
    ocr.CITY, ocr.RESTAURANTS
)
SELECT
  CITY,
  RESTAURANTS
FROM
  last_month_orders
WHERE
  rank_orders = 1
ORDER BY





-- Question 3 : In the Last month, Which ORDER_CATEGORY FAILED the most in each city and what was the failure rate in that category.
WITH failed_orders AS 
(
  SELECT
    ocr.CITY,
    ocr.RESTAURANTS,
    od.ORDER_CATEGORY,
    COUNT(CASE WHEN ods.ORDER_STATUS = 'FAILED' THEN 1 END) AS total_failed_orders,
    COUNT(*) AS total_orders,
    RANK() OVER (PARTITION BY ocr.CITY, ocr.RESTAURANTS ORDER BY COUNT(CASE WHEN ods.ORDER_STATUS = 'FAILED' THEN 1 END) DESC) AS rank_failed
  FROM
    ORDER_DETAILS od
    JOIN ORDER_DELIVERY_STATUS ods ON od.ORDERID = ods.ORDERID
    JOIN ORDER_CITY_RESTAURANT ocr ON ods.ORDERID = ocr.ORDERID
  WHERE
    DATE(ods.CREATEDAT) BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE
  GROUP BY
    ocr.CITY, ocr.RESTAURANTS, od.ORDER_CATEGORY
  HAVING
    total_failed_orders > 0
)

SELECT
  CITY,
  RESTAURANTS,
  ORDER_CATEGORY,
  total_failed_orders,
  total_orders,
  (total_failed_orders / total_orders) * 100 AS failure_rate
FROM
  failed_orders
WHERE
  rank_failed = 1
ORDER BY
  CITY, RESTAURANTS, failure_rate DESC;