-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    c.category_id,
    c.category_name,
    SUM(o.total_amount) AS total_sales_amount

FROM
    Categories c
JOIN
    Products p ON c.category_id = p.category_id
LEFT JOIN   
    Order_Items oi ON p.product_id = oi.product_id
LEFT JOIN
    Orders o ON oi.order_id = o.order_id
GROUP BY
    c.category_id, c.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    u.user_id, 
    u.username
FROM
    Users u
JOIN
    Orders o ON u.user_id = o.user_id
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
JOIN
    Products p ON oi.product_id = p.product_id
JOIN
    Categories c ON p.category_id = c.category_id
WHERE 
    c.category_name = 'Toys & Games'
GROUP BY
    u.user_id, u.username
HAVING
    COUNT(DISTINCT p.product_id) = (
        SELECT
            COUNT(DISTINCT p2.product_id)

        FROM 
            Products p2

        WHERE
            p2.category_id = c.category_id
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH RankedProducts AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num
    FROM
        Products
)
SELECT
    product_id,
    product_name,
    category_id,
    price

FROM
    RankedProducts

WHERE
    row_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH UserConsecutiveOrders AS (
    SELECT
        o.user_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date

    FROM 
        Orders o
)

SELECT DISTINCT
    uco1.user_id,
    u.username
FROM
    UserConsecutiveOrders uco1
JOIN
    UserConsecutiveOrders uco2 ON uco1.user_id = uco2.user_id
JOIN 
    User u ON uco1.user_id = u.user_id
WHERE
    DATEDIFF(uco1.order_date, uco1.prev_order_date) = 1
    AND DATEDIFF (uco2.order_date, uco1.order_date) = 1
    AND uco1.order_date < uco2.order_date
    AND NOT EXISTS (
        SELECT 1
        FROM 
            UserConsecutiveOrders uco3
        
        WHERE
            uco3.user_id = uco1.user_id
            AND DATEDIFF(uco3.order_date, uco2.order_date) = 1
    )
