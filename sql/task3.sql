-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT Categories.category_id AS "Category_ID",
category_name AS "Category_Name",
SUM(Orders.total_amount) AS "Total_Sales_Amount"
FROM Categories
INNER JOIN Products
ON Categories.category_id = Products.category_id
INNER JOIN Order_Items 
ON Products.product_id = Order_Items.product_id
INNER JOIN Orders 
ON Order_Items.order_id = Orders.order_id
GROUP BY Categories.category_id, category_name
ORDER BY Total_Sales_Amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT Users.user_id AS "User_ID",
username AS "Username"
FROM Users
WHERE
NOT EXISTS (
    SELECT Products.product_id
    FROM Products
    WHERE Products.category_id = (
      SELECT category_id
      FROM Categories
      WHERE UPPER(category_name) = 'TOYS & GAMES'
    )
    AND NOT EXISTS (
      SELECT Order_Items.product_id
      FROM Order_Items
      JOIN Orders 
      ON Order_Items.order_id = Orders.order_id
      WHERE Orders.user_id = Users.user_id AND Order_Items.product_id = Products.product_id
    )
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS (
    SELECT product_id,
    product_name,
    category_id,
    price,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS Ranked
    FROM Products
)
SELECT product_id AS "Product_ID",
product_name AS "Product_Name",
category_id AS "Category_ID",
price AS "Price"
FROM RankedProducts
WHERE Ranked = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderDates AS (
    SELECT user_id,
    MIN(order_date) AS start_date,
    MAX(order_date) AS end_date
    FROM Orders
    GROUP BY user_id
),
ConsecutiveDates AS (
    SELECT user_id,
    start_date,
    end_date,
    DATEDIFF(end_date, start_date) AS "Date_Difference"
    FROM OrderDates
)
SELECT Users.user_id AS "User_ID",
username AS "Username"
FROM Users
INNER JOIN ConsecutiveDates CD 
ON Users.user_id = CD.user_id
WHERE Date_Difference >= 2;
