-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

-- Load data from files .csv files:

SELECT 
	product_id, product_name
FROM 
	products
WHERE 
	category_id = 8;  -- The category id for sports is 8, hence I ran the query by category ID. You can also query by category name if you use JOIN.
	

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.


SELECT 
	users.user_id, users.username, COUNT(order_id) as total_orders
FROM 
	orders
JOIN 
	users ON orders.user_id = users.user_id
GROUP BY 
	users.user_id, users.username; -- This retrieves the total number of ORDERS, not the total amount of items ordered.

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.



-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
