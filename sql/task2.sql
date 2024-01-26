-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- COALESCE is used to set average rating as 0 if a product has no rating.
-- LEFT JOIN is used to ensure if all products have no rating, they are all
-- listed.
-- We only need to GROUP BY product_id since it is the primary key in 
-- Products.
-- The subquery lists the average rating of all products.
-- The >= ALL makes sure that the listed products are the ones with the
-- highest average rating.
SELECT p1.product_id, p1.product_name, p1.description, p1.price,
    p1.category_id, COALESCE(AVG(r1.rating), 0) AS avg_rating
FROM Products p1 LEFT JOIN Reviews r1
    ON p1.product_id = r1.product_id
GROUP BY p1.product_id
HAVING COALESCE(AVG(r1.rating), 0) >= ALL(
    SELECT COALESCE(AVG(r2.rating), 0)
    FROM Products p2 JOIN Reviews r2
        ON p2.product_id = r2.product_id
    GROUP BY p2.product_id
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

-- (INNER) JOIN is used since if any user_id is lost in the process,
-- then the user must not satisfy the required condition.
-- After the JOINs, we have the users with all categories they ordered.
-- A user who have made at least one order in each category must order
-- the same number of distinct categories as the total number of categories.
SELECT u.user_id, u.username
FROM Users u
    JOIN Orders o ON u.user_id = o.order_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.username
HAVING COUNT(DISTINCT p.category_id) = (
    SELECT COUNT(DISTINCT category_id)
    FROM Categories
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- NOT IN is used to select product_id that doesn't appear in Reviews.
SELECT p.product_id, p.product_name
FROM Products p
WHERE p.product_id NOT IN (
    SELECT r.product_id
    FROM Reviews r
);

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- Two joins to get all pairs of orders a user made. If the date difference
-- is 1, include the user. Since both orders of a pair are included, we don't
-- need an absolute value.
SELECT DISTINCT u.user_id, u.username
FROM Users u
    JOIN Orders o1 ON u.user_id = o1.user_id
    JOIN Orders o2 ON u.user_id = o2.user_id    
WHERE o1.order_date - o2.order_date = 1;
