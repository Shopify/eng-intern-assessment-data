-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- **********Explanation**********:

-- AverageRatings CTE calculates the average rating for each product.
WITH AverageRatings AS (
    SELECT product_id, AVG(rating) as avg_rating
    FROM Reviews
    GROUP BY product_id
)

-- Final query joins the Products table with the AverageRatings CTE on product_id to get the product names, and
-- filters out the products where the avg_rating is equal to the maximum avg_rating found in the CTE. So only
-- products with the highest average rating are selected. Note that multiple products can have the same 
-- highest rating.
SELECT P.product_id, P.product_name, AR.avg_rating
FROM Products AS P
INNER JOIN AverageRatings AS AR ON P.product_id = AR.product_id
WHERE AR.avg_rating = (SELECT MAX(avg_rating) FROM AverageRatings);


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- **********Explanation**********:

-- UserCategoryCounts CTE calculates the count of distinct categories that each user has ordered from.
-- TotalCategoryCount CTE gets the total number of distinct categories available.
WITH UserCategoryCounts AS (
    SELECT O.user_id, COUNT(DISTINCT P.category_id) AS distinct_category_count
    FROM Orders AS O
    JOIN Order_Items AS OI ON O.order_id = OI.order_id
    JOIN Products AS P ON OI.product_id = P.product_id
    GROUP BY O.user_id
),
TotalCategoryCount AS (
	SELECT COUNT(*) AS total_category_count
    FROM Categories
)

-- Final query joins Users with UserCategoryCounts and TotalCategoryCount. Then selects users whose count of
-- distinct categories ordered matches the total number of categories available.
SELECT U.user_id, U.username
FROM Users AS U
JOIN UserCategoryCounts AS UCC ON U.user_id = UCC.user_id
JOIN TotalCategoryCount AS TCC
WHERE UCC.distinct_category_count = TCC.total_category_count


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- **********Explanation**********:

-- LEFT JOIN ensures that all products are included in the result set, and filter out the products that do
-- have reviews by checking for NULL in the review_id column.
SELECT P.product_id, P.product_name
FROM Products AS P
LEFT JOIN Reviews AS R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- **********Explanation**********:

-- OrderedUsers CTE fetches user_id, username, order_date, and the [rev] order date for each order.
-- The LAG function gets the previous order date, partitioned by user_id and ordered by order_date.
WITH OrderedUsers AS (
    SELECT O.user_id, U.username, O.order_date,
        LAG(O.order_date) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS prev_order_date
    FROM Orders AS O
    JOIN Users AS U ON O.user_id = U.user_id
)

-- Final query selects distinct user_id and username from the OrderedUsers CTE and checks if the order_date is
-- exactly one day after the prev_order_date.
SELECT DISTINCT user_id, username
FROM OrderedUsers
WHERE order_date = DATE_ADD(prev_order_date, INTERVAL 1 DAY)

