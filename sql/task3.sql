-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT a.category_id, a.category_name, SUM(b.quantity * b.unit_price) as total_sales_amount
FROM Categories a
INNER JOIN Products c ON a.category_id = c.category_id
INNER JOIN Order_Items b ON b.product_id = c.product_id
GROUP BY a.category_id, a.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Comment: In Cartegories table where Toys & Games value has a category_id of 5
SELECT a.user_id, a.username
FROM
    Users a
INNER JOIN 
    Orders b ON a.user_id = b.user_id
INNER JOIN 
    Order_Items c ON c.order_id = b.order_id
INNER JOIN 
    Products d ON c.product_id = d.product_id
INNER JOIN 
    Categories e ON d.category_id = e.category_id
WHERE e.category_name = 'Toys & Games'
GROUP BY 
    a.user_id, a.username
HAVING COUNT(DISTINCT d.product_id) = (
    SELECT COUNT(*) FROM Products p
    INNER JOIN Categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Toys & Games'
);



-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT a.product_id, a.product_name, a.price, a.category_id
FROM Products a
JOIN (
    SELECT category_id, MAX(price) as max_price
    FROM Products
    GROUP BY category_id
) b ON a.category_id = b.category_id AND a.price = b.max_price;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT a.user_id, a.username
FROM Users a
INNER JOIN (
    SELECT user_id, order_date, 
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS pre_order_date,
        CASE 
            WHEN julianday(order_date) - julianday(LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date)) = 1 THEN 1
            ELSE 0
        END AS is_consecutive
    FROM Orders
) b ON a.user_id = b.user_id
GROUP BY a.user_id, a.username, order_date
HAVING COUNT(order_date) >= 3;



