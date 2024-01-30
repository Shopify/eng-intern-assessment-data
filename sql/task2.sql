-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH ProductAverageRating AS (
    SELECT
        P.product_id,
        P.product_name,
        AVG(R.rating) AS average_rating
    FROM
        shopify.product_data P
    LEFT JOIN
        shopify.review_data R ON P.product_id = R.product_id
    GROUP BY
        P.product_id, P.product_name
)
SELECT
    product_id,
    product_name,
    average_rating
FROM (
    SELECT
        *,
        RANK() OVER (ORDER BY average_rating DESC) AS ranking
    FROM
        ProductAverageRating
) AS RankedProducts
WHERE
    ranking = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT
    U.user_id,
    U.username
FROM
    shopify.user_data U
JOIN
    shopify.order_data O ON U.user_id = O.user_id
JOIN
    shopify.order_items_data OI ON O.order_id = OI.order_id
JOIN
    shopify.product_data P ON OI.product_id = P.product_id
JOIN
    shopify.category_data C ON P.category_id = C.category_id
GROUP BY
    U.user_id, U.username, C.category_id
HAVING
    COUNT(DISTINCT C.category_id) = (SELECT COUNT(*) FROM shopify.category_data);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    P.product_id,
    P.product_name
FROM
    shopify.product_data P
LEFT JOIN
    shopify.review_data R ON P.product_id = R.product_id
WHERE
    R.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM
        shopify.order_data
)
SELECT DISTINCT
    U.user_id,
    U.username
FROM
    shopify.user_data U
JOIN
    UserConsecutiveOrders UCO ON U.user_id = UCO.user_id
WHERE
    UCO.order_date = UCO.prev_order_date + INTERVAL 1 DAY;
