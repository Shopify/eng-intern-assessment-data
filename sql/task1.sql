USE ecommerce_data;

-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
-- Sports category is #8 in category data

SELECT product_name
FROM Products
WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Sports & Outdoors');

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.

SELECT Users.user_id, Users.username, Orders.total_amount
FROM Users
JOIN Orders ON Orders.user_id = Users.user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.

SELECT Reviews.product_id, product_name, Reviews.rating
FROM 

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
