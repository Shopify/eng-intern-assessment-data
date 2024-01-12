-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Find each products average rating by define CTE:
WITH Avg_rating AS (
SELECT p.product_id, p.product_name, AVG(r.rating) as Average_rating
FROM Products p 
INNER JOIN Reviews r ON p.product_id = r.product_id
GROUP BY r.product_id)

-- Find products with the maximum average rating based on the results in the CTE
SELECT ar.product_id, ar.product_name, ar.Average_rating
FROM Avg_rating ar
WHERE ar.Average_rating = (
	SELECT MAX(Average_rating)
    FROM Avg_rating);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Join all the tables that link from users to categories
-- Then, compare the number of the categories that each user ordered to the total number of categories
SELECT u.user_id, u.username, c.category_id
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id, u.username, c.category_id
HAVING COUNT(DISTINCT c.category_id) = (
	SELECT COUNT(*)
    FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- LEFT JOIN shows the products which may not have records in table "Review"
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- the subquery sq will get the date of previous order of each user by using the LAG window function
SELECT DISTINCT sq.user_id, sq.username
FROM (
	SELECT u.user_id, u.username, o.order_date,
    LAG(o.order_date) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_date
    FROM Users u
    JOIN Orders o ON u.user_id = o.user_id) AS sq
WHERE DATEDIFF(sq.order_date, prev_date) = 1;