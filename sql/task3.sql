-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c
    JOIN Products p ON c.category_id = p.category_id
    JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
  u.user_id, u.username
FROM Users u
WHERE 
  NOT EXISTS (
    SELECT p.product_id FROM Products p
    JOIN 
      Categories c ON c.category_id = p.category_id
    WHERE c.category_name = 'Toys & Games'
    AND 
      NOT EXISTS (
        SELECT oi.product_id
        FROM Order_Items oi
        JOIN Orders o ON o.order_id = oi.order_id
        WHERE o.user_id = u.user_id
        AND oi.product_id = p.product_id
      )
  );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    product_id,
    product_name,
    category_id,
    price
FROM (
    SELECT 
        product_id,
        product_name,
        category_id,
        price,
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM Products
) p
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT
  u.user_id,
  u.username
FROM
  Users u
WHERE 
  EXISTS (
    SELECT 1
    FROM (
      SELECT
        o.user_id,
        o.order_date,
        LAG(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_day,
        LAG(o.order_date, 2) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_2day
      FROM
        Orders o
    ) o2
    WHERE
      o2.user_id = u.user_id
      AND DATEDIFF(o2.order_date, o2.prev_day) = 1
      AND DATEDIFF(o2.order_date, o2.prev_2day) = 2
  );