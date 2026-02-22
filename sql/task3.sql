-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Tables: Categories(c), Products(p), Order_Items(oi)
SELECT
    c.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY 
    c.category_id, 
    c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Retrieves users who placed orders for all products in the Toys & Games
-- Tables: Users(u), Categories(c), Orders(o), Order_Items(oi) Products(p), 
SELECT
    u.user_id,
    u.username
FROM Users u 
-- Joins Orders (o), Order_Items (oi), Products (p), and Categories (c)
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games' -- filters to products only in the 'Toys & Games' category
GROUP BY 
    u.user_id, 
    u.username
-- Checks if the count of distinct products equals the number ordered by each user (they ordered for all products)
HAVING COUNT(DISTINCT p.product_id) = ( -- Counts the distinct products ordered by each user
    SELECT COUNT(*)
    FROM Products
    WHERE category_id IN (
        SELECT category_id
        FROM Categories
        WHERE category_name = 'Toys & Games'
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Saves product information sorted by price 
WITH ProductsByPrice AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY price desc
        ) AS rank -- Saves the products price ranking as rank (1 meaning highest price)
    FROM Products
)

-- Selects all products that are ranked the highest price from each category
SELECT
    product_id,
    product_name,
    category_id,
    price
FROM ProductsByPrice
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT
    u.user_id,
    u.username
FROM Users u 
JOIN Orders o1 
    ON u.user_id = o1.user_id
JOIN Orders o2 
    ON u.user_id = o2.user_id
    AND o2.order_date - o1.order_date = 1 
JOIN Orders o3
    ON u.user_id = o3.user_id 
    AND o3.order_date - o1.order_date = 2;