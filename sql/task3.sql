-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
Select c.category_id, category_name, SUM(total_amount) as total_amount
From
    `Categories` c
    Inner Join `Products` p ON c.category_id = p.category_id
    Inner Join `Order_Items` oi ON oi.product_id = p.product_id
    Inner Join `Orders` o ON oi.order_id = o.order_id
GROUP BY
    C.category_id
ORDER BY total_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT u.user_id, username
FROM
    `Users` u
    JOIN `Orders` o ON u.user_id = o.user_id
    JOIN `Order_Items` oi ON o.order_id = oi.order_id
    JOIN `Products` p ON oi.product_id = p.product_id
    JOIN (
        SELECT category_id
        FROM `Categories`
        WHERE
            category_name = 'Toys & Games'
    ) Toys ON p.category_id = Toys.category_id
GROUP BY
    u.user_id,
    u.username,
    Toys.category_id
HAVING
    COUNT(DISTINCT P.product_id) = (
        SELECT COUNT(*)
        FROM `Products`
        WHERE
            category_id = Toys.category_id
    );

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM `Products` p
    JOIN (
        SELECT category_id, MAX(price) AS max_price
        FROM `Products`
        GROUP BY
            category_id
    ) P_MAX ON p.category_id = P_MAX.category_id
    AND p.price = P_MAX.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT u.user_id, u.username
FROM
    `Users` u
    JOIN `Orders` o1 on u.user_id = o1.user_id
    JOIN `Orders` o2 on u.user_id = o2.user_id
    AND o2.order_date = DATE_ADD(o1.order_date, INTERVAL 1 DAY)
    JOIN `Orders` o3 on u.user_id = o3.user_id
    AND o3.order_date = DATE_ADD(o1.order_date, INTERVAL 2 DAY)
GROUP BY
    u.user_id,
    u.username
HAVING
    COUNT(DISTINCT o1.order_id) > 2;