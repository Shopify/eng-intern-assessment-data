/*
Problem 5: Retrieve the products with the highest average rating
Write an SQL query to retrieve the products with the highest average rating.
The result should include the product ID, product name, and the average rating.
Hint: You may need to use subqueries or common table expressions (CTEs) to
solve this problem.
 */
-- Make a CTE with the products' data and their average rating as columns
WITH ProductAverages AS (
    SELECT
        P.Product_Id,
        P.Product_Name,
        AVG(R.Rating) AS Average_Rating
    FROM
        Products AS P
    INNER JOIN Reviews AS R ON P.Product_Id = R.Product_Id
    GROUP BY
        P.Product_Id
),

-- Compute the maximum average over all average ratings
MaxAverage AS (
    SELECT MAX(Average_Rating) AS Max_Avg_Rating
    FROM ProductAverages
)

-- Select the products with the maximum averaging rating through inner joining
SELECT
    Pa.Product_Id,
    Pa.Product_Name,
    Pa.Average_Rating
FROM
    ProductAverages AS Pa
INNER JOIN MaxAverage AS Maxavg
    ON Pa.Average_Rating = Maxavg.Max_Avg_Rating
ORDER BY
    Pa.Product_Id ASC; -- Order for readability

/*
Problem 6: Retrieve the users who have made at least one order in each category
Write an SQL query to retrieve the users who have made at least one order in
each category.
The result should include the user ID and username.
Hint: You may need to use subqueries or joins to solve this problem.
 */
-- Make a CTE of the number of unique categories each user ordered from
WITH
NumCategoriesOrderedFrom AS (
    SELECT
        U.User_Id,
        U.Username,
        COUNT(DISTINCT P.Category_Id) AS Num_Categories_Ordered_From
    FROM
        Order_Items AS Oi
    INNER JOIN Products AS P ON Oi.Product_Id = P.Product_Id
    INNER JOIN Orders AS O ON Oi.Order_Id = O.Order_Id
    INNER JOIN Users AS U ON O.User_Id = U.User_Id
    GROUP BY
        U.User_Id
),

-- Compute the total number of unique categories
TotalNumCategories AS (
    SELECT COUNT(*) AS Total_Categories
    FROM
        Categories
)

-- Select the user who ordered from all unique categories through inner joining
SELECT
    Ncof.User_Id,
    Ncof.Username
FROM
    NumCategoriesOrderedFrom AS Ncof
INNER JOIN TotalNumCategories AS Tnc
    ON Ncof.Num_Categories_Ordered_From = Tnc.Total_Categories
ORDER BY
    Ncof.User_Id;

/*
Problem 7: Retrieve the products that have not received any reviews
Write an SQL query to retrieve the products that have not received any reviews.
The result should include the product ID and product name.
Hint: You may need to use subqueries or left joins to solve this problem.
 */
SELECT
    P.Product_Id,
    P.Product_Name
FROM
    Products AS P
-- We left join to keep the rows of products which have no reviews
LEFT OUTER JOIN Reviews AS R ON P.Product_Id = R.Product_Id
GROUP BY
    P.Product_Id
HAVING
    COUNT(R.Review_Id) = 0 -- True iff the product has no reviews
ORDER BY
    P.Product_Id ASC; -- Order for readability


/*
Problem 8: Retrieve the users who have made consecutive orders on consecutive
days
Write an SQL query to retrieve the users who have made consecutive orders on
consecutive days.
The result should include the user ID and username.
Hint: You may need to use subqueries or window functions to solve this problem.
 */
-- Make a CTE of (unique) days on which each user made at least one order
WITH OrderDays AS (
    SELECT DISTINCT
        Users.User_Id,
        Users.Username,
        O.Order_Date
    FROM
        Orders AS O
    INNER JOIN Users ON O.User_Id = Users.User_Id
),

-- Add a column holding the next day an order was made
NextDays AS (
    SELECT
        *,
        LEAD(Order_Date) OVER (
            PARTITION BY
                User_Id -- Partitioning over the orders made by a single user
            ORDER BY
                Order_Date ASC -- Pick the next largest day
        ) AS Next_Order_Day
    FROM
        OrderDays
)

-- Select data for each unique user who made orders on consecutive days
SELECT DISTINCT
    User_Id,
    Username
FROM
    NextDays
WHERE
    Next_Order_Day = Order_Date + 1 -- Incrementing a DATE adds a day
ORDER BY
    User_Id ASC -- Order for readability
