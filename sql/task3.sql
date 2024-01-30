-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
    category_id,
    category_name,
    SUM(unit_price * quantity) AS total_sales_amount
FROM
    Categories
    JOIN Products ON Categories.category_id = Products.product_id
    JOIN Order_Items ON Products.product_id = Order_Items.product_id
GROUP BY category_id
ORDER BY total_sales_amount DESC 
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT 
    user_id, 
    username
FROM 
    Users
WHERE EXISTS (
    SELECT *
    FROM 
        Products
        JOIN Categories ON Products.category_id = Categories.category_id
    WHERE 
        category_name = 'Toys & Games'
        AND NOT EXISTS (
            SELECT *
            FROM 
                Orders
                JOIN Order_Items OI ON Orders.order_id = Order_Items.order_id
            WHERE 
                Orders.user_id = Users.user_id AND Order_Items.product_id = Products.product_id
        )
)

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

SELECT
    product_id,
    product_name,
    category_id,
    MAX(price)
FROM Products
JOIN Categories ON Categories.category_id = Products.product_id
GROUP BY category_id;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.