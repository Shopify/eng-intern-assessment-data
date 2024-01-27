-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT a.category_id, a.category_name, SUM(b.total_amount) as total_sales_amount
FROM Categories a
INNER JOIN Products c ON a.category_id = c.category_id
INNER JOIN Orders b ON b.product_id = c.product_id
GROUP BY a.category_id, a.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Comment: In Cartegories table where Toys & Games value has a category_id of 5
SELECT a.user_id, a.username
FROM users a
WHERE NOT EXISTS (
    SELECT b.product_id
    FROM products b
    WHERE b.category_id = 5
    AND NOT EXISTS (
        SELECT c.order_id
        FROM Orders c
        WHERE c.user_id = a.user_id
        AND c.product_id = b.product_id
    )
)


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT a.product_id, a.product_name, a.price, a.category_id
FROM Products a
JOIN (
    SELECT category_id, MAX(price) as max_price
    FROM Products
    GROUP BY category_id
) b ON a.category_id = b.category_id AND a.price = b.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH ConsecutiveOrders AS (
    SELECT user_id, username, order_date, 
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
),
ConsecutiveDays AS (
    SELECT user_id, username, order_date, 
        CASE 
            WHEN order_date = DATE_ADD(prev_order_date, INTERVAL 1 DAY) THEN 1
            ELSE 0
        END AS is_consecutive
    FROM 
        ConsecutiveOrders
),
ConsecutiveGroups AS (
    SELECT user_id, username, order_date, 
        SUM(is_consecutive) OVER (PARTITION BY user_id ORDER BY order_date) AS group_id
    FROM 
        ConsecutiveDays
)
SELECT user_id, username
FROM 
ConsecutiveGroups
GROUP BY 
    user_id, 
    username, 
    group_id
HAVING 
    COUNT(*) >= 3;
