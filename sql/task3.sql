-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Note
-- Approach: We first obtain amounts at the order item category grain using the order items table.

-- Amounts at the order item - category grain
WITH category_item_amounts AS (
    SELECT 
      order_item_id,
      (quantity * unit_price) AS item_amount,
      category_id,
      category_name
    FROM Orders
    INNER JOIN Order_Items USING(order_id)
    INNER JOIN Products USING(product_id)
    INNER JOIN Categories USING(category_id)
    GROUP BY 1, 2
)

-- Now we get the top 3 categories with the highest total sales amount
SELECT 
  category_id,
  category_name,
  SUM(item_amount) AS total_sales_amount
FROM category_item_amounts
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 3


-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Note
-- Assumption: Toys and Games category is cateory_id = 5
-- Approach: We start with getting a fine grain table with rows for each user, product, cateory.
-- From here, we get users with orders with products in the Toys & Games category. 
-- Then we aggregate up to the user level. 

-- getting table with users, all the products they bought and their categories
WITH user_order_product_category AS (
    SELECT user_id, product_id, category_id
    FROM Orders
    INNER JOIN Order_Items USING(order_id)
    INNER JOIN Products USING(product_id)
    INNER JOIN Categories USING(category_id)
),

-- getting users who brought products in the Toys and Games category
users_toygame AS (
    SELECT user_id, product_id
    FROM user_order_product_category
    WHERE category_id = 5
    GROUP BY 1, 2
),

-- all products in the toys and games category
products_toygame AS (
    SELECT product_id
    FROM Products
    WHERE category_id = 5
),

-- select users who have bought all the products in the toys and games category 
final AS (
    SELECT user_id
    FROM users_toygame 
    INNER JOIN Users USING(user_id)
    GROUP BY 1 
    HAVING COUNT(product_id) = (SELECT COUNT(product_id) FROM product_toygame)
)

SELECT user_id, username
FROM final 
JOIN Users USING(user_id)


-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Note
-- Assumption: To further interprate this as resulting the highest priced product in each category.
-- Approach: We partition the products table to obtain the max prices for each product

-- paritioning by category id
WITH max_prices AS (
    SELECT
      cateogry_id,
      product_id,
      product_name,
      price,
      ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS row_num
    FROM Products
)

-- selecting the highest priced product in each category
SELECT * EXCEPT(row_num)
FROM max_prices
WHERE row_num = 1


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Note
-- Approach: using problem 8 solution as a CTE here (refer to problem 8 for notes on that)
-- We look for 3 consecutive days by looking at order date, next order date, next next order date.
-- Since we are only looking for 3 consecutive days, this approach is works fine.

-- Alternative: if we were looking for N consecutive, where it is tedious to compute next...next order date,
-- We could take a binning approach, bin the consecutive orders and count where the bin has at least N days

-- -- Computing next order date and next next order date for each order 
WITH user_order_dates AS (
    SELECT
      user_id,
      order_date,
      LEAD(order_date, 1) OVER (PARTITION BY user_id ORDER BY order_date) AS next_order_date,
      LEAD(order_date, 2) OVER (PARTITION BY user_id ORDER BY order_date) AS next_next_order_date
    FROM Orders
),

-- Getting users that placed an order the next day and next next day
3_consecutive_users AS (
    SELECT 
    FROM user_order_dates
    WHERE 
      next_order_date IS NOT NULL
      AND next_next_order_date IS NOT NULL
      AND DATEDIFF(DAY, order_date, next_order_date) = 1
      AND DATEDIFF(DAY, order_date, next_next_order_date) = 2
)

-- Joining with the users table to get the username
SELECT 
  3_consecutive_users.user_id,
  username
FROM 3_consecutive_users
JOIN Users USING(user_id)