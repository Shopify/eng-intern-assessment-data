-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT product_name
FROM Products NATURAL JOIN Categories
WHERE category_name='Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT user_id, username, count(order_id) AS num_orders
FROM Users NATURAL LEFT JOIN Orders
GROUP BY user_id, username;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT product_id, product_name, avg(rating) AS avg_rating
FROM Products NATURAL LEFT JOIN Reviews
GROUP BY product_id, product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT TOP 5 user_id, username, sum(total_amount) AS total_spent
FROM Users NATURAL LEFT JOIN Orders
GROUP BY user_id, username
ORDER BY total_spent DESC;