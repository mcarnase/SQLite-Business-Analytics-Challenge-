
--Task #1
SELECT c.first_name, c.last_name as Name,
sum(oi.quantity * oi.unit_price) as Total_spend
FROM customers c
join orders o on c.id = o.customer_id
JOIN order_items oi on o.id = oi.order_id
GROUP BY c.id
ORDER BY Total_spend desc
limit 5;

--Task #2
SELECT p.category, sum(oi.quantity*oi.unit_price) as Revenue
FROM products p
join order_items oi on p.id = oi.product_id
group by p.category
ORDER by Revenue DESC;

--Task #3
SELECT e.first_name, e.last_name, d.name, e.salary
FROM employees e
JOIN departments d on e.department_id = d.id
where e.salary > (
    SELECT avg(salary)
    From employees
    where department_id = e.department_id
)
ORDER BY d.name, e.salary desc;

--Task #4
SELECT city, count(*) as GOLD_COUNT
From customers
where loyalty_level = 'Gold'
GROUP BY city
ORDER BY GOLD_COUNT desc;
