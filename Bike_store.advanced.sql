drop table if exists brands;

create table  brands ( brand_id varchar (50) primary key,
brand_name varchar(100));

drop  table if exists categories;

create table categories(category_id varchar (50) primary key,
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

create table order_items (order_id varchar(20),
item_id int ,product_id varchar (30),
quantity numeric, list_price decimal(5,2), discount decimal(5,2),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products (product_id));

select * from orders;


--------------------------
SQL advanced project Questions--



1. Find the total number of orders per store?

select store_id , count(order_id) as total_orders
from orders group by store_id;


2. Find total revenue per store

SELECT store_id, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.store_id;

SELECT * from orders;
SELECT * from order_items;

drop table order_items;

create table order_items (order_id varchar(20), item_id int primary key,
product_id varchar (20) , quantity numeric, list_price decimal (10,2),
discount decimal (5,2), foreign  key (order_id) references 
orders(order_id), foreign key (product_id) references products(product_id));

alter table order_items drop constraint order_items_pkey ;

select * from orders;


INSERT INTO orders (order_id, customer_id, order_status, order_date, required_date,
shipped_date,store_id, staff_id)
VALUES (407, 77, 4, 30-08-2016
, 02-09-2016
, 01-09-2016,2,7
);

ALTER TABLE orders
ALTER COLUMN shipped_date TYPE varchar USING order_id::int;

select * from order_items;

INSERT INTO orders (order_id, customer_id, order_status, order_date, required_date,
shipped_date,store_id, staff_id)
VALUES (582, 32, 3, 04-12-2016
,04-12-2016
, 07-12-2016, 1,2
);


3. Get top 5 products by revenue

select p.product_name, sum(oi.quantity*oi.list_price*(1-oi.discount))
as total_revenue from order_items oi join products p on
oi.product_id = p.product_id group by p.product_name
order by total_revenue desc limit 5;


4. Find average order value per customer?

select c.customer_id,c.first_name,c.last_name,
avg(oi.quantity*oi.list_price *(1-oi.discount)) as
avg_order_value from customers c 
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id= oi.order_id
group by c.customer_id,c.first_name,c.last_name
order by avg_order_value desc limit 10;


5. Rank stores by total sales using a window function


select store_id, sum(oi.quantity*oi.list_price *(1-oi.discount))
as total_sales , rank() over (order by sum(oi.quantity*oi.list_price *(1-oi.discount))desc)
as sales_rank from orders o join order_items oi on o.order_id = oi.order_id
group by store_id;


6. Find cumulative revenue by order date

select order_date ,sum(oi.quantity*oi.list_price *(1-oi.discount))
as daily_revenue, sum(sum(oi.quantity*oi.list_price *(1-oi.discount)))
over (order by order_date) as cumulative_revenue
from orders o
join order_items oi on o.order_id = oi.order_id 
group by order_date
order by order_date;


7.  Find top 3 products per category by sales

select category_id,product_name, total_sales , rank_in_category
from
(select p.product_name, p.category_id ,
sum(oi.quantity*oi.list_price *(1-oi.discount))
as total_sales ,
rank() over (partition by p.category_id order 
by sum(oi.quantity*oi.list_price *(1-oi.discount)) desc) as rank_in_category 
from products p
join order_items oi  on p.product_id = oi.product_id
group by p.category_id , p.product_name) ranked where
rank_in_category <=3;


8. Calculate average discount per brand?

select b.brand_name, ROUND(avg(oi.discount),2) as avg_discounts
from brands b
join products p on b.brand_id=p.brand_id
join order_items oi on p.product_id = oi.product_id
group by b.brand_name;


9. Find customers who placed more than 2 orders

select c.customer_id,c.first_name,c.last_name, count(o.order_id) as order_count
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.first_name,c.last_name having count (o.order_id) >2;

10.  Get the latest order for each customer

select customer_id , max(order_date) as last_order_date 
from orders
group by customer_id;

11. Find product sales contribution percentage

select p.product_name, sum((oi.quantity * oi.list_price * (1 - oi.discount)))
as product_sales,
round(100*sum(oi.quantity * oi.list_price * (1 - oi.discount))
/sum(sum(oi.quantity * oi.list_price * (1 - oi.discount))) over(),2)
as percent_contribution
from order_items oi
join products p on oi.product_id=p.product_id
group by product_name;


12. Find average quantity ordered per staff

 select s.staff_id, s.first_name, s.last_name,
 avg(quantity) as avg_qty from staffs s 
 join orders o on s.staff_id = o.staff_id
 join order_items oi on o.order_id = oi.order_id
 group by s.staff_id, s.first_name, s.last_name;


 13. Find difference between highest and lowest product price

 select max(list_price) - min(list_price) as price_range
 from products;


 14. Rank customers by total spend

 select c.customer_id,c.first_name,c.last_name,
 sum(oi.quantity * oi.list_price * (1 - oi.discount))
 as total_spent ,
 dense_rank() over (order by sum(oi.quantity * oi.list_price * (1 - oi.discount))
 desc) as spending_rank
 from customers c
 join orders o on c.customer_id = o.customer_id
 join order_items oi on o.order_id = oi.order_id
 group by c.customer_id,c.first_name,c.last_name;


 15. Find staff with the highest average order value

 select s.staff_id,s.first_name,s.last_name,
 avg(oi.quantity * oi.list_price * (1 - oi.discount)) as
 order_value
 from staffs s
 join orders o on s.staff_id = o.staff_id
 join order_items oi on o.order_id= oi.order_id
 group by s.staff_id,s.first_name,s.last_name
 order by order_value desc;


 16. Find top customer in each store

 select store_id, customer_id , total_spent
 from ( select o.store_id, c.customer_id, sum 
 (oi.quantity * oi.list_price * (1 - oi.discount)) as total_spent,
 row_number() over (partition by o.store_id order by sum 
 (oi.quantity * oi.list_price * (1 - oi.discount)) desc) as rn
 from customers c
 join orders o on c.customer_id = o.customer_id
 join order_items oi on o.order_id = oi.order_id
 group by o.store_id, c.customer_id )
 ranked where rn=1;



 17. Calculate moving average of daily sales (7-day)


 select o.order_date, c))
 as daily_sales, avg(sum(oi.quantity * oi.list_price * (1 - oi.discount)))
 over (order by order_date rows between 6 preceding and current row) as 
 moving_average from orders o
 join order_items oi on o.order_id = oi.order_id
 group by order_date
 order by order_date;



 18. Find number of customers per store

 SELECT o.store_id, count(distinct customer_id) as unique_customers
 from orders o
 group by o.store_id;



