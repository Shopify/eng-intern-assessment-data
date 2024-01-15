-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH AvgRatings AS (
    SELECT
        product_data.product_id,
        product_data.product_name,
        AVG(review_data.rating) AS average_rating,
        RANK() OVER (ORDER BY AVG(review_data.rating) DESC) AS rating_rank
    FROM
        product_data
    INNER JOIN
        review_data ON product_data.product_id = review_data.product_id
    GROUP BY
        product_data.product_id, product_data.product_name
)
SELECT
    product_id,
    product_name,
    average_rating
FROM
    AvgRatings
WHERE
    rating_rank = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH UserOrdersByCategory AS (
    SELECT
        user_data.user_id,
        category_data.category_id,
        COUNT(DISTINCT order_data.order_id) AS orders_in_category
    FROM
        user_data
    INNER JOIN
        order_data ON user_data.user_id = order_data.user_id
    INNER JOIN
        order_items_data ON order_data.order_id = order_items_data.order_id
    INNER JOIN
        product_data ON order_items_data.product_id = product_data.product_id
    INNER JOIN
        category_data ON product_data.category_id = category_data.category_id
    GROUP BY
        user_data.user_id, category_data.category_id
),
UsersInAllCategories AS (
    SELECT
        user_id,
        COUNT(DISTINCT category_id) AS total_categories
    FROM
        UserOrdersByCategory
    GROUP BY
        user_id
    HAVING
        COUNT(DISTINCT category_id) = (SELECT COUNT(DISTINCT category_id) FROM category_data)
)
SELECT
    user_data.user_id,
    user_data.username
FROM
    UsersInAllCategories
INNER JOIN
    user_data ON UsersInAllCategories.user_id = user_data.user_id;


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT
    product_data.product_id,
    product_data.product_name
FROM
    product_data
LEFT JOIN
    review_data ON product_data.product_id = review_data.product_id
WHERE
    review_data.review_id IS NULL;



-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH UserConsecutiveOrders AS (
    SELECT
        user_data.user_id,
        user_data.username,
        order_data.order_date,
        LAG(order_data.order_date) OVER (PARTITION BY user_data.user_id ORDER BY order_data.order_date) AS prev_order_date
    FROM
        user_data
    INNER JOIN
        order_data ON user_data.user_id = order_data.user_id
)
SELECT
    user_id,
    username
FROM
    UserConsecutiveOrders
WHERE
    order_date - prev_order_date = 1 OR prev_order_date IS NULL;
