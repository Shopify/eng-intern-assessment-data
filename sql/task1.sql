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

SELECT * 
FROM products
WHERE category = 'Sports';

SELECT users.user_id, users.username, COUNT(orders.order_id) AS total_orders
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id, users.username;

SELECT products.product_id, products.product_name, AVG(ratings.rating) AS average_rating
FROM products
LEFT JOIN ratings ON products.product_id = ratings.product_id
GROUP BY products.product_id, products.product_name;

SELECT users.user_id, users.username, SUM(order_details.total_price) AS total_amount_spent
FROM users
LEFT JOIN (
    SELECT orders.user_id, order_details.product_id, SUM(order_details.quantity * products.price) AS total_price
    FROM orders
    LEFT JOIN order_details ON orders.order_id = order_details.order_id
    LEFT JOIN products ON order_details.product_id = products.product_id
    GROUP BY orders.user_id, order_details.product_id
) AS order_details ON users.user_id = order_details.user_id
GROUP BY users.user_id, users.username
ORDER BY total_amount_spent DESC
LIMIT 5;

