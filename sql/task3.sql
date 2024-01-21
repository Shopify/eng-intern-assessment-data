-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- SUM function to total the cost of every order for a specific category
-- Join products with categories to get products in each category, then join with order items  and orders to get associated order cost
-- Order by total sales amount DESC to display highest first and limit to 3 results to only get top 3
SELECT
    Categories.category_id,
    Categories.category_name,
    SUM(Orders.total_amount) AS total_sales_amount
FROM Categories
JOIN Products ON Categories.category_id = Products.category_id
JOIN Order_Items ON Products.product_id = Order_Items.product_id
JOIN Orders ON Order_Items.order_id = Orders.order_id
GROUP BY Categories.category_id, Categories.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Joins to match users to categories they ordered from
-- Returns users where the count of the unique products they ordered is equal to the result of the subquery
-- Subquery used to calculate total # of products in the desired category
SELECT Users.user_id, Users.username
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = OrderIems.order_id
JOIN Products ON OrderItems.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
WHERE Categories.category_name = 'Toys & Games'
GROUP BY Users.user_id, Users.username
HAVING COUNT(DISTINCT Products.product_id) = (SELECT COUNT(*) FROM Products WHERE category_id = Categories.category_id);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- CTE RankedProducts to rank products based on price from highest to lowest
-- ROW_NUMBER() window function used to create new rank column for each product partitioned by category_id
-- Each product in a category is assigned a unique rank due to partition
-- Return only products with rank as 1 (highest price)
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


-- CTE UserOrderDates to get the current, prevoius, and following order date matched with user_id
-- LEAD() and LAG() window functions used with user_id partition to get previous and following order_date for each user and create new column for both
-- DATEDIFF() function used to check if difference between previous and current, and current and following order dates are consecutive (1)
WITH UserOrderDates AS (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date
    FROM Orders
)
SELECT DISTINCT Users.user_id, Users.username
FROM Users
JOIN UserOrderDates ON Users.user_id = UserOrderDates.user_id
WHERE DATEDIFF(next_order_date, order_date) = 1 
AND DATEDIFF(order_date, prev_order_date) = 1
ORDER BY Users.user_id;
