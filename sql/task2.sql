-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Use idea from Problem 3 (Task 1) to create subquery to get average rating for each product
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
HAVING average_rating = (SELECT MAX(average_rating) 
                         FROM (SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
                               FROM Products p
                               JOIN Reviews r ON p.product_id = r.product_id
                               GROUP BY p.product_id));

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Join table Users with table Orders, Order_Items, Products, and Categories to get the number of products in each category that each user has ordered; 
-- and then compare that number with the total number of categories to get the users who have made at least one order in each category
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items o_i ON o.order_id = o_i.order_id
JOIN Products p ON o_i.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id
HAVING COUNT(c.category_id) = (SELECT COUNT(category_id) 
                               FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Use left join to get products that have not received any reviews
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Join table Orders with itself  to compare consecutive orders on consecutive days
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id 
AND o1.order_date = DATE(o2.order_date, '+1 day');