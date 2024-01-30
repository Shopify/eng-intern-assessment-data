-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Select all from products table where category id is 8 (sports).
SELECT * FROM product_data WHERE category_id = '8';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Select columns user_id and username and count order_id from order_data
SELECT user.user_id, user.username,
COUNT(ord.order_id) AS total_amount FROM user_data user
-- JOIN user_data with order_data
JOIN order_data ord ON user.user_id = ord.user_id
-- Group results by user ID and username.
GROUP BY user.user_id, user.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Select columns of product_id and product_name, and the average rating
SELECT pr.product_id, pr.product_name,
-- Calculate average rating
AVG(re.rating) AS average_rating FROM product_data pr
-- Join review_data from product_data and match product_id in both tables
JOIN review_data re ON pr.product_id = re.product_id
-- group by product id and product name.
GROUP BY pr.product_id, pr.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Select columns of user_id and username, and sum of total_amount.
SELECT us.user_id, us.username,
-- Calculate sum
SUM(ord.total_amount) AS total_amount_spent FROM user_data us
-- join order_data with user_data and match user_id with both tables.
JOIN order_data ord ON us.user_id = ord.user_id
-- group results by user id and username.
GROUP BY us.user_id, us.username
-- order results by descending order and limit to top 5.
ORDER BY total_amount_spent DESC LIMIT 5;
