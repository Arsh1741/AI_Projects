create database pizza;
use pizza;
select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

#Basic:
#Retrieve the total number of orders placed.
select count(order_id) as total_order from orders;

#Calculate the total revenue generated from pizza sales.
select round(sum(od.quantity*p.price),2) as total_sales
from order_details od
join pizzas p 
on od.pizza_id = p.pizza_id;


#Identify the highest-priced pizza.
-- select * from pizzas order by price desc limit 1;
select pt.name, p.price
from pizza_types pt
join pizzas p 
on pt.pizza_type_id=p.pizza_type_id
order by price desc limit 1;



#Identify the most common pizza size ordered.
select p.size, count(od.quantity) as total
from order_details od
join pizzas p
on od.pizza_id=p.pizza_id
group by p.size order by total desc limit 1;

#list the top 5 most ordered pizza types along with their quantities.
select pt.name, sum(od.quantity) as quantity
from order_details od
join pizzas p
on od.pizza_id=p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.name order by quantity desc limit 5;


#Intermediate:
#Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category, sum(od.quantity) as quantity
from order_details od
join pizzas p
on od.pizza_id=p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.category order by quantity desc;


#Determine the distribution of orders by hour of the day.
select hour(time) as hour, count(order_id) as orders
from orders group by hour(time) order by orders desc;


#Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name)
from pizza_types
group by category;


#Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),2) from
(select o.date, sum(od.quantity) as quantity
from order_details od
join orders o
on od.order_id=o.order_id
group by o.date order by quantity desc) as order_qty;

#Determine the top 3 most ordered pizza types based on revenue.
select pt.name, round(sum(od.quantity*p.price),2) as total_sales
from order_details od
join pizzas p 
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.name order by total_sales desc limit 3;


#Advanced:
#Calculate the percentage contribution of each pizza type to total revenue.
select pt.category,
round((round(sum(od.quantity*p.price),2)) / (select round(sum(od.quantity*p.price),2) as total_sales
from order_details od
join pizzas p 
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id)*100 , 2) as revenue
from order_details od
join pizzas p 
on od.pizza_id = p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.category order by revenue desc;


#Analyze the cumulative revenue generated over time.
select date, 
sum(revenue) over(order by date) as cum_revenue
from
(select o.date, sum(od.quantity*p.price) as revenue
from order_details od
join orders o
on od.order_id=o.order_id
join pizzas p
on od.pizza_id=p.pizza_id
group by o.date order by revenue) as sales;


#Determine the top 3 most ordered pizza types based on revenue for each pizza category
select category, name, revenue
from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pt.category, pt.name,
sum((od.quantity)*p.price) as revenue
from order_details od
join orders o
on od.order_id=o.order_id
join pizzas p
on od.pizza_id=p.pizza_id
join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.category, pt.name) as a) as b
where rn <= 3;

call pizza ('m',16);


