-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
  Categories.category_id,
  Categories.category_name,
  SUM(Orders.total_amount) AS total_sales_amount
FROM Categories
JOIN Products ON Categories.category_id = Products.category_id
JOIN Order_Items ON Products.product_id = Order_Items.product_id
JOIN Orders ON Order_Items.order_id = Orders.order_id
GROUP BY Categories.category_id, Categories.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
  Users.user_id,
  Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
WHERE NOT EXISTS (
  SELECT Products.product_id
  FROM Products
  WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
  EXCEPT
  SELECT Order_Items.product_id
  FROM Order_Items
  WHERE Order_Items.order_id = Orders.order_id
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
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
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
WITH UserConsecutiveOrderDays AS (
  SELECT
    user_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM Orders
)

SELECT DISTINCT
  UC1.user_id,
  U.username
FROM UserConsecutiveOrderDays UC1
JOIN UserConsecutiveOrderDays UC2 ON UC1.user_id = UC2.user_id
JOIN UserConsecutiveOrderDays UC3 ON UC1.user_id = UC3.user_id
JOIN Users U ON UC1.user_id = U.user_id  -- Added join condition for Users table
WHERE UC1.prev_order_date = UC1.order_date - INTERVAL '1 day'
  AND UC2.prev_order_date = UC2.order_date - INTERVAL '1 day'
  AND UC3.prev_order_date = UC3.order_date - INTERVAL '1 day';



