-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.


SELECT 
	categories.category_id, category_name, SUM(quantity * unit_price) AS total_amount
FROM 
	categories
JOIN 
	products ON categories.category_id = products.category_id
JOIN 
	order_items ON products.product_id = order_items.product_id
GROUP BY 
	categories.category_id
ORDER BY 
	total_amount DESC
LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

SELECT
	user_id,
    username
FROM 
	users
WHERE (
    SELECT COUNT(DISTINCT order_items.product_id) 
    FROM 
		order_items
    JOIN 
		orders ON orders.order_id = order_items.order_id 
    JOIN 
		products ON products.product_id = order_items.product_id
    JOIN 
		categories ON products.category_id = categories.category_id
    WHERE orders.user_id = users.user_id and category_name = 'Toys & Games') 
    = 
    (SELECT COUNT(Distinct product_id) 
     FROM 
		products
     JOIN 
		categories ON categories.category_id = products.category_id
     WHERE 
		category_name = 'Toys & Games');
        
	-- Sarah placed the most orders for Toys & Games

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.


WITH MaxP AS (
    SELECT
		category_id, MAX(price) as highest_price
    FROM 
		products
    GROUP BY 
		category_id
)

SELECT 
	product_id, 
    product_name, 
    products.category_id, 
    highest_price
FROM 
	products
JOIN 
	MaxP ON products.category_id = MaxP.category_id
WHERE
	price = highest_price;

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem

WITH OrderDateRank AS ( 
    SELECT 
        ordered.user_id,
        ordered.order_date,
        RANK() OVER (PARTITION BY ordered.user_id ORDER BY ordered.order_date) AS ranked
    FROM Orders ordered
)

SELECT 
    users.user_id,
    users.username
FROM 
	OrderDateRank ordered
INNER JOIN 
	Users users ON ordered.user_id = users.user_id
WHERE 
	ordered.ranked >= 3;
    
    -- There are no users who retrieved orders on consecutive days