-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
-- This query identifies the top 3 categories with the highest total sales.
-- It selects the category ID, name, and sums the total sales amount.
-- The total sales are calculated by summing the product of price and quantity for each order item.
-- A JOIN is used to connect Categories to Products and Order_Items.
-- GROUP BY is used to aggregate sales by category.
-- ORDER BY with DESC is used to sort categories by total sales in descending order.
-- LIMIT 3 restricts the results to the top three categories.
SELECT C.category_id, C.category_name, SUM(P.price * OI.quantity) AS total_sales
FROM Categories C
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
GROUP BY C.category_id, C.category_name
ORDER BY total_sales DESC
LIMIT 3;


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- This query finds users who have ordered every product in the 'Toys & Games' category.
-- The main query selects user ID and username from the Users table.
-- A NOT EXISTS clause checks for products in the 'Toys & Games' category not ordered by the user.
-- A nested NOT EXISTS clause is used to verify if the user has ordered each product.
-- The query ensures selection of users who ordered every 'Toys & Games' product.

SELECT U.user_id, U.username
FROM Users U
WHERE NOT EXISTS (
    SELECT P.product_id
    FROM Products P
    WHERE P.category_id = (SELECT category_id FROM Categories WHERE category_name = 'Toys & Games')
    AND NOT EXISTS (
        SELECT OI.product_id
        FROM Orders O
        JOIN Order_Items OI ON O.order_id = OI.order_id
        WHERE OI.product_id = P.product_id AND O.user_id = U.user_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- This query fetches products with the highest price in their respective categories.
-- A subquery is used to select products along with their rank within each category based on price.
-- The RANK window function orders products by price in descending order within each category.
-- The main query filters products ranked first (highest priced) in their category.
-- The result includes product ID, name, category ID, and price.
SELECT product_id, product_name, category_id, price
FROM (
    SELECT 
        product_id, 
        product_name, 
        category_id, 
        price,
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as rank
    FROM Products
) AS Subquery
WHERE rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


-- This query selects users who have placed orders on consecutive days for at least 3 days.
-- It selects the user ID and username from Users who have joined the Orders table.
-- GROUP BY is used to group the results by user ID and username.
-- The HAVING clause ensures that the count of distinct orders is at least 3.
-- It also checks that the difference between the maximum and minimum order dates is equal to the count of orders minus one, indicating consecutive days.
SELECT U.user_id, U.username
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username
HAVING COUNT(*) >= 3
AND MAX(O.order_date) - MIN(O.order_date) = COUNT(*) - 1;