19. Find most popular brand by quantity sold?

 select b.brand_name, sum(oi.quantity)
 as quantity_sold from brands b 
 join products p on b.brand_id = p.brand_id
 join order_items oi on p.product_id = oi.product_id
 group by brand_name
 order by quantity_sold desc;



 20. Display top 5 customers by number of items purchased

 select c.customer_id,  c.first_name, c.last_name, sum(oi.quantity)
 as total_items_purchased from customers c
 join orders o on c.customer_id = o.customer_id
 join order_items oi on o.order_id = oi.order_id
 group by c.customer_id,  c.first_name, c.last_name
 order by total_items_purchased desc;


 21.  Find orders with more than 3 items

 select order_id , count(product_id) as item_count
 from order_items 
 group by order_id
 having count(product_id) > 3;



 22. Find repeat customers

 select customer_id
 from orders 
 group by customer_id
 having count(order_id) >1; 



 23.  Use CASE to classify order size

 select order_id, sum(quantity) as total_quantity,
 case 
 when sum(quantity) <=2 then 'small'
 when sum(quantity) between 3 and 5 then 'medium'
 else 'large'
 end as order_size
 from order_items
 group by order_id;


 24. Identify duplicate customer emails


 select email, count(*) as occurence
 from customers
 group by email  
 having count(*) >1;


 25. Show order count and percentage per staff 


 select s.staff_id,s.first_name,s.last_name,
 count(o.order_id) as order_count,
 round (100.0*count(o.order_id)/sum(count(o.order_id)) over(),2)
 as percentage
 from staffs s
 join orders o on s.staff_id=o.staff_id
