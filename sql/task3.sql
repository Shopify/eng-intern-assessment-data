-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    C.category_id, 
    C.category_name, 
    SUM(OI.quantity * OI.unit_price) AS total_sales
FROM 
    Categories C
JOIN 
    Products P ON C.category_id = P.category_id
JOIN 
    Order_Items OI ON P.product_id = OI.product_id
GROUP BY 
    C.category_id, C.category_name
ORDER BY 
    total_sales DESC
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
    Categories C ON P.category_id = C.category_id AND C.category_name = 'Toys & Games'
GROUP BY 
    U.user_id
HAVING 
    COUNT(DISTINCT P.product_id) = (
        SELECT 
            COUNT(product_id) 
        FROM 
            Products 
        WHERE 
            category_id = (
                SELECT 
                    category_id 
                FROM 
                    Categories 
                WHERE 
                    category_name = 'Toys & Games'
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
INNER JOIN (
    SELECT 
        category_id, 
        MAX(price) AS max_price
    FROM 
        Products
    GROUP BY 
        category_id
) AS MaxPrices ON P.category_id = MaxPrices.category_id AND P.price = MaxPrices.max_price;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
WHERE (
    SELECT COUNT(DISTINCT order_date)
    FROM Orders
    WHERE user_id = u.user_id
    AND order_date BETWEEN o.order_date - INTERVAL 2 DAY AND o.order_date + INTERVAL 2 DAY
) >= 3;

