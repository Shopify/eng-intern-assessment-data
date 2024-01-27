-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount -- calculate the total sales amount
FROM
    Categories c
    JOIN Products p ON c.category_id = p.category_id
    JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY total_sales_amount DESC
LIMIT 3; -- limit to the top 3 categories


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH
    AllToyGameProducts AS (
        -- CTE containing all toys & games products
        SELECT *
        FROM Products p
            JOIN Categories c ON p.category_id = c.category_id
        WHERE
            c.category_name = 'Toys & Games'
    )
SELECT u.user_id, u.username
FROM
    Users u
    JOIN Orders o ON u.user_id = o.user_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Categories c ON p.category_id = c.category_id
WHERE
    c.category_name = 'Toys & Games' -- retrieves all toys & games products each user has bought
GROUP BY
    u.user_id
    -- filters for the users where the number of toys & games products they have bought is equal to the total number of toys & games products
HAVING
    COUNT(DISTINCT p.product_id) = (
        SELECT COUNT(*)
        FROM AllToyGameProducts
    );


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH
    ProductPriceRanking AS (
        -- rank the products based on their price for each category
        SELECT p.product_id, p.product_name, p.category_id, p.price, RANK() OVER (
                PARTITION BY
                    p.category_id
                ORDER BY p.price DESC
            ) as price_ranking
        FROM Products p
    )
-- MAIN QUERY
SELECT
    product_id,
    product_name,
    category_id,
    price
FROM ProductPriceRanking
WHERE
    price_ranking = 1; -- get the top ranking product from each category


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username FROM ( -- distinct to ensure unique users
-- subquery to retrieve user_id and the next 3 order dates
	SELECT o.user_id, o.order_date,
        -- use lead to get the next_order_date and next_next_order_date
		LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
        LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_next_order_date
	FROM Orders o
) AS sub_query
JOIN Users u ON sub_query.user_id = u.user_id
-- include only users who have made consecutive orders on 3 consecutive days
WHERE sub_query.order_date = sub_query.next_order_date - INTERVAL '1 day'
AND sub_query.order_date = sub_query.next_next_order_date - INTERVAL '2 days';