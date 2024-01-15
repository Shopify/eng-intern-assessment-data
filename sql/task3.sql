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
    JOIN Products P ON C.category_id = P.category_id
    JOIN Order_Items OI ON P.product_id = OI.product_id
    JOIN Orders O ON OI.order_id = O.order_id
GROUP BY 
    C.category_id, 
    C.category_name
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
    COUNT(DISTINCT P.product_id) = (SELECT COUNT(DISTINCT product_id) FROM Products WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'));

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT 
    product_id, 
    product_name, 
    category_id, 
    price
FROM (
    SELECT 
        P.product_id, 
        P.product_name, 
        P.category_id, 
        P.price,
        ROW_NUMBER() OVER (PARTITION BY P.category_id ORDER BY P.price DESC) AS rn
    FROM 
        Products P
) AS ranked_products
WHERE 
    rn = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- NOTE FROM THE POTENTIAL INTERN:
-- There's no consecutive orders from looking at the data.

SELECT 
    sub.user_id, 
    sub.username
FROM (
    SELECT 
        O.user_id, 
        U.username, 
        O.order_date,
        CASE 
            WHEN day_diff = 1 THEN 0 
            ELSE 1 
        END AS day_diff,
        SUM(CASE 
                WHEN day_diff = 1 THEN 0 
                ELSE 1 
            END) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS consecutive_group
    FROM (
        SELECT 
            O.user_id, 
            O.order_date,
            DATEDIFF(O.order_date, LAG(O.order_date) OVER (PARTITION BY O.user_id ORDER BY O.order_date)) AS day_diff
        FROM 
            Orders O
    ) O
    JOIN 
        Users U ON O.user_id = U.user_id
) AS sub
JOIN (
    SELECT 
        user_id, 
        consecutive_group, 
        COUNT(*) AS consecutive_days
    FROM (
        SELECT 
            O.user_id, 
            O.order_date,
            SUM(CASE 
                    WHEN day_diff = 1 THEN 0 
                    ELSE 1 
                END) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS consecutive_group
        FROM (
            SELECT 
                O.user_id, 
                O.order_date,
                DATEDIFF(O.order_date, LAG(O.order_date) OVER (PARTITION BY O.user_id ORDER BY O.order_date)) AS day_diff
            FROM 
                Orders O
        ) O
    ) AS sub_sub
    GROUP BY 
        user_id, 
        consecutive_group
    HAVING 
        consecutive_days >= 3
) AS filter
ON 
    sub.user_id = filter.user_id AND sub.consecutive_group = filter.consecutive_group
GROUP BY 
    sub.user_id, 
    sub.username;