create database sql_project ;

use sql_project ;

create table category (
	category_id int primary key ,
    category_name varchar (30) 
);
desc category;
create table product (
	product_id int primary key ,
    product_name varchar (255),
    price int,
    stock_quantity int,
    category_id int,
    FOREIGN KEY(category_id)REFERENCES category (category_id)
    );
create table customer (
	customer_id int primary key ,
    customer_name varchar(20),
    email varchar(30) 
);
create table Orders (
	orders_id int primary key ,
	order_date DATE,
    customer_id int ,
    foreign key(customer_id) references customer (customer_id) 
);

use sql_project ;

create table order_details(
	details_id int primary key,
    quantity int ,
    orders_id int ,
	product_id int,
    foreign key (orders_id)  references Orders (orders_id) ,
    foreign key (product_id) references product(product_id) 
    );
create table reviews(
	review_id int primary key ,
    rating int ,
    comments varchar(500) ,
	product_id int  ,
	customer_id  int ,
	foreign key (product_id) references product (product_id),
    foreign key (customer_id)  references customer (customer_id) 
);
create table shipping (
	shipping_id int primary key ,
	shipdate DATE ,
    deliverydate DATE, 
    orders_id int ,
    foreign key (orders_id) references Orders(orders_id)
);
create table discount (
	discount_id int primary key ,
	discount_amount int,
    product_id int ,
    foreign key (product_id) references product (product_id)
);
create table coupons (
	coupon_id  int primary key ,
    discount_amount int 
);



insert into category (category_id,category_name)
values (1,'kurti'),
(2,'top'),
(3,'jeans'),
(4,'saree'),
(5,'sweaters');

insert into product (product_id,product_name,price,stock_quantity,category_id)
values (7438,'anarkali',50000,100,1),
(9004,'crop top',72000,52,2),
(8108,'cargo',120000,211,3),
(9967,'paithani',3300,100,4),
(8010,'hoodie',150,500,5);


insert into customer (customer_id,customer_name,email)
values (7891,'ruby','ruby890@gmail.com'),
(2424,'max','maxmin234@gmail.com'),
(3456,'fake','fakejake@gmail.com'),
(9874,'jake','jakefake@gmail.com'),
(4353,'jordan','michealjordan@gmail.com');

insert into orders (orders_id,order_date,customer_id)
values (1234, '2006-08-17',7891),
(5678,'2005-07-28',2424),
(9012,'2008-08-14',3456),
(6854,'2012-04-16',9874),
(4332,'2003-01-31',4353);
 
 insert into order_details(details_id ,quantity,orders_id,product_id)
 values (1467,10,1234,7438),
 (3040,20,5678,9004),
 (3333,5,9012,8108),
 (4444,8,6854,9967),
 (7744,7,4332,8010);

insert into reviews (review_id,rating ,comments,product_id,customer_id)
values(1001,4,'fabolus product',7438,7891),
(1002,3,'money utilized',9004,2424),
(1003,5,'very food working nicely',8108,3456),
(1004,2,'money wasted',9967,9874),
(1005,5,'nice product satisfied',8010,4353);

insert into shipping (shipping_id,shipdate,deliverydate ,orders_id)
values(2001,'2024-06-02','2024-06-12',1234),
(2002,'2024-06-04','2024-06-14',5678),
(2003,'2023-04-28','2023-05-02',9012),
(2004,'2023-05-24','2023-05-28',6854),
(2005,'2024-03-12','2024-03-18',4332);


insert into discount (discount_id,discount_amount,product_id)
values (3001,3000,7438),
(3002,450,9004),
(3003,2000,8108),
(3004,500,9967),
(3005,100,8010);

insert into coupons(coupon_id,discount_amount)
values (4001,3000),
(4002,450),
(4003,2000),
(4004,500),
(4005,100);
 
 
 /* requirement 1 */
 SELECT MONTH(order_date) AS month, COUNT(*) AS sales_count
FROM Orders
GROUP BY month
ORDER BY sales_count DESC
LIMIT 1;

/* requirement 2 */
SELECT YEAR(order_date) AS year, COUNT(*) AS sales_count
FROM Orders
GROUP BY year
ORDER BY year;

/* requirement 3 */
SELECT customer_id, COUNT(*) AS order_count
FROM Orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 1;

/* requirement 4 */
SELECT product_id, SUM(quantity) AS total_sold
FROM order_details
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 1;
  
