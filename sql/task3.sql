-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- Solution: We calculate the total sales by taking the sum of all sales (product price * quantity ordered) over each category, sorted and limited to the top 3.
-- e.g., if a customer orders 3 of an item in the Toy category with a price of 50, that order would have spent 150 on Toys. If another customer spent 80 on some combination of toys,
-- the category total would be 230.
SELECT Categories.category_id, Categories.category_name, SUM(Order_Items.quantity * Products.price) AS category_sales FROM Order_Items, Products, Categories WHERE Order_Items.product_id = Products.product_id AND Products.category_id = Categories.category_id
GROUP BY Categories.category_id ORDER BY category_sales DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- Assumption: We'll assume that we mean any single order which contains all of the products in Toys and Games. This problem could also represent finding users who have ordered
-- all products from Toys & Games at any point

-- Solution: We need to join together a bunch of rows, as well as make a subquery here (to get the count of the unique product ids)
WITH Toy_Ids AS (
SELECT Products.product_id FROM Products, Categories WHERE Products.category_id = Categories.category_id AND Categories.category_name = 'Toys & Games')
SELECT * FROM Users, Orders, Order_Items, Toy_Ids 
WHERE Order_Items.product_id = Toy_Ids.product_id AND Orders.order_id = Order_Items.order_id AND Users.user_id = Orders.user_id 
GROUP BY Users.user_id HAVING COUNT(DISTINCT Order_Items.product_id) = COUNT(Toy_Ids.product_id);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- Solution: Pretty straightforward, using the MAX agg function on rows grouped by category id
SELECT Products.product_id, Products.product_name, Products.category_id, MAX(Products.price) FROM Products, Categories WHERE Products.category_id = Categories.category_id GROUP BY Products.category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--Solution: Started from the last solution, but expanded to pick out the second previous order as well, and compare both, looking for a streak.
WITH Last_Order AS 
(
	SELECT *, Users.user_id, Users.username, Orders.order_date, LAG(Orders.order_date) OVER (PARTITION BY Orders.user_id ORDER BY Orders.order_date) AS last_order_date, LAG(Orders.order_date, 2) OVER (PARTITION BY Orders.user_id ORDER BY Orders.order_date) AS last_order_date_two
	FROM Users, Orders WHERE Users.user_id = Orders.user_id
) SELECT user_id, username FROM Last_Order WHERE JULIANDAY(order_date) - JULIANDAY(last_order_date) = 1 AND JULIANDAY(order_date) - JULIANDAY(last_order_date_two) = 2;