-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- First find all average ratings, then filter for highest average
WITH avg_rating AS (
    SELECT product_id, product_name, AVG(rating) as average_rating
    FROM products
    JOIN reviews USING (product_id)
    GROUP BY 1,2
)

SELECT * FROM avg_rating 
WHERE average_rating = (SELECT max(average_rating) FROM avg_rating);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- First find information on each category, then calculate number of categories and users for each category
with category_info as (
    select user_id, username, order_id, order_item_id, product_id, category_id
    from users
    join orders using (user_id)
    join order_items using (order_id)
    join products using (product_id)
    join categories using (category_id)
)
, user_category_counts as (
    select user_id, count(distinct category_id) as distinct_categories_count
    from category_info
    group by user_id
)

, total_categories as (
    select count(distinct category_id) as total_categories_count
    from categories
)

select u.user_id, u.username
from users u
join user_category_counts ucc using (user_id)
cross join total_categories tc
where ucc.distinct_categories_count = tc.total_categories_count;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT product_id, product_name 
FROM products 
WHERE product_id NOT IN (
    SELECT product_id 
    FROM reviews 
);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


-- Find a column with the last order date the user has made, then use this to find if there is a date difference of 1 for consecutive
WITH ordered_orders AS (
    SELECT
        order_id,
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM orders
)

SELECT user_id, username
FROM users JOIN ordered_orders USING (user_id)
WHERE DATEDIFF(order_date, prev_order_date) = 1
ORDER BY username;