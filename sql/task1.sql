-- Query to Retrieve Product Names in the 'Sports' Category
-- This query selects product names from the 'Products' table that belong to the 'Sports' category.
-- It performs an INNER JOIN with the 'Categories' table using the 'category_id' column as the join condition.
-- The WHERE clause filters the results to include only rows where the 'category_name' in the 'Categories' table contains the word 'Sports'.
SELECT product_name
FROM Products
INNER JOIN Categories ON Products.category_id = Categories.category_id
WHERE category_name LIKE '%Sports%';

-- Query to Count Total Orders for Each User
-- This query calculates the total number of orders for each user.
-- It joins the 'Orders' and 'users' tables using the 'user_id' column as the join condition.
-- The result set is grouped by 'user_id' and 'username', and the COUNT() function calculates the total number of orders for each user.
SELECT Users.user_id, Users.username, COUNT(order_id) as total_orders
FROM Orders
JOIN users ON Orders.user_id = Users.user_id
GROUP BY Users.user_id, Users.username;

-- Query to Calculate the Average Rating for Each Product
-- This query calculates the average rating for each product based on user reviews.
-- It joins the 'reviews' and 'products' tables using the 'product_id' column as the join condition.
-- The result set is grouped by 'product_id', and the AVG() function calculates the average rating for each product.
SELECT Products.product_id, Products.product_name, AVG(rating)
FROM reviews
JOIN products ON Reviews.product_id = Products.product_id
GROUP BY Products.product_id;

-- Query to Find the Top 5 Users by Total Amount Spent
-- This query identifies the top 5 users with the highest total spending on orders.
-- It joins the 'Orders' and 'users' tables using the 'user_id' column as the join condition.
-- The result set is grouped by 'user_id', and the SUM() function calculates the total amount spent by each user.
-- The results are then sorted in descending order based on 'total_spent', and the LIMIT 5 clause restricts the output to the top 5 users with the highest total spending.
SELECT Users.user_id, username, SUM(total_amount) as total_spent
FROM Orders
JOIN users ON Orders.user_id = Users.user_id
GROUP BY Users.user_id
ORDER BY total_spent DESC
LIMIT 5;
