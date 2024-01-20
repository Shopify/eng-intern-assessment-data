-- Problem 5: Retrieve the products with the highest average rating

-- Uses a LEFT JOIN to include all products and associate them with their reviews.
-- Due to foreign key constraint issues identified in the dataset,
-- the query is limited to products with IDs between 1 and 16.
-- A subquery is used to determine the maximum average rating from these products.
SELECT p.product_id, p.product_name, AVG(r.rating) AS average_rating
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE p.product_id BETWEEN 1 AND 16
GROUP BY p.product_id, p.product_name
HAVING average_rating = (
    SELECT MAX(avg_rating) FROM (
        SELECT AVG(rating) as avg_rating
        FROM Reviews
        WHERE product_id BETWEEN 1 AND 16
        GROUP BY product_id
    ) as subquery
);


-- Problem 6: Retrieve the users who have made at least one order in each category

-- JOINS the Orders table with Users, then Order_Items with Orders, and finally Products with Order_Items.
-- Due to foreign key constraint issues identified in the dataset,
-- the query is limited to products with IDs between 1 and 16.
-- The DISTINCT keyword is used within the COUNT() function to ensure each category per user is counted only once.
-- The HAVING clause compares the count of distinct categories ordered by each user against the total number of categories.
-- If the distinct count is the same as the all count, the user has ordered from each category atleast once.
SELECT u.user_id, u.username
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.product_id BETWEEN 1 AND 16
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (SELECT COUNT(*) FROM Categories);


-- Problem 7: Retrieve the products that have not received any reviews

-- LEFT JOINs the Products table with the Reviews table. 
-- If product doesn't have review, there will be no match in reviews table
-- and so the LEFT JOIN will give those fields NULL
-- we are only checking product_id between 1 and 16 due to foreign key constraints
-- if review_id is NULL, we know that there wasn't an association during the LEFT JOIN therefore a review doesnt exist for that product_id.
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE p.product_id BETWEEN 1 AND 16 AND r.review_id IS NULL;


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days

-- JOINS the Orders table with itself to compare each order date with other order dates of the same user.
-- It looks for pairs of orders where the date difference is exactly one day. DATEDIFF()compares 2 dates and returns number of days between them.
--ABS() returns absolute value in case DATEDIFF() returns a negative number.
-- Only unique user IDs and usernames are selected, indicating they have made orders on consecutive days.
--DISTINCT ensures we only display the user once.
SELECT DISTINCT u.user_id, u.username
FROM Users u
JOIN Orders o1 ON u.user_id = o1.user_id
JOIN Orders o2 ON u.user_id = o2.user_id
WHERE ABS(DATEDIFF(o1.order_date, o2.order_date)) = 1;