-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    -- obtain info from Orders (order_id, total_amount), Order_Items (order_id, product_id),
    -- Products (product_id, category_id), Categories (category_id, category_name)
    -- will create a new attribute noting the sum of all orders by category
    -- based on assumption that "sales amount" = gross profit
    SELECT *, sum(total_amount) as total_by_category
    FROM (( SELECT order_id, total_amount FROM Orders) NATURAL JOIN
	( SELECT order_id, product_id FROM Order_Items ) NATURAL JOIN
	( SELECT product_id, category_id FROM Products ) NATURAL JOIN
	( SELECT category_id, category_name FROM Categories ))

    -- then we group results by category_id (to keep them separate), order by total amount spent
    -- and specify limit of 3
    GROUP BY category_id ORDER BY total_by_category DESC LIMIT 3;

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
    -- get info from Orders (user_id, order_id) Users (user_id, username),
    -- Order_Items (order_id, product_id), Categories (category_id, category_name)
    SELECT user_id, username FROM (
	-- determine the number of items ordered in a category
	SELECT *, COUNT(DISTINCT product_id) as items_ordered_in_category
	FROM
		( SELECT *
			-- get the order id, products ordered, their category, and name
			FROM USERS NATURAL JOIN (SELECT order_id, user_id FROM Orders) NATURAL JOIN
				(SELECT order_id, product_id FROM Order_Items) NATURAL JOIN
				( SELECT product_id, category_id FROM Products) NATURAL JOIN
				(SELECT category_id, category_name FROM Categories)  NATURAL JOIN
			    -- this gets the total number of items in the category of choice for later reference
				(SELECT category_id, COUNT(DISTINCT product_id) as total_in_category FROM Products GROUP BY category_id)
			-- filter by selected category
			WHERE category_name = 'Toys & Games')
	GROUP BY user_id )
    WHERE items_ordered_in_category = total_in_category;

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    -- obtain info from Products, order by descending price
    -- Then select the relevant attributes and group them by category id (due to the descending price,
    -- the most expensive items go first)
    SELECT product_id, product_name, category_id, price
    FROM ( SELECT * FROM Products ORDER BY price DESC) GROUP BY category_id;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
    -- obtain info from Orders natural joined with User
    SELECT user_id, username FROM
        -- Determine consecutive orders for two days
        ( SELECT *, LAG(consec1) OVER (PARTITION BY user_id ORDER BY order_date) AS consec2 FROM
            -- Determine consecutive orders for one day
            (SELECT *, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS consec1 FROM Orders NATURAL JOIN Users)
        )
        -- integrity constraints; order_date, consec1, and consec2 are each one day apart with order_date being the latest and consec2 being the earliest
        -- if such tuples exist matching the criteria, then the user has ordered for three consecutive days
    WHERE order_date = consec1 + 1 AND consec1 = consec2 + 1 AND order_date = consec2 + 2 AND consec1 IS NOT NULL and consec2 IS NOT NULL;