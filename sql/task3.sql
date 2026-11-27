-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH Sales_Per_Category AS (
    SELECT 
        prd.category_id, 
        SUM(oi.quantity * oi.unit_price) AS total_sales 
    FROM 
        Order_Items oi 
    LEFT JOIN 
        Products prd ON oi.product_id = prd.product_id
    GROUP BY 
        prd.category_id
)
SELECT 
    cat.category_id, 
    cat.category_name, 
    spc.total_sales 
FROM 
    Sales_Per_Category spc 
LEFT JOIN 
    Categories cat ON spc.category_id = cat.category_id
ORDER BY 
    spc.total_sales DESC
LIMIT 
    3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH Toy_Products AS (
    SELECT * 
    FROM Products 
    WHERE category_id = (
        SELECT category_id 
        FROM Categories 
        WHERE category_name = 'Toys & Games'
    )
)
SELECT 
    usr.user_id, 
    usr.username 
FROM
    Order_Items oi
RIGHT JOIN 
    Toy_Products tp ON oi.product_id = tp.product_id
JOIN 
    Orders ord ON oi.order_id = ord.order_id
JOIN 
    Users usr ON ord.user_id = usr.user_id
GROUP BY 
    usr.user_id
HAVING 
    COUNT(DISTINCT tp.product_id) = (SELECT COUNT(product_id) FROM Toy_Products);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH Ranked_Products AS (
    SELECT 
        product_id, 
        product_name, 
        category_id, 
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM 
        Products
)
SELECT 
    product_id, 
    product_name, 
    category_id, 
    price
FROM 
    Ranked_Products
WHERE 
    rank = 1;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH Order_Intervals AS (
    WITH Unique_Date_Orders AS (
        SELECT DISTINCT user_id, order_date
        FROM Orders
    )
    SELECT 
        user_id,
        order_date - LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS interval_1,
        order_date - LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS interval_2
    FROM 
        Unique_Date_Orders
)
SELECT DISTINCT 
    oi.user_id, 
    u.username 
FROM 
    Order_Intervals oi 
JOIN 
    Users u ON oi.user_id = u.user_id
WHERE 
    oi.interval_1 = 1 AND oi.interval_2 = 2;
