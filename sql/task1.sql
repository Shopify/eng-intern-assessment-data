-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Assume "the Sports category" refers to the category named 'Sports & Outdoors'.
SELECT * 
FROM Products 
WHERE category_id = (
    SELECT category_id FROM Categories WHERE category_name = 'Sports & Outdoors'
);

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT user_id, username, COUNT(order_id) AS total_number_orders
FROM Users NATURAL JOIN Orders
GROUP BY user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Assume only need to report the avy rating for those products that have been reviewed.
SELECT product_id, product_name, AVG(rating) AS avg_rating
FROM Products NATURAL JOIN Reviews
GROUP BY product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- First calculate the total amount spent for each user, and then select the top 5 users.
SELECT user_id, username, SUM(total_amount) AS total_amount_spent 
FROM Users NATURAL JOIN Orders
GROUP BY user_id
ORDER BY total_amount_spent DESC
LIMIT 5;