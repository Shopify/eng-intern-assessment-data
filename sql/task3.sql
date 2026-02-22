-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT C.category_id, C.category_name, SUM(O.total_amount) AS total_sales_amount
FROM Categories C

-- join category with product item orders
JOIN Products P ON C.category_id = P.category_id
JOIN Order_Items OI ON P.product_id = OI.product_id
JOIN Orders O ON OI.order_id = O.order_id
GROUP BY C.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT U.user_id, U.username
FROM Users U
-- join users with orders
JOIN Orders O ON U.user_id = O.user_id
JOIN Order_Items OI ON O.order_id = OI.order_id

-- join with products of category Toys
JOIN Products P ON OI.product_id = P.product_id
JOIN (
    SELECT category_id
    FROM categories
    WHERE category_name = 'Toys & Games'
) Toys ON P.category_id = Toys.category_id

-- check who bought all the toys
GROUP BY U.user_id, U.username, Toys.category_id
HAVING COUNT(DISTINCT P.product_id) = (
    SELECT COUNT(*)
    FROM Products
    WHERE category_id = Toys.category_id
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT P.product_id, P.product_name, P.category_id, P.price
FROM Products P

-- Get the max priced item in each category
JOIN (
  SELECT category_id, MAX(price) AS max_price
  FROM Products
  GROUP BY category_id
) P_MAX 
-- check if product is max in category
ON P.category_id = P_MAX.category_id AND P.price = P_MAX.max_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this 

-- I NEED TO LERAN WINDOW FUNCTIONS THIS IS SO UGLY AHHHHHHHHHHHHHHHHHH
SELECT U.user_id, U.username
FROM Users U
WHERE EXISTS (
 SELECT *
 FROM Orders O1
 WHERE O1.user_id = U.user_id
 AND EXISTS (
    SELECT *
    FROM Orders O2
    -- check if same user ordered for 2 consecutive days
    WHERE O2.user_id = O1.user_id    
    AND O2.order_date = O1.order_date + INTERVAL '1 day'
    AND EXISTS(
    SELECT *
    FROM Orders O3
    -- check if user ordered for 3 consecutive days
    WHERE O3.user_id = O2.user_id
    AND O3.order_date = O2.order_date + INTERVAL '1 day'
    )
 )
);