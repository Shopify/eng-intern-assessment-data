-- Problem 1: Retrieve all products in the Sports category

-- This command returns all products in the Sports category (category_id of 8), with the product_id, product_name, description, and price
SELECT products.product_id, products.product_name, products.price, products.description
FROM Products WHERE Products.category_id = 8;



-- Problem 2: Retrieve the total number of orders for each user

-- This command returns the total number of orders for each user, with the user_id, username, and total_number_orders
SELECT users.user_id, users.username, COUNT(orders.order_id) AS total_number_orders
FROM users
JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id, users.username;



-- Problem 3: Retrieve the average rating for each product

-- This command returns the average rating for each product, with the product_id, product_name, and average_rating
SELECT products.product_id, products.product_name, AVG(reviews.rating) AS average_rating
FROM products
JOIN reviews ON products.product_id = reviews.product_id
GROUP BY products.product_id, products.product_name;



-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders

-- This command returns the top 5 users with the highest total amount spent on orders, with the user_id, username, and total_amount_spent
SELECT users.user_id, users.username, SUM(orders.total_amount) AS total_amount_spent
FROM users
JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id
ORDER BY total_amount_spent DESC
LIMIT 5;
