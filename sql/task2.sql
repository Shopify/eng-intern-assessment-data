-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH AVG_RATING AS (
     SELECT product_id, AVG(rating) as average_rating
     FROM Reviews
     GROUP BY product_id
 )
 SELECT p.product_id, p.product_name, a.average_rating 
 FROM Products p
 INNER JOIN AVG_RATING a
 ON p.product_id = a.product_id
 ORDER BY a.average_rating;
 -- Return a list of all products with their average rating in descending order of average rating. If the question is asking
 -- for only products with the highest average rating, then you can use
 -- "WHERE a.average_rating = (SELECT MAX(avg_rating) FROM AVG_RATING)"


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
 FROM Users u
 INNER JOIN Orders o ON u.user_id = o.user_id
 INNER JOIN Order_Items oi ON o.order_id = oi.order_id
 INNER JOIN Products p ON oi.product_id = p.product_id
 GROUP BY u.user_id, u.username
 HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
 FROM Products p
 WHERE NOT EXISTS 
     (SELECT * 
     FROM Reviews r
     WHERE p.product_id = r.product_id);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
 FROM Users u 
 INNER JOIN Orders o ON u.user_id = o.user_id
 INNER JOIN Orders oo ON u.user_id = oo.user_id
 WHERE DATEDIFF(day, o.order_date, oo.order_date) = 1;