-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT category_id, category_name, sum(unit_price * quantity) as sales_amount
FROM categories NATURAL JOIN products NATURAL JOIN order_items
GROUP BY category_id, category_name
ORDER BY sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT category_count.user_id, username
FROM (
    --Get the count of the total number of products in the category 'Toys & Games' per person
    SELECT user_id, count(distinct product_id) as cat_count
    FROM users NATURAL JOIN categories NATURAL JOIN products
    WHERE category_name = 'Toys & Games'
    GROUP BY user_id
     ) AS category_count
JOIN (
    -- Get the actual ordered number of products in the category 'Toys & Games' per person
    SELECT user_id, username, count(distinct product_id) as order_count
    FROM users NATURAL JOIN orders NATURAL JOIN order_items natural JOIN products NATURAL JOIN categories
    WHERE category_name = 'Toys & Games'
    GROUP BY user_id, username
) as user_count
-- Compare if they are equal
ON user_count.user_id = category_count.user_id
WHERE cat_count = order_count;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT product_id, product_name, category_id, price
FROM (
    -- Group together by all the categories and sort from highest price to lowest price
    SELECT *, row_number() OVER (PARTITION BY category_id ORDER BY price DESC) as row_number
    FROM products NATURAL JOIN categories
     ) as highest_prices
--Choose the highest price one from each category
WHERE row_number = 1
ORDER BY product_id ASC;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

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
-- Checks for at least 3 consecutive days
WHERE num_days >= 3
ORDER BY user_id ASC;
