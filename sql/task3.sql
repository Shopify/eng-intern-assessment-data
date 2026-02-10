-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT categories.category_id, category_name, SUM(quantity * unit_price) AS totalSales -- Multiply order_items quantity and unit_price and call it "totalSales"
FROM categories
JOIN products
ON categories.category_id = products.category_id -- Inner join categories and products on category_id
JOIN order_items
ON products.product_id = order_items.product_id -- Inner join on product_id
GROUP BY categories.category_id
ORDER BY totalSales DESC
LIMIT 3; -- Limit to the top 3 total sales amounts
-- This does not include order_items associated with a product_id that does not exist on the products table
-- Could also be done with RANK:
SELECT category_id, category_name, totalSales
FROM (
    SELECT categories.category_id, category_name, SUM(quantity * unit_price) AS totalSales, RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS salesRank -- RANK ranks the sales from highest to lowest
    FROM categories
    JOIN products
    ON categories.category_id = products.category_id 
    JOIN order_items
    ON products.product_id = order_items.product_id
    GROUP BY categories.category_id
) ranked_sales
WHERE salesRank <= 3; -- Limit to the top 3 total sales amount

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT users.user_id, username
FROM users
JOIN orders
ON users.user_id = orders.user_id -- Inner join on user_id
JOIN order_items
ON orders.order_id = order_items.order_id -- Inner join on order_id
JOIN products
ON order_items.product_id = products.product_id -- Inner join on product_id
JOIN categories
ON products.category_id = categories.category_id -- Inner join on category_id
WHERE category_name = "Toys & Games" -- Filter for the Toys & Games category
GROUP BY users.user_id, username
HAVING COUNT(DISTINCT order_items.product_id) = (SELECT COUNT(DISTINCT product_id) FROM products WHERE category_id = 5); -- Checking for users that have bought each of the Toys & Games products by looking for distinct product ids and comparing the count to the number of unique product ids in the products table in the Toys & Games category
-- The category_id for Toys & Games is 5, alternatively I could've done a join in the subquery to use the category_name:
-- (SELECT COUNT(DISTINCT product_id) FROM products JOIN categories ON products.category_id = categories.category_id WHERE category_name = "Toys & Games")

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT product_id, product_name, category_id, price
FROM (
    SELECT product_id, product_name, category_id, price, RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS catRanking
    FROM products
) ranking_data
WHERE catRanking = 1;
-- RANK is partitioned over category_id so it ranks each item within the category, then we can select all products with rank = 1 


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT user_id, username
FROM (
    SELECT users.user_id, username, order_date, LAG(order_date) OVER(PARTITION BY users.user_id ORDER BY order_date) AS oneDayPrev, LAG(order_date, 2) OVER(PARTITION BY users.user_id ORDER BY order_date) AS twoDaysPrev -- LAG returns the previous order date for each user, performed twice so that there's a lag for the previous order_date and a lag for the order_date two records prior
    FROM users
    JOIN orders
    ON users.user_id = orders.user_id 
) consecutive_dates
WHERE DATEDIFF(order_date, oneDayPrev) = 1 AND DATEDIFF(order_date, twoDaysPrev) = 2 -- Check that the first lag (oneDayPrev) is 1 day prior, check that the second lag (twoDayPrev) is 2 days prior, showing that this is the third consecutive day
GROUP BY user_id, username;
-- This method would not be scalable for checking more consecutive days
-- None of the users in the given dataset have placed orders on at least 3 consecutive days.