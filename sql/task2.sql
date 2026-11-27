-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- First calculate the average rating for each product, given that it has been reviewed,
-- and then select the product with the highest average rating.
SELECT product_id, product_name, AVG(rating) AS avg_rating
FROM Products NATURAL JOIN Reviews
GROUP BY product_id
ORDER BY avg_rating DESC
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Find all the user_is, username, and category_id pairs grouped by user_id, 
-- then count the number of distinct categories for each user.
SELECT user_id, username
FROM Users NATURAL JOIN Orders NATURAL JOIN Order_Items NATURAL JOIN Products NATURAL JOIN Categories
GROUP BY user_id
HAVING COUNT(DISTINCT category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- First select all products, and then subtract it by the products that have received reviews.
SELECT product_id, product_name
FROM Products
EXCEPT
SELECT product_id, product_name
FROM Products NATURAL JOIN Reviews;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- First calculate the last order date for each order by each user.
WITH Last_Order AS (
    SELECT 
        user_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS last_order_date
    FROM Orders
)
-- Then select the users who have made consecutive orders on consecutive days (i.e., the order date is the last order date + 1 day).
SELECT DISTINCT user_id, username
FROM Users NATURAL JOIN Last_Order
WHERE order_date = last_order_date + INTERVAL '1' DAY;