-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

SELECT Products.product_id AS "Product_ID",
product_name AS "Product_Name",
AVG(rating) AS "Average_Rating"
FROM Products
INNER JOIN Reviews 
ON Products.product_id = Reviews.product_id
GROUP BY Products.product_id, product_name
ORDER BY Average_Rating DESC
LIMIT 1;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

SELECT Users.user_id AS "User_ID",
username AS "Username"
FROM Users
WHERE
NOT EXISTS (
    SELECT Categories.category_id
    FROM Categories
    WHERE
    NOT EXISTS (
        SELECT Orders.order_id
        FROM Orders 
        INNER JOIN Order_Items
        ON Orders.order_id = Order_Items.order_id
        INNER JOIN Products
        ON Order_Items.product_id = Products.product_id
        WHERE Users.user_id = Orders.user_id AND Products.category_id = Categories.category_id
    )
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

SELECT Products.product_id AS "Product_ID",
product_name AS "Product_Name"
FROM Products
LEFT JOIN Reviews
ON Products.product_id = Reviews.product_id
WHERE review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT Users.user_id AS "User_ID",
username AS "Username"
FROM Users
INNER JOIN Orders O1 
ON Users.user_id = O1.user_id
INNER JOIN Orders O2 
ON Users.user_id = O2.user_id
AND O1.order_date = DATE_ADD(O2.order_date, INTERVAL -1 DAY);
