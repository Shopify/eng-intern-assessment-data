import psycopg2


def main():
    conn = psycopg2.connect(
        dbname="shopifyOA",
        user="shopify",
        password="1234",
        host="localhost",
        port="5432",
    )
    cur = conn.cursor()

    with open("./sql/schema.sql", "r") as file:
        sql_query = file.read()

    cur.execute(sql_query)
    conn.commit()
    
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
