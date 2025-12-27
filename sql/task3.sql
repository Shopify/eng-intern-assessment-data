-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select c.category_id, c.category_name, SUM(o.quantity * o.unit_price) as total_sales_value --multiplying the quantity and unit price, as total amount is not available in the selected table
FROM Categories c JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items o ON p.product_id = o.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales_value DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select u.user_id, u.username
FROM Users u JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.product_id) = 
(select COUNT(*) FROM Products p JOIN Categories C ON p.category_id = c.category_id WHERE C.category_name = 'Toys and Games'); --this subquery returns the total number of products in the category, which is then used to ensure that the users have purchased all the products in that category.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select p.product_id, p.product_name, p.category_id, p.price
FROM Products p 
INNER JOIN (select category_id, MAX(price) as max_price FROM Products GROUP BY category_id) as max_prices ON p.category_id = max_prices.category_id --The PRODUCTS table is joined with a subquery to enable selecting the maximum price for each category
AND p.price = max_prices.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SET @user_id = 0, @counter = 0, @prev_date = NULL;
select user_id, username
FROM (
    select o.user_id, u.username, o.order_date,
        @counter := IF(@user_id = o.user_id AND DATEDIFF(o.order_date, @prev_date) = 1, @counter + 1, 
                       IF(@user_id = o.user_id AND DATEDIFF(o.order_date, @prev_date) > 1, 1, 
                       IF(@user_id != o.user_id, 1, @counter))) AS consecutive_days,
        @user_id := o.user_id AS dummy_user_id, -- for carrying the user_id to the next row
        @prev_date := o.order_date AS dummy_order_date -- for carrying the order_date to the next row
    FROM Orders o
    JOIN Users u ON o.user_id = u.user_id
    ORDER BY o.user_id, o.order_date) AS SubQuery
WHERE consecutive_days >= 3
GROUP BY user_id, username;
