-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Notes:
-- It is noted that the prices vary depending on the table
-- For example in Orders (order_id=1) the total price is 100
-- But the price for the same order_id in Order_Items is 125
-- This could be due to discounts or sales, or perhaps the data inconsistency

WITH
Total_Category_Sales_Amount AS (
	SELECT 
        category_id, 
        category_name, 
        (quantity * unit_price) AS total_amount     -- We compute the total amount for each order
  	FROM Categories                                 -- We join the tables to get the category name
  		LEFT JOIN Products USING (category_id)      -- and what products were ordered in that category
  		LEFT JOIN Order_Items using (product_id)    -- We use the total sales price, not actual price
)
SELECT 
    category_id, 
    category_name, 
    SUM(total_amount) as total_sales_amount
FROM Total_Category_Sales_Amount
GROUP BY category_id, category_name
ORDER BY total_sales_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

WITH
Category_Products AS (
	SELECT 
        product_id,                                 -- We retrieve the product_id for all products in category
        category_name, 
        product_name
  	FROM Products AS p                              -- More efficent to filter while joining
  		INNER JOIN Categories AS c                  -- Database engine doesn't need to join then filter again
  		ON (p.category_id=c.category_id AND 
            c.category_name = 'Toys & Games')
)
SELECT DISTINCT user_id, username                   -- We then select the users who have ordered all products
FROM Order_Items                                    -- By inner joining to it   
	INNER JOIN Category_Products USING (product_id)
    INNER JOIN Orders USING (order_id)
    INNER JOIN Users USING (user_id);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

WITH 
Category_Max_Price AS (
    SELECT
        category_id,                                -- We group by category_id to use agg function to get max
        MAX(price) AS price                         -- We use this high price and id to retrieve more data
    FROM Products                                   -- In doing so we preserve if multiple items have max price 
        INNER JOIN Categories using (category_id)   -- In a particular category
    GROUP BY category_id
)
SELECT 
    product_id,                                     -- We join the max price and id to the products table
    product_name,                                   -- to get all max price products in a category
    category_id, 
    price
FROM Products
    INNER JOIN Category_Max_Price USING (category_id, price);

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- Methodology:
-- Similar to problem 8 we use a lead function to store the next two order dates
-- By computing the difference between the order dates, we can determine if they are consecutive

WITH 
User_Order_Days AS (
    SELECT
        user_id,
        username,
        order_date AS order_date_1,                 -- Renaming for clarity of order dates
        LEAD(order_date)                            -- Note that dates are sorted by order_date, so we can
            OVER (PARTITION BY user_id ORDER BY order_date) 
            AS order_date_2,                        -- Use this to our advantage to get the "next" order date
        LEAD(order_date, 2)                         -- We lead by 2 to get "next next" order date
            OVER (PARTITION BY user_id ORDER BY order_date) 
            AS order_date_3
    FROM Orders
        INNER JOIN Users USING (user_id)
)
SELECT DISTINCT user_id, username
FROM User_Order_Days
WHERE                                               -- We ensure 1->2 and 2->3 are consecutive, i.e., 1 day diff
    julianday(order_date_2) - julianday(order_date_1) = 1 AND 
    julianday(order_date_3) - julianday(order_date_2) = 1;
