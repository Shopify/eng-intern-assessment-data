-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- use joins to link categories->products->orders 
-- use sum to find the total about spent on orders in each category
-- order them in descending order and limit to top 3
SELECT
    Categories.category_id,
    Categories.category_name,
    SUM(Orders.total_amount) AS sales_total
FROM Categories 
JOIN Products
    ON Categories.category_id = Products.category_id
JOIN Order_items
    ON Products.product_id = Order_Items.product_id
JOIN Orders 
    ON Order_Items.order_id = Orders.order_id
GROUP BY
    Categories.category_id,
    Categories.category_name
ORDER BY
    sales_total DESC
LIMIT 3
-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


-- use joins to link users->orders->order items->products->categories
-- in a subquery, count the number of unique products in each category
-- using the where clause, only look at orders with products within the toys and games category
-- then, check to see if the number of distinct items ordered equals the total amount of distinct items in the category

SELECT
    Users.user_id,
    Users.username
FROM
    Users 
JOIN Orders 
    ON Users.user_id = Orders.user_id
JOIN Order_Items
    ON Orders.order_id = Order_Items.order_id
JOIN Products 
    ON Order_Items.product_id = Products.product_id
JOIN Categories 
    ON Products.category_id = Categories.category_id
WHERE
    Categories.category_id = 5
GROUP BY
    Users.user_id,
    Users.username
HAVING
    COUNT(DISTINCT Products.product_id) = (
        SELECT COUNT(*)
        FROM Products
        WHERE category_id = 5
    )

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- in a subquery, use the row_number() function to assign a rank to each product in descending order, partitioned by category
-- then in the main query, select all the top ranked products 
SELECT
    product_id, 
    product_name, 
    category_id, 
    price
FROM (
    SELECT
        product_id,
        product_name,
        category_id,
        price,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
    FROM
        Products
) ProductsRanked
WHERE price_rank = 1

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- in a subquery, use the lead() and lag() functions to find the date of the previous and next order made by a given user
-- in the main query, check to see if the previous order is one day behind the current order 
-- AND the next order is one day ahead of the current order, meaning the three days are consecutive

SELECT DISTINCT
    Users.user_id,
    Users.username
FROM
    Users 
JOIN
(
    SELECT
        user_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_date,
        LEAD(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS next_date
    FROM
        Orders
) ConsecOrders 
ON Users.user_id = ConsecOrders.user_id
WHERE
    ConsecOrders.next_date = ConsecOrders.order_date + INTERVAL '1 day'
    AND ConsecOrders.prev_date = ConsecOrders.order_date - INTERVAL '1 day';