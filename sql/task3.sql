-- Please note that I used Postgres as the underlying RDBMS. 

-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT C.category_id,
    C.category_name,
    SUM(OI.unit_price * OI.quantity) as total_sales_amount
FROM Order_Items OI,
    Orders O,
    Products PR,
    Categories C
WHERE OI.order_id = O.order_id
    AND OI.product_id = PR.product_id
    AND PR.category_id = C.category_id
    AND EXISTS (
        SELECT *
        FROM Payments PA
        WHERE PA.order_id = O.order_id
    )
GROUP BY C.category_id,
    C.category_name
ORDER BY total_sales_amount DESC
LIMIT 3;
-- Explanation for Problem 9:
-- Note that I am making the same assumption I specified for Problem 4, hence my use 
-- of the Payments table (that is, orders must have at least one payment to count towards total sales).
-- We perform a join on orders, order_items, products and categories, and exclude results with no payment.
-- Group results by category, and for each category, sum the total sales amount of the 
-- order items (unit_price * quantity). Then, order results in descending fashion (largest first), 
-- and limit the results to the top 3 categories with the highest total sales amount.
-- ASIDE:
-- We could get a bit more complicated with Payments, e.g. only include orders that are 'paid in full'
-- (that is, only consider order items if the sum of the payments for that order match the total amount
-- of the order). However, to keep things relatively simple I opted not to include that additional piece
-- of logic.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT UP.user_id,
    UP.username
FROM (
        SELECT U.user_id,
            U.username,
            P.product_id
        FROM Users U,
            Orders O,
            Order_Items OI,
            Products P,
            Categories C
        WHERE U.user_id = O.user_id
            AND O.order_id = OI.order_id
            AND OI.product_id = P.product_id
            AND P.category_id = C.category_id
            AND C.category_name = 'Toys & Games'
            AND OI.quantity > 0
        GROUP BY U.user_id,
            U.username,
            P.product_id
    ) AS UP
GROUP BY UP.user_id,
    UP.username
HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM Products PI,
            Categories CI
        WHERE PI.category_id = CI.category_id
            AND CI.category_name = 'Toys & Games'
    );
-- Explanation for Problem 10:
-- This solution is similar in spirit to my solution for Problem 6.
-- The subquery returns all (user, product) permutations if that user has ordered that product
-- and the category of that product is 'Toys & Games'. The group by clause in the subquery
-- ensures that we only return one record for a given product and user, even if the user has ordered it
-- multiple times. Then, in the outer query, we group by user. For each user, using the HAVING clause,
-- we check if the total number of records returned by the subquery equal the total number of 'Toys & Games'
-- products. If this is the case, the user has placed an order for all products in the 'Toys & Games' section.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT PO.product_id,
    PO.product_name,
    PO.category_id,
    PO.price
FROM Products PO
WHERE PO.price >= ALL (
        SELECT PI.price
        FROM Products PI
        WHERE PI.category_id = PO.category_id
    );
-- Explanation for Problem 11:
-- This one is fairly self-explanatory.
-- For each product, return the product if the price is greater than or 
-- equal to the price of every product with the same category.
-- Note that this query will return multiple products for the same category
-- if there are multiple products in the same category that all have the same highest
-- price. This behaviour seems to align best with the problem statement.

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT UC.user_id,
    UC.username
FROM (
        SELECT U.user_id,
            U.username,
            (OT.order_date::DATE - OS.order_date::DATE) + (OS.order_date::DATE - OF.order_date::DATE) as difference
        FROM Orders OF,
            Orders OS,
            Orders OT,
            Users U
        WHERE U.user_id = OF.user_id
            AND U.user_id = OS.user_id
            AND U.user_id = OT.user_id
            AND OF.order_date < OS.order_date
            AND OS.order_date < OT.order_date
    ) as UC
WHERE UC.difference = 2
GROUP BY UC.user_id,
    UC.username;
-- Explanation for Problem 12:
-- This solution is similar in spirit to my solution for Problem 8.
-- In the inner query, we return permutations of 3 distinct orders for a given user.
-- We enforce an ordering on the order_dates in the WHERE clauses (OF < OS < OT).
-- This allows us to determine if the orders are on three consecutive days.
-- Specifically, if (OT - OS) + (OS - OF) == 2, then OT was placed a day after OS, which was
-- placed a day after OF. We check this in the outer query, which also groups by user 
-- to eliminate duplicates.