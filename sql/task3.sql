-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, COALESCE(SUM(p.price), 0) AS "TOTAL SALES"
FROM CATEGORIES C
LEFT JOIN PRODUCTS p ON c.category_id = p.category_id
LEFT JOIN ORDER_ITEMS oi ON p.product_id = oi.product_id
LEFT JOIN ORDERS o ON oi.order_id = o.order_id
WHERE o.order_id IS NOT NULL
GROUP BY c.category_id, c.category_name
ORDER BY "TOTAL SALES" DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, u.username
FROM USERS u
JOIN ORDERS o ON u.user_id = o.user_id
JOIN ORDER_ITEMS oi ON o.order_id = oi.order_id
JOIN PRODUCTS p ON oi.product_id = p.product_id
JOIN CATEGORIES c ON p.category_id = c.category_id
WHERE c.category_name = 'Toys & Games'
GROUP BY u.user_id, u.username
HAVING
  COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(DISTINCT product_id)
    FROM PRODUCTS
    WHERE category_id = c.category_id
  );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT p.product_id, p.product_name, p.category_id, p.price
FROM PRODUCTS p
JOIN(
  SELECT category_id, MAX(price) AS "highest_price"
  FROM PRODUCTS
  GROUP BY category_id
)
hp ON p.category_id = hp.category_id AND p.price = hp.highest_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT u.user_id, u.username
FROM USERS u
JOIN ORDERS o1 ON u.user_id = o1.user_id
JOIN ORDERS o2 ON u.user_id = o2.user_id
JOIN ORDERS o3 ON u.user_id = o3.user_id
WHERE o2.order_date = o1.order_date + 1 AND o3.order_date = o2.order_date + 1
GROUP BY u.user_id, u.username;
