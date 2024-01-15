-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT AVG(Reviews.rating), Reviews.product_id, Products.product_name
FROM Reviews
LEFT JOIN Products ON Reviews.product_id=Products.product_id
GROUP BY Reviews.product_id, Products.product_name
HAVING AVG(Reviews.rating)=(
    SELECT MAX(avgrate) 
    FROM (
        SELECT AVG(Reviews.rating) as avgrate
        FROM Reviews 
        GROUP BY Reviews.product_id, Products.product_name
    )
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Here, we need the category_id, but Orders gives us only the order_id
-- From there, we can connect to Order_Items to get the product_id
-- From there, we can connect to Products to get the category_id
-- From there, we can connect to Categories to get list of all category_id
-- If at least one order is made for each category by a user, the number of distinct
-- category_ids should equal the number of category_ids that exist (through subquery)
SELECT Orders.user_id, Users.username
FROM Orders
LEFT JOIN Order_Items ON Order_Items.order_id=Orders.order_id
LEFT JOIN Products ON Order_Items.product_id=Products.product_id
LEFT JOIN Categories ON Products.category_id=Categories.category_id
LEFT JOIN Users ON Users.user_id=Orders.user_id
GROUP BY Orders.user_id, Users.username
HAVING COUNT(DISTINCT Categories.category_id) = (
    SELECT COUNT(category_id) 
    FROM Categories
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

--I want product_id and product_name from Products
--I used the WHERE clause to filter out any products that have reviews
SELECT Products.product_id, Products.product_name
FROM Products
LEFT JOIN Reviews ON Reviews.product_id=Products.product_id
WHERE Reviews.product_id IS NULL
GROUP BY Products.product_id, Products.product_name;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

--Here I am using a self join to compare the dates from the Order table,
--Using the WHERE clause to filter only orders from the same user that differ by 1 day
--To add the username, I put that in a subquery and JOIN with the Users table
SELECT A.user_id, Users.username
FROM (SELECT A.user_id
FROM Orders A, Orders B
WHERE A.user_id = B.user_id
AND A.order_date - B.order_date = 1
GROUP BY A.user_id) a 
LEFT JOIN Users ON a.user_id = Users.user_id;