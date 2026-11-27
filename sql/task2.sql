-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- assuming problem is to find the product with the highest average rating
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
HAVING AVG(r.rating) = (SELECT MAX(AVG(rating)) FROM Reviews GROUP BY product_id);
-- above statement ensures we get the max rating and handles cases where they may be multiple products with the same max rating


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT
    u.user_id,
    u.username
FROM
    Users u
LEFT JOIN
    Orders o ON u.user_id = o.user_id
LEFT JOIN
    Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN
    Products p ON oi.product_id = p.product_id
GROUP BY
    u.user_id
HAVING
    COUNT(DISTINCT p.category_id) = (SELECT COUNT(DISTINCT category_id) FROM Categories); -- this will be equal ONLY if they have at least one order in each category due to the use of "distinct"


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM Products p 
LEFT JOIN Reviews r on p.product_id = r.product_id
WHERE r.review_id is NULL; -- this will ONLY be null if no reviews

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM Users u 
LEFT JOIN Orders o1 on u.user_id = o1.user_id
LEFT JOIN Orders o2 on u.user_id = o2.user_id AND o1.order_date = DATE_ADD(o2.order_date, INTERVAL 1 DAY);
-- statement above filters out all cases where the order dates are not consecutive