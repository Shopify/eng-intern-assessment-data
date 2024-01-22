-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select top 3 c.category_id, c.category_name, sum(p.amount) amountcategory
from dbo.order_items i
inner join dbo.payments p on p.order_id = i.order_id
inner join dbo.products pp on pp.product_id = i.product_id
inner join dbo.Categories c on c.category_id =pp.category_id
group by c.category_id, c.category_name
order by 3 desc 

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

With CTE_UserOrder
as (
    select distinct u.user_id, u.username, p.product_id, p.product_name
    from dbo.users u
    inner join dbo.orders o on o.user_id = u.user_id
    inner join dbo.order_items i on o.order_id = i.order_id
    inner join dbo.Products p on p.product_id = i.product_id
    inner join dbo.Categories c on c.category_id = p.category_id
    where c.category_name = 'Toys & Games'
), CTE_UserOrderCategoryCount
as (
    select user_id, username, count(product_id) Userproductcount
    from CTE_UserOrder
    group by user_id, username
)

, CTE_CategoryProduct as
(
    select Count(p.product_id) TotalproductCount
    from dbo.Categories c
    inner join dbo.Products p on p.category_id = c.category_id
    where c.category_name = 'Toys & Games'
)

select c.user_id, c.username
from CTE_UserOrderCategoryCount c
inner join CTE_CategoryProduct p on c.Userproductcount = p.TotalproductCount


-- Problem 11: Retrieve the products that have  the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select p.product_id, p.product_name, p.category_id, p.price
from dbo.products p
inner join (
            select p.category_id, Max(p.price) HighestPrice
            from dbo.products p
            group by p.category_id
          ) t on p.category_id = t.category_id and t.HighestPrice = p.price  


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
;with CTE_Result
AS (
select  u.User_id, 
        u.UserName,
        Order_Date, 
        --row_Number() over (partition by username order by order_date) RowNumberByUserID,
        DateAdd(Day,-row_Number() over (partition by o.user_id order by order_date), Order_date) OrderConsecutive
from dbo.users u
inner join dbo.orders o on u.user_id = o.user_id 
)

select user_id, username 
from CTE_Result
group by user_id, username, OrderConsecutive
having count(*) >=3