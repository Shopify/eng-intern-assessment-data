-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT product_name
FROM products
JOIN categories ON products.category_id = categories.category_id
WHERE category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT users.user_id, username, COUNT(order_id) as total_number_of_orders
FROM orders
JOIN users ON orders.user_id = users.user_id
GROUP BY users.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT products.product_id, products.product_name, AVG(rating)
FROM reviews
JOIN products ON reviews.product_id = products.product_id
GROUP BY products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT users.user_id, username, SUM(total_amount) as total_amount_spent
FROM orders
JOIN users ON orders.user_id = users.user_id
GROUP BY users.user_id
ORDER BY SUM(total_amount) DESC
LIMIT 10;