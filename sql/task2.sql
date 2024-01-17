-- Please note that I used Postgres as the underlying RDBMS. 

-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
SELECT PO.product_id,
    PO.product_name,
    AVG(RO.rating)
FROM Products PO,
    Reviews RO
WHERE PO.product_id = RO.product_id
GROUP BY PO.product_id,
    PO.product_name
HAVING AVG(RO.rating) >= ALL (
        SELECT AVG(RI.rating) as rating
        FROM Products PI,
            Reviews RI
        WHERE PI.product_id = RI.product_id
        GROUP BY PI.product_id
    );
-- Explanation for Problem 5:
-- The subquery returns the average rating for each product, much like in Problem 3.
-- The outer query also returns the average rating for each product,
-- however using the HAVING clause and ALL predicate it checks that the 
-- average rating for this product is greater than or equal to every average rating.
-- Therefore only the records with the highest average rating will be returned.

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
SELECT UC.user_id,
    UC.username
FROM (
        SELECT U.user_id,
            U.username,
            C.category_id
        FROM Users U,
            Orders O,
            Order_Items OI,
            Products P,
            Categories C
        WHERE U.user_id = O.user_id
            AND O.order_id = OI.order_id
            AND OI.product_id = P.product_id 
            AND P.category_id = C.category_id
        GROUP BY C.category_id,
            U.user_id,
            U.username
    ) AS UC
GROUP BY UC.user_id,
    UC.username
HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM Categories
    );
-- Explanation for Problem 6:
-- The subquery, which I name UC (Users, Categories)
-- returns a record for each permutation of (user, category)
-- if the user has at least one order in that category.
-- This is done using a handful of joins to retrieve all the
-- necessary information. The group by clause in the  subquery eliminates 
-- duplicates if a user has multiple order items for the same category.
-- Then, the outer query groups UC by users, and for each user,
-- checks if the number of records from UC for that user equals 
-- the total number of categories. If this is the case, the user
-- has made an order in every category.

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
SELECT P.product_id, P.product_name
FROM Products P
    LEFT JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id,
    P.product_name
HAVING COUNT(R.review_id) = 0;
-- Explanation for Problem 7: 
-- Perform a left join on products with reviews. If a product has no reviews, 
-- then the left join will return one record with that product's information
-- and null values for the review columns. In Postgres, null values are not
-- included in the COUNT function, therefore for the products that do not have 
-- a review, COUNT(R.review_id) will be 0. We group by product to enable the use
-- of the COUNT function for the records for each product. 
-- ASIDE:
-- If I remember correctly, some RDMS's may not handle counting null values this
-- way. I have not done an exhaustive search to verify this, however this solution
-- certainly works in Postgres.

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem. 
SELECT UC.user_id,
    UC.username
FROM (
        SELECT U.user_id,
            U.username,
            OS.order_date::DATE - OF.order_date::DATE as difference
        FROM Orders OF,
            Orders OS,
            Users U
        WHERE U.user_id = OF.user_id
            AND U.user_id = OS.user_id
            AND OF.order_date < OS.order_date
    ) as UC
WHERE UC.difference = 1
GROUP BY UC.user_id,
    UC.username;
-- Explanation for Problem 8:
-- In the subquery, we return permutations of 2 distinct orders for each user.
-- We enforce an ordering on the order_dates in the WHERE clauses (OF < OS).
-- This allows us to determine if the orders were placed on consecutive days.
-- Specifically, if (OS - OF) == 1, then OS was placed a day after OF.
-- We check this clause in the outer query, which also groups by user 
-- to eliminate duplicates.