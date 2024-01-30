-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- !!!!!! Used SQL Server instead of MySQL hence used TOP instead of LIMIT !!!!!!!
SELECT TOP 3
    c.category_id,
    c.category_name,
    SUM(oi.unit_price * oi.quantity) AS total_sales_amount -- get the total sales amount for each category by summing the product of unit price and quantity for all products in the category
FROM
    categories c
JOIN
    products p ON c.category_id = p.category_id 
JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY
    c.category_id, c.category_name 
ORDER BY
    total_sales_amount DESC ;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- CTE to get total number of products for the Toys & Games category

WITH total_products AS (
    SELECT 
        COUNT(DISTINCT product_id) AS total_products 
    FROM 
        categories
    JOIN        
        products ON categories.category_id = products.category_id
    WHERE
        categories.category_name like '%Toys & Games%' --used like since category names seem to have human errors
)   

-- need multiple joins to get the user_id and username for each order (outer join is ideal due to foreign key and primary constraints)
SELECT 
    u.user_id, 
    u.username    
FROM 
    users u 
JOIN    
    orders o ON u.user_id = o.user_id       
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    products p ON oi.product_id = p.product_id  
JOIN    
    categories c ON p.category_id = c.category_id
WHERE
    c.category_name like '%Toys & Games%' -- only return users who have placed orders for all products in the Toys & Games category   
GROUP BY
    u.user_id, 
    u.username  
HAVING  
    COUNT(DISTINCT p.product_id) = (SELECT total_products FROM total_products); 


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT 
    product_id, 
    product_name,
    category_id,
    price
FROM 
    Products AS p
WHERE 
    price = (
        SELECT 
            MAX(price) 
        FROM 
            Products 
        WHERE 
            category_id = p.category_id
    )
order BY category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- get the days between consecutive orders for each user
WITH days_between_orders AS (
    SELECT 
        user_id,
        order_date,
        DATEDIFF(day, LAG(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date), order_date) AS consecutive_diff_1,
        DATEDIFF(day, LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date), order_date) AS consecutive_diff_2
    FROM 
        orders
)

SELECT
    DISTINCT u.username,
    u.user_id
FROM 
    users u
JOIN 
    days_between_orders dbo ON u.user_id = dbo.user_id
-- filtering the results to include only users with orders placed on consecutive days for at least 3 days
WHERE 
    dbo.consecutive_diff_1 = 1
    AND dbo.consecutive_diff_2 = 2;


select * from Order_Items where order_id = 5;