-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
  Category_Sales.category_id,
  Category_Sales.category_name,
  Category_Sales.total_sales_amount
FROM
  (SELECT 
    Categories.category_id,
    Categories.category_name,
    SUM(Order_Items.unit_price * Order_Items.quantity) AS total_sales_amount
  FROM Categories
  INNER JOIN Products ON Products.category_id = Categories.category_id
  INNER JOIN Order_Items ON Order_Items.product_id = Products.product_id
  GROUP BY Categories.category_id, Categories.category_name) as Category_Sales
ORDER BY Category_Sales.total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
WITH Toys_Games_Products AS (
  SELECT product_id
  FROM Products
  INNER JOIN Categories ON Products.category_id = Categories.category_id
  WHERE Categories.category_name = 'Toys & Games'
)
SELECT 
  Users.user_id,
  Users.username
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
INNER JOIN Order_Items ON Orders.order_id = Order_Items.order_id
INNER JOIN Toys_Games_Products ON Order_Items.product_id = Toys_Games_Products.product_id
WHERE Order_Items.product_id IN (SELECT product_id FROM Toys_Games_Products)
GROUP BY Users.user_id, Users.username
HAVING COUNT(DISTINCT Order_Items.product_id) = (SELECT COUNT(*) FROM Toys_Games_Products);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
WITH Category_Max_Price AS (
  SELECT
    Products.category_id,
    MAX(Products.price) as "max_price"
  FROM Products
  GROUP BY Products.category_id
)

SELECT
  Products.product_id,
  Products.product_name,
  Products.category_id,
  Products.price
FROM Products
INNER JOIN Category_Max_Price on Products.category_id = Category_Max_Price.category_id
WHERE Products.price = Category_Max_Price.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT
  Users.user_id,
  Users.username
FROM (
  SELECT
    o.user_id,
    o.order_date,
    LEAD(o.order_date, 1) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_order_date,
    LEAD(o.order_date, 2) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS next_next_order_date,
  FROM Orders o
) AS OrderDates
JOIN Users ON OrderDates.user_id = Users.user_id
WHERE 
  DATEDIFF(next_order_date, order_date) = 1 AND 
  DATEDIFF(next_next_order_date, next_order_date) = 1;
