-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- This query retrieves all products belonging to the 'Sports & Outdoors' category.
-- It selects product ID, name, description, and price from the Products table.
-- An INNER JOIN is used with the Categories table to match products with their categories.
-- The WHERE clause filters the products to include only those in 'Sports & Outdoors'.
SELECT p.product_id, p.product_name, p.description, p.price
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Sports & Outdoors';



-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.


-- This query calculates the total number of orders made by each user.
-- It includes user ID, username, and the total order count.
-- A LEFT JOIN is performed with the Orders table to count orders for each user.
-- The COUNT function counts the number of orders per user.
-- GROUP BY is used to group results by user ID.
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id;



-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.


-- This query fetches the average rating for each product.
-- It selects the product ID, name, and the average rating.
-- A LEFT JOIN with the Reviews table is used to include ratings.
-- COALESCE is used to ensure a zero rating for products with no reviews.
-- Results are grouped by product ID.
SELECT p.product_id, p.product_name, COALESCE(AVG(r.rating), 0) AS average_rating
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id;


-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.


-- This query identifies the top 5 users based on the total amount spent on orders.
-- It selects user ID, username, and the sum of order amounts.
-- A LEFT JOIN with the Orders table is used to sum the total amount spent by each user.
-- IFNULL is used to handle users with no orders (considering their total as 0).
-- Results are grouped by user ID and sorted by the total amount spent in descending order.
-- LIMIT 5 restricts the output to the top 5 users.


SELECT u.user_id, u.username, IFNULL(SUM(o.total_amount), 0) AS total_spent
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY total_spent DESC
LIMIT 5;

