-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Select all columns from the 'Products' table for products in the 'Sports' category
SELECT *
FROM Products
-- Specify the condition to filter products in the 'Sports' category (replace 'X' with the actual category_id)
WHERE category_id = 'X';


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
-- Selecting the category ID, category name, and the total sales amount for the top 3 categories

-- Select the user ID, username, and the count of orders for each user
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
-- Join the 'Orders' table to get order details
JOIN Orders o ON u.user_id = o.user_id
-- Group the results by user_id to count the total number of orders per user
GROUP BY u.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Select the product ID, product name, and the average rating of reviews for each product
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
-- Join the 'Reviews' table to get review details
JOIN Reviews r ON p.product_id = r.product_id
-- Group the results by product_id to calculate the average rating per product
GROUP BY p.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Select the user ID, username, and the sum of total_amount from the 'Orders' table for each user
SELECT u.user_id, u.username, SUM(o.total_amount) AS total_spent
FROM Users u
-- Join the 'Orders' table to get order details
JOIN Orders o ON u.user_id = o.user_id
-- Group the results by user_id to get the total spent per user
GROUP BY u.user_id, u.username
-- Order the results by total_spent in descending order to get the highest total amount spent at the top
ORDER BY total_spent DESC
-- Limit the results to the top 5 users
LIMIT 5;

