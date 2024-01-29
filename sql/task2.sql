-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Get average rating for each product and keep in result if its average rating
-- equals to max average rating
SELECT
    p.product_id,
    p.product_name,
    AVG(r.rating) AS avg_rating
FROM Products p
LEFT JOIN Reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id
HAVING AVG(r.rating) = (
    -- Get max average rating
    SELECT MAX(avg_rating)
    FROM (
        SELECT AVG(r.rating) AS avg_rating
        FROM Reviews r
        GROUP BY r.product_id
    ) AS average_ratings
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Get count of unique categories across all orders for each user, and keep in
-- result if user's count equals to total # of categories
SELECT
    u.user_id,
    u.username
FROM Users u
LEFT JOIN Orders o
    ON u.user_id = o.user_id
LEFT JOIN Order_Items oi
    ON o.order_id = oi.order_id
LEFT JOIN Products p 
    ON oi.product_id = p.product_id
GROUP BY u.user_id
HAVING COUNT(DISTINCT(p.category_id)) = (
    SELECT COUNT(*) FROM Categories
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT
    p.product_id,
    p.product_name
FROM Products p
LEFT JOIN Reviews r
    ON p.product_id = p.product_id
WHERE r.review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- For each user, keep in result if they have an order where the difference 
-- between order_date and order_date of their last order is 1 day
SELECT DISTINCT
    u.user_id,
    u.username
FROM Users u
LEFT JOIN (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date
    FROM Orders
) AS dates ON u.user_id = dates.user_id
WHERE order_date - prev_date = 1;