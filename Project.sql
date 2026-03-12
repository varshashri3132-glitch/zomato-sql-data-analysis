create database zomato;

use zomato;

alter table customers
add primary key (customer_id);

alter table restaurants
add primary key (Restaurant_id);

alter table riders
add primary key(rider_id);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_item TEXT,
    order_date TEXT NOT NULL,
    order_time TEXT NOT NULL,
    order_status TEXT,
    total_amount DOUBLE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    delivery_status TEXT,
    delivery_time TIME,
    rider_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id)
);

delete from riders where rider_id is null;

select * from orders limit 10;

alter table orders
add column order_time_new time; 

set sql_safe_updates = 0;

update orders
set order_time_new = str_to_date(order_time,"%H:%i:%s");

alter table orders
drop column order_time;

alter table orders
rename column order_time_new to order_time;

update orders
set order_date = str_to_date(order_date,"%Y-%m-%d");

alter table orders
modify column order_date date;

update customers
set reg_date = str_to_date(reg_date,"%Y-%m-%d");

alter table customers
modify column reg_date date;

update deliveries
set delivery_time = str_to_date(delivery_time,"%H:%i:%s");

alter table deliveries
modify column delivery_time time;

update riders
set sign_up = str_to_date(sign_up, "%Y-%m-%d");

alter table riders
modify column sign_up date;

select * from restaurants;

select trim(left(opening_hours,(locate("-",opening_hours)-1))) as opening_hour,
trim(substring(opening_hours,(locate("-",opening_hours)+1))) as closing_hour
from restaurants;

alter table restaurants
add column opening_hour time;

alter table restaurants
add column closing_hour time;

update restaurants
set opening_hour = str_to_date(trim(left(opening_hours,(locate("-",opening_hours)-1))),"%h:%i %p");

update restaurants
set closing_hour = str_to_date(trim(substring(opening_hours,(locate("-",opening_hours)+1))),"%h:%i %p");

select order_item, count(order_id) as No_of_times_ordered
from orders
group by order_item
order by No_of_times_ordered desc
limit 10;

select order_item, count(order_id) as No_of_times_ordered
from orders
group by order_item
order by No_of_times_ordered
limit 10;

select * from orders limit 10;

select hour(order_time), count(order_id) as No_of_orders
from orders
group by hour(order_time)
order by no_of_orders;


select customer_id, count(order_id) as Customer_order_count
from orders
group by customer_id;

SELECT * FROM CUSTOMERS;

DELIMITER //
create procedure discount_customers()
begin
select customer_id, round(avg(total_amount),2) as Customer_average_order_value
from orders
group by customer_id
having Customer_average_order_value < avg(total_amount);
END//
DELIMITER ;

CALL DISCOUNT_CUSTOMERS();

select * from restaurants;

select a.restaurant_name, count(b.order_id) as No_of_orders
from restaurants a join orders b using (restaurant_id)
group by a.restaurant_name
order by No_of_orders desc
limit 5;

select a.restaurant_name, count(b.order_id) as No_of_orders
from restaurants a join orders b using (restaurant_id)
group by a.restaurant_name
order by No_of_orders
limit 5;

select b.city, count(a.order_id) as No_of_orders,
sum(total_amount) as Total_revenue
from orders a join restaurants b using (restaurant_id)
group by b.city;


create view rankingrestaurants as
select b.city, b.restaurant_name,count(a.order_id) as Order_count,
rank() over(partition by b.city order by count(a.order_id) desc) as Ranking
from orders a join restaurants b using(restaurant_id)
group by b.city,b.restaurant_name;

select * from rankingrestaurants where ranking=1;

create view toporderitem as
select b.city, a.order_item, count(a.order_id) as Order_count,
rank() over(partition by b.city order by count(a.order_id) desc) as FoodRank
from orders a join restaurants b using(restaurant_id)
group by b.city, a.order_item;

select * from toporderitem where foodrank = 1;

select distinct order_item from orders;
select * from deliveries
where delivery_status = "delivered";

select dayname(order_date) as Order_day, count(order_id) as No_Of_Orders
from orders 
group by Order_day
order by No_Of_Orders desc;

