-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT p.product_id, p.product_name,ROUND(AVG(r.rating), 2) AS average_rating
FROM Products p LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) = (
        SELECT MAX(avg_rating)
        FROM ( SELECT product_id, AVG(rating) AS avg_rating
            FROM Reviews
            GROUP BY product_id) AS product_avg
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT u.user_id, u.username FROM Users u
WHERE EXISTS (
        SELECT c.category_id FROM Categories c
        WHERE NOT EXISTS (
                SELECT p.product_id FROM Products p
                WHERE NOT EXISTS (
                        SELECT o.order_id FROM Orders o
                        WHERE
                            o.user_id = u.user_id
                            AND EXISTS (
                                SELECT oi.order_item_id FROM Order_Items oi
                                    JOIN Products p2 ON oi.product_id = p2.product_id
                                WHERE p2.category_id = c.category_id AND oi.order_id = o.order_id
                            )
                    )
            )
    );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT user_id, username FROM Users
WHERE user_id IN ( SELECT DISTINCT o1.user_id FROM Orders o1
    JOIN Orders o2 ON o1.user_id = o2.user_id
        AND o1.order_date = o2.order_date + INTERVAL '1 day'
);