/* requirement 5 */
SELECT c.category_id, c.category_name, COUNT(o.customer_id) AS customer_count
FROM category c
JOIN product p ON c.category_id = p.category_id
LEFT JOIN order_details od ON p.product_id = od.product_id
LEFT JOIN Orders o ON od.orders_id = o.orders_id
GROUP BY c.category_id
ORDER BY customer_count DESC
LIMIT 1;

/* requirement 6*/
SELECT od.product_id, SUM(od.quantity) AS total_quantity
FROM Orders o
JOIN order_details od ON o.orders_id = od.orders_id
WHERE MONTH(o.order_date) = 6  -- Replace '6' with the desired month number
GROUP BY od.product_id
ORDER BY total_quantity DESC
LIMIT 1;
   
/* requirement 7*/
SELECT c.category_id, c.category_name, SUM(od.quantity) AS total_quantity
FROM category c
JOIN product p ON c.category_id = p.category_id
JOIN order_details od ON p.product_id = od.product_id
JOIN Orders o ON od.orders_id = o.orders_id
WHERE MONTH(o.order_date) = 6  -- you can change the month if you want 
GROUP BY c.category_id
ORDER BY total_quantity DESC
LIMIT 1;

/* requirement 8*/
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM order_details
GROUP BY product_id;

/* requirement 9*/
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM order_details
GROUP BY product_id
HAVING total_quantity_sold < 120;

/* requirement 10*/
SELECT product_id, product_name, stock_quantity
FROM product
WHERE stock_quantity > 0;

/* requirement 11*/
SELECT product_id, product_name, stock_quantity
FROM product
WHERE stock_quantity <= 0;

/* requirement 12*/
SELECT *
FROM Orders
WHERE orders_id NOT IN (SELECT orders_id FROM shipping);

/* requirement 13*/
SELECT *
FROM Orders
WHERE orders_id NOT IN (SELECT orders_id FROM shipping WHERE shipdate IS NOT NULL);



/* requirement 15*/
SELECT p.product_id, p.product_name, SUM(od.quantity * p.price) AS total_revenue
FROM product p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 1;

/* requirement 16*/
SELECT c.category_id, c.category_name, SUM(od.quantity * p.price) AS total_revenue
FROM category c
JOIN product p ON c.category_id = p.category_id
JOIN order_details od ON p.product_id = od.product_id
GROUP BY c.category_id
ORDER BY total_revenue DESC
LIMIT 1;

/* requirement 17*/


/* requirement 18*/
SELECT product_id, product_name, price
FROM product;

/* requirement 19*/
SELECT p.product_id, p.product_name, COUNT(r.review_id) AS review_count
FROM product p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
ORDER BY review_count DESC;
 
/* requirement 20*/
SELECT c.customer_id, c.customer_name
FROM customer c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.orders_id = od.orders_id
INNER JOIN product p ON od.product_id = p.product_id
INNER JOIN discount d ON p.product_id = d.product_id
WHERE d.discount_amount = 200;

/* requirement 21*/
SELECT MAX(price) AS max_price
FROM product;


/* requirement 22*/-- here i am assuming that good review means 4 or 5 stars
SELECT p.product_id, p.product_name
FROM product p
INNER JOIN reviews r ON p.product_id = r.product_id
WHERE r.rating >= 4;

/* requirement 23*/
SELECT MAX(stock_quantity) AS max_stock_quantity
FROM product;


/* requirement 24*/
SELECT *
FROM orders o
INNER JOIN shipping s ON o.orders_id = s.orders_id
WHERE s.deliverydate = '2024-06-12';

/* requirement 25*/
SELECT c.customer_id, c.customer_name, COUNT(o.orders_id) AS num_orders
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY num_orders DESC
LIMIT 1;

/* requirement 26*/
SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_units_sold
FROM product p
INNER JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_units_sold DESC
LIMIT 1;

/* requirement 27*/
SELECT c.customer_id, c.customer_name
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.orders_id IS NULL;

/* requirement 28*/
SELECT p.product_id, p.product_name, d.discount_amount
FROM product p
LEFT JOIN discount d ON p.product_id = d.product_id;

/* requirement 29*/
SELECT c.customer_id, c.customer_name, SUM(d.discount_amount) AS total_discount_amount
FROM customer c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.orders_id = od.orders_id
INNER JOIN discount d ON od.product_id = d.product_id
GROUP BY c.customer_id, c.customer_name;

/* requirement 30*/
SELECT p.product_id, p.product_name
FROM product p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN orders o ON od.orders_id = o.orders_id
INNER JOIN shipping s ON o.orders_id = s.orders_id
WHERE s.deliverydate BETWEEN '2024-01-25' AND '2024-02-20';

