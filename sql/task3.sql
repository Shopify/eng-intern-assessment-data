-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    c.category_id,
    c.category_name,
    SUM(p.amount) AS total_sales_amount
FROM Categories c
JOIN Products pr ON c.category_id = pr.category_id
JOIN Order_Items oi ON pr.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT 
    u.user_id,
    u.username
FROM Users u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products p
    WHERE p.category_id = (
        SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
    )
    EXCEPT
    SELECT oi.product_id
    FROM Order_Items oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE o.user_id = u.user_id
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
        ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) AS rank
    FROM Products
)
SELECT 
    product_id,
    product_name,
    category_id,
    price
FROM RankedProducts
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH OrderedUsers AS (
    SELECT 
        user_id,
        order_date,
        LEAD(order_date, 1) OVER(PARTITION BY user_id ORDER BY order_date) AS next_order_date,
        LEAD(order_date, 2) OVER(PARTITION BY user_id ORDER BY order_date) AS next_next_order_date
    FROM Orders
)
SELECT 
    DISTINCT ou1.user_id,
    u.username
FROM OrderedUsers ou1
JOIN OrderedUsers ou2 ON ou1.user_id = ou2.user_id AND ou1.next_order_date = ou2.order_date
JOIN OrderedUsers ou3 ON ou1.user_id = ou3.user_id AND ou2.next_next_order_date = ou3.order_date
JOIN Users u ON ou1.user_id = u.user_id;
