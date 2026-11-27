-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT categories.category_id, category_name, product_id, product_name, description, price -- I did this instead of SELECT * to eliminate the second category_id column from the products join
FROM categories
JOIN products 
ON categories.category_id = products.category_id -- Inner join on category_id
WHERE categories.category_name = 'Sports & Outdoors'; -- Filter for categories with the name "Sport & Outoodrs"
-- Alternatively, if I wanted to find products in any sports-related category I could use >> WHERE categories.category_name LIKE "%Sports%" to find all category names containing the word "Sports"

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT users.user_id, username, COUNT(order_id) AS orderCount -- Counts the orders and calls the column "orderCount"
FROM users
JOIN orders
ON users.user_id = orders.user_id -- Inner join on user_id
GROUP BY users.user_id; -- Groups the order count by user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT products.product_id, product_name, AVG(rating) AS avgRating -- Takes the average of each product's rating and calls the column "avgRating"
FROM products
JOIN reviews
ON products.product_id = reviews.product_id -- Inner join on product_id
GROUP BY products.product_id; -- Groups the average ratings by product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT users.user_id, username, SUM(total_amount) AS amountSpent -- Takes the sum of the amount spent on an order and calls the column "amountSpent"
FROM users
JOIN orders
ON users.user_id = orders.user_id -- Inner join on user_id
GROUP BY users.user_id -- Groups the amount spent by user_id
ORDER BY amountSpent DESC -- Orders the results by total amount spent in descending order
LIMIT 5; -- Limit the result to the top 5
-- Two people spent $145 but since the limit is set to 5, one of them is excluded.
-- Using RANK on the sum of the total amounts captures the second user who spent $145
SELECT user_id, username, amountSpent
FROM (
    SELECT users.user_id, username, RANK() OVER (ORDER BY SUM(total_amount) DESC) AS amountRank, SUM(orders.total_amount) AS amountSpent
    FROM users
    JOIN orders ON users.user_id = orders.user_id
    GROUP BY users.user_id
) ranked_data
WHERE amountRank <= 5; -- Limits the results to the top 5 ranks, instead of the top 5 results
