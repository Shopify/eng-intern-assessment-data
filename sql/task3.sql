-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
LEFT JOIN Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY 
    u.user_id, u.username
-- get the number of products, and check if ordered number is equal to total products in category
HAVING 
    COUNT(DISTINCT p.product_id) = (
        SELECT COUNT(*) FROM Products p WHERE category_id = (
            SELECT category_id
            FROM Categories c
            WHERE category_name = 'Toys & Games'
        )
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT sq.product_id, sq.product_name, sq.category_id, sq.price
FROM (
    SELECT p.product_id, p.product_name, p.category_id, p.price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS rank
    FROM Products p
) AS sq
WHERE 
    sq.rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM Users u
LEFT JOIN 
    (
        SELECT user_id, order_date,
            LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS one_day_prev_order_date,
            LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS two_day_prev_order_date
        FROM Orders o
    ) AS o1 ON u.user_id = o1.user_id
WHERE 
    o1.order_date = DATE(o1.one_day_prev_order_date, '+1 day') AND
    o1.order_date = DATE(o1.two_day_prev_order_date, '+2 day');

-- thank you for your consideration!
