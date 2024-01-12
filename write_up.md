# How I did the challenge
1. Created a new database called `shopify_data.db` (Used `tests/create_db.py`)
2. Created a script to test sql queries (Used `tests/run_sql.py`)
3. Modified the `tests/test_sql_queries.py` to test the queries
	a. Hard to run multiple queries from one file so I had to change the setup. 
	b. I created a function `execute_and_test_query` to execute and test the queries


# Things I noticed
1. Payment amount are inconsistent with the amount in the invoice

```sql
SELECT 
    Payments.payment_id,
    Payments.order_id,
    Payments.amount AS payment_amount,
    Orders.total_amount AS invoice_amount
FROM 
    Payments
INNER JOIN 
    Orders ON Payments.order_id = Orders.order_id;
```