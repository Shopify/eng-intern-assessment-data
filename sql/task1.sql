-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Joining tables products and categories to get all products in each categories and then 
-- filtering the category to be only 'Sports & Outdoors"
Select p.product_id, p.product_name
FROM Products p 
INNER JOIN Categories c 
ON c.category_id = p.category_id
WHERE c.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

Select u.user_id, u.username, count(o.order_id) as total_orders
FROM users u
INNER JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
Select p.product_id, p.product_name, avg(r.rating) as average_rating
From products p
INNER JOIN reviews r 
ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
Select u.user_id, u.username, sum(o.total_amount) as total_spent
FROM users u
INNER JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_spent DESC
Limit 5;
