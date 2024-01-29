-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Answer 1: Using Joins
-- The query retrieves the products with the highest average rating.
-- The AVG function is used to calculate the average rating for each product.
-- A JOIN statement is used to combine the product data and review data based on their product ID.
-- The GROUP BY clause is used to group the result by product ID and product name.
-- The ORDER BY clause is used to sort the result by average rating in descending order.
-- The LIMIT clause is used to limit the result to only include the top 1 product.
SELECT pd.product_id, pd.product_name, AVG(rd.rating) AS avg_rating
FROM Products AS pd JOIN Reviews AS rd
ON pd.product_id = rd.product_id
GROUP BY pd.product_id, pd.product_name
ORDER BY avg_rating DESC;

-- Answer 2: Using CTE
-- The WITH clause is used to create a temporary table called Ratings.
-- The AVG function is used to calculate the average rating for each product.
-- The GROUP BY clause is used to group the result by product ID.
-- The SELECT statement is used to select the product ID and average rating from the Ratings table.
-- The JOIN statement is used to combine the product data and Ratings data based on their product ID.
-- The WHERE clause is used to filter the result to only include products with the highest average rating.
WITH Ratings AS, AVG(rating) AS avg_rating
    FROM Products
    GROUP BY product_id
) 
SELECT pd.product_id, pd.product_name, r.avg_rating
FROM Products AS pd JOIN Ratings AS r
ON pd.product_id = r.product_id
WHERE avg_rating = (SELECT MAX(avg_rating) FROM Ratings);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- This query will retrieve the users who have made at least one order in each category.
-- The NOT EXISTS operator is used to check if there is no order in a category for a user.
-- The subquery is used to retrieve the users who have made at least one order in each category.
SELECT ud.user_id, ud.username
FROM Users AS ud 
WHERE NOT EXISTS (
    SELECT cd.category_id
    FROM Categories as cd 
    WHERE NOT EXISTS (
        SELECT od.order_id
        FROM Orders AS od
        JOIN Order_Items AS oi ON od.order_id = oi.order_id
        JOIN Products AS pd ON oi.product_id = pd.product_id
        WHERE od.user_id = ud.user_id AND pd.category_id = cd.category_id
    )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- This query will retrieve the products that have not received any reviews.
-- A LEFT JOIN statement is used to combine the product data and review data based on their product ID.
-- The WHERE clause is used to filter the result to only include products that have not received any reviews.
-- The IS NULL operator is used to check if the review data is null.
SELECT pd.product_id, pd.product_name, 
FROM Products AS pd LEFT JOIN Reviews AS rd
ON pd.product_id = rd.product_id
WHERE rd.product_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- This query will retrieve the users who have made consecutive orders on consecutive days.
-- A JOIN statement is used to combine the user data and order data based on their user ID.
-- The WHERE clause is used to filter the result to only include users who have made consecutive orders on consecutive days.
SELECT DISTINCT ud.user_id, ud.username
FROM Users AS ud JOIN Orders AS od 
ON ud.user_id = od.user_id
JOIN Orders AS od2 ON od.user_id = od2.user_id
WHERE DATEDIFF(od.order_date = od2.order_date) = 1;
