-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    SELECT c.category_id, c.category_name, SUM (o.total_amt) AS total_sales_amt
    FROM Categories c
    JOIN Products p ON c.category_id = p.category_id
    JOIN Order_Items i ON p.product_id = i.product_id
    JOIN Orders o ON o.order_id = i.order_id
    GROUP BY c.category_id, c.category_name
    ORDER BY total_sales_amt DESC
    LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    WITH ToyAndGames AS (
        SELECT product_id
        FROM Products
        WHERE category_id = 5
    )

    SELECT u.user_id, u.username
    FROM Users u
    WHERE NOT EXISTS (
        SELECT t.product_id
        FROM ToyAndGames t
        WHERE NOT EXISTS (
            SELECT 1
            FROM Order_Items i
            JOIN Orders o ON o.order_id = i.order_id
            WHERE u.user_id = o.user_id AND i.product_id = t.product_id
        )
    );
-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    WITH HighestPrice AS (
        SELECT product_id, product_name, category_id, price, ROW_NUMBER () OVER 
                                                                (PARTITION BY category_id
                                                                ORDER BY price DESC)
                                                                AS r_num
        FROM Products
    )

    SELECT product_id, product_name, category_id, price
    FROM HighestPrice
    WHERE r_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    WITH ConsecDays AS (
        SELECT user_id, order_date, 
               LAG (order_date) OVER (PARTITION BY user_id
                                    ORDER BY order_date)
                                    AS prev_order_date,  
                LEAD (order_date) OVER (PARTITION BY user_id
                                    ORDER BY order_date)
                                    AS next_order_date
        FROM Orders
    )

    SELECT DISTINCT u.user_id, u.username
    FROM Users u
    JOIN ConsecDays cd ON u.user_id = cd.user_id
    WHERE DATEDIFF (cd.order_date, cd.prev_order_date) = 1 
            AND DATEDIFF (cd.next_order_date, cd.order_date) = 1
            AND EXISTS (
                SELECT 1
                FROM Orders o
                WHERE o.user_id = u.user_id
                GROUP BY o.user_id
                HAVING COUNT(DISTINCT o.order_date) >= 3
            );