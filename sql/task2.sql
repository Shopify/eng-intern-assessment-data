-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Problem 5 Solution:

WITH average_rating AS (
    SELECT product_data.product_id, product_data.product_name, (
        SELECT AVG(review.rating)
        FROM review_data
        WHERE review_data.product_id = product_data.product_id
    ) AS average_rating
    FROM product_data
    LEFT JOIN review_data ON product_data.product_id = review_data.product_id
    GROUP BY
        product_data.product_id, product_data.product_name
)

SELECT average_rating_data.product_id, average_rating_data.product_name, average_rating_data.avg_rating
FROM average_rating_data
WHERE
    average_rating_data.average_rating = (
        SELECT MAX(average_rating)
        FROM average_rating
    );


-- Problem 6 Solution:

SELECT user_data.user_id, user_data.username
FROM user_data
WHERE NOT EXISTS (
    SELECT category_data.category_id
    FROM category_data
    WHERE NOT EXISTS (
        SELECT order_data.user_id
        FROM order_data 
        JOIN order_items_data ON order_data.order_id = order_items_data.order_id
        JOIN product_data ON order_items_data.product_id = product_id.product_id
        WHERE order_data.user_id = user_data.user_id 
        AND product_data.category_id = category_data.category_id
            )
    );


-- Problem 7 Solution:

SELECT product_data.product_id, product_data.product_name
FROM product_data
LEFT JOIN review_data ON product_data.product_id = review_data.product_id
WHERE review_data.product_id IS NULL;


-- Problem 8 Solution:

WITH UserConsecutiveOrders AS (
    SELECT
        user_data.user_id, user_data.username, order_data.order_date,
        LAG(order_data.order_date, 1) OVER (PARTITION BY user_data.user_id ORDER BY order_data.order_date) AS prev_order_date
    FROM
        user_data
    JOIN
        order_data ON user_data.user_id = order_data.user_id
)
SELECT DISTINCT
    user_id, username
FROM UserConsecutiveOrders
WHERE order_date = prev_order_date + INTERVAL '1 day';

