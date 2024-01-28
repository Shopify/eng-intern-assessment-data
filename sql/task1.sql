-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT *
FROM products as p
LEFT JOIN categories as c
	ON p.category_id = c.category_id
WHERE category_name LIKE 'Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT o.user_id, username, COUNT(o.order_id) AS number_of_orders
FROM orders as o
LEFT JOIN users as u
	ON u.user_id = o.user_id
GROUP BY o.user_id, username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM reviews as r
LEFT JOIN products as p
	ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT u.user_id, u.username, SUM(total_amount) as total_amount_sum
FROM orders as o
LEFT JOIN users as u
	ON o.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_sum DESC
LIMIT 5;