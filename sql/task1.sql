-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * FROM Products
WHERE category_id = 8;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT a.user_id, a.username, COUNT(b.order_id) as total_orders
FROM Users a 
INNER JOIN Orders b ON a.user_id = b.user_id
GROUP BY a.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT a.product_id, a.product_name, AVG(b.rating) as average_rating
FROM Products a
INNER JOIN Review b ON a.product_id = b.product_id
GROUP BY a.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT a.user_id, a.username, SUM(b.total_amount) as total_spent
FROM Users a 
INNER JOIN Orders b ON a.user_id = b.user_id
GROUP BY a.user_id
ORDER BY total_spent DESC
LIMIT 5;