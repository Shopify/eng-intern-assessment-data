-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
WITH average_rating AS (
    SELECT product_id, AVG(rating) as avg_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT a.product_id, a.product_name, b.avg_rating
FROM Products a 
INNER JOIN average_rating b ON a.product_id = b.product_id
WHERE b.avg_rating = (SELECT MAX(avg_rating) FROM average_rating);
-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT a.user_id, a.username
FROM Users a  
WHERE NOT EXISTS (
    SELECT b.category_id
    FROM Categories b  
    WHERE NOT EXISTS (
        SELECT c.order_id
        FROM Orders c 
        INNER JOIN Products d ON c.product_id =d.product_id
        WHERE c.user_id = a.user_id AND d.category_id =b.category_id
      )
);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT a.product_id, a.product_name
FROM Products a 
LEFT JOIN Reviews b ON a.product_id =b.product_id
WHERE b.product_id is NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
WITH ordered_users AS (
    SELECT user_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS pre_order_date
    FROM Orders
)
SELECT DISTINCT a.user_id, a.username
FROM Users a 
INNER JOIN ordered_users b ON a.user_id =b.user_id
WHERE b.order_date = b.pre_order_date + INTERVAL '1 day'; 