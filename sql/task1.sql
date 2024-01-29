-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- find product_id and name for all products in Sports & Outdoors
SELECT product_id, product_name
FROM Products NATURAL JOIN Categories
WHERE category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- the number of orders equals the number of distinct order IDs that each user has made. 
-- grouping on user, counts the distinct order IDs.
SELECT user_id, username, COUNT(DISTINCT order_id) as num_orders
FROM Orders NATURAL JOIN Users 
GROUP BY user_id, username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- can calculate average review by grouping on product and using AVG() on the rating score.
SELECT product_id, product_name, AVG(rating) as avg_rating
FROM Reviews NATURAL JOIN Products
GROUP BY product_id, product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- can use SUM() on the total cost of each order, grouped by user, to find the total amount spent per user.
SELECT user_id, username, sum(total_amount) as total_spent
FROM Orders NATURAL JOIN Users
GROUP BY user_id, username

-- sorts results with those who have largest total_spent appearing first, and showing only 5.
ORDER BY total_spent DESC
LIMIT 5;