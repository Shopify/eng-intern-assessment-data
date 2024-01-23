-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT product_id, product_name, avg_rating
FROM (
    -- Get the the average rating of all the products
    SELECT product_id, product_name, avg(rating) AS avg_rating
    FROM products NATURAL JOIN reviews
    GROUP BY product_id, product_name
     ) as avg_p
WHERE avg_rating IN (
    -- Subquery to get the products with maximal rating
    SELECT max(avg_rating)
    FROM (
        SELECT avg(rating) AS avg_rating
        FROM reviews
        GROUP BY product_id
         ) AS max_rating
    )
ORDER BY product_id ASC;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT category_count.user_id, username
FROM (
    --Get the count of the total number of categories for each person
    SELECT user_id, count(distinct categories.category_id) as cat_count
    FROM users, categories
    GROUP BY user_id
     ) AS category_count
JOIN (
    -- Get the count of the actual number of categories each person has ordered from
    SELECT user_id, username, count(distinct category_id) as order_count
    FROM users NATURAL JOIN orders NATURAL JOIN order_items natural JOIN products
    GROUP BY user_id, username
) as user_count
-- Compare if they are equal
ON user_count.user_id = category_count.user_id
WHERE cat_count = order_count;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT product_id, product_name
FROM products
WHERE product_id NOT IN (
    -- subquery to get products with reviews
    SELECT DISTINCT product_id from products NATURAL JOIN reviews
    )
ORDER BY product_id ASC;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Use CTE to set dates to be same if there are consecutive orders
WITH date_differences AS (
    -- use window functions to set the row numbers for each person and subtract so they will be equal if the dates are consecutive
    SELECT user_id, username, order_date - CAST(ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS INT) as row_num
    FROM users natural join orders
)
SELECT user_id, username
FROM (
    -- Get the total number where all the days computed are the same, in other words consecutive
    SELECT count(*) as num_days, user_id, username
    FROM date_differences
    GROUP BY row_num, username, user_id
     ) as num_consec_days
-- Checks for more than 1 day in a row (consecutive orders)
WHERE num_days > 1
ORDER BY user_id ASC;