select monthname(order_date) as Order_month, count(order_id) as No_Of_Orders
from orders 
group by Order_month
order by No_Of_Orders desc;

select day(order_date) as Order_date_of_month, count(order_id) as No_Of_Orders
from Orders
group by Order_date_of_month
order by No_of_orders desc;

with dayofmonth as
(select order_id, 
case when day(order_date) between 1 and 5 then "Firs 5 days"
     when day(order_date) between 6 and 10 then "6th to 10th"
     when day(order_date) between 11 and 15 then "11th to 15th"
     when day(order_date) between 16 and 20 then "16th to 20th"
     when day(order_date) between 21 and 25 then "21st to 25th"
     when day(order_date) between 26 and 31 then "last 5 days"
End as Order_date_of_month
from orders)
select Order_date_of_month, count(Order_id) as No_Of_orders
from dayofmonth
group by Order_date_of_month;     

select customer_id, sum(total_amount) 
from orders
group by customer_id;

select customer_id, count(order_id) 
from orders
group by customer_id;

select customer_id,
case when sum(total_amount) >= 100000 then "Gold"
     when sum(total_amount) < 100000 and sum(total_amount) >= 50000 then "Silver"
     else "Bronze"
end as Customer_Category
from orders
group by customer_id;

Select distinct year(order_date) from orders;

with growthratio as
(select year(order_date) as order_year, month(order_date) as Order_month,
count(order_id) as No_Of_Orders,
round((count(order_id)/lag(count(Order_id)) over(order by year(order_date), month(order_date)))*100,2) as Growth
from orders
group by 1, 2
order by 1,2)
select order_year, order_month, No_of_orders,
growth-100 as Growthpercentage
from growthratio;

alter table riders
add column Rider_rating text;

set sql_safe_updates = 0;

with deliver as
(select a.rider_id, b.rider_name, count(a.delivery_id) as No_of_deliveries,
ntile(4) over(order by count(a.delivery_id) desc) as Bucket
from deliveries a join riders b using (rider_id)
where a.delivery_status = "Delivered"
group by a.rider_id, b.rider_name
order by No_of_deliveries desc)
update riders a left join deliver b using(rider_id)
set a.Rider_rating = case when bucket=1 then "5 rating"
                        when bucket=2 then "4 rating"
                        when bucket=3 then "3 rating"
                        when bucket=4 then "2 rating"
                        else "1 rating"
				end;
                

delimiter //
create function meal_type(order_time time)
returns varchar(15)
deterministic
begin
    Declare type varchar(15);
    set type = case when order_time between '06:00:00' AND '10:59:59' THEN "Breakfast"
               when order_time between '11:00:00' AND '15:59:59' THEN "Lunch"
               when order_time between '16:00:00' AND '17:59:59' THEN "Evening snack"
               when order_time between '18:00:00' AND '21:59:59' THEN "Dinner"
               else "Late night"
	end;
    return type;
end //
delimiter ;
               
select order_id, order_item, meal_type(order_time) as Meal_category
from orders 
limit 20;

select distinct order_item from orders;

select distinct order_item, if(order_item regexp 'chicken|egg|fish|mutton|prawn',"Non-Veg","Veg") as Meal_type
from orders;

select r.restaurant_id, r.restaurant_name
from restaurants r
where exists (select 1 from orders o
              where o.restaurant_id = r.restaurant_id and
			  (order_item like "%pizza%" or order_item like "%pasta%"));

select r.restaurant_id, r.restaurant_name
from restaurants r
where exists (select order_item from orders o
              where o.restaurant_id = r.restaurant_id and
			  (order_item like "%burger%"));           
              
select r.restaurant_id, r.restaurant_name
from restaurants r
where not exists (select 1 from orders o
              where o.restaurant_id = r.restaurant_id and
			  order_item not regexp 'chicken|egg|fish|mutton|prawn');
              
select distinct restaurant_id from orders
where order_item like "%pasta%" and order_item like "%pizzza%";

select restaurant_id, order_item from orders where restaurant_id like '6_';