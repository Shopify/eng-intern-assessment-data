-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT * FROM products
WHERE category_id = 1;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT users.user_id, users.username, COUNT(orders.order_id) AS total_number_of_orders FROM orders
JOIN users ON orders.user_id = users.user_id
GROUP BY users.user_id;


-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.


SELECT products.product_id, products.product_name, AVG(reviews.rating) AS average_rating FROM reviews
JOIN products ON reviews.product_id = products.product_id
GROUP BY products.product_id;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT users.user_id, users.username, SUM(orders.total_amount) AS total_amount_spent FROM orders
JOIN users ON orders.user_id = users.user_id
GROUP BY users.user_id
ORDER BY total_amount_spent DESC
LIMIT 5;


