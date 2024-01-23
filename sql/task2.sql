-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
    WITH PrdAvgRating AS ( -- CTE that calculate avg rating of each product
        SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating
        FROM Products p
        JOIN Reviews r ON p.product_id = r.product_id
        GROUP BY p.product_id, p.product_name
    )
    SELECT product_id, product_name, avg_rating
    FROM PrdAvgRating
    ORDER BY avg_rating DESC
    LIMIT 1; -- the highest

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
    SELECT u.user_id, u.username
    FROM Users u
    WHERE
        EXISTS ( -- determine the presence
            SELECT DISTINCT o.category_id
            FROM Orders o
            JOIN Order_Items i on o.order_id = i.order_id
            JOIN Products p on o.product_id = p.product_id
            WHERE u.user_id = o.user_id
        )
        
        AND 
        
        NOT EXISTS ( -- determine the absence
            SELECT c.category_id
            FROM Categories c
            WHERE NOT EXISTS ( 
                SELECT DISTINCT o.category_id -- ensure each category is considered unique
                FROM Orders o
                JOIN Order_Items i on o.order_id = i.order_id
                JOIN Products p on o.product_id = p.product_id
                WHERE u.user_id = o.user_id AND c.category_id = o.category_id
            )
        );
    
-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
    SELECT p.product_id, p.product_name
    FROM Products p
    LEFT JOIN Reviews r ON p.product_id = r.product_id
    WHERE r.review_id IS NULL; -- ensure only product is selected without review 

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
    WITH ConsecOrders AS (
        SELECT user_id, order_id, order_date, LAG(order_date) OVER 
                                                    (PARTITION BY user_id 
                                                    ORDER BY order_date)
                                                    AS prev_order_date -- retrieve the previous order date for each order
        FROM Orders
    )
    SELECT DISTINCT u.user_id, u.username
    FROM Users u
    JOIN ConsecOrders co ON u.user_id = co.user_id
    WHERE DATEDIFF (order_date, prev_order_date) = 1 OR prev_order_date IS NULL; -- filters for consecutive orders on consecutive days with a day difference of 1.