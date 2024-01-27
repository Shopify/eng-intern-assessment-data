-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.
SELECT product_id, category_id, (LENGTH(category_id) - LENGTH(REPLACE(category_ids), ',','')) + 1)as category_cnt FROM (
    SELECT product_id, GROUP_CONCAT(category_id) as category_ids FROM (
        SELECT `e`.product_id, `at_category_id`.`category_id` 
        FROM `catalog_product_entity` AS `e` 
        LEFT JOIN `catalog_category_product` AS `at_category_id`
        ON (at_category_id.`product_id`=e.entity_id)
    ) sub_query
    GROUP BY product_id
) final_query
HAVING category_cnt > 2


-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
SELECT CID,
       COUNT(Orders.OrderID) AS TotalOrders,
       SUM(OrderAmounts.DollarAmount) AS TotalDollarAmount
FROM [Orders]
INNER JOIN (SELECT OrderID, Sum(Quantity*SalePrice) AS DollarAmount 
      FROM OrderItems GROUP BY OrderID) AS OrderAmounts
  ON Orders.OrderID = OrderAmounts.OrderID
GROUP BY CID
ORDER BY Count(Orders.OrderID) DESC
    
-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
select *
 from PRODUCT p
  join (
    select
      P_NUM,
      avg(RATE) avg
     from REVIEW
     group by P_NUM
     having sum( CASE WHEN RATE < 3 THEN 1
                  ELSE 0
                  END ) > ( count(*) * 0.5 )
    ) as r
   on p.P_NUM = r.P_NUM

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.
SELECT CUSTOMER_NAME, Y.QNTY 
FROM CUSTOMER_T CUST,
(
  SELECT X.CUSTOMER_ID, X.QNTY, MAX(X.QNTY) MAXAMT
  FROM (
        SELECT ORD.CUSTOMER_ID, SUM(OLN.QUANTITY * PRD.UNIT_PRICE) QNTY
        FROM ORDER_T ORD, ORDER_LINE_T OLN, PRODUCT_T PRD
        WHERE TRUNC(OLN.ORDER_DATE,'YEAR') = TRUNC(SYSDATE,'YEAR')
        AND ORD.ORDER_ID = OLN.ORDER_ID
        AND PRD.PRODUCT_ID = OLN.PRODUCT_ID
        GROUP BY ORD.CUSTOMER_ID
       ) X 
) Y
WHERE CUST.CUSTOMER_ID = Y.CUSTOMR_ID
AND Y.QNTY = Y.MAXAMT;
