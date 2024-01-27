-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT *
FROM products
WHERE category = 'Sports';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT users.user_id, users.username, COUNT(orders.order_id) AS total_orders
FROM users
JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT products.product_id, products.product_name, AVG(ratings.rating) AS average_rating
FROM products
JOIN ratings ON products.product_id = ratings.product_id
GROUP BY products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT users.user_id, users.username, SUM(orders.amount) AS total_spent
FROM users
JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id
ORDER BY total_spent DESC
LIMIT 5;
