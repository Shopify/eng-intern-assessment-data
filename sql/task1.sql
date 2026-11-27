-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT 
    p.product_id,
    p.product_name, 
    c.category_id
FROM Products p 
LEFT JOIN Categories c ON p.category_id = c.category_id -- LEFT JOIN is used to associate products with their categories
WHERE c.category_name = 'Sports';  --  WHERE clause filters the results to include only those products in the "Sports" category.


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username; -- GROUP BY clause groups the results by both user_id and username, ensuring COUNT operates correctly for each user.

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p 
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount_spent
FROM Users u 
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_amount_spent DESC -- Ordering the results by the total amount spent in descending order
LIMIT 5; --  Ensures that only the top 5 users are included in the result set.
