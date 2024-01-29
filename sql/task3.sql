-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

-- sales amount = quantity x unit price 
select c.category_id, c.category_name, SUM(o.quantity * o.unit_price) as total_sales    
from Order_Items o join Products d on o.product_id = d.product_id join Categories c on d.category_id = c.category_id
group by c.category_id, c.category_name 
order by total_sales DESC
limit 3; 
 -- only want the top 3 categories

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.

select u.user_id, u.username
from Categories c join Products p on c.category_id = p.category_id 
        join Order_Items o1 on o1.product_id = p.product_id join Orders o2 on o2.order_id = o1.order_id 
        join Users u on u.user_id = o2.user_id 
where c.category_name = 'Toys & Games'      
group by u.user_id, u.username
having count(Distinct p.product_id) = (select count(Distinct p2.product_id)     
                                        from Products p2 join Categories c2 on p2.category_id = c2.category_id
                                        where c2.category_name = 'Toys & Games');
   -- count distinct will only count different product, so matching the counts of product bought by each users to counts of each distinct product in each category 
   -- (In this problem is toys & games) will achieve the purpose of retrieve the users who placed order for all products.



-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

select p1.product_id, p1.product_name, p1.category_id, p1.price
from Products p1
where p1.price >= all (select p2.price                         -- Find the the product with highest price in each category
                        from Products p2
                        where p1.category_id = p2.category_id)   
group by p1.product_id, p1.product_name, p1.category_id, p1.price;


-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

with Find_consecutive as (      -- Temporary table to store all the user that placed orders on at least 3 days, modified from problem 8
    select o1.user_id
    from Orders o1, Orders o2, Orders o3
    where o1.user_id = o2.user_id and o2.user_id = o3.user_id and o1.order_date = o2.order_date + INTERVAL '1 day' and o1.order_date = o3.order_date + INTERVAL '2 day'
    group by o1.user_id   
)
select u.user_id, u.username    
from Users u join Find_consecutive f on u.user_id = f.user_id;