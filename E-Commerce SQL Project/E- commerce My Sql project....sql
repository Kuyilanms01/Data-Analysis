create database e_commerce;
USE e_commerce;
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address TEXT,
    phone_number VARCHAR(20),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO Customers (customer_id, first_name, last_name, email, address, phone_number)
VALUES (1,'John', 'Doe', 'john.doe@example.com', '1234 Elm Street, Springfield', '555-1234');
INSERT INTO Customers (customer_id ,first_name, last_name, email, address, phone_number)
VALUES (2,'Jane', 'Smith', 'jane.smith@example.com', '5678 Oak Avenue, Springfield', '555-5678');
INSERT INTO Customers (customer_id ,first_name, last_name, email, address, phone_number)
VALUES (3,'Emily', 'Johnson', 'emily.johnson@example.com', '9101 Maple Road, Shelbyville', '555-9101');
INSERT INTO Customers (customer_id ,first_name, last_name, email, address, phone_number)
VALUES (4,'Michael', 'Brown', 'michael.brown@example.com', '3456 Pine Street, Capital City', '555-3456');
select * from customers;

 

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);
INSERT INTO Products (product_id ,product_name, category, price, stock_quantity)
VALUES (10,'Laptop', 'Electronics', 799.99, 50);
INSERT INTO Products (product_id ,product_name, category, price, stock_quantity)
VALUES (20,'T-Shirt', 'Apparel', 19.99, 200);
INSERT INTO Products (product_id, product_name, category, price, stock_quantity)
VALUES (30,'Smartphone', 'Electronics', 499.99, 150);
INSERT INTO Products (product_id, product_name, category, price, stock_quantity)
VALUES  (40,'Coffee Maker', 'Appliances', 89.99, 80);
select * from Products;


CREATE TABLE Orders (
    order_id INT  PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Orders (order_id, customer_id, total_amount, shipping_address)
VALUES (1101,1, 839.97, '1234 Elm Street, Springfield, IL');
INSERT INTO Orders (order_id, customer_id, total_amount, shipping_address)
VALUES (1113,2, 499.99, '5678 Oak Avenue, Springfield, IL');
INSERT INTO Orders (order_id ,customer_id, total_amount, shipping_address)
VALUES(1145,3, 589.98, '9101 Maple Road, Shelbyville, IL');
INSERT INTO Orders (order_id, customer_id, total_amount, shipping_address)
VALUES(1146,4, 889.98, '3456 Pine Street, Capital City, IL');
select * from orders;


CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1101, 10, 1, 799.99),(1101, 20, 2, 19.99);
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1113, 30, 1, 499.99);
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1145, 30, 1, 499.99), (1145, 40, 1, 89.99);
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1146, 10, 1, 799.99), (1146, 40, 1, 89.99); 
select * from order_items;


CREATE TABLE Payments (
    payment_id INT  PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Payments (payment_id, order_id, payment_method, payment_date, payment_amount)
VALUES (2306,1101, 'Credit Card', '2025-03-01 10:00:00', 839.97);
INSERT INTO Payments (payment_id, order_id, payment_method, payment_date, payment_amount)
VALUES (2408,1113, 'PayPal', '2025-03-01 12:30:00', 499.99);
INSERT INTO Payments (payment_id, order_id, payment_method, payment_date, payment_amount)
VALUES (6369,1145, 'Debit Card', '2025-03-02 15:00:00', 589.98);
INSERT INTO Payments (payment_id, order_id, payment_method, payment_date, payment_amount)
VALUES (2406,1146, 'Credit Card', '2025-03-03 14:45:00', 889.98);
select * from Payments;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Total Sales by Product Category #
 
 SELECT p.category, SUM(oi.quantity * oi.price) AS total_sales
FROM order_items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.category;

# Find the Number of Orders Placed by Each Customer #
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS number_of_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

# Find Products with Low Stock (Below 50 Units) #
SELECT product_name, stock_quantity
FROM Products
WHERE stock_quantity < 50;


# Get the Average Order Value for Each Customer #
SELECT c.first_name, c.last_name, AVG(o.total_amount) AS avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

# Get the Products That Have Been Ordered the Most #
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;


# Get the Total Payment Amount by Payment Method # 
SELECT payment_method, SUM(payment_amount) AS total_payment_amount
FROM Payments
GROUP BY payment_method;


# Get All Orders with Customer Details (INNER JOIN)# 
Select o.order_id, c.first_name, c.last_name, o.total_amount, o.order_date
From Orders o
Join Customers c ON o.customer_id = c.customer_id;

# Query to Get Top 2 Highest Payments with customer Details# 
SELECT p.payment_id, p.order_id, p.payment_method, p.payment_date, p.payment_amount,
       c.first_name, c.last_name, c.email
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
ORDER BY p.payment_amount DESC
LIMIT 2;

#Find the Customers Who Have Made the Most Expensive Order#
SELECT c.first_name, c.last_name, o.total_amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.total_amount = (
    SELECT MAX(total_amount)
    FROM Orders
);






