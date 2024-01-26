-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

with rating_rank_tb as(
select r.product_id,
p.product_name,
average_rating,
 DENSE_RANK() over(order by average_rating desc) as rank_rating --Using dense_rank to resolve ties
from
(   
    select product_id,
	round(AVG(rating),1) as average_rating
	from Reviews
	group by product_id  

) as r
	join Products as p
	on p.product_id=r.product_id 
)

select  product_id, product_name, average_rating from rating_rank_tb
where rank_rating=1; --Display all the products with highest rating



-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.


with user_cat as
(
select user_id,
username, 
count(category_id) as cat_count 
from 
(
	select distinct u.user_id, u.username, category_id 
	from Order_Items as oi
	join Orders as o
	on o.order_id=oi.order_id
	left join Users as u
	on  o.user_id=u.user_id
	left join products as p
	on p.product_id=oi.product_id
) temp
group by user_id,username
)


select user_id,
username 
from user_cat
where cat_count= (select count(category_id) from Categories ); --Number of product categories purchase by users must match the total categories




-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.

select  p.product_id
product_name
from Products as p
left join Reviews as r
on p.product_id=r.product_id
where r.rating is null;  --If rating in null then no review is recorded for the product


-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.

with nextdayorder AS (
    select user_id,
    order_date,
    lead(order_date, 1) over (PARTITION BY user_id ORDER BY order_date) AS next_order --Add a column to account for the next date the order is placed by a single customer
    FROM Orders
)
 --The difference between the two columns should be a day
select distinct n.user_id,username 
from nextdayorder as n
join  Users as u 
on u.user_id=n.user_id
where DATEDIFF(day,order_date,next_order) =1;

