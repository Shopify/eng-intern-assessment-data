/*
Problem 1: Retrieve all products in the Sports category
Write an SQL query to retrieve all products in a specific category.
 */
SELECT
    P.Product_Id,
    P.Product_Name,
    P.Description,
    P.Price
FROM
    Products AS P
INNER JOIN Categories AS C ON (P.Category_Id = C.Category_Id)
WHERE -- Entering the category name as a string allows easy modification later
    C.Category_Name = 'Sports & Outdoors'
ORDER BY
    P.Product_Id ASC; -- Order for readability

/*
Problem 2: Retrieve the total number of orders for each user
Write an SQL query to retrieve the total number of orders for each user.
The result should include the user ID, username, and the total number of orders.
 */
SELECT
    U.User_Id,
    U.Username,
    COUNT(O.Order_Id) AS Num_Orders
FROM
    Users AS U -- Left join in case some users made no orders
LEFT OUTER JOIN Orders AS O ON (U.User_Id = O.User_Id)
GROUP BY
    U.User_Id
ORDER BY
    U.User_Id ASC; -- Order for readability

/*
Problem 3: Retrieve the average rating for each product
Write an SQL query to retrieve the average rating for each product.
The result should include the product ID, product name, and the average rating.
 */
SELECT
    P.Product_Id,
    P.Product_Name,
    AVG(R.rating) AS Average_Rating
FROM
    Products AS P -- Left join as some products might not have any reviews
LEFT OUTER JOIN Reviews AS R ON (P.Product_id = R.Product_id)
GROUP BY
    P.Product_Id
ORDER BY
    P.Product_Id ASC; -- Order for readability

/*
Problem 4: Retrieve the top 5 users with the highest total amount spent on
orders
Write an SQL query to retrieve the top 5 users with the highest total amount
spent on orders.
The result should include the user ID, username, and the total amount spent.
 */
SELECT
    U.User_Id,
    U.Username,
    SUM(O.Total_Amount) AS Total_Spent
FROM
    Orders AS O
INNER JOIN Users AS U ON (O.User_Id = U.User_Id)
GROUP BY
    U.User_Id
ORDER BY
    Total_Spent DESC -- Order from highest to lowest total amount spent
LIMIT
    5 -- Then pick the 5 highest spenders
