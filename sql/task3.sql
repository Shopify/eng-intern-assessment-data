-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    C.category_id, 
    C.category_name, 
    SUM(OI.quantity * OI.unit_price) AS total_sales_amount
FROM 
    Categories C
JOIN 
    Products P ON C.category_id = P.category_id
JOIN 
    Order_Items OI ON P.product_id = OI.product_id
GROUP BY 
    C.category_id
ORDER BY 
    total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    U.user_id, 
    U.username
FROM 
    Users U
JOIN 
    Orders O ON U.user_id = O.user_id
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
JOIN 
    Products P ON OI.product_id = P.product_id
JOIN 
    Categories C ON P.category_id = C.category_id
WHERE 
    C.category_name = 'Toys & Games'
GROUP BY 
    U.user_id
HAVING 
    COUNT(DISTINCT P.product_id) = (
        SELECT COUNT(*) 
        FROM Products 
        WHERE category_id = (
            SELECT category_id 
            FROM Categories 
            WHERE category_name = 'Toys & Games'
        )
    );


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    P.product_id, 
    P.product_name, 
    P.category_id, 
    P.price
FROM 
    Products P
WHERE 
    (P.category_id, P.price) IN (
        SELECT 
            category_id, 
            MAX(price)
        FROM 
            Products
        GROUP BY 
            category_id
    );


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    U.user_id, 
    U.username
FROM 
    Users U
WHERE 
    EXISTS (
        SELECT 1
        FROM 
            Orders O1
        WHERE 
            O1.user_id = U.user_id AND
            EXISTS (
                SELECT 1
                FROM 
                    Orders O2
                WHERE 
                    O2.user_id = O1.user_id AND
                    DATE(O1.order_date) = DATE(O2.order_date, '+1 day') AND
                    EXISTS (
                        SELECT 1
                        FROM 
                            Orders O3
                        WHERE 
                            O3.user_id = O2.user_id AND
                            DATE(O2.order_date) = DATE(O3.order_date, '+1 day')
                    )
            )
    );
