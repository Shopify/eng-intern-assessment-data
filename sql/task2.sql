-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductAvgRating AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(r.rating) AS avg_rating
    FROM
        products p
    LEFT JOIN
        reviews r ON p.product_id = r.product_id
    GROUP BY
        p.product_id, p.product_name
)

SELECT
    product_id,
    product_name,
    avg_rating
FROM
    ProductAvgRating
ORDER BY
    avg_rating DESC
LIMIT 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
    u.user_id,
    u.username
FROM
    users u
JOIN
    orders o ON u.user_id = o.user_id
JOIN
    order_details od ON o.order_id = od.order_id
JOIN
    products p ON od.product_id = p.product_id
JOIN
    (
        SELECT DISTINCT
            category
        FROM
            products
    ) c ON p.category = c.category
GROUP BY
    u.user_id, u.username
HAVING
    COUNT(DISTINCT p.category) = (SELECT COUNT(DISTINCT category) FROM products);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    p.product_id,
    p.product_name
FROM
    products p
LEFT JOIN
    reviews r ON p.product_id = r.product_id
WHERE
    r.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH OrderedUserDates AS (
    SELECT
        u.user_id,
        o.order_date,
        LEAD(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS next_order_date
    FROM
        users u
    JOIN
        orders o ON u.user_id = o.user_id
)

SELECT
    user_id,
    MIN(order_date) AS start_date,
    MAX(next_order_date) AS end_date
FROM
    OrderedUserDates
GROUP BY
    user_id
HAVING
    MIN(order_date) = MAX(next_order_date) - INTERVAL 1 DAY;

