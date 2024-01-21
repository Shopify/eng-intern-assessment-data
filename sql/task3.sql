-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c JOIN Products p ON c.category_id = p.category_id JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id ORDER BY total_sales DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM Users u JOIN Orders o ON u.user_id = o.user_id JOIN Order_Items oi ON o.order_id = oi.order_id JOIN Products p ON oi.product_id = p.product_id JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH rankedProducts AS (SELECT p.product_id, p.product_name, p.category_id, p.price,
    ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price) AS ranked FROM Products p)

SELECT rp.product_id, rp.product_name, rp.category_id, rp.price FROM RankedProducts rp WHERE ranked = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH ConsecutiveOrders AS (
    SELECT o.user_id, o.order_date, 
    LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date, 
    LEAD(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_order_date
    FROM Orders o
)

SELECT DISTINCT c.user_id, u.username
FROM ConsecutiveOrders c JOIN Users u ON c.user_id = u.user_id
WHERE c.order_date = date(c.prev_order_date, '+1 day') AND c.order_date = date(c.next_order_date, '-1 day');
