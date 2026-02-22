-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH CategorySales AS (
  SELECT c.category_id, c.category_name, SUM(o.total_amount) AS total_sales
  FROM Categories c
  LEFT JOIN Products p ON c.category_id = p.category_id
  LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
  LEFT JOIN Orders o ON oi.order_id = o.order_id
  GROUP BY c.category_id, c.category_name
)

SELECT category_id, category_name, total_sales
FROM CategorySales
ORDER BY total_sales DESC
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
  WHERE p.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
    AND NOT EXISTS (
      SELECT oi.order_id
      FROM Order_Items oi
      JOIN Orders o ON oi.order_id = o.order_id
      WHERE o.user_id = u.user_id AND oi.product_id = p.product_id
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH MaxPriceProducts AS (
  SELECT product_id, product_name, category_id, price,
         ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
  FROM Products
)

SELECT product_id, product_name, category_id, price
FROM MaxPriceProducts
WHERE rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH OrderedUsers AS (
  SELECT user_id, order_date,
         LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM Orders
)

SELECT DISTINCT ou1.user_id, Users.username
FROM OrderedUsers ou1
JOIN Users ON ou1.user_id = Users.user_id
WHERE DATEDIFF(ou1.order_date, ou1.prev_order_date) = 1
   OR DATEDIFF(ou1.order_date, ou1.prev_order_date) = 2;

