-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    c.category_id,  -- Selecting category_id from the Categories table
    c.category_name,  -- Selecting category_name from the Categories table
    SUM(oi.unit_price * oi.quantity) AS total_sales_amount  -- Calculating the total sales amount for each category
FROM 
    Categories c  -- variable 'c' is used for the Categories table
    JOIN Products p ON c.category_id = p.category_id  -- Joining only when category_id is matching
    JOIN Order_Items oi ON p.product_id = oi.product_id  -- Join only when product_id is matching
GROUP BY 
    c.category_id,  -- Grouping the results by category_id
    c.category_name  -- Grouping the results by category_name
ORDER BY 
    total_sales_amount DESC  -- Ordering the results by total sales amount in descending order
LIMIT 3;  -- Limiting the results to the top (3) categories


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    u.user_id,  -- Selecting user_id from the Users table
    u.username  -- Selecting username from the Users table
FROM 
    Users u  -- variable 'u' is used for the Users table
WHERE NOT EXISTS (  -- Filtering to only include users who have placed orders for all products in the "Toys & Games"
    SELECT p.product_id  -- Selecting product_id from the Products table
    FROM 
        Products p  -- p is the Products table
    WHERE 
        p.category_id = (  -- Filtering to only include products in the Toys & Games category
            SELECT c.category_id  -- Selecting category_id from the Categories table
            FROM Categories c  -- c is Categories table
            WHERE c.category_name = 'Toys & Games'  -- Filtering to only include the Toys & Games category
        )
        AND p.product_id NOT IN (  -- Filtering to only include products that the user has not ordered
            SELECT oi.product_id  -- Select product_id from the Order_Items table
            FROM 
                Order_Items oi  -- variable 'oi' is used for the Order_Items table
                JOIN Orders o ON oi.order_id = o.order_id  -- Join only when order_id is matching
            WHERE o.user_id = u.user_id  -- Filtering to only include orders made by the user
        )
);



-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    p.product_id,  -- Selecting product_id from the Products table
    p.product_name,  -- Selecting product_name from the Products table
    p.category_id,  -- Selecting category_id from the Products table
    p.price  -- Selecting price from the Products table
FROM 
    Products p  -- variable 'p' is used for the Products table
    JOIN (
        SELECT 
            category_id,  -- Selecting category_id from the Products table
            MAX(price) AS max_price  -- Calculating the maximum price for each category
        FROM Products  -- This is the products table
        GROUP BY category_id  -- Grouping the results by category_id
    ) subq ON p.category_id = subq.category_id AND p.price = subq.max_price;  -- Joining only when category_id and price match




-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    u.user_id,  -- Selecting user_id from the Users table
    u.username  -- Selecting username from the Users table
FROM 
    Users u  -- variable 'u' is used for the Users table
    JOIN (
        SELECT o.user_id  -- Selecting user_id from the Orders table
        FROM 
            Orders o  -- variable 'o' is used for the Orders table
        WHERE EXISTS (  -- Filtering to only include users who have placed orders on consecutive days for at least 3 days
            SELECT 1
            FROM 
                Orders o2  -- variable 'o2' is used for the Orders table
            WHERE 
                o.user_id = o2.user_id AND  -- Filtering to only include orders made by the user
                ABS(julianday(o.order_date) - julianday(o2.order_date)) BETWEEN 1 AND 2  -- Filtering to only include orders made on consecutive days (using Julianday function)
            GROUP BY o2.user_id  -- Group the results by user_id
            HAVING COUNT(DISTINCT DATE(o2.order_date)) >= 3  -- Filtering to only include users who have placed orders on consecutive days for at least 3 days
        )
    ) subq ON u.user_id = subq.user_id;  -- Join only when user_id is matching
