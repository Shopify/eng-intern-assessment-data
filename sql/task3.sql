-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    category_id,
    category_name,
    total_sales_amount
FROM (
    SELECT
        c.category_id,
        c.category_name,
        SUM(o.total_amount) AS total_sales_amount,
        RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS rnk
    FROM
        Categories c
    JOIN Products p ON c.category_id = p.category_id
    JOIN Order_Items oi ON p.product_id = oi.product_id
    JOIN Orders o ON oi.order_id = o.order_id
    GROUP BY
        c.category_id, c.category_name
) ranked_categories
WHERE
    rnk <= 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    u.user_id,
    u.username
FROM
    Users u
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM Products p
    WHERE p.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
    AND NOT EXISTS (
        SELECT 1
        FROM Orders o
        JOIN Order_Items oi ON o.order_id = oi.order_id
        WHERE u.user_id = o.user_id AND oi.product_id = p.product_id
    )
);


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.price
FROM
    Products p
WHERE
    p.price = (
        SELECT
            MAX(price) AS max_price
        FROM
            Products p2
        WHERE
            p.category_id = p2.category_id
        GROUP BY
            category_id
     );



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


WITH UserConsecutiveOrders AS (
  SELECT
    u.user_id,
    u.username,
    o.order_date,
    LAG(o.order_date, 1) OVER (PARTITION BY u.user_id ORDER BY o.order_date) AS prev_order_date
  FROM
    Users u
    JOIN Orders o ON u.user_id = o.user_id
)

SELECT DISTINCT
  user_id,
  username
FROM (
  SELECT
    user_id,
    username,
    order_date,
    prev_order_date,
    LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
  FROM
    UserConsecutiveOrders
) AS ConsecutiveDays
WHERE
  DATEDIFF(d,next_order_date, order_date) = 1
  AND DATEDIFF(d,order_date, prev_order_date) = 1;






