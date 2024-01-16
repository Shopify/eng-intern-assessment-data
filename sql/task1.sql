-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT * 
FROM Products 
JOIN Categories ON Products.category_id = Categories.category_id
WHERE Categories.category_name = 'Sports & Outdoors'; -- specify category name = 'Sports & Outdoors'

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT Orders.user_id, username, COUNT(*) AS 'total_number_of_orders' -- count total number of orders per user
FROM Orders 
JOIN Users ON Orders.user_id = Users.user_id
GROUP BY Orders.user_id;

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
SELECT Products.product_id, product_name, AVG(rating) AS average_rating -- compute average rating per product
FROM Products 
JOIN Reviews ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id;

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT Orders.user_id, username, total_amount AS 'total_amount_spent'
FROM Orders 
JOIN Users ON Orders.user_id = Users.user_id 
ORDER BY total_amount DESC -- sort by total amount spent from highest to lowest
LIMIT 5; -- select top 5 users with highest total amount spent
