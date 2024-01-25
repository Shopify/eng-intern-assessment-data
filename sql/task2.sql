-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Assumption: since there was no number of products to return, I'm returning all of them sorted by their average rating
-- There's a second commented out option for if you only want THE highest (singular) item WITHOUT A SEMICOLON SO THAT MY CODE CAN SPLIT THE QUERIES WELL

-- We group all the reviews for each product by the product ID, and then take the avearge of each
-- Return in descending order for the reason in the asusmption above

SELECT 
    DISTINCT Products.product_id, 
    product_name, 
    AVG(rating) as avg_rating 
FROM 
    Products 
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id 
GROUP BY
    Products.product_id
ORDER BY 
    avg_rating DESC;

-- SELECT DISTINCT Products.product_id, product_name, AVG(ratings) as avg_rating FROM Products LEFT JOIN Ratings ON Products.product_id = Ratings.product_id GROUP BY Products.product_id ORDER BY avg_rating DESC LIMIT 1


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- We find all of the products each user has purchases through subsequent joins
-- We then count the number of distinct categories they have ordred, and compare that to the total number of categories

SELECT 
    Users.user_id, 
    username 
FROM 
    Users 
INNER JOIN 
    Orders ON Users.user_id = Orders.user_id 
INNER JOIN 
    Order_Items ON Orders.order_id = Order_Items.order_id 
INNER JOIN 
    Products ON Order_Items.product_id = Products.product_id
GROUP BY 
    Users.user_id 
HAVING 
    COUNT(DISTINCT Products.category_id) = (
        SELECT 
            COUNT(DISTINCT category_id) 
        FROM 
            Categories
    );

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Find all the reviews for each product, and then only keep the products with no reviews
-- This solution takes advantage of the fact that a left join on values with no matches will set NULL

SELECT 
    Products.product_id, 
    product_name
FROM
    Products
LEFT JOIN
    Reviews ON Products.product_id = Reviews.product_id
WHERE
    Reviews.product_id IS NULL; 

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Assumption: it's not clear what the prompt means by consecutive orders, so I'm going to focus on idea that users have at some time ordered on conseutive days

-- For each user's orders, we use LEAD to look ahead one line in the list of their orders sorted by date, and store the data of the next order
-- We then filter user's orders by this next order is the next day
-- We then only keep the distinct user ids, so users will only come up once

SELECT 
    DISTINCT user_id, 
    username 
FROM (
    SELECT 
        Users.user_id, 
        username, 
        order_date, 
        LEAD(order_date) OVER 
            (PARTITION BY Users.user_id ORDER BY order_date) AS next_order_date 
    FROM 
        Users 
    JOIN 
        Orders ON Users.user_id = Orders.user_id
) AS UserOrders 
WHERE 
    next_order_date = DATE(order_date, '+1 day');
