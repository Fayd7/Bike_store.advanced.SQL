drop table if exists brands;

CREATE TABLE brands ( brand_id varchar (50) primary key,
brand_name varchar(100));

drop  table if exists categories;

CREATE TABLE categories(category_id varchar (50) primary key,
category_name varchar (100));

drop table if exists products;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT REFERENCES brands(brand_id) ON DELETE CASCADE,
    category_id INT REFERENCES categories(category_id) ON DELETE CASCADE,
    model_year INT CHECK (model_year >= 2000),
    list_price NUMERIC(10,2) NOT NULL CHECK (list_price > 0)
);

CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(10)
);

CREATE TABLE staffs (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    active BOOLEAN DEFAULT TRUE,
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    manager_id INT REFERENCES staffs(staff_id)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(10)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_status SMALLINT CHECK (order_status BETWEEN 1 AND 5),
    order_date DATE NOT NULL,
    required_date DATE,
    shipped_date DATE,
    store_id INT REFERENCES stores(store_id) ON DELETE CASCADE,
    staff_id INT REFERENCES staffs(staff_id) ON DELETE SET NULL
);

drop table order_items;

CREATE TABLE order_items (order_id varchar(20),
item_id int ,product_id varchar (30),
quantity numeric, list_price decimal(5,2), discount decimal(5,2),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products (product_id));