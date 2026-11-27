-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- in the subquery, join products and reviews to obtain information on each products reviews
-- use the avg() function to find the average rating
-- rank the products in descending order by their average rating
-- in the main query select the products that ranked first.
-- using a ranking method instead of a limit allows the query to return multiple products that "tie" for the top ranking

SELECT
    product_id, 
    product_name, 
    average_rating 
FROM (
    SELECT
        Products.product_id, 
        Products.product_name, 
        AVG(Reviews.rating) AS average_rating,
        RANK() OVER (ORDER BY AVG(Reviews.rating) DESC) AS review_rank
    FROM Products
    LEFT JOIN Reviews 
    ON Products.product_id = Reviews.product_id
    GROUP BY  
        Products.product_id,
        Products.product_name
) AveragedRatings
WHERE review_rank = 1



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- use four joins to link users->orders->order items->products->categories
-- select users whos number of distinct category orders equals the total number of categories
SELECT
    Users.user_id,
    Users.username
FROM Users 
JOIN Orders ON Users.user_id = Orders.user_id
JOIN Order_Items ON Orders.order_id = Order_Items.order_id
JOIN Products ON Order_Items.product_id = Products.product_id
JOIN Categories ON Products.category_id = Categories.category_id
GROUP BY
    Users.user_id,
    Users.username
HAVING COUNT(DISTINCT Categories.category_id) = (
    SELECT 
        COUNT(DISTINCT category_id)
    FROM Categories
    )


-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- join Product and reviews to get information about the reviews for each product
-- select all products where the review id is null, meaning it has no review
SELECT
    Products.product_id, 
    Products.product_name
FROM Products
LEFT JOIN Reviews 
ON Products.product_id = Reviews.product_id
WHERE Reviews.review_id IS NULL
-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- in a subquery, use the lag window function partitioned by user id to find the previous date of orders made by that user
-- select users who have made orders where their current order date is equal to their previous order date +1 day (consecutive)
SELECT DISTINCT
    Users.user_id,
    Users.username
FROM
    Users
JOIN (
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date
    FROM
        Orders
    ) OrdersPrev 
ON Users.user_id = OrdersPrev.user_id
WHERE
    OrdersPrev.order_date = OrdersPrev.prev_date + 1 

