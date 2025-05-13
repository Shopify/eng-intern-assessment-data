import psycopg2

def get_connection():
    conn = psycopg2.connect(
            dbname='technicalassessment',
            user='newuser',
            password='123',
            host='localhost',
        )
    cur = conn.cursor()

    return cur, conn

def create_tables(cur, conn):
    with open('./sql/schema.sql', 'r') as file:
        sql_query = file.read()

    cur.execute(sql_query)

    conn.commit()

def add_users(cur, conn):
    sql = "copy public.users (user_id, username, email, password, address, phone_number) FROM '/Users/aaronchen/eng-intern-assessment-data/data/user_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_carts(cur, conn):
    sql = "copy public.cart (cart_id, user_id) FROM '/Users/aaronchen/eng-intern-assessment-data/data/cart_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_categories(cur, conn):
    sql = "copy public.categories (category_id, category_name) FROM '/Users/aaronchen/eng-intern-assessment-data/data/category_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_products(cur, conn):
    sql = "copy public.products (product_id, product_name, description, price, category_id) FROM '/Users/aaronchen/eng-intern-assessment-data/data/product_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_orders(cur, conn):
    sql = "copy public.orders (order_id, user_id, order_date, total_amount) FROM '/Users/aaronchen/eng-intern-assessment-data/data/order_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_payments(cur, conn):
    sql = "copy public.payments (payment_id, order_id, payment_date, payment_method, amount) FROM '/Users/aaronchen/eng-intern-assessment-data/data/payment_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_shipping(cur, conn):
    sql = "copy public.shipping (shipping_id, order_id, shipping_date, shipping_address, tracking_number) FROM '/Users/aaronchen/eng-intern-assessment-data/data/shipping_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_order_items(cur, conn):
    sql = "copy public.order_items (order_item_id, order_id, product_id, quantity, unit_price) FROM '/Users/aaronchen/eng-intern-assessment-data/data/order_items_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_cart_items(cur, conn):
    sql = "copy public.cart_items (cart_item_id, cart_id, product_id, quantity) FROM '/Users/aaronchen/eng-intern-assessment-data/data/cart_item_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_reviews(cur, conn):
    sql = "copy public.reviews (review_id, user_id, product_id, rating, review_text, review_date) FROM '/Users/aaronchen/eng-intern-assessment-data/data/review_data.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '\"' ESCAPE '''';"
    cur.execute(sql)
    conn.commit()

def add_all_data(cur, conn):
    add_users(cur, conn)
    add_carts(cur, conn)
    add_categories(cur, conn)
    add_products(cur, conn)
    add_orders(cur, conn)
    add_payments(cur, conn)
    add_shipping(cur, conn)
    add_order_items(cur, conn)
    add_cart_items(cur, conn)
    add_reviews(cur, conn)

cur, conn = get_connection()

create_tables(cur, conn)
add_all_data(cur, conn)

cur.close()
conn.close()
