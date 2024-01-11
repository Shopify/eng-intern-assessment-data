-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category (Electronics).

-- This query joins Product and Category tables then filters the results to include only those products that are in the 'Electronics' category
SELECT * FROM products AS p
JOIN categories AS c ON c.category_id = p.category_id
WHERE c.category_name = 'Electronics';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- This query joins Users and Orders tables and counts the number of orders associated with each user.
SELECT u.user_id, u.username, COUNT(o.order_id) FROM users AS u
JOIN orders AS o ON o.user_id = u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- This query joins Products and Reviews tables to calculate the average of all ratings per product.
-- GROUPED BY is used to group results by product_id and product and ORDER BY to sort from highest to lowest.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating FROM products AS p
JOIN reviews AS r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- This query joins User and Orders tables and calculated the total sum spent by each user.
-- GROUP BY is used to sort from highest to lowest and LIMIT to restrict to only the top 5.
SELECT user_id, username, SUM(o.total_amount) AS total_amount_spent FROM user AS u
JOIN orders AS o ON u.user_id = o.user_id 
GROUP BY total_amount_spent DESC
LIMIT 5;