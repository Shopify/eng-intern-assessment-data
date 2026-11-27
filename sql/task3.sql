-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM users u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
    AND NOT EXISTS (
        SELECT oi.order_id
        FROM order_items oi
        JOIN orders o ON oi.order_id = o.order_id
        WHERE oi.product_id = p.product_id AND o.user_id = u.user_id
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM products p
JOIN (
    SELECT category_id, MAX(price) AS max_price
    FROM products
    GROUP BY category_id
) AS MaxPrices ON p.category_id = MaxPrices.category_id AND p.price = MaxPrices.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH OrderedDates AS (
    SELECT o.user_id, o.order_date,
           LAG(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date,
           LAG(o.order_date, 2) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date_2
    FROM orders o
)
SELECT DISTINCT u.user_id, u.username
FROM OrderedDates
JOIN users u ON OrderedDates.user_id = u.user_id
WHERE DATEDIFF(OrderedDates.order_date, OrderedDates.prev_order_date) = 1 
AND DATEDIFF(OrderedDates.prev_order_date, OrderedDates.prev_order_date_2) = 1;
