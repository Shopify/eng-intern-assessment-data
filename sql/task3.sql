-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- This query will retrieve the top 3 categories with the highest total sales amount.
-- The SUM function is used to calculate the total sales amount for each category.
-- A JOIN statement is used to combine the category data, product data, and order item data based on their category ID and product ID.
-- The GROUP BY clause is used to group the result by category ID and category name.
-- The ORDER BY clause is used to sort the result by total sales amount in descending order.
-- The LIMIT clause is used to limit the result to only include the top 3 categories.
SELECT cd.category_id, cd.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Categories AS cd
JOIN Products AS pd ON cd.category_id = pd.category_id
JOIN Order_Items AS oi ON pd.product_id = oi.product_id
GROUP BY cd.category_id, cd.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- This query will retrieve the users who have placed orders for all products in the Toys & Games category.
-- The NOT EXISTS checks that there is no product in the "Toys & Games" category for which the user has not placed an order.
-- If the subquery returns any rows (i.e., there is at least one product for which the user has not placed an order), the condition evaluates to FALSE.
-- If the subquery returns no rows (i.e., the user has placed orders for all products in the "Toys & Games" category), the condition evaluates to TRUE
-- The subquery is used to retrieve the users who have placed orders for all products in the Toys & Games category.
SELECT ud.user_id, ud.username
FROM Users AS ud
WHERE NOT EXISTS (
    SELECT pd.product_id
    FROM Products AS pd
    JOIN Categories AS cd ON pd.category_id = cd.category_id
    WHERE cd.category_name = 'Toys & Games' AND NOT EXISTS (
        SELECT 1
        FROM Orders AS od
        JOIN Order_Items AS oi ON od.order_id = oi.order_id
        WHERE oi.product_id = p.product_id AND od.user_id = ud.user_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This query will retrieve the products that have the highest price within each category.
-- The ROW_NUMBER function is used to assign a row number to each product within each category.
-- The PARTITION BY clause is used to partition the products by category ID.
-- The ORDER BY clause is used to sort the products by price in descending order.
SELECT product_id, product_name, category_id, price
FROM (
    SELECT 
        product_id, 
        product_name, 
        category_id, 
        price, 
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) 
        AS row_num
    FROM Products
) AS pd
WHERE row_num = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This query will retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The JOIN statement is used to combine the user data and order data based on their user ID.
-- The GROUP BY clause is used to group the result by user ID and username.
-- The HAVING clause is used to filter the result to only include users who have placed orders on consecutive days for at least 3 days.
-- The MAX and MIN functions are used to get the maximum and minimum order dates for each user.
SELECT ud.user_id, ud.username
FROM Users AS ud
JOIN Orders AS od ON ud.user_id = od.user_id
GROUP BY ud.user_id, ud.username
HAVING COUNT(*) >= 3
AND MAX(od.order_date) - MIN(od.order_date) = COUNT(*) - 1;
