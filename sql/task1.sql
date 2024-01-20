-- Problem 1: Retrieve all products in the Sports category

--Aliases for readability.
--Uses a JOIN to link Products to Categories based on category_id.
--Specifies we only want products under the Sports & Outdoors category.
SELECT p.product_id, p.product_name, p.description, p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- The result includes the user ID, username, and the total number of orders.

--Uses aliases for readability. Selects the user_id and username from the Users table.
--Creates a new column called total_orders using the COUNT() function to count the number of order IDs per user.
--COUNT(o.order_id) is used because each order generates a unique order_id, allowing us to count the total orders per user.
--LEFT JOIN includes all users from the Users table even if they have no orders. Their order count will be 0.
--GROUP BY u.user_id, u.username ensures the count is calculated for each unique user.
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;

-- Problem 3: Retrieve the average rating for each product
-- The result includes the product ID, product name, and the average rating.

-- Selects product_id and product_name from the Products table.
-- Creates a new column called average_rating using AVG() to calculate the average of the ratings for each product.
-- LEFT JOIN includes all products from the Products table, even those without reviews. Products without reviews will show a NULL average rating.
-- GROUP BY p.product_id, p.product_name ensures that the average rating is calculated for each unique product.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;



-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- The result includes the user ID, username, and the total amount spent.

-- Uses aliases for readability. Selects user_id and username from the Users table.
-- Creates column called total_spent using the SUM() function to sum the total_amount from the Orders table for each user.
-- Joins the Orders table to the Users table using user_id to link orders to the correct users.
-- GROUP BY u.user_id, u.username to ensure that the SUM() function calculates the total amount spent for each unique user.
-- Orders the results in descending order based on total_spent, so the user with the highest total amount spent appears first.
-- sets limit to 5 so only the top 5 highest totals are displayed.
SELECT u.user_id, u.username, SUM(o.total_amount) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username
ORDER BY total_spent DESC
LIMIT 5;

