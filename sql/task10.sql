-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH ToysGamesProducts AS (
    SELECT product_id
    FROM Products
    JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games'
), UserOrdersForToysGames AS (
    SELECT Orders.user_id, Order_Items.product_id
    FROM Orders
    JOIN Order_Items ON Orders.order_id = Order_Items.order_id
    WHERE Order_Items.product_id IN (SELECT product_id FROM ToysGamesProducts)
    GROUP BY Orders.user_id, Order_Items.product_id
), UserCount AS (
    SELECT user_id, COUNT(*) AS product_count
    FROM UserOrdersForToysGames
    GROUP BY user_id
    HAVING COUNT(*) = (SELECT COUNT(*) FROM ToysGamesProducts)
)

SELECT Users.user_id, Users.username
FROM Users
JOIN UserCount ON Users.user_id = UserCount.user_id;
