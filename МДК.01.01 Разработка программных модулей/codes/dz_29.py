import mysql.connector

conn = mysql.connector.connect(
    host="127.0.0.1",
    port=3306,
    user="root",
    password=""
)
cursor = conn.cursor()

cursor.execute("CREATE DATABASE IF NOT EXISTS testdb")
cursor.execute("USE testdb")

cursor.execute("""
    CREATE TABLE IF NOT EXISTS categories (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    )
""")
conn.commit()

cursor.execute("SELECT * FROM categories")
print(cursor.fetchall())

cursor.execute("INSERT INTO categories (name) VALUES (%s)", ("Новая категория",))
conn.commit()
print(cursor.lastrowid)

cursor.execute("UPDATE categories SET name = %s WHERE id = %s", ("Обновлённая категория", 1))
conn.commit()
print(cursor.rowcount)

cursor.execute("DELETE FROM categories WHERE id = %s", (2,))
conn.commit()
print(cursor.rowcount)

cursor.execute("SELECT * FROM categories")
print(cursor.fetchall())

cursor.close()
conn.close()