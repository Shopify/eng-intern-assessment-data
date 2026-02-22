-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- create a temporary table that calculates the average rating for each 
-- product_id
WITH AverageRating AS (
    SELECT Products.product_id, product_name, avg(rating) as avg_rating
    FROM Reviews JOIN Products ON Reviews.product_id = Products.product_id
    GROUP BY Products.product_id, product_name
) 
-- identify the product(s) with the highest average rating by finding the max
-- rating from AverageRating and finding all products that have the same rating
-- as the max average rating 
SELECT product_id, product_name, avg_rating
FROM AverageRating
WHERE avg_rating = (
    SELECT max(avg_rating)
    FROM AverageRating
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- create a temporary table that pairs every user with every possible category
-- (the user had to make an order in every category to be selected
-- in this query)
WITH UserCategoryPairs AS (
    SELECT user_id, category_id
    FROM Users, Categories
), UsersMissingCategories AS (
    -- create a temporary table that identifies users who have not made an 
    -- order in a certain category by subtracting the categories users actually
    -- made orders in from the expected user-category list
    (SELECT *
    FROM UserCategoryPairs)
    EXCEPT 
    (SELECT user_id, category_id
    FROM Orders JOIN Order_Items ON Orders.order_id = Order_Items.order_id JOIN
        Products ON Products.product_id = Order_Items.product_id)
), OrderedAllCategories AS (
    -- create a temporary table that idenfities users who have made an order
    -- from every category by subtracting users who were missing at least
    -- one category (as identified in the previous table) from all users
    (SELECT user_id
    FROM Users)
    EXCEPT
    (SELECT user_id
    FROM UsersMissingCategories)
)
-- join OrderedAllCategories with Users to retrieve usernames
SELECT Users.user_id, username
FROM OrderedAllCategories JOIN Users ON OrderedAllCategories.user_id = 
    Users.user_id;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- create a temporary table of all products with no reviews by subtracting
-- products that have been reviewed (ie. in the Reviews table) from Products
-- to find remaining products with no reviews
WITH NoReviews AS (
    (SELECT product_id
    FROM Products)
    EXCEPT 
    (SELECT product_id
    FROM Reviews)
)
-- natural join NoReviews with Products to retrieve product names
SELECT product_id, product_name
FROM NoReviews NATURAL JOIN Products;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

SELECT DISTINCT Users.user_id, username
FROM (
    -- find the number of days between every order made by a user by sorting
    -- all order dates in ascending order and finding the difference between
    -- each date and the one before it
    SELECT user_id, order_date, order_date - LAG(order_date, 1) 
        OVER (PARTITION BY user_id ORDER BY order_date) as days_between
    FROM Orders
) as DaysBetweenOrders JOIN Users ON DaysBetweenOrders.user_id = Users.user_id
WHERE days_between = 1;
-- find users where the difference in dates of some orders is 1; that
-- is, they made orders at least two days in a row