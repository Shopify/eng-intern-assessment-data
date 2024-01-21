-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH RankedProductRatings AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(r.rating) AS average_rating,
        RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rnk
    FROM
        Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id
    GROUP BY
        p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    average_rating
FROM
    RankedProductRatings
WHERE
    rnk = 1;



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
    u.user_id,
    u.username
FROM
    Users u
WHERE
    NOT EXISTS (
        SELECT c.category_id
        FROM Categories c
        WHERE NOT EXISTS (
            SELECT 1
            FROM Orders o
            JOIN Order_Items oi ON o.order_id = oi.order_id
            JOIN Products p ON oi.product_id = p.product_id
            WHERE u.user_id = o.user_id AND p.category_id = c.category_id
        )
    );



-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    p.product_id,
    p.product_name
FROM
    Products p
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Reviews r
        WHERE p.product_id = r.product_id
    );


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH OrderedDates AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS previous_date
    FROM Orders
)
SELECT DISTINCT u.user_id, u.username
FROM OrderedDates od
JOIN Users u ON od.user_id = u.user_id
WHERE DATEDIFF(day, od.previous_date, od.order_date) = 1;
