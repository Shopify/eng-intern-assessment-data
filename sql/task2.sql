-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) = (
    SELECT MAX(avg_rating)
    FROM (
        SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
        FROM Products p
        JOIN Reviews r ON p.product_id = r.product_id
        GROUP BY p.product_id, p.product_name
    ) AS avg_ratings
);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

--steps: Join all the orders with the products and categories, then group by user_id and category_id, then count the number of categories each user has ordered from, then filter for users who have ordered from all categories
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id, c.category_id
HAVING COUNT(DISTINCT c.category_id) = (
    SELECT COUNT(DISTINCT c.category_id)
    FROM Categories c
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id -- left join to include products that have not received any reviews
WHERE r.product_id IS NULL; -- filter for products that have not received any reviews


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Orders o2 ON u.user_id = o2.user_id -- join orders with itself to compare consecutive orders
WHERE o.order_date = o2.order_date - INTERVAL '1 day' -- filter for users who have made consecutive orders on consecutive days
AND o.order_id != o2.order_id; -- filter for users who have made consecutive orders on consecutive days