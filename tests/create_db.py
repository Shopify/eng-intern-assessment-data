import psycopg2
import csv

conn = psycopg2.connect(
            dbname='shopify',
            user='postgres',
            password='PostgreSQL_2003',
            host='localhost',
            port='5432'
)

cur = conn.cursor()

# Insert 'category_data.csv' data into Categories table of Database
csv_file_path = './data/category_data.csv'

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    # Skip header row
    next(csv_reader)  

    for row in csv_reader:
        insert_query = """
        INSERT INTO Categories (category_id, category_name)
        VALUES (%s, %s);
        """
        cur.execute(insert_query, (int(row[0]), row[1]))
        
conn.commit()

# Insert 'product_data.csv' data into Products table of Database
csv_file_path = './data/product_data.csv'

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    # Skip header row
    next(csv_reader)  

    for row in csv_reader:
        insert_query = """
        INSERT INTO Products (product_id, product_name, description, price, category_id)
        VALUES (%s, %s, %s, %s, %s);
        """
        cur.execute(insert_query, (int(row[0]), row[1], row[2], float(row[3]), int(row[4])))

conn.commit()

# Insert 'user_data.csv' data into Users table of Database
csv_file_path = './data/user_data.csv'

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    # Skip header row
    next(csv_reader)  

    for row in csv_reader:
        insert_query = """
        INSERT INTO Users (user_id, username, email, password, address, phone_number)
        VALUES (%s, %s, %s, %s, %s, %s);
        """
        cur.execute(insert_query, (int(row[0]), row[1], row[2], row[3], row[4], row[5]))

conn.commit()

# Insert 'order_data.csv' data into Orders table of Database
csv_file_path = './data/order_data.csv'

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    # Skip header row
    next(csv_reader)  

    for row in csv_reader:
        insert_query = """
        INSERT INTO Orders (order_id, user_id, order_date, total_amount)
        VALUES (%s, %s, %s, %s);
        """
        cur.execute(insert_query, (int(row[0]), int(row[1]), row[2], float(row[3])))

conn.commit()

# Insert 'order_items_data.csv' data into Order_Items table of Database
csv_file_path = './data/order_items_data.csv'

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    # Skip header row
    next(csv_reader)  

    for row in csv_reader:
        product_id = int(row[2])
        # Check if the product_id exists in the Products table
        check_query = "SELECT COUNT(*) FROM Products WHERE product_id = %s;"
        cur.execute(check_query, (product_id,))
        count = cur.fetchone()[0]
        
        # If product_id does not exist in the Product table, do not insert
        if count == 0:
            print(f"Product with product_id {product_id} does not exist. Skipping insertion for this row.")
            continue
        
        # If product_id exists in the Product table, insert
        insert_query = """
        INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, unit_price)
        VALUES (%s, %s, %s, %s, %s);
        """
        cur.execute(insert_query, (int(row[0]), int(row[1]), int(row[2]), int(row[3]), float(row[4])))

conn.commit()

# Insert 'review_data.csv' data into Reviews table of Database
csv_file_path = './data/review_data.csv'

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    # Skip header row
    next(csv_reader)  

    for row in csv_reader:
        product_id = int(row[2])
        # Check if the product_id exists in the Products table
        check_query = "SELECT COUNT(*) FROM Products WHERE product_id = %s;"
        cur.execute(check_query, (product_id,))
        count = cur.fetchone()[0]
        
        # If product_id does not exist in the Products table, do not insert
        if count == 0:
            print(f"Product with product_id {product_id} does not exist. Skipping insertion for this row.")
            continue
        
        # If product_id exists in the Products table, insert
        insert_query = """
        INSERT INTO Reviews (review_id, user_id, product_id, rating, review_text, review_date)
        VALUES (%s, %s, %s, %s, %s, %s);
        """
        cur.execute(insert_query, (int(row[0]), int(row[1]), int(row[2]), int(row[3]), row[4], row[5]))

conn.commit()

conn.close()

