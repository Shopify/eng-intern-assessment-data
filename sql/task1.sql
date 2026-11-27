-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Join products and categories on category id so that category information about each product can be identified
SELECT Products.product_id, Products.product_name, Products.description, Products.price
FROM Products
INNER JOIN Categories
ON Products.category_id = Categories.category_id
WHERE Categories.category_name = 'Sports & Outdoors';

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

-- Join users and orders to identify the orders placed by each user
-- COUNT function used to get the total number of orders for each users
-- Left join is used to include users with no orders
SELECT Users.user_id, Users.username, COUNT(Orders.order_id) as Number_of_Orders
FROM Users
LEFT JOIN Orders
ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.username;
 
-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

-- Join products and reviews to get the corresponding reviews for each product
-- AVG function used to get the mean rating for each product
SELECT Products.product_id, Products.product_name, AVG(Reviews.rating) as Average_Rating
FROM Products
LEFT JOIN Reviews 
ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id, Products.product_name;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

-- Join users and orders to match orders to the corresponding users
-- SUM function used to total the cost of every order for each user
SELECT TOP 5 Users.user_id, Users.username, SUM(Orders.total_amount) AS total_amount_spent
FROM Users
LEFT JOIN Orders 
ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.username
ORDER BY total_amount_spent DESC;
-- Can also use LIMIT 5 instead of TOP 5 if not using Microsoft SQL Server
