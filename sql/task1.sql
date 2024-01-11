-- Problem 1: Retrieve all products in the Sports category
-- Query to retrieve all products in a specific category.
-- This example retrieves all products in the 'Sports' category.

-- SELECT p.product_id, p.product_name
-- FROM product_data p
-- JOIN category_data c ON p.category_id = c.category_id
-- WHERE c.category_name = 'Sports';

-- To retrieve products in a different category, replace 'Sports' with the desired category name.
-- Example for 'Electronics':

-- SELECT p.product_id, p.product_name
-- FROM product_data p
-- JOIN category_data c ON p.category_id = c.category_id
-- WHERE c.category_name = 'Electronics';


-- Problem 2: Retrieve the total number of orders for each user
-- Query to retrieve the total number of orders for each user.
-- Includes the user ID, username, and the total number of orders.

-- SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
-- FROM user_data u
-- JOIN order_data o ON u.user_id = o.user_id
-- GROUP BY u.user_id, u.username;


-- Problem 3: Retrieve the average rating for each product
-- Query to retrieve the average rating for each product.
-- Includes the product ID, product name, and the average rating.

-- SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
-- FROM product_data p
-- JOIN review_data r ON p.product_id = r.product_id
-- GROUP BY p.product_id, p.product_name;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Query to retrieve the top 5 users with the highest total amount spent on orders.
-- Includes the user ID, username, and the total amount spent.

-- SELECT u.user_id, u.username, SUM(o.total_amount) AS total_spent
-- FROM user_data u
-- JOIN order_data o ON u.user_id = o.user_id
-- GROUP BY u.user_id, u.username
-- ORDER BY total_spent DESC
-- LIMIT 5;
