---- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS totalRevenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;

----- Identify the highest-priced pizza.
SELECT 
    p.pizza_id, p.price, t.name
FROM
    pizzas p
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
ORDER BY price DESC
LIMIT 1;

----- Identify the most common pizza size ordered.

SELECT 
    (p.size), (SUM(o.quantity))
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY SUM(o.quantity) DESC
LIMIT 1
;


------ List the top 5 most ordered pizza types along with their quantities.

SELECT 
    (t.name), (SUM(o.quantity))
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name
ORDER BY SUM(o.quantity) DESC
LIMIT 5
; 

## Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    (t.category), (SUM(o.quantity))
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.category
ORDER BY SUM(o.quantity) DESC

; 
## Determine the distribution of orders by hour of the day.
SELECT 
    hour(o.order_time) AS hod, SUM(d.quantity) AS quantity
FROM
    order_details d
        JOIN
    orders o ON d.order_id = o.order_id
GROUP BY hod
ORDER BY quantity DESC
;

## Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) AS total_count
FROM
    pizza_types
GROUP BY category
ORDER BY total_count DESC;

## Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) AS average_per_day
FROM
    (SELECT 
        (o.order_date) AS day, SUM(d.quantity) AS quantity
    FROM
        order_details d
    JOIN orders o ON d.order_id = o.order_id
    GROUP BY day) AS data
;

## Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    t.name AS name, ROUND(SUM(p.price * o.Quantity), 0) AS rev
FROM
    pizza_types t
        JOIN
    pizzas p ON t.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY name
ORDER BY rev DESC
LIMIT 3;

## Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    t.category,
    ROUND((SUM(p.price * o.Quantity) / (SELECT 
                    ROUND(SUM(o.quantity * p.price), 2) AS totalRevenue
                FROM
                    order_details o
                        JOIN
                    pizzas p ON o.pizza_id = p.pizza_id) * 100),
            0) AS rev
FROM
    pizza_types t
        JOIN
    pizzas p ON t.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON o.pizza_id = p.pizza_id
GROUP BY t.category
ORDER BY rev DESC;

## Analyze the cumulative revenue generated over time.
select date,
sum(rev) over (order by date) as cumulative_rev
from

(SELECT 
    t.order_date AS date, ROUND(SUM(p.price * o.Quantity), 0) AS rev
FROM
    orders t
        JOIN
    order_details o ON t.order_id = o.order_id
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
GROUP BY date) as sales;


## Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name from
(select category, name, rev,
(rank () over(partition by category order by rev desc)) as rnk
from
(select t.category,t.name , sum(p.price * o.quantity) as rev from order_details o
join pizzas p
on p.pizza_id = o.pizza_id
join pizza_types t
on t.pizza_type_id = p.pizza_type_id
group by t.category,t.name) as a) as b
where  rnk <=3 ;





























