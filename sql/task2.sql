-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
CREATE VIEW ProductAvgRating AS (
    SELECT product_id, product_name, avg(rating) AS avg_rating
    FROM Products NATURAL LEFT JOIN Reviews
    GROUP BY product_id, product_name
);

SELECT *
FROM ProductAvgRating
WHERE avg_rating = (
    SELECT max(avg_rating) FROM ProductAvgRating
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT user_id, username
FROM Users NATURAL JOIN Orders NATURAL JOIN Order_Items NATURAL JOIN Products
GROUP BY user_id, username
HAVING count(DISTINCT category_id) = (SELECT count(DISTINCT category_id) FROM Products);


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
(SELECT product_id, product_name FROM Products)
EXCEPT
(SELECT product_id, product_name FROM Reviews NATURAL JOIN Products);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
SELECT DISTINCT u.user_id, u.username
FROM (Orders o1, Orders o2) JOIN Users u ON o1.user_id = u.user_id
WHERE o1.user_id = o2.user_id AND 
DATE_PART('day', o2.order_date - o1.order_date) = 1;