-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH CategoryTotalSales AS (
  SELECT 
    c.category_id,
    c.category_name,
    SUM(o.total_amount) AS total_sales
  FROM Categories c
  LEFT JOIN Products p ON c.category_id = p.category_id
  LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
  LEFT JOIN Orders o ON oi.order_id = o.order_id
  GROUP BY c.category_id, c.category_name
)
SELECT 
  category_id,
  category_name,
  total_sales
FROM CategoryTotalSales
ORDER BY total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
  u.user_id,
  u.username
FROM Users u
WHERE NOT EXISTS (
  SELECT p.product_id
  FROM Products p
  WHERE p.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
  EXCEPT
  SELECT oi.product_id
  FROM Orders o
  JOIN Order_Items oi ON o.order_id = oi.order_id
  WHERE o.user_id = u.user_id
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ProductsWithRank AS (
  SELECT 
    product_id,
    product_name,
    category_id,
    price,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
  FROM Products
)
SELECT 
  product_id,
  product_name,
  category_id,
  price
FROM ProductsWithRank
WHERE price_rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsecutiveOrderDays AS (
  SELECT 
    user_id,
    order_date,
    LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
    LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS third_order_date
  FROM Orders
)
SELECT DISTINCT
  user_id,
  username
FROM ConsecutiveOrderDays cod
JOIN Users u ON cod.user_id = u.user_id
WHERE next_order_date = DATEADD(day, 1, order_date)
  AND third_order_date = DATEADD(day, 2, order_date);
