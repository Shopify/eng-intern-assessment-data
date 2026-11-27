-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Find all products where Sports shows up in the category name
SELECT product_id, product_name
FROM products
WHERE category_id = (SELECT category_id FROM categories WHERE category_name LIKE '%Sports%');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.


-- Count the number of orders per user
SELECT user_id, username, COUNT(order_id) AS num_orders
FROM orders 
JOIN users USING (user_id)
GROUP BY 1;

-- -- Problem 3: Retrieve the average rating for each product
-- -- Write an SQL query to retrieve the average rating for each product.
-- -- The result should include the product ID, product name, and the average rating.

-- Find the average rating
SELECT product_id, product_name, AVG(rating)
FROM products
JOIN reviews USING (product_id)
GROUP BY 1,2;

-- -- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- -- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- -- The result should include the user ID, username, and the total amount spent.

-- Find the highest spend by ordering in descending order
SELECT user_id, username, SUM(total_amount) AS total_amount_spent
FROM orders
JOIN users USING (user_id)
GROUP BY 1,2
ORDER BY total_amount_spent DESC
LIMIT 5;