-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.
with prod_avg_rating as (
    select  
        Products.product_id,
        Products.product_name,
        AVG(Reviews.rating) as avg_rating
    from Products 
    left join Reviews on Products.product_id = Reviews.product_id
    group by 1,2
)

select * 
from prod_avg_rating
where avg_rating = (select max(t2.avg_rating) from prod_avg_rating as t2)
;

-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
with user_ids as (
    select 
        user_id,
        count(distinct category_id)
    from Order_Items
    join Orders on Orders.order_id = Order_Items.order_id
    join Products on Products.order_id = Order_Items.order_id
    group by 1
    having count(distinct category_id) = (select count(*) from Categories)
)

select 
    Users.user_id,
    Users.username
from user_ids
join Users on user_ids.user_id = Users.user_id
;

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
with products_and_reviews as (
    select distinct
        Products.product_id,
        Products.product_name,
        Reviews.review_id
    from Products 
    left join Reviews on Products.product_id = Reviews.product_id
)

select distinct
    product_id,
    product_name
from products_and_reviews
where review_id is null
;

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
with consec_user_ids as (
    select distinct
        o1.user_id,
    from Orders o1
    join Orders o2 on o1.user_id = o2.user_id and o1.order_date = date_add(o2.order_date, interval -1 day);
)

select
    consec_user_ids.user_id,
    Users.username
from consec_user_ids
join Users on consec_user_ids.user_id = Users.user_id
;