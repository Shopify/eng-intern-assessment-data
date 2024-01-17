-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH
    AverageProductRatings AS (
        SELECT
            Products.product_id,
            Products.product_name,
            AVG(Reviews.rating) AS average_rating
        FROM
            Products
            LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
        GROUP BY
            Products.product_id
    ),
    MaxAverageProductRating AS (
        SELECT
            MAX(average_rating) AS max_average_rating
        FROM
            AverageProductRatings
    )

-- Find the products with the highest average rating
SELECT
    AverageProductRatings.product_id,
    AverageProductRatings.product_name,
    AverageProductRatings.average_rating
FROM
    AverageProductRatings
    INNER JOIN MaxAverageProductRating ON AverageProductRatings.average_rating = MaxAverageProductRating.max_average_rating;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH
    UserOrdersByCategory AS (
        SELECT DISTINCT
            Users.user_id,
            Users.username,
            Products.category_id
        FROM
            Users
            INNER JOIN Orders ON Users.user_id = Orders.user_id
            INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
            INNER JOIN Products ON Order_Items.product_id = Products.product_id
    ),
    UserOrdersByCategoryCount AS (
        SELECT
            user_id,
            username,
            COUNT(*) AS category_count
        FROM
            UserOrdersByCategory
        GROUP BY
            user_id,
            username
    ),
    TotalCategoryCount AS (
        SELECT
            COUNT(*) AS total_category_count
        FROM
            Categories
    )

-- Find the users who have made at least one order in each category
SELECT
    UserOrdersByCategoryCount.user_id,
    UserOrdersByCategoryCount.username
FROM
    UserOrdersByCategoryCount
    INNER JOIN TotalCategoryCount ON UserOrdersByCategoryCount.category_count = TotalCategoryCount.total_category_count;

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
    Products.product_id,
    Products.product_name
FROM
    Products
    LEFT JOIN ReviewedProducts ON Products.product_id = ReviewedProducts.product_id
WHERE
    ReviewedProducts.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH
    UserOrdersByDate AS (
        SELECT DISTINCT
            Users.user_id,
            Users.username,
            Orders.order_date
        FROM
            Users
            INNER JOIN Orders ON Users.user_id = Orders.user_id
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
