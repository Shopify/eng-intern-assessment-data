-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    Categories.category_id,
    Categories.category_name,
    SUM(Order_Items.quantity * Order_Items.unit_price) AS total_sales_amount
FROM
    Categories
JOIN
    Products ON Categories.category_id = Products.category_id
JOIN
    Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY
    Categories.category_id, Categories.category_name
ORDER BY
    total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT Users.user_id, Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
WHERE Users.user_id IN (
    SELECT DISTINCT Users.user_id
    FROM Users
    JOIN Orders ON Users.user_id = Orders.user_id
    JOIN Order_Items ON Orders.order_id = Order_Items.order_id
    JOIN Products ON Order_Items.product_id = Products.product_id
    JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games'
)
GROUP BY Users.user_id, Users.username
HAVING COUNT(DISTINCT Products.product_id) = (
    SELECT COUNT(*)
    FROM Products
    WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
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
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank
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

WITH UserConsecutiveOrders AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT DISTINCT Users.user_id, Users.username
FROM UserConsecutiveOrders
JOIN Users ON UserConsecutiveOrders.user_id = Users.user_id
WHERE DATEDIFF(order_date, prev_order_date) = 1
   OR (DATEDIFF(order_date, prev_order_date) = 2 AND
       LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) = order_date)
   OR (DATEDIFF(order_date, prev_order_date) = 3 AND
       LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) = order_date AND
       LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) = order_date);
