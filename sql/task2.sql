-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.


-- I used a LEFT JOIN to get all the products and then an AVG to get the average rating
-- Then I grouped by the product ID and product name
-- Then I used a HAVING to get the products with the highest average rating
-- To get the highest average rating, I used a subquery to get the maximum average rating

SELECT 
    Products.product_id,
    Products.product_name,
    AVG(Reviews.rating) AS average_rating
FROM 
    Products
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id
GROUP BY 
    Products.product_id, Products.product_name
HAVING 
    AVG(Reviews.rating) = (
        SELECT MAX(avg_rating)
        FROM (
            SELECT AVG(rating) AS avg_rating
            FROM Reviews
            GROUP BY product_id
        ) AS subquery
    );

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- Here I used three LEFT JOINS in order to get the users -> orders -> products
-- Then I used a GROUP BY to group by the user ID and username
-- Then I used a HAVING to get the users the occurrences when the number of categories order by a user is equal to the total number of categories

SELECT 
    u.user_id, 
    u.username
FROM 
    Users u
LEFT JOIN 
    Orders o ON u.user_id = o.user_id
LEFT JOIN 
    Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN 
    Products p ON oi.product_id = p.product_id
GROUP BY 
    u.user_id, u.username
HAVING 
    COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- Here I used a LEFT JOIN to get all the products and then a WHERE to get the products that have not received any reviews

SELECT 
    Products.product_id,
    Products.product_name
FROM 
    Products
LEFT JOIN 
    Reviews ON Products.product_id = Reviews.product_id
WHERE 
    Reviews.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Here I used a LEFT JOIN on a subquery that gets the most recent previous order date for each user
-- Then I filtered the results to get the rows where the order date is equal to the previous order date + 1 day

SELECT DISTINCT 
    u.user_id, 
    u.username
FROM 
    Users u
LEFT JOIN 
    (
        SELECT 
            user_id, 
            order_date,
            LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date
        FROM 
            Orders
    ) AS ord ON u.user_id = ord.user_id
WHERE 
    ord.order_date = DATE(ord.prev_order_date, '+1 day');
