-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT p.product_id, p.product_name, r.avgRating AS AverageRating
FROM Products p INNER JOIN (
    SELECT r.product_id, AVG(r.rating) as avgRating
    FROM Reviews r
    GROUP BY r.product_id
) averages ON p.product_id = averages.product_id
WHERE averages.avgRating = (
    SELECT MAX(r.avgRating)
    FROM (
        SELECT AVG(r.rating) as avgRating
        FROM Reviews r
        GROUP BY r.product_id
    ) 
)

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id
INNER JOIN Order_Items oi ON o.order_id = oi.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(c.category_id) FROM Categories c);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name 
FROM Products p LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id = NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
FROM Users u INNER JOIN Orders o ON u.user_id = o.user_id 
INNER JOIN Orders ord ON u.user_id = ord.user_id
WHERE o.order_id <> ord.order_id AND o.order_date = ord.order_date + INTERVAL 1 DAY 
OR o.order_date = ord.order_date - INTERVAL 1 DAY;

