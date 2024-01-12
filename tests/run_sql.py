import sqlite3

conn = sqlite3.connect('shopify_data.db')

cursor = conn.cursor()

query = """
SELECT 
    Payments.payment_id,
    Payments.order_id,
    Payments.amount AS payment_amount,
    Orders.total_amount AS invoice_amount
FROM 
    Payments
INNER JOIN 
    Orders ON Payments.order_id = Orders.order_id;
""" 

cursor.execute(query)

for row in cursor.fetchall():
    print(row)

conn.close()
