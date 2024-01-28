-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- SOLUTION: Straightforward. Used a nested query insteaed of hardcoding the category id
SELECT * FROM Products WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Sports & Outdoors');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Again, pretty straightforward, the key is to count instances of a user ID in the orders table
SELECT Users.user_id, Users.username, COUNT(Orders.user_id) FROM Orders INNER JOIN Users on Orders.user_id = Users.user_id GROUP BY Orders.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Similar to problem 2 with a different aggregation. Noted that the products table wasn't complete so I had to fix it myself
SELECT Reviews.product_id, Products.product_name, AVG(Reviews.rating) FROM Reviews INNER JOIN Products ON Reviews.product_id = Products.product_id GROUP BY Reviews.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

SELECT Users.user_id, Users.username, SUM(Orders.total_amount) FROM Orders INNER JOIN Users ON Orders.user_id = Users.user_id GROUP BY Users.user_id ORDER BY SUM(Orders.total_amount) DESC LIMIT 5;