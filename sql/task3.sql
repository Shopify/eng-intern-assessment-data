-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- NOTE: I am not including categories with no sales, so there could be 0-3 categories found in this query
DROP VIEW IF EXISTS OrderRevenueByProduct CASCADE;
CREATE VIEW OrderRevenueByProduct AS
SELECT product_id, quantity*price AS sale_total FROM Order_Items;

-- I am assuming that the top three total sale values are what is being queried 
-- since several categories can have the same total sales. 
DROP VIEW IF EXISTS Top3Totals CASCADE;
CREATE VIEW Top3Totals AS
SELECT sum(sale_total) AS total_sales
FROM OrderRevenueByProduct NATURAL JOIN Products GROUP BY category_id
ORDER BY total_amount DESC LIMIT 3;

-- Select all categories with these top 3 values
SELECT category_id, sum(sale_total) AS total_sales FROM OrderRevenueByProduct NATURAL JOIN Products 
GROUP BY category_id HAVING sum(sale_total) IN Top3Totals;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- First find all the users who lack any category among their orders. (This includes users who have never made an order.)
DROP VIEW IF EXISTS UsersLackingToyProducts CASCADE;
CREATE VIEW UsersLackingToyProducts AS
SELECT DISTINCT user_id FROM
(SELECT user_id, product_id FROM Products, Users 
    WHERE category_id IN (SELECT category_id FROM Categories WHERE category_name LIKE "%Toys & Games%"))
EXCEPT 
(SELECT DISTINCT user_id, product_id FROM Order_Items NATURAL JOIN Users);

-- Retrieve and return relevant information
SELECT user_id, username FROM Users WHERE user_id NOT IN UsersLackingToyProducts;


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Find the maximum price per category
DROP VIEW IF EXISTS MaxPricePerCategory CASCADE;
CREATE VIEW MaxPricePerCategory AS
SELECT category_id, max(price) AS price FROM Products GROUP BY category_id;

-- A natural join on the price filters out all products that are not the maximum price for their category automatically
SELECT product_id, product_name, category_id, price FROM MaxPricePerCategory NATURAL JOIN Products;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Get each unique date per user (consecutive orders on the same day ignored)
DROP VIEW IF EXISTS UniqueOrderDates CASCADE;
CREATE VIEW UniqueOrderDates AS
SELECT DISTINCT user_id, order_date FROM Orders;

-- Find users with consecutive pairs (order is restricted to most easily measure consecutive days)
DROP VIEW IF EXISTS Consecutive2 CASCADE;
CREATE VIEW Consecutive2 AS
SELECT D1.user_id, D2.order_date AS first_date, D1.order_date AS second_date FROM UniqueOrderDates D1, UniqueOrderDates D2
WHERE D1.order_date - D2.order_date = 1 and D1.user_id = D2.user_id;

-- Find users with a third date in the sequence. All remaining users have at least one 3 day streak
DROP VIEW IF EXISTS Consecutive3 CASCADE;
CREATE VIEW Consecutive3 AS
SELECT DISTINCT D1.user_id FROM UniqueOrderDates D1, Consecutive1 D2
WHERE D1.order_date - second_date = 1 and D1.user_id = D2.user_id;

-- Extract the usernames for the final query
SELECT user_id, username FROM Consecutive3 NATURAL JOIN Users;
