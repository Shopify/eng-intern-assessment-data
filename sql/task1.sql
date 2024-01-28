-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * FROM products WHERE category_id = 8;

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT Users.user_id, Users.username, COUNT(Orders.order_id) AS total_orders
FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.username
ORDER BY Users.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT Products.product_id, Products.product_name, ROUND(AVG(Reviews.rating),1) AS average_rating
FROM Products
LEFT JOIN Reviews ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id, Products.product_name
ORDER BY Products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT Users.user_id, Users.username, SUM(Orders.total_amount) AS total_spent
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.username
ORDER BY total_spent DESC
LIMIT 5;