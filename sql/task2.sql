-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT p.product_id, p.product_name, AVG(r.rating)
FROM Products p JOIN Reviews r on p.product_id = r.product_id
GROUP BY p.product_id
ORDER BY AVG(r.rating) DESC
-- Here, I am taking the top five highest rated products, as the number was not specified in the question.
LIMIT 5;


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

WITH order_view AS (SELECT O.order_id, O.product_id, O.user_id, OI.category_id
FROM Orders O LEFT JOIN Order_Items OI on O.order_id = OI.order_id) 
SELECT u.user_id, u.username, order_view.*, COUNT(distinct order_view.category_id) AS category_count
FROM Users u RIGHT JOIN order_view ON u.user_id = order_view.user_id
GROUP BY u.user_id
-- there are 50 categories
HAVING COUNT(distinct order_view.category_id) = 50 ;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT p.product_id, p.product_name
FROM Products p LEFT OUTER JOIN Reviews r on p.product_id = r.product_id;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

WITH temp AS (SELECT user_id, CASE 
    WHEN LEAD(order_date) Over(PARTITION BY user_id) IS NULL THEN 1 
    ELSE ABS(order_date -LEAD(order_date) Over(PARTITION BY user_id))
END  AS 'days_since_last_order'
FROM Orders)
SELECT user_id
FROM temp
GROUP BY user_id
HAVING count(*) = SUM(days_since_last_order)
AND count(*) >1
;