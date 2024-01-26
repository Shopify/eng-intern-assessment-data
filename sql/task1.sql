-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT p.*
FROM category_data AS c
JOIN product_data AS p
ON c.category_id = p.category_id
WHERE c.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT o.user_id, u.username, COUNT(*) AS num_of_orders
FROM user_data AS u
LEFT JOIN order_data AS o
ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM product_data AS p
LEFT JOIN review_data AS r
ON p.product_id = r.product_id
GROUP BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT o.user_id, u.username, SUM(total_amount) AS total_amount_spent
FROM order_data AS o
JOIN user_data AS u
ON o.user_id = u.user_id
GROUP BY o.user_id
ORDER BY total_amount_spent DESC
LIMIT 5;
