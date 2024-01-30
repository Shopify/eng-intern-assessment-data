-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.


SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
LEFT JOIN Reviews r on r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC
LIMIT 1;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Counts the distinct categories for each user and compares it to the total count of categories in 'Categories'
-- If equal, then user has made atleast one order in each category
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON o.user_id = u.user_id
JOIN Order_Items oi on oi.order_id = o.order_id
JOIN Products p on p.product_id = oi.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories);




-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.


SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r on r.product_id = p.product_id
WHERE r.review_id IS NULL;




-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Calculates new column 'prev_order_date' for each order
WITH PrevOrders AS (
  SELECT user_id, order_id, order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
  FROM Orders
)
-- Select only those users who have made consecutive orders on consecutive days
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN PrevOrders o ON u.user_id = o.user_id
WHERE o.order_date = o.prev_order_date + INTERVAL 1 DAY;
