-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH CategorySales AS (
  SELECT
    C.category_id,
    C.category_name,
    SUM(OI.quantity * OI.unit_price) AS total_sales
  FROM
    Categories C
    JOIN Products P ON C.category_id = P.category_id
    JOIN Order_Items OI ON P.product_id = OI.product_id
    JOIN Orders O ON OI.order_id = O.order_id
  GROUP BY
    C.category_id, C.category_name
)

SELECT
  category_id,
  category_name,
  total_sales
FROM
  CategorySales
ORDER BY
  total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH ToysAndGamesProducts AS (
  SELECT
    P.product_id
  FROM
    Categories C
    JOIN Products P ON C.category_id = P.category_id
  WHERE
    C.category_name = 'Toys & Games'
)

SELECT
  U.user_id,
  U.username
FROM
  Users U
  JOIN Orders O ON U.user_id = O.user_id
  JOIN Order_Items OI ON O.order_id = OI.order_id
WHERE
  OI.product_id IN (SELECT product_id FROM ToysAndGamesProducts)
GROUP BY
  U.user_id, U.username
HAVING
  COUNT(DISTINCT OI.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
  SELECT
    product_id,
    product_name,
    category_id,
    price,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_within_category
  FROM
    Products
)

SELECT
  product_id,
  product_name,
  category_id,
  price
FROM
  RankedProducts
WHERE
  rank_within_category = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH UserOrderDays AS (
  SELECT
    o.user_id,
    o.order_date,
    LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date,
    COUNT(*) OVER (PARTITION BY o.user_id, 
                  CASE WHEN LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) = o.order_date - 1
                       THEN NULL ELSE o.order_date END) AS consecutive_days
  FROM
    Orders o
)

SELECT
  u.user_id,
  u.username
FROM
  Users u
JOIN
  UserOrderDays uod ON u.user_id = uod.user_id
WHERE
  uod.consecutive_days >= 3;
