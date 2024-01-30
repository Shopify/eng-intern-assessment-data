-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
with tot_q AS (
    SELECT 
        oi.product_id, 
        SUM(oi.quantity) total_q_per_prod
    FROM Order_Items oi
    GROUP BY oi.product_id
)
SELECT c.category_name, c.category_id, SUM(t.total_q_per_prod) q_per_category FROM tot_q t
    JOIN Products p
        ON t.product_id=p.product_id
    JOIN Categories c
        ON p.category_id=c.category_id
    GROUP BY c.category_id

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT u.user_id, u.username FROM Users u
    JOIN Orders o 
        ON u.user_id=o.user_id
WHERE o.order_id IN (
    SELECT oi.order_id FROM Order_Items oi
        JOIN Products p
            ON oi.product_id=p.product_id
        JOIN Categories c
            ON p.category_id=c.category_id
    WHERE c.category_name LIKE 'Toys & Games'
)

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT p.product_id, p.product_name, c.category_id, MAX(p.price) FROM Products p
    JOIN Categories c
        ON p.category_id=c.category_id
    GROUP BY c.category_id

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
with 
    users_with_date_diff AS (
        SELECT 
            o.user_id, 
            u.username, 
            o.order_date, 
            LAG(o.order_date,1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) previous_order_date,
            LEAD(o.order_date,1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) next_order_date
        FROM Orders o
            JOIN Users u
                ON o.user_id=u.user_id
            ORDER BY 1,3
    ),
    users_with_date_diff_nominal AS (
        SELECT 
            user_id, 
            username,
            order_date,
            previous_order_date,
            next_order_date,
            Cast((JulianDay(order_date) - JulianDay(previous_order_date)) As Integer) date_diff_before,
            Cast((JulianDay(next_order_date) - JulianDay(order_date)) As Integer) date_diff_after
        FROM users_with_date_diff
        --WHERE Cast((JulianDay(order_date) - JulianDay(previous_order_date)) As Integer) = 1
    )
SELECT 
    user_id, 
    username
FROM users_with_date_diff_nominal 
WHERE date_diff_before&date_diff_after