group by s.staff_id,s.first_name,s.last_name ;



26. Find products with sales higher than the average of all products


SELECT p.product_name,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS product_sales
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >
       (SELECT AVG(sub.sales) 
        FROM (
          SELECT SUM(oi2.quantity * oi2.list_price * (1 - oi2.discount)) AS sales
          FROM order_items oi2
          JOIN products p2 ON oi2.product_id = p2.product_id
          GROUP BY p2.product_id
        ) sub);
		


27. Find each store’s best-selling category 

  select store_id,category_id,total_sales,rnk
  from
  (select o.store_id,p.category_id,SUM
  (oi.quantity * oi.list_price * (1 - oi.discount))
  as total_sales, rank () over (partition by o.store_id order by
  SUM(oi.quantity * oi.list_price * (1 - oi.discount)) desc) as
  rnk 
  from orders o
  join order_items oi on o.order_id = oi.order_id
  join products p on oi.product_id = p.product_id
  group by o.store_id,p.category_id ) ranked
  where rnk  = 1;
  


28. Find staff with revenue above their store’s average

select store_id, staff_id , staff_sales 
from
(select o.store_id, s.staff_id,SUM
  (oi.quantity * oi.list_price * (1 - oi.discount)) as staff_sales,
 avg (SUM(oi.quantity * oi.list_price * (1 - oi.discount)))
 over (order by SUM
  (oi.quantity * oi.list_price * (1 - oi.discount))) as average
  from staffs s
  join orders o on s.staff_id = o.staff_id
  join order_items oi on o.order_id = oi.order_id
  group by o.store_id, s.staff_id) sub
 where staff_sales > average;


29. Calculate store performance percentile

 select store_id, sum(oi.quantity * oi.list_price * (1 - oi.discount))
 as total_sale,
 percent_rank() over (order by sum(oi.quantity * oi.list_price * (1 - oi.discount)))
 as sales_percentile from orders o
 join order_items oi on o.order_id = oi.order_id
 group by store_id;

30. Find top 2 brands in each category by quantity

 select category_id, brand_name, total_qty
 from
 (select p.category_id, b.brand_name, sum(oi.quantity)
 as total_qty, rank() over (partition by category_id 
 order by sum(oi.quantity)) as rnk 
 from products p
 join brands b on p.brand_id = b.brand_id
 join order_items oi on p.product_id = oi.product_id
 group by p.category_id, b.brand_name
 order by total_qty desc)
  ranked
  where rnk >=2;

 



31.Find category with most products

select c.category_name , count(p.product_id) as 
total_products from categories c
join products p on c.category_id = p.category_id
group by c.category_name
order by total_products desc
limit 2;


32. Find percentage of discounted sales vs full-price sales

 select 
 case when discount>0 then 'discounted ' else 'full_price'
 end as sale_type,
 round(100.0*SUM(quantity * list_price * (1 - discount))/
 sum(SUM(quantity * list_price * (1 - discount))) over(),2)
 as percentsales from order_items
 group by sale_type;


33. Identify best-selling product per brand

select brand_name,product_name, total_sales
from
(select b.brand_name, p.product_name,
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_sales,
row_number() over (partition by b.brand_name order by
SUM(oi.quantity * oi.list_price * (1 - oi.discount))desc) as rn
from brands b
join products  p on b.brand_id = p.brand_id
join order_items oi on p.product_id = oi.product_id
group by b.brand_name, p.product_name
order by total_sales desc
) ranked 
where rn=1;


34. Find highest-priced product per category

select category_id,product_name,list_price 
from
(select category_id,product_name,list_price,
rank()over (partition by category_id order by list_price )
as rn 
from products
order by list_price desc
)ranked
where rn = 1;



35. Count of distinct brands sold by each store

select o.store_id, count(distinct p.brand_id) as
total_distincts from orders o
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by o.store_id;




 
 
 


































