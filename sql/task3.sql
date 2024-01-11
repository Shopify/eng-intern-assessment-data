use schema_name;
-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- The way that I figured out to do this is to take the sum of the price and quantity sold (im assuming sold) after
-- grouping all of the data by the category characteristics. Just like the rest of the advanced problems, we have
-- to the the inner joins on categories, products, and order items to bring them together into one structure so that
-- we can aggregate them. The data is than output in descending order on a limit of 3 to fulfil the requirements.

SELECT categories.category_id, categories.category_name, SUM(order_items.unit_price * order_items.quantity)
AS sales FROM categories JOIN products ON categories.category_id = products.category_id
JOIN order_items ON products.product_id = order_items.product_id JOIN orders ON order_items.order_id = orders.order_id
GROUP BY categories.category_id, categories.category_name ORDER BY sales DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in a specific category
-- Write an SQL query to retrieve the users who have placed orders for all products in a specific category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- This one is similar to the one in every category question from task2, except for this one, we need to make sure
-- that the count of distinct product id's are the same from within the products table of a specific category.
-- In this case, you see that the second count statement in the having statement is being pulled from the category.
-- I chose to do the LIKE as opposed to = since we are calling with strings, and LIKE was required earlier to ensure
-- that sports was able to be looked up. This can easily be subbed with = if that was the goal.

SELECT users.user_id, users.username FROM users JOIN orders ON users.user_id = orders.user_id JOIN order_items
    ON orders.order_id = order_items.order_id JOIN products ON order_items.product_id = products.product_id JOIN categories
    ON products.category_id = categories.category_id WHERE categories.category_name LIKE '%YourCategoryName%'
    GROUP BY users.user_id, users.username
    HAVING COUNT(DISTINCT products.product_id) = (SELECT COUNT(DISTINCT product_id)
    FROM products WHERE category_id = (SELECT category_id FROM categories WHERE category_name LIKE '%YourCategoryName%'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This one is almost identical to the ranking by average in task2, except this one is easier because we have
-- no added aggregation. For this, we could use row_number or rank, but since we dont want to pollute the table with
-- duplicate category_id's I used row_number. I explained window functions in the rank explanation, but the difference
-- here is that row number will not give duplicate values for first, second, third etc. and will instead rank them by
-- their order, but if a value already has first for example, the value will automatically be demoted to second,
-- continuing all the way down the list.

WITH rankedProducts AS (SELECT product_id, product_name, category_id, price,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price) AS ranked FROM products)

SELECT product_id, product_name, category_id, price FROM RankedProducts WHERE ranked = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Wow, last problem, this was definitely an adventure. This one is similar to our lag example, but I decided to switch
-- it up and use lead for this one. This has almost the exact same structure as the first one with the exact same joins,
-- since we are using the same user characteristics, and the only change here, is the addition of the date_add function,
-- that just allows you to add any interval of time to another without breaking the months (which will happen if you just
-- try to do order_date + INTERVAL 1 DAY) to ensure that the original date, and the two lead dates, are the same.

WITH days AS (SELECT user_id, order_date, username,
    LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS 1_days,
    LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS 2_days
    FROM (SELECT users.user_id, users.username, orders.order_id, orders.order_date FROM users JOIN
    orders ON users.user_id = orders.user_id) AS orders)

SELECT DISTINCT days.user_id, username, order_date AS first_day, 1_days AS second_day, 2_days AS third_day
    FROM days WHERE days.1_days = DATE_ADD(days.order_date, INTERVAL 1 DAY)
    AND days.2_days = DATE_ADD(days.order_date, INTERVAL 2 DAY);

-- I really enjoyed this exercise and thanks to everyone who worked on this! I had a great time working out all of the
-- problems