-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- defining the CTE "RankedProducts" to store the ranked products, which are evaluated using the RANK() window function to rank products by descending order of average ratings
-- select only the product(s) with the highest rank (1) of average rating -> solves edge case where there are more than one products having a rank of 1 
WITH RankedProducts AS (
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating, RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rating_rank from Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name)
SELECT product_id, product_name, average_rating from RankedProducts
WHERE rating_rank = 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- selecting user_id and username from Users table, to be used as identifiers for the series of JOINS from relevant tables
-- using JOIN operators to align user_id, order_id, product_id, and category_id fields to each user_id
-- "at least one order in each category" -> use a subquery to fetch the minimum possible count of orders for each corresponding category_id and use the HAVING operator to check if the condition is satisfied
SELECT u.user_id, u.username from Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items o_i ON o.order_id = o_i.order_id
JOIN Products p ON o_i.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id
HAVING COUNT(c.category_id) = (SELECT COUNT(category_id) from Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- LEFT JOIN returns all the records from the left table and only the matching rows from the right table -> want all the product_id's from the Products table that have no review_id's
-- use LEFT JOIN where the left table is Products and matching rows are from Reviews table using the WHERE operator with condition of review_id being NULL
SELECT p.product_id, p.product_name from Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;  

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- consecutive days -> given 2 days day1 and day2, consecutive means day2 = day1 + 1
-- can use the above expression with the DATE function to filter consecutive days when doing a JOIN on separate order tables
-- need 2 JOINS for o1 and o2 elements -> need to include 'DISTINCT' after 'SELECT' to handle duplicates
-- can define an AND condition on the second join to filter for consecutive dates by including '+1 day' as an argument
SELECT DISTINCT u.user_id, u.username from Users u 
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id
AND o2.order_date = DATE(o1.order_date, '+1 day');