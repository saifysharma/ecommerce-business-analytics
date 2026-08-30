CREATE DATABASE Ecommerce_Analysis;
USE Ecommerce_Analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    country CHAR(2) NOT NULL,
    age INT CHECK (age >= 0),
    signup_date DATE,
    marketing_opt_in BOOLEAN NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    price_usd DECIMAL(10,2) NOT NULL,
    cost_usd DECIMAL(10,2) NOT NULL,
    margin_usd DECIMAL(10,2) NOT NULL
);

CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    device VARCHAR(20) NOT NULL,
    source VARCHAR(30) NOT NULL,
    country CHAR(2) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_time DATETIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    discount_pct INT NOT NULL,
    subtotal_usd DECIMAL(10,2) NOT NULL,
    total_usd DECIMAL(10,2) NOT NULL,
    country CHAR(2) NOT NULL,
    device VARCHAR(20) NOT NULL,
    source VARCHAR(30) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    unit_price_usd DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    line_total_usd DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


CREATE TABLE events (
    event_id INT PRIMARY KEY,
    session_id INT NOT NULL,
    timestamp DATETIME NOT NULL,
    event_type VARCHAR(30) NOT NULL,
    product_id INT,
    qty INT,
    cart_size INT,
    payment VARCHAR(30),
    discount_pct INT,
    amount_usd DECIMAL(10,2),

    FOREIGN KEY (session_id)
        REFERENCES sessions(session_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_time DATETIME NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

select * from customers;
select * from products;
select * from sessions;
select * from orders;
select * from events;
select * from reviews;
select * from order_items;
