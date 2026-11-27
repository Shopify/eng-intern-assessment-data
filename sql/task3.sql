-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
  c.category_id,
  c.category_name,
  SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM
  Categories c
  JOIN Products p ON c.category_id = p.category_id
  JOIN Order_Items oi ON p.product_id = oi.product_id
  JOIN Orders o ON oi.order_id = o.order_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM Users u
WHERE NOT EXISTS (
  SELECT p.product_id
  FROM Products p
  WHERE p.category_id = (
    SELECT c.category_id
    FROM Categories c
    WHERE c.category_name = 'Toys & Games'
  )
  AND NOT EXISTS (
    SELECT *
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    WHERE oi.product_id = p.product_id AND o.user_id = u.user_id
  )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
  SELECT 
    p.product_id, 
    p.product_name, 
    p.category_id, 
    p.price,
    ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as rank
  FROM 
    Products p
)
SELECT 
  product_id, 
  product_name, 
  category_id, 
  price
FROM 
  RankedProducts
WHERE 
  rank = 1;



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH OrderedDates AS (
  SELECT 
    u.user_id,
    u.username,
    o.order_date,
    LAG(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_order_date,
    LEAD(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS next_order_date
  FROM 
    Users u
  JOIN 
    Orders o ON u.user_id = o.user_id
),
ConsecutiveOrders AS (
  SELECT 
    user_id, 
    username,
    order_date,
    CASE 
      WHEN order_date = prev_order_date + INTERVAL '1 day' AND order_date = next_order_date - INTERVAL '1 day' THEN 1
      ELSE 0
    END AS is_consecutive
  FROM 
    OrderedDates
)
SELECT DISTINCT
  user_id,
  username
FROM
  ConsecutiveOrders
WHERE
  user_id IN (
    SELECT user_id
    FROM ConsecutiveOrders
    GROUP BY user_id
    HAVING SUM(is_consecutive) >= 2
  );
