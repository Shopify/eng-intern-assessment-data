-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT 
    U.user_id, 
    U.username
FROM 
    Users U
JOIN 
    Orders O ON U.user_id = O.user_id
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
JOIN 
    Products P ON OI.product_id = P.product_id
GROUP BY 
    U.user_id, U.username
HAVING 
    COUNT(DISTINCT P.category_id) = (SELECT COUNT(*) FROM Categories);
