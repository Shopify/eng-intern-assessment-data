-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- selecting all entries matching the "Sports & Outdoors" category_name attribute in the Categories table by using a JOIN operator
SELECT * from Products p
JOIN Categories c ON c.category_name = "Sports & Outdoors";

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- selecting user_id and username from Users table and the count for each order_id from the Orders table, using the JOIN and GROUP BY operators to align entries by user_id
SELECT u.user_id, u.username, COUNT(o.order_id) AS total_orders from Users u 
JOIN Orders o ON u.user_id = o.order_id
GROUP BY u.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- selecting product_id and product_name from Products table and using the AVG operator to calculate the average rating of each rating in the Reviews table
-- using JOIN and GROUP BY operators to align each entry by product_id
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating from Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- selecting user_id and username from Users table and using the SUM operator to get the total amount spent for each order in the Orders table
-- using JOIN and GROUP BY operators to align each entry by user_id 
-- using ORDER BY operator to sort (in descending order) the top 5 users that spent the most
SELECT u.user_id, u.username, SUM(o.total_amount) AS total_amount_spent from Users u 
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id 
ORDER BY o.total_amount_spent DESC LIMIT 5;