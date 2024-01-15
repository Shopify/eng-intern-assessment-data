-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

--Here, I use a subquery to multiple the unit price with the quantity to get the total price
--I use SUM function along with GROUP BY to aggregate based on category_id
--To get only the top 3, I used descending order and then limited it to the first three entries
SELECT Categories.category_id, Categories.category_name, SUM(a.price) AS total_sales
FROM (
    SELECT Order_Items.product_id, Order_Items.quantity*Order_Items.unit_price AS price
    FROM Order_Items
) a
LEFT JOIN Products ON Products.product_id=a.product_id
LEFT JOIN Categories ON Products.category_id=Categories.category_id
GROUP BY Categories.category_id, Categories.category_name
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

--Here I join several tables in order to connect the Categories table
--I then use a WHERE clause to filter out only products from the Toys & Games
--I use the COUNT DISTINCT to filter out the people who have bought every product from Toys & Games
SELECT Orders.user_id, Users.username
FROM Orders
LEFT JOIN Users ON Orders.user_id=Users.user_id
LEFT JOIN Order_Items ON Orders.order_id=Order_Items.order_id
LEFT JOIN Products ON Order_Items.product_id=Products.product_id
LEFT JOIN Categories ON Products.category_id=Categories.category_id
WHERE Categories.category_name='Toys & Games'
GROUP BY Orders.user_id, Users.username
HAVING COUNT(DISTINCT Products.product_id) = (
    SELECT COUNT(*)
    FROM Products
    LEFT JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games'
);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--I use a subquery with the window function & RANK function to rank products by price within each category
--I then use the WHERE clause to only take the highest price (which in descending is the first)
SELECT subquery.product_id, subquery.product_name, subquery.category_id, subquery.unit_price
FROM (
    SELECT Products.product_id, Products.product_name, Products.category_id, Order_Items.unit_price,
           RANK() OVER (PARTITION BY Products.category_id ORDER BY Order_Items.unit_price DESC) as rank
    FROM Products
    LEFT JOIN Order_Items ON Products.product_id=Order_Items.product_id
) subquery
WHERE subquery.rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

--I use a subquery with self join to compare order dates
--In the self join, I have one that gets only users who ordered consectively once
--and another for consectively twice (for at least 3 days)

SELECT subquery.user_id, subquery.username
FROM (
    SELECT o1.user_id, Users.username, o1.order_date
    FROM orders o1
    JOIN Users ON Users.user_id=o1.user_id
    JOIN orders o2 ON o1.user_id = o2.user_id AND o1.order_date = o2.order_date + INTERVAL '1 day'
    JOIN orders o3 ON o2.user_id = o3.user_id AND o2.order_date = o3.order_date + INTERVAL '1 day'
) subquery
GROUP BY subquery.user_id, subquery.username;