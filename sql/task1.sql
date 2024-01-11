-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Left join so that you can get category names
SELECT * FROM Products LEFT JOIN Categories WHERE category_name LIKE '%Sports%';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Count order_id so you can get individual orders per user
SELECT u.user_id, u.username, COUNT(DISTINCT o.order_id) AS total 
FROM Users u RIGHT JOIN Orders o GROUP BY u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Same as above but uses average
SELECT p.product_id, p.product_name, AVG(r.rating) as average_rating 
FROM Products p LEFT JOIN Reviews r GROUP BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Limit the descending total by 5 to display top 5
SELECT u.user_id, u.username, sum(o.amount) as total_spent 
FROM Users u JOIN Orders o ON u.user_id = o.user_id 
GROUP BY u.user_id ORDER BY total_amount DESC LIMIT 5;
