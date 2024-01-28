-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
SELECT
    Categories.category_id,
    Categories.category_name,
    -- Calculate the total sales for each category by multiplying the quantity of each order item by the product's price, and then summing the results
    SUM(Order_Items.quantity * Products.price) AS total_sales
FROM
    Order_Items,
    Products,
    Categories
WHERE
    -- Join condition between Order_Items and Products tables based on the product_id
    Order_Items.product_id = Products.product_id AND
    -- Join condition between Products and Categories tables based on the category_id
    Products.category_id = Categories.category_id
GROUP BY
    Categories.category_id
ORDER BY
    total_sales DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- Define a Common Table Expression (CTE) named Toy_Ids
-- This CTE selects all product_ids from the Products table that belong to the 'Toys & Games' category
WITH Toy_Ids AS (
    SELECT
        Products.product_id
    FROM
        Products,
        Categories
    WHERE
        -- Join condition between Products and Categories tables based on the category_id
        Products.category_id = Categories.category_id AND
        -- Condition to filter for products in the Toys & Games category
        Categories.category_name = 'Toys & Games'
)
SELECT
    Users.user_id,
    Users.username
FROM
    Users,
    Orders,
    Order_Items,
    Toy_Ids
WHERE 
    -- Join condition between Order_Items and Toy_Ids tables based on the product_id
    Order_Items.product_id = Toy_Ids.product_id AND 
    -- Join condition between Orders and Order_Items tables based on the order_id
    Orders.order_id = Order_Items.order_id AND 
    -- Join condition between Users and Orders tables based on the user_id
    Users.user_id = Orders.user_id 
-- Group the results by user_id
GROUP BY 
    Users.user_id
-- Filter the results to include only those users who have ordered all products in the Toys & Games category
HAVING 
    COUNT(DISTINCT Order_Items.product_id) = COUNT(Toy_Ids.product_id);

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT
    product_id,
    product_name,
    category_id,
    price
FROM
    (
        -- Subquery to select the product_id, product_name, category_id, price, and the rank of each product within its category based on the price
        SELECT
            product_id,
            product_name,
            category_id,
            price,
            -- Window function to rank each product within its category based on the price
            RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as rank
        FROM
            Products
    ) as ProductsRanked
WHERE 
    -- Condition to filter for the products that have the highest price within each category
    rank = 1;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
SELECT 
    user_id,
    username
FROM 
    (
        -- Subquery to select the user_id, order_date, and the difference in days between each order and the previous order for each user
        SELECT 
            Orders.user_id,
            Users.username,
            Orders.order_date,
            -- Window function to calculate the difference in days between each order and the previous order for each user
            Orders.order_date - LAG(Orders.order_date) OVER (PARTITION BY Orders.user_id ORDER BY Orders.order_date) as diff_days
        FROM 
            Orders
        JOIN 
            Users ON Orders.user_id = Users.user_id  -- Join condition between Orders and Users tables
    ) as OrdersDiffDays
-- Group the results by user_id and username
GROUP BY 
    user_id, 
    username
-- Filter the results to include only those users who have placed orders on consecutive days for at least 3 days
HAVING 
    COUNT(CASE WHEN diff_days = 1 THEN 1 END) >= 3;