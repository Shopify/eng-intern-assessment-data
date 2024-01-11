-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join all products of the same category with all order and order items associated with each product
-- With these joins, we can extract the total_amount of each order per product per category
-- Aggregate SUM to get the total sales amount
-- Sort by highest to lowest and cap at only the top 3 rows.
SELECT c.category_id, c.category_name, SUM(o.total_amount) AS total_sales FROM categories AS c 
JOIN products AS p ON p.category_id = c.category_id
JOIN Order_Items AS oi ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in a specific category
-- Write an SQL query to retrieve the users who have placed orders for all products in a specific category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- CTE to get the amount of distinct products in Clothing category
WITH TotalProductsInCategory AS (
    SELECT COUNT(DISTINCT product_id) AS total_products
    FROM Products
    WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Clothing')
),
-- Get all user's product orders and check that they placed orders for all products in a specific category
SELECT u.user_id, u.username FROM users AS u
JOIN orders AS o ON u.user_id = o.user_id
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
JOIN categories as c ON p.category_id = c.category_id
CROSS JOIN TotalProductsInCategory
WHERE c.category_name = 'Clothing'
AND (COUNT(DISTINCT p.product_id) = TotalProductsInCategory.total_products)
GROUP BY u.user_id, u.username;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- CTE to get the max price of every product grouped by category
WITH MaxPriceInCategory AS (
    SELECT p.category_id, MAX(p.price) AS max_price
    FROM Products AS p
    GROUP BY p.category_id
)
-- Select product details of the products in each category
-- Join with the MaxPriceInCategory CTE and price match the max price of that category
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products AS p
JOIN MaxPriceInCategory AS m ON p.category_id = m.category_id AND p.price = m.max_price
GROUP BY p.product_id, p.product_name, p.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- My implementation is similar to problem 8 in Task2
-- CTE using LEAD to get the next 2 consecutive days (day 2 and day 3)
WITH Cons_Orders AS (
    SELECT u.user_id, u.username, o.order_date,
    LEAD(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS next_order_date,
    LEAD(o.order_date, 2) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS next_next_order_date
    FROM Orders AS o
    JOIN Users AS u ON o.user_id = u.user_id
)
-- Check if day 1, 2, 3 are all different and that the there are at least 3 consecutive days
-- Select the user id and name which consecutively placed orders
SELECT user_id, username FROM Cons_Orders
WHERE DATEDIFF(next_order_date, order_date) = 1 
AND DATEDIFF(next_next_order_date, next_order_date) = 1
GROUP BY user_id, username
HAVING count(*) > 3;