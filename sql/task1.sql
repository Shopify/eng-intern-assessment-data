-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

SELECT p.* 
FROM Products p JOIN Categories c ON p.category_id = c.category_id
-- Selects all columns in products table
-- Joins the categories table with our selected products columns based on the shared category_id column in either table
WHERE c.category_name = 'Sports & Outdoors';
-- Only outputs rows where the category is sports, condition can be changed for any category in the products table

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT u.user_id, u.username, Count(o.order_id) AS total
FROM Users u LEFT JOIN Orders o ON u.user_id = o.user_id
-- Selects columns user_id, username from the Users table, and a total count of orders from the Orders table using the Count function
-- Joins the selected columns based on the shared user_id column in either table
GROUP BY u.user_id, u.username;
-- Groups the result based on user id and username from Users table

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM Products p INNER JOIN Reviews r ON p.product_id = r.product_id
-- Selects columns product_name and product_id columns from Products table, and product_id and an average of ratings in the Reviews table using AVG function
-- Joins the selected columns based on the product_id column in either table
GROUP BY p.product_name, p.product_id;
-- Groups the result by product name and product Id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount
FROM Users u INNER JOIN Orders o ON u.user_id = o.user_id
-- Selects columns user_id, username from the Users table and a sum of the total_amount column in the Orders table
-- Joins the selected columns based on the shared user_id column in either table
GROUP BY u.user_id, u.username ORDER BY total_amount DESC
LIMIT 5;
-- Groups the result by the user_id and orders the data in descending order by the total_amount and limits the results to 5 rows giving the top 5 users