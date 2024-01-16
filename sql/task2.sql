-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- NOTE: This query does not consider any products that does not have any reviews. 
-- First, a view containing all the average ratings of rated products are created
DROP VIEW IF EXISTS AvgRatings CASCADE;
CREATE VIEW AvgRatings AS
SELECT product_id, product_name, avg(rating) AS average_rating FROM Products NATURAL JOIN Reviews;

-- All products that have the maximum value for average_rating are included for the final query
SELECT product_id, product_name, average_rating FROM AvgRatings
WHERE average_rating >= (SELECT average_rating FROM AvgRatings);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- First find all the users who lack any category among their orders. (This includes users who have never made an order.)
DROP VIEW IF EXISTS UsersLackingCategories CASCADE;
CREATE VIEW UsersLackingCategories AS
SELECT DISTINCT user_id FROM
(SELECT user_id, category_id FROM Categories, Users)
EXCEPT 
(SELECT DISTINCT user_id, category_id FROM Order_Items NATURAL JOIN Products);

-- Retrieve and return relevant information
SELECT user_id, username FROM Users WHERE user_id NOT IN UsersLackingCategories;


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- This query includes all products in Products table that do not appear in Reviews table
SELECT product_id, product_name 
FROM Products WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Reviews);


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- NOTE: I am interpreting the query to mean: users that have at some point more than one order per day for consecutive days
-- Collect all distinct order days associated with users. 
DROP VIEW IF EXISTS NonUniqueOrderDates CASCADE;
CREATE VIEW NonUniqueOrderDates AS
SELECT user_id, order_date FROM Orders GROUP BY user_id, order_date HAVING count(*) > 1;

-- Find users with consecutive pairs
SELECT DISTINCT U.user_id, U.username FROM NonUniqueOrderDates D, NonUniqueOrderDates NATURAL JOIN Users U
WHERE D.order_date - U.order_date = 1 and D.user_id = U.user_id;

