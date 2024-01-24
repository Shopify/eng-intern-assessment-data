-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Problem 1 --
SELECT product_id, product_name, description, price, product_data.category_id FROM product_data -- Only include the product name in the query output
INNER JOIN category_data ON product_data.category_id = category_data.category_id
WHERE category_name = "Sports"; -- Only retrieve products in the "Sports" category 

-- Problem 2 --
SELECT user_data.user_id, user_data.username, COUNT(*) AS total_number_of_orders FROM order_data
INNER JOIN user_data ON order_data.user_id = user_data.user_id -- Join user_data to obtain the usernames
GROUP BY user_data.user_id, user_data.username; -- Group COUNT(*) by the user_id and username

-- Problem 3 --
SELECT review_data.product_id, product_data.product_name, AVG(rating) AS average_rating FROM review_data -- Use aggregate function to find the average rating
INNER JOIN product_data
    ON review_data.product_id = product_data.product_id -- Obtain the product_name based on product_id
GROUP BY review_data.product_id, product_data.product_name; -- Find average rating for each product

-- Problem 4 --
SELECT order_data.user_id, user_data.username, SUM(total_amount) AS total_amount_all_orders FROM order_data
INNER JOIN user_data
    ON order_data.user_id = user_data.user_id -- Add username to result
GROUP BY order_data.user_id, user_data.username -- Group the total_amount_all_orders by the user_id
ORDER BY total_amount_all_orders DESC -- Order the users by the total amount spent on orders
LIMIT 5; --Only show the top 5 users which spent the most

