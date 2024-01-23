-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- selecting category_id, category_name from Categories table and aggregating the total_sales_amount for each order item by using the SUM(unit price * quantity ordered) expression
-- in order to correctly use the GROUP BY operator and display results (both category_id and category_name), we must first align similar attributes from different tables -> JOINS on category_id's from the Categories and Products tables & product_id's from the Categories and Order_Items tables
-- lastly, we need the top 3 categories -> use ORDER BY with a limit of 3 to return the top 3 results (in descending order)
SELECT c.category_id, c.category_name, SUM(o_i.unit_price * o_i.quantity) AS total_sales_amount from Categories c 
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items o_i ON p.product_id = o_i.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- need to fetch only the users who have placed orders for all products in the specific Toys & Games category -> compare counts of (distinct) product_id's from querying the results from each user with the results from all available products
-- if equal, return the user_id and username from Users table -> can filter to return only the users that satisfy this condition with the HAVING clause
-- use JOINS to align similar attributes from different tables together such as user_id's, order_id's, product_id's, and category_id's from the Users, Orders, Order_Items, and Products tables 
SELECT u.user_id, u.username from Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items o_i ON o.order_id = o_i.order_id
JOIN Products p ON o_i.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id 
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(DISTINCT product_id) from Products p
JOIN Categories c ON p.category_id = c.category_id WHERE c.category_name = 'Toys & Games');


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- can to use window function to retrieve the product(s) with the highest price within each category
-- logic: inner query uses the ROW_NUMBER() window function to assign a rank to each product based on its price (in descending order)
-- the PARTITION BY clause allows for products to be separated by category_id, which is desired
-- outer query selects the product_id, product_name, category_id, and price of only the products which have a rank of 1 
SELECT p.product_id, p.product_name, p.category_id, p.price
from (SELECT p.product_id, p.product_name, p.category_id, p.price,
ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS row_num from Products) ranked_products
WHERE row_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- almost the exact same logic as Problem 8 in task 2 -> selecting distinct user_id's and usernames from the Users table based on the condition that the user has ordered on consecutive days
-- only change needed is an extra JOIN operation to check for the "at least 3 days" condition
SELECT DISTINCT u.user_id, u.username from Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id 
AND o1.order_date = DATE(o2.order_date, '+1 day')
JOIN Orders o3 ON u.user_id = o2.user_id 
AND o2.order_date = DATE(o3.order_date, '+1 day');