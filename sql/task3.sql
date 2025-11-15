-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH orders_temp AS (SELECT OI.*, OI.unit_price*OI.quantity AS order_amount, p.category_id
FROM Order_Items OI LEFT JOIN Products p ON OI.product_id = p.product_id)
SELECT c.category_id, c.category_name, SUM(ot.order_amount
) AS total_sales_amount
FROM orders_temp ot LEFT JOIN Categories c on ot.category_id = c.category_id
GROUP BY c.category_id
ORDER BY SUM(ot.order_amount) DESC 
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- retrieve the count of unique items in the Toys & Games category
WITH target_number AS (SELECT COUNT(DISTINCT product_id)
FROM Products 
WHERE category_id = 5),
orders_temp AS (SELECT * 
FROM Orders JOIN Order_Items ON Orders.order_id = Order_Items.order_id),
products_temp AS (SELECT orders_temp.*, p.product_id, p.category_id
FROM orders_temp JOIN Products p ON orders_temp.product_id = p.product_id
WHERE Products.category_id = 5),
final_temp AS (SELECT u.user_id, u.username, COUNT(DISTINCT pt.product_id) AS product_count
FROM Users u RIGHT JOIN products_temp pt ON Users.user_id = pt.user_id
GROUP BY u.user_id)
SELECT user_id, username
FROM final_temp
WHERE product_count = target_number;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT product_id, product_name, category_id, price, 
ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num 
FROM Products
WHERE row_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH temp AS (SELECT * 
FROM Users u RIGHT JOIN Orders o ON u.user_id = o.user_id),
cte AS (SELECT order_date DATEADD(d, - ROW_NUMBER() OVER(PARTITION BY order_date), order_date) AS helper_col 
FROM temp),
cte_2 AS (SELECT COUNT(*) AS cnt, MIN(order_date) AS starting_date, MAX(order_date) AS end_date
GROUP BY helper_col)
SELECT user_id, username
FROM cte_2
WHERE cnt >= 3;
