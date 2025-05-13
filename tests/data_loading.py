import psycopg2

class Import_Data():

    def setUp(self):
        # Establish a connection to your test database
        self.conn = psycopg2.connect(
            dbname='your_dbname',
            user='your_username',
            password='your_password',
            host='your_host',
            port='your_port'
        )
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Close the database connection
        self.cur.close()
        self.conn.close()

    def display_tables(self):
        # Execute SQL query to get all table names
        self.cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")

        # Fetch all the table names
        tables = self.cur.fetchall()

        # Print the table names
        for table in tables:
            print(table[0])

    def create_table_from_file(self, file_path):
        # Read the contents of the SQL file
        with open(file_path, 'r') as file:
            sql_statements = file.read()

        # Execute the SQL statements
        self.cur.execute(sql_statements)
        self.conn.commit()

    def delete_all_tables(self):
        # Execute SQL query to get all table names
        self.cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")

        # Fetch all the table names
        tables = self.cur.fetchall()

        # Drop each table
        for table in tables:
            self.cur.execute(f"DROP TABLE {table[0]} CASCADE")
            # print(f"Deleted table {table[0]}")

        self.conn.commit()

    def import_data_from_csv(self, file_path, table_name):
        # Open the CSV file
        with open(file_path, 'r') as file:
            # Skip the header row
            next(file)
            
            # Iterate over each line in the CSV file
            for line in file:
                # Split the line into values
                values = line.strip().split(',')
                
                # Generate the SQL INSERT statement
                sql = f"INSERT INTO {table_name} VALUES ({','.join(['%s'] * len(values))})"
                
                # Execute the SQL statement with the values
                self.cur.execute(sql, values)
        
        self.conn.commit()
    
    #display table contents
    def display_table_contents(self, table_name):
        # Execute SQL query to get all table names
        self.cur.execute(f"SELECT * FROM {table_name}")

        # Fetch all the table names
        tables = self.cur.fetchall()

        # Print the table names
        for table in tables:
            print(table)
                #insert data into table
            
    def insert_data_into_table(self, table_name, data):
        # Execute SQL query to get all table names
        self.cur.execute(f"INSERT INTO {table_name} VALUES ({','.join(['%s'] * len(data))})", data)
        self.conn.commit()    


    def test_task(self, file_path):
        # Task 1: Example SQL query in task1.sql
        with open(file_path, 'r') as file:
            sql_query = file.read()

        sql_query = '\n'.join(line for line in sql_query.split('\n') if line.strip() and not line.strip().startswith('--'))
        # print(sql_query)

        querys = sql_query.split(';')
        for query in querys:
            if query:
                self.cur.execute(query)
                result = self.cur.fetchall()
                print(result)
                print('\n')
    

def main():    
    Import_data = Import_Data()
    Import_data.setUp()    
    Import_data.delete_all_tables()
    Import_data.create_table_from_file('\sql\schema.sql')   

    Import_data.import_data_from_csv('\sql\category_data.csv', 'Categories')
    Import_data.import_data_from_csv('\sql\product_data.csv', 'Products')

    # Insert missing data into Products table
    for i in range (17,37):
        Import_data.insert_data_into_table('Products', (str(i), None, None, None, None))
    
    # Import_data.display_table_contents('Products')

    Import_data.import_data_from_csv('\sql\user_data.csv', 'Users')
    Import_data.import_data_from_csv('\sql\order_data.csv', 'Orders')
    Import_data.import_data_from_csv('\sql\order_items_data.csv', 'Order_Items')
    Import_data.import_data_from_csv('\sql\review_data.csv', 'Reviews')
    Import_data.import_data_from_csv('\sql\cart_data.csv', 'Cart')
    Import_data.import_data_from_csv('\sql\cart_item_data.csv', 'Cart_items')
    Import_data.import_data_from_csv('\sql\payment_data.csv', 'Payments')
    Import_data.import_data_from_csv('\sql\shipping_data.csv', 'Shipping')

    #Import_data.test_task('\sql\task3.sql')
    Import_data.tearDown()

if __name__ == '__main__':
    main()
