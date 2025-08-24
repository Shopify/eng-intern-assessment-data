import pandas as pd
import mysql.connector
from mysql.connector import Error

path = 'path/to/data'

cart_data = 'cart_data.csv'
cart_item_data = 'cart_item_data.csv'
category_data = 'category_data.csv'
order_data = 'order_data.csv'
order_items_data = 'order_items_data.csv'
payment_data = 'payment_data.csv'
product_data = 'product_data.csv'
review_data = 'review_data.csv'
shipping_data = 'shipping_data.csv'
user_data = 'user_data.csv'

insert_order = [
    (path + category_data, 'Categories'),
    (path + product_data, 'Products'),
    (path + user_data, 'Users'),
    (path + order_data, 'Orders'),
    (path + order_items_data, 'Order_Items'),
    (path + review_data, 'Reviews'),
    (path + cart_data, 'Cart'),
    (path + cart_item_data, 'Cart_Items'),
    (path + payment_data, 'Payments'),
    (path + shipping_data, 'Shipping'),
]


def import_csv_to_mysql(csv_file, table_name, db_connection):
    cursor = db_connection.cursor()

    df = pd.read_csv(csv_file)

    for i, row in df.iterrows():
        sql = f"INSERT INTO {table_name} ({', '.join(df.columns)}) VALUES ({', '.join(['%s'] * len(df.columns))})"
        try:
            cursor.execute(sql, tuple(row))
            db_connection.commit()
        except Error as e:
            print(f"Row {i} wasn't added: {e}")


db_config = {
    'host': 'localhost',
    'database': 'db',
    'user': 'root',
    'password': 'password'
}

connection = mysql.connector.connect(**db_config)

for data, table in insert_order:
    import_csv_to_mysql(data, table, connection)

if connection.is_connected():
    connection.close()
