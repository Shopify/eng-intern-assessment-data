-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- finds average rating for all products.
WITH avg_ratings AS (
    SELECT product_id, product_name, avg(rating) as avg_rating
    FROM Reviews NATURAL JOIN Products
    GROUP BY product_id, product_name
)

-- selects only the products that have the highest average rating,
-- i.e. an average rating that is greater than or equal to all others.
SELECT product_id, product_name, avg_rating
FROM avg_ratings
WHERE avg_rating >= ALL (
    SELECT avg_rating
    FROM avg_ratings
);

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.


SELECT u.user_id, u.username
FROM Users u NATURAL JOIN Orders NATURAL JOIN Order_Items NATURAL JOIN Products p
GROUP BY user_id, username
-- select only users whose orders include products from all categories
-- if the count of distinct category IDs in all of a user's ordered items equals
-- the count of distinct category IDs in the Categories table, then they have
-- ordered at least one item from each category.
HAVING COUNT(DISTINCT p.category_id) = (
    SELECT COUNT(DISTINCT c.category_id)
    FROM Categories c
);

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

-- left join keeps all products and matches reviews to them.
-- meaning if a product has no reviews, no review will be matched to it.
-- in that cause, the review ID for a product will be null.
SELECT DISTINCT p.product_id, p.product_name
FROM Products p LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE review_id IS NULL;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

-- self join on Orders using cartesian product, filtering on equal user IDs
-- to ensure that only relevant orders are compared.
-- i understood 'consecutive orders' to mean orders whose IDs follow each other
-- similarly, i understood 'consecutive days' to mean days that follow each other.
SELECT u.user_id, u.username
FROM Orders o1 CROSS JOIN Orders o2
JOIN Users u on o1.user_id = u.user_id
WHERE o1.user_id = o2.user_id AND
    o1.order_id + 1 = o2.order_id AND 
    o1.order_date + 1 = o2.order_date;