-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


--Canidate's note:
-- Check null for C.category_id to make sure that the category is not missing due to the missing product data(which is manually inserted in the database to resolve the foreign key constraint)
SELECT C.category_id, C.category_name, sum(OI.quantity * OI.unit_price) AS total_sales_amount
FROM Order_Items OI 
LEFT JOIN Products P ON OI.product_id = P.product_id
LEFT JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_id IS NOT NULL
GROUP BY C.category_id
ORDER BY total_sales_amount DESC
LIMIT 3;



-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT DISTINCT U.user_id, U.username 
FROM Order_Items OI 
LEFT JOIN Products P ON OI.product_id = P.product_id
LEFT JOIN Categories C ON P.category_id = C.category_id
LEFT JOIN Orders O ON OI.order_id = O.order_id
LEFT JOIN Users U ON O.user_id = U.user_id
WHERE C.category_name = 'Toys & Games';



-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.



SELECT P_Max.product_id, P_Max.product_name, P_Max.category_id, P_Max.max_price
FROM 
(SELECT P.product_id, P.product_name, P.category_id, P.Price, MAX(P.price) OVER (PARTITION BY P.category_id) AS max_price 
FROM Products P
WHERE P.category_id IS NOT NULL) AS P_Max
WHERE P_Max.price = P_Max.max_price
ORDER BY P_Max.category_id;



-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--Canidate's note:

--1st CTE, O_with_RN is used to retrieve to label user with multiple orders on the same day with row number
--2st CTE, O_with_2previous, is used to filter away orders on the same date, and then  retrieve 2 distinct previous order date for each order
--finally, select distinct user_id 
With O_with_RN AS
(
    SELECT user_id, order_date, ROW_NUMBER() OVER (PARTITION BY user_id, Order_date ORDER BY order_date) AS rn
    From Orders
),
O_with_2previous AS
(
    SELECT O_with_RN.user_id, O_with_RN.order_date,  
    LAG(O_with_RN.order_date, 1) OVER (PARTITION BY O_with_RN.user_id ORDER BY O_with_RN.order_date) AS previous_order_date,
    LAG(O_with_RN.order_date, 2) OVER (PARTITION BY O_with_RN.user_id ORDER BY O_with_RN.order_date) AS previous_order_date_2
    FROM O_with_RN
    WHERE O_with_RN.rn = 1
)

SELECT DISTINCT O_with_2previous.user_id, U.username
From O_with_2previous
LEFT JOIN Users U ON O_with_2previous.user_id = U.user_id
WHERE order_date - previous_order_date = 1
AND order_date - previous_order_date_2 = 2;

