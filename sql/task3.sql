-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- I used a LEFT JOIN to get all the categories and then a SUM to get the total sales amount
-- I then used an ORDER BY to sort the total sales amount in descending order and a LIMIT to get the top 3

SELECT 
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM 
    Categories c
LEFT JOIN 
    Products p ON c.category_id = p.category_id
LEFT JOIN 
    Order_Items oi ON p.product_id = oi.product_id
GROUP BY 
    c.category_id, c.category_name
ORDER BY 
    total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- I used four LEFT JOINS in order to get the users -> orders -> order_items -> products -> categories
-- Then I used COUNT and DISTINCT to get the number of products ordered by a user for the 'Toys & Games' category
-- Then I used a subquery to get the total number of products in the 'Toys & Games' category
-- Then I compared the number of products ordered by a user for the 'Toys & Games' category to the total number of products in the 'Toys & Games' category

SELECT 
    u.user_id,
    u.username
FROM 
    Users u
LEFT JOIN 
    Orders o ON u.user_id = o.user_id
LEFT JOIN 
    Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN 
    Products p ON oi.product_id = p.product_id
LEFT JOIN 
    Categories c ON p.category_id = c.category_id
WHERE 
    c.category_name = 'Toys & Games'
GROUP BY 
    u.user_id, u.username
HAVING 
    COUNT(DISTINCT p.product_id) = (
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

-- Here I used the ROW_NUMBER window function to get the products that have the highest price within each category
-- Then I selected the products that have a rank of 1

WITH RankedProducts AS (
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
    RankedProducts
WHERE 
    rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Similar to problem 8
-- Just need to add a second LAG to get the previous previous order date
-- Then I filtered the results to get the rows where the order date is equal to the previous order date + 1 day and the previous previous order date + 2 days

SELECT DISTINCT 
    u.user_id, 
    u.username
FROM 
    Users u
LEFT JOIN 
    (
        SELECT 
            user_id, 
            order_date,
            LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
            LAG(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_prev_order_date
        FROM 
            Orders
    ) AS ord ON u.user_id = ord.user_id
WHERE 
    ord.order_date = DATE(ord.prev_order_date, '+1 day') AND
    ord.order_date = DATE(ord.prev_prev_order_date, '+2 day');