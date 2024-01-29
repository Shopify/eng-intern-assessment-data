-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH ProductAvgRating AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(r.rating) AS average_rating
    FROM
        Products p
    LEFT JOIN
        Reviews r ON p.product_id = r.product_id
    GROUP BY
        p.product_id, p.product_name
)
SELECT 
    pa.product_id,
    pa.product_name,
    pa.average_rating
FROM
    ProductAvgRating pa
WHERE
    pa.avg_rating = (
        SELECT 
            MAX(avg_rating)
        FROM    
            ProductAvgRating
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT
    u.user_id,
    u.username
FROM
    User u
WHERE EXISTS (
    SELECT DISTINCT category_id
    FROM Categories
    EXCEPT
    SELECT DISTINCT o.category_id
    FROM Orders o
    WHERE o.user_id = u.user_id
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
LEFT JOIN
    Reviews r ON p.product_id = r.product_id
WHERE
    r.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH UserConsecutiveOrders AS (
    SELECT
        o.user_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date

    FROM
        Orders o
)

SELECT 
    u.user_id,
    u.username
FROM
    Users u
JOIN 
    UserConsecutiveOrders uco ON u.user_id = uco.user_id
WHERE
    DATEDIFF(uco.order_date, uco.prev_order_date) = 1 OR uco.prev_order_date IS NULL;