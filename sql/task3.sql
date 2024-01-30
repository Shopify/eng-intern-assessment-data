-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Select category details and calculate total sales amount
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM Categories c
JOIN Products p ON c.category_id = p.category_id  -- Link products to their categories
JOIN Order_Items oi ON p.product_id = oi.product_id  -- Get sales data for products
GROUP BY c.category_id, c.category_name  -- Aggregate sales by category
ORDER BY total_sales_amount DESC  -- Order categories by total sales
LIMIT 3;  -- Return only the top 3 categories


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Find users who ordered all 'Toys & Games' products
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id  -- Join orders to users
JOIN Order_Items oi ON o.order_id = oi.order_id  -- Get items in those orders
JOIN Products p ON oi.product_id = p.product_id  -- Link those items to products
WHERE p.category_id = (
  SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'  -- Target 'Toys & Games' category
)
GROUP BY u.user_id, u.username  -- Group by user, Ensure user ordered all products in category
HAVING COUNT(DISTINCT p.product_id) = (  
  SELECT COUNT(*) FROM Products WHERE category_id = (
    SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
  )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Rank products by price within each category
WITH RankedProducts AS (
  SELECT product_id, product_name, category_id, price,
  RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
  FROM Products
)


SELECT product_id, product_name, category_id, price -- Select highest-priced products in each category
FROM RankedProducts
WHERE price_rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- Identify consecutive order days for each user
WITH consecutivedays AS (
  SELECT user_id, order_date, DATE(order_date) - ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS grp FROM Orders
),
-- Count the length of each consecutive day streak
consec AS (
  SELECT user_id, COUNT(*) AS streak_length FROM consecutivedays GROUP BY user_id, grp HAVING COUNT(*) >= 3
)
SELECT DISTINCT o.user_id, u.username FROM consec o JOIN Users u ON o.user_id = u.user_id;
