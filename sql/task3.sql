-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Categories.category_id AS CategoryID, 
    Categories.category_name AS CategoryName, 
    SUM(Order_Items.unit_price) AS TotalSales
FROM
((Categories LEFT JOIN Products ON Categories.category_id=Products.category_id)
 LEFT JOIN Order_Items ON Order_Items.product_id=Products.product_id)
GROUP BY Categories.category_id
ORDER BY TotalSales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT Users.user_id AS UserID, Users.username AS Username
FROM
((((Users LEFT JOIN Orders ON Users.user_id=Orders.user_id)
    LEFT JOIN Order_Items ON Orders.order_id=Order_Items.order_id)
   LEFT JOIN Products ON Order_Items.product_id=Products.product_id)
  LEFT JOIN Categories ON Products.category_id=Categories.category_id)
WHERE Categories.category_name="Toys & Games"
GROUP BY Users.user_id
HAVING COUNT(DISTINCT Products.product_id)=
    (SELECT COUNT(DISTINCT Products.product_id)
     FROM
     (Products LEFT JOIN Categories ON Products.category_id=Categories.category_id)
     WHERE Categories.category_name="Toys & Games");

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT Products1.product_id AS ProductID, Products1.product_name AS ProductName,
    Products1.category_id AS CategoryID, Products1.price AS Price
FROM 
Products Products1
WHERE Products1.price=
    (SELECT MAX(Products2.price) 
     FROM
     Products Products2
     WHERE Products1.category_id=Products2.category_id);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT DISTINCT Users.user_id AS UserID, Users.username AS Username 
FROM
(((Users LEFT JOIN Orders Orders1 ON Users.user_id=Orders1.user_id)
  LEFT JOIN Orders Orders2 ON Users.user_id=Orders2.user_id)
 LEFT JOIN Orders Orders3 ON Users.user_id=Orders3.user_id)
WHERE (Orders1.order_date=DATE(Orders2.order_date, "+1 day") AND
    Orders2.order_date=DATE(Orders3.order_date, "+1 day"));
