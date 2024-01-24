-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    c.category_id,
    c.category_name,
    SUM(oi.unit_price * oi.quantity) AS total_sales_amount
FROM category_data c
JOIN product_data p ON c.category_id = p.category_id
JOIN order_items_data oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT ud.user_id, ud.username
FROM user_data ud
JOIN order_data od ON ud.user_id = od.user_id
JOIN order_items_data oid ON od.order_id = oid.order_id
JOIN product_data pd ON oid.product_id = pd.product_id
JOIN category_data cd ON pd.category_id = cd.category_id
WHERE cd.category_name = 'Toys & Games'
GROUP BY ud.user_id, ud.username
HAVING COUNT(DISTINCT pd.product_id) = (SELECT COUNT(*) FROM product_data WHERE category_id = cd.category_id);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT pd.product_id, pd.product_name, pd.category_id, pd.price
FROM product_data pd
INNER JOIN (SELECT category_id, MAX(price) AS max_price
            FROM product_data GROUP BY category_id) AS max_prices
ON pd.category_id = max_prices.category_id AND pd.price = max_prices.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT u.user_id, u.username
FROM user_data u
WHERE EXISTS (SELECT 1
        FROM order_data o1
        JOIN order_data o2 ON o1.user_id = o2.user_id AND o1.order_id <> o2.order_id
        JOIN order_data o3 ON o1.user_id = o3.user_id AND o1.order_id <> o3.order_id AND o2.order_id <> o3.order_id
        WHERE u.user_id = o1.user_id
          AND ABS(julianday(o1.order_date) - julianday(o2.order_date)) = 1
          AND ABS(julianday(o2.order_date) - julianday(o3.order_date)) = 1
        )
GROUP BY u.user_id, u.username;
