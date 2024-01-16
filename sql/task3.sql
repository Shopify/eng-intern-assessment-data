-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT c.category_id, c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales_amount -- Total sales amount for each category
FROM Categories c
JOIN Products p ON c.category_id = p.category_id -- Join Categories with Products, 
JOIN Order_Items oi ON p.product_id = oi.product_id -- and Products with Order_Items to get sales data,
GROUP BY c.category_id, c.category_name -- then group by category to aggregate sales data.
ORDER BY total_sales_amount DESC -- Finally, order by total sales amount in descending order.
LIMIT 3 -- Limit the result to the top 3 categories.

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH TotalToysGamesProducts AS ( -- Count all products in the Toys & Games category
    SELECT COUNT(*) AS total_products
    FROM Products
    JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games'
),

UserToysGamesProductCounts AS ( -- Count unique Toys & Games products ordered by each user
    SELECT Users.user_id, Users.username, COUNT(DISTINCT Products.product_id) AS user_product_count
    FROM Users
    -- Join Users with Orders, then Orders -> Order_Items -> Products -> Categories,
    JOIN Orders ON Users.user_id = Orders.user_id
    JOIN Order_Items ON Orders.order_id = Order_Items.order_id
    JOIN Products ON Order_Items.product_id = Products.product_id
    JOIN Categories ON Products.category_id = Categories.category_id
    WHERE Categories.category_name = 'Toys & Games' -- then filter by category name.
    GROUP BY Users.user_id -- Finally, group by user_id to aggregate data per user.
)

SELECT u.user_id, u.username -- Main query starts here
FROM UserToysGamesProductCounts u, TotalToysGamesProducts t
WHERE u.user_product_count = t.total_products -- Select users whose product count matches the total number of T&G products.

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH RankedProducts AS ( -- Rank products based on price within each category
  SELECT p.product_id, p.product_name, p.category_id, p.price, RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) as price_rank
  FROM Products p -- Rank products within each category by price in descending order from the Products table, aliased as 'p'
)

SELECT product_id, product_name, category_id, price -- Main query starts here
FROM RankedProducts
WHERE price_rank = 1; -- Filter to get the top-ranked products in each category

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH OrderedUsers AS ( -- Join Orders and Users, and find the previous order date for each user using LAG
  SELECT o.user_id, u.username, o.order_date, LAG(o.order_date) OVER (PARTITION BY o.user_id ORDER BY o.order_date) AS prev_order_date
  FROM Orders o
  JOIN Users u ON o.user_id = u.user_id
),

ConsecutiveOrders AS ( -- Determine if an order is consecutive (1 day after the previous order)
  SELECT user_id, username, order_date, prev_order_date,
    CASE -- Label as consecutive if the difference in days equals 1
      WHEN DATEDIFF(day, prev_order_date, order_date) = 1 THEN 1
      ELSE 0
    END AS is_consecutive
  FROM OrderedUsers
),

ConsecutiveCounts AS ( -- Calculate the count of consecutive orders within a 3-day window
  SELECT user_id, username, SUM(is_consecutive) OVER (PARTITION BY user_id ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS consecutive_count
  FROM ConsecutiveOrders
)

SELECT DISTINCT user_id, username -- Main query starts here
FROM ConsecutiveCounts
WHERE consecutive_count >= 2; -- Select users who have at least 3 consecutive days of order
-- A quick note on line 83:
-- If the orders are on the 1st, 2nd, and 3rd, the one-day gaps are between the 1st & 2nd and the 2nd & 3rd.
-- So in a sequence of three consecutive days of orders, the flag will be 1, leading to a `consecutive_count` of 2.
-- If `>= 3`, it would mean 4 consecutive days because three 1-day gaps.