-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

WITH AverageRatings AS(
    SELECT p.product_id, p.product_name, 
        CASE 
            WHEN COUNT(r.rating > 0) THEN AVG(r.rating) AS avg
            ELSE 0 AS avg
        END
    FROM Products p
    LEFT JOIN Reviews r ON  p.product_id = r.product_id
    GROUP BY p.product_id, p.product_name
    )
SELECT TOP 1 a.product_id, a.product_name, a.avg AS [Average Rating]
FROM AverageRatings a
ORDER BY [Average Rating] DESC;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT u.user_id, u.username
FROM Users u
INNER JOIN Orders o ON u.user_id = o.user_id
INNER JOIN Order_Items ot ON ot.order_id = o.order_id
INNER JOIN Product p ON p.product_id = ot.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories c);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.


SELECT p.product_id, p.product_name
FROM Products p, Reviews r 
WHERE p.product_id NOT IN (
                            SELECT DISTINCT r2.product_id
                            FROM reviews r2 );


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Take users where for each user, select orders where: exists orders that have a date later that than the current
                                        -- AND that order occurs exactly one day after 

SELECT u.user_id, u.username
FROM Users u, Orders o  
WHERE u.user_id = o.user_id AND (
            NOT NULL ( 
                        SELECT * FROM users u2, orders o2
                        WHERE o2.order_date > o.order_date AND 1 = (DATEDIFF(day,o.order_date,o2.order_date))  
            )
        );

