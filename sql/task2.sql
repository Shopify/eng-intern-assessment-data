-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Will return no results if there are no reviews
WITH
    AverageProductRatings AS (
        SELECT
            p.product_id,
            p.product_name,
            AVG(r.rating) AS average_rating
        FROM
            Products AS p
            INNER JOIN Reviews AS r ON p.product_id = r.product_id
        GROUP BY
            p.product_id
    ),
    MaxAverageProductRating AS (
        SELECT
            MAX(average_rating) AS max_average_rating
        FROM
            AverageProductRatings
    )

-- Find the products with the highest average rating
SELECT
    apr.product_id,
    apr.product_name,
    apr.average_rating
FROM
    AverageProductRatings AS apr
    INNER JOIN MaxAverageProductRating AS mapr ON apr.average_rating = mapr.max_average_rating;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Will return no results if there are no categories
WITH
    TotalCategoryCount AS (
        SELECT
            COUNT(*) AS total_category_count
        FROM
            Categories
    ),
    UsersCategoryCount AS (
        SELECT
            u.user_id,
            u.username,
            COUNT(DISTINCT p.category_id) AS category_count
        FROM
            Users AS u
            INNER JOIN Orders AS o ON u.user_id = o.user_id
            INNER JOIN Order_Items AS oi ON o.order_id = oi.order_id
            INNER JOIN Products AS p ON oi.product_id = p.product_id
        GROUP BY
            u.user_id,
            u.username
    )

-- Find the users who have made at least one order in each category
SELECT
    ucc.user_id,
    ucc.username
FROM
    UsersCategoryCount AS ucc
    INNER JOIN TotalCategoryCount AS tcc ON ucc.category_count = tcc.total_category_count;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

WITH
    ReviewedProducts AS (
        SELECT DISTINCT
            product_id
        FROM
            Reviews
    )

-- Find the products that have not received any reviews
SELECT
    p.product_id,
    p.product_name
FROM
    Products AS p
    LEFT JOIN ReviewedProducts AS rp ON p.product_id = rp.product_id
WHERE
    rp.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH
    UserOrdersByDate AS (
        SELECT DISTINCT
            u.user_id,
            u.username,
            o.order_date
        FROM
            Users AS u
            INNER JOIN Orders AS o ON u.user_id = o.user_id
    ),
    UserOrdersByDateLag AS (
        SELECT
            user_id,
            username,
            order_date,
            LAG (order_date) OVER (
                PARTITION BY
                    user_id
                ORDER BY
                    order_date
            ) AS previous_order_date
        FROM
            UserOrdersByDate
    )

-- Find the users who have made consecutive orders on consecutive days
SELECT DISTINCT
    user_id,
    username
FROM
    UserOrdersByDateLag
WHERE
    order_date = previous_order_date + INTERVAL '1 day';
