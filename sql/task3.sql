-- Problem 9: Retrieve the top 3 categories with the highest total sales amount

-- JOINS Order_Items with Orders, and then Products with Order_Items to link products to their sales.
-- Further joins Categories to include category names.
-- GROUP BY is used to group sales by category.
-- Orders the results by total sales in descending order and limits to the top 3 categories.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games

-- JOINS multiple tables to link users with their orders and product categories.
-- A subquery is used to count the number of distinct products in the Toys & Games category.
-- The HAVING clause compares this count with the count of distinct products ordered by each user in this category.
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
)
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*) FROM Products WHERE category_id = (
        SELECT category_id FROM Categories WHERE category_name = 'Toys & Games'
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category

-- Uses a subquery to determine the maximum price for each category.
-- The outer query selects products that match this maximum price within their respective category.
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p
WHERE (p.category_id, p.price) IN (
    SELECT category_id, MAX(price)
    FROM Products
    GROUP BY category_id
);


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days

-- self-JOINs on the Orders table to compare dates of different orders for the same user.
-- filters for users with consecutive orders spanning at least 3 days.
-- this is ugly but idk how else to approach this...
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id
JOIN Orders o3 ON u.user_id = o3.user_id
WHERE ABS(DATEDIFF(o1.order_date, o2.order_date)) = 1
AND ABS(DATEDIFF(o2.order_date, o3.order_date)) = 1
AND o1.order_id <> o2.order_id
AND o2.order_id <> o3.order_id;

