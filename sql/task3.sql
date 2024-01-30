/*
Problem 9: Retrieve the top 3 categories with the highest total sales amount
Write an SQL query to retrieve the top 3 categories with the highest total
sales amount.
The result should include the category ID, category name, and the total sales
amount.
Hint: You may need to use subqueries, joins, and aggregate functions to solve
this problem.
 */
SELECT
    C.Category_Id,
    C.Category_Name,
    COALESCE(SUM(Oi.Quantity * P.Price), 0) -- 0 if None
    AS Total_Sales_Amount
FROM
    Categories AS C -- Left join in case categories have no ordered products
LEFT OUTER JOIN Products AS P ON C.Category_Id = P.Category_Id
LEFT OUTER JOIN Order_Items AS Oi ON P.Product_Id = Oi.Product_Id
GROUP BY
    C.Category_Id
ORDER BY
    Total_Sales_Amount DESC, -- From highest to lowest total sales amount
    C.Category_Id ASC -- For readability in case of ties
LIMIT
    3; -- Pick top 3 categories in terms of total sales amount

/*
Problem 10: Retrieve the users who have placed orders for all products in the
Toys & Games
Write an SQL query to retrieve the users who have placed orders for all
products in the Toys & Games
The result should include the user ID and username.
Hint: You may need to use subqueries, joins, and aggregate functions to solve
this problem.
 */
-- Make a CTE of all IDs for products in the Toys & Games category
WITH
ToysGamesProducts AS (
    SELECT P.Product_Id
    FROM
        Products AS P
    INNER JOIN Categories AS C ON P.Category_Id = C.Category_Id
    WHERE
        C.Category_Name = 'Toys & Games'
),

-- Make a CTE to count the number of unique toys & games each user ordered
NumOrderedToysGames AS (
    SELECT
        O.User_Id,
        COUNT(DISTINCT Oi.Product_Id) AS Ordered_Toy_Games_Count
    FROM
        Order_Items AS Oi
    INNER JOIN Orders AS O ON Oi.Order_Id = O.Order_Id
    INNER JOIN -- Inner join to only keep items in the T&G category
        ToysGamesProducts AS Tgp
        ON Oi.Product_Id = Tgp.Product_Id
    GROUP BY
        O.User_Id
),

-- Compute the total number of products in the Toys & Games category
ToysGamesTotal AS (
    SELECT COUNT(*) AS Toys_Games_Total
    FROM ToysGamesProducts
)

-- Select users who ordered as many products as there are in the P&G category
SELECT
    U.User_Id,
    U.Username
FROM
    Users AS U
INNER JOIN NumOrderedToysGames AS NumOTG ON U.User_Id = NumOTG.User_Id
CROSS JOIN ToysGamesTotal AS Tgt -- Cross join scalar value
WHERE
    NumOTG.Ordered_Toy_Games_Count = Tgt.Toys_Games_Total;

/*
Problem 11: Retrieve the products that have the highest price within each
category
Write an SQL query to retrieve the products that have the highest price within
each category.
The result should include the product ID, product name, category ID, and price.
Hint: You may need to use subqueries, joins, and window functions to solve this
problem.
 */
-- Make a CTE of all data relevant to products in each category
WITH
ProductCategoryData AS (
    SELECT
        C.Category_Id,
        P.Product_Id,
        P.Product_Name,
        P.Price
    FROM
        Categories AS C
    LEFT OUTER JOIN Products AS P ON C.Category_Id = P.Category_Id
),

-- Compute the max price of all products in a given category
CategoryMaxPrice AS (
    SELECT
        C.Category_Id,
        MAX(P.Price) AS Max_Price
    FROM
        Categories AS C
    LEFT OUTER JOIN Products AS P ON C.Category_Id = P.Category_Id
    GROUP BY
        C.Category_Id
)

SELECT
    Pcd.Category_Id, -- Always return the category ID first
    -- If there are no products in it, return Null in 3 columns, otherwise
    CASE
        WHEN Cmp.Max_Price IS NULL THEN NULL ELSE Pcd.Product_Id
    END AS Product_Id, -- return the product's ID
    CASE
        WHEN Cmp.Max_Price IS NULL THEN NULL ELSE Pcd.Product_Name
    END AS Product_Name, -- return the product's name
    CASE
        WHEN Cmp.Max_Price IS NULL THEN NULL ELSE Pcd.Price
    END AS Product_Price -- return the product's price
FROM
    ProductCategoryData AS Pcd -- Join with the max price per category
INNER JOIN CategoryMaxPrice AS Cmp ON Pcd.Category_Id = Cmp.Category_Id
WHERE
    Pcd.Price = Cmp.Max_Price -- Either  there is a product with the max price,
    OR Cmp.Max_Price IS NULL -- or there are no products in the category
ORDER BY -- Order for readability
    Pcd.Category_Id ASC,
    Pcd.Product_Id ASC; -- In case there are multiple products at max price

/*
Problem 12: Retrieve the users who have placed orders on consecutive days for
at least 3 days
Write an SQL query to retrieve the users who have placed orders on consecutive
days for at least 3 days.
The result should include the user ID and username.
Hint: You may need to use subqueries, joins, and window functions to solve this
problem.
 */
-- Make a CTE of (unique) days on which each user made at least one order
WITH
OrderDays AS (
    SELECT DISTINCT
        Users.User_Id,
        Users.Username,
        Orders.Order_Date
    FROM
        Orders
    INNER JOIN Users ON (Orders.User_Id = Users.User_Id)
),

-- Add columns holding the previous and next day an order was made
PrevNextDays AS (
    SELECT
        *,
        LAG(Order_Date) OVER (
            PARTITION BY
                User_Id -- Partition over orders made by a single user
            ORDER BY
                Order_Date ASC -- Previous day
        ) AS Prev_Order_Day,
        LEAD(Order_Date) OVER (
            PARTITION BY
                User_Id -- Partition over orders made by a single user
            ORDER BY
                Order_Date ASC -- Next day
        ) AS Next_Order_Day
    FROM
        OrderDays
)

-- Select data for each unique user who made orders on 3 consecutive days
SELECT DISTINCT
    User_Id,
    Username
FROM
    PrevNextDays
WHERE -- If an order is made on 3 consecutive days, this is true on the 2nd day
    Next_Order_Day = Order_Date + 1
    AND Prev_Order_Day = Order_Date - 1
ORDER BY
    User_Id ASC -- Order for readability
