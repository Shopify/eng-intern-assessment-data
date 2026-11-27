-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Creating a CTE 'avg_ratings' to provide a temporary table that holds the average rating for each product:
WITH avg_ratings AS (
SELECT p.product_id, p.product_name, AVG(r.rating) as average_rating
FROM Products p 
INNER JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name)

-- Select product ID, product name, and average rating as columns
-- from the CTE 'avg_ratings' where the average rating is the highest (subquery is used to obtain the max rating).

SELECT ar.product_id, ar.product_name, ar.average_rating
FROM avg_ratings ar
WHERE ar.average_rating = (
	SELECT MAX(average_rating)
    FROM avg_ratings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Select user ID and username as columns from several tables (that connects users to categories) joined together.
-- Groupby is used to aggregate the data, and a 'HAVING' clause is used to filter for users who have made at least one order in each category.

SELECT u.user_id, u.username 
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY users.user_id, users.username, categories.category_id
HAVING COUNT(DISTINCT c.category_id) = ( 
    SELECT COUNT(DISTINCT c.category_id) 
    FROM Categories c);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Select product ID and product name as columns from a joined table between 'Products' and 'Reviews' matched on the product_id column. 
-- a 'WHERE' clause is used to filter for products that have not received any reviews.
-- Note: LEFT JOIN is used to include products that have not received any reviews.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Select distinct user ID and username pairs from a subquery (po) that combines user information
-- with order details (order_date) and the previous order date (prev_date) using the LAG window function.
-- The 'WHERE' clause then filters the results to include only rows where the time difference between 
-- the current order date and the previous order date is exactly one day (consecutive).

SELECT DISTINCT po.user_id, po.username
FROM (
	SELECT u.user_id, u.username, o.order_date,
    LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS previous_date
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id) AS po
WHERE DATEDIFF(po.order_date, previous_date) = 1;