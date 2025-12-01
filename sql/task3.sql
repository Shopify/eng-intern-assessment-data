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
LEFT JOIN
    Products p ON c.category_id = p.category_id
LEFT JOIN
    Order_Items oi ON p.product_id = oi.product_id
LEFT JOIN
    Orders o ON oi.order_id = o.order_id
GROUP BY
    c.category_id
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
LEFT JOIN
    Orders o ON u.user_id = o.user_id
LEFT JOIN
    Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN
    Products p ON oi.product_id = p.product_id
WHERE
    p.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
GROUP BY
    u.user_id
HAVING
    COUNT(DISTINCT p.product_id) = (SELECT COUNT(DISTINCT product_id) FROM Products WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'));


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH HighestProductPrices AS (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_rank
    FROM Products
)
SELECT
    product_id,
    product_name,
    category_id,
    price
FROM HighestProductPrices
WHERE row_rank = 1;
-- use of CTE ensures ties are handled correctly for cases with multiple products with the same maximum price


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT
    u.user_id,
    u.username
FROM
    Users u
LEFT JOIN
    Orders o1 ON u.user_id = o1.user_id
LEFT JOIN
    Orders o2 ON u.user_id = o2.user_id AND o1.order_date = DATE_ADD(o2.order_date, INTERVAL 1 DAY)
LEFT JOIN
    Orders o3 ON u.user_id = o3.user_id AND o2.order_date = DATE_ADD(o3.order_date, INTERVAL 1 DAY);
-- join statements above filter out all cases where order dates are not consecutive