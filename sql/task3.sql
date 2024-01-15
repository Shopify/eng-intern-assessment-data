-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join table Categories with table Products and Order_Items to get the total sales amount for each category
-- `total_sales_amount` is calculated by multiplying `quantity` and `unit_price` for all products in each category
SELECT c.category_id, c.category_name, SUM(o_i.quantity * o_i.unit_price) AS total_sales_amount
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items o_i ON p.product_id = o_i.product_id
GROUP BY c.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Join table Users with table Orders, Order_Items, Products, and Categories get the orders that contain product in Toys & Games category
-- then compare the number of products with the total number of products in Toys & Games category
-- finally get the user who ordered it
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items o_i ON o.order_id = o_i.order_id
JOIN Products p ON o_i.product_id = p.product_id
JOIN (SELECT * 
      FROM Categories 
      WHERE category_name = "Toys & Games") t 
    ON p.category_id = t.category_id 
GROUP BY u.user_id
HAVING COUNT(p.product_id) = (SELECT COUNT(p.product_id) 
                              FROM Products p
                              JOIN (SELECT * 
                                    FROM Categories
                                    WHERE category_name = "Toys & Games") t 
                              ON p.category_id = t.category_id);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Use subquery to get the highest price for each category
-- then join with the table Products to get the products that have the highest price within each category
SELECT p.product_id, p.product_name, p.category_id, p.price
FROM Products p 
JOIN (SELECT category_id, MAX(price) AS max_price 
      FROM Products 
      GROUP BY category_id) c
ON p.category_id = c.category_id AND p.price = c.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Use the same idea from Problem 8 (task 2)
-- Join table Orders with itself twice to to find the users who have placed orders on consecutive days for at least 3 days
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id AND o1.order_date = DATE(o2.order_date, '+1 day')
JOIN Orders o3 ON u.user_id = o2.user_id AND o2.order_date = DATE(o3.order_date, '+1 day');