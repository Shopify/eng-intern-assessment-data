-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

With CTE_Result
AS (
    select R.product_id, P.product_name, Avg(R.rating) RatingAvg
    from dbo.reviews R
    inner join dbo.products P on R.product_id=P.product_id
    group by R.product_id, P.product_name
), 
CTE_HighestRating
As ( select Max(RatingAvg) MaxRatingAvg
     from CTE_Result )

select r.product_id, r.product_name, r.RatingAvg
from CTE_Result r
inner join CTE_HighestRating h on r.RatingAvg = h.MaxRatingAvg


-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.

select tt.user_id, tt.username
from (
    select count(*) categorycount 
    from dbo.Categories 
    ) c
inner join (
                select t.user_id, t.username, count(category_id) usercategorycount 
                from (
                    select distinct u.user_id, u.username, p.category_Id 
                    from dbo.users u
                    inner join dbo.orders o on u.user_id = o.user_id 
                    inner join dbo.order_items i on o.order_id = i.order_id 
                    inner join dbo.products p on p.product_id = i.product_id
                )t
                group by t.user_id, t.username
            ) tt on c.categorycount = tt.usercategorycount 
        

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
select p.product_id, p.product_name 
from dbo.products p
where p.product_id not in ( select product_id from dbo.reviews )

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.


;with CTE_Result_ConsecutiveOrder_S1
AS
(
    select User_Id, 
          Order_id,
          order_date,
          lag(Order_id) over ( partition by user_id order by order_id) PreviousOrderID
    from dbo.orders

),
CTE_Result_ConsecutiveOrder
AS (
select * from CTE_Result_ConsecutiveOrder_S1 where order_id = PreviousOrderID + 1
),

CTE_ConsecutiveDay
AS(
select  u.User_id, 
        u.UserName,
        Order_Date, 
        row_Number() over (partition by username order by order_date) RowNumberByUserID,
        DateAdd(Day,-row_Number() over (partition by o.user_id order by order_date), Order_date) OrderConsecutive
from dbo.users u
inner join CTE_Result_ConsecutiveOrder  o on u.user_id = o.user_id 
)


select user_id, username 
from CTE_ConsecutiveDay
group by user_id, username, OrderConsecutive
having count(*) >=2

