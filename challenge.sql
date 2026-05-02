
-- 1. Customers who spent above the average customer spend
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spend
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.id
HAVING total_spend > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(oi.quantity * oi.unit_price) AS customer_total
        FROM customers c
        JOIN orders o ON c.id = o.customer_id
        JOIN order_items oi ON o.id = oi.order_id
        GROUP BY c.id
    )
)
ORDER BY total_spend DESC;

-- 2. Products priced above the average product price
SELECT
    name,
    category,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
)
ORDER BY price DESC;

-- 3. Employees earning above their department average
SELECT
    e.first_name,
    e.last_name,
    e.salary,
    d.name AS department
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
)
ORDER BY d.name, e.salary DESC;



-- 4. Total revenue by customer
WITH customer_spend AS (
    SELECT
        c.id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY c.id
)
SELECT
    customer_name,
    total_spend
FROM customer_spend
ORDER BY total_spend DESC;


-- 5. Top 5 customers by total spend
WITH customer_spend AS (
    SELECT
        c.id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY c.id
)
SELECT
    customer_name,
    total_spend
FROM customer_spend
ORDER BY total_spend DESC
LIMIT 5;


-- 6. Revenue by product category
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category
)
SELECT
    category,
    revenue
FROM category_revenue
ORDER BY revenue DESC;


-- 7. Categories earning more than $1,000
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category
)
SELECT
    category,
    revenue
FROM category_revenue
WHERE revenue > 1000
ORDER BY revenue DESC;


-- 8. Categories above average category revenue
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category
)
SELECT
    category,
    revenue
FROM category_revenue
WHERE revenue > (
    SELECT AVG(revenue)
    FROM category_revenue
)
ORDER BY revenue DESC;


-- 9. Loyalty count by city
WITH city_loyalty AS (
    SELECT
        city,
        COUNT(*) AS gold_count
    FROM customers
    WHERE loyalty_level = 'Gold'
    GROUP BY city
)
SELECT
    city,
    gold_count
FROM city_loyalty
ORDER BY gold_count DESC, city ASC;


-- 10. Full loyalty distribution by city
WITH loyalty_distribution AS (
    SELECT
        city,
        SUM(CASE WHEN loyalty_level = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
        SUM(CASE WHEN loyalty_level = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
        SUM(CASE WHEN loyalty_level = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
    FROM customers
    GROUP BY city
)
SELECT
    city,
    gold_count,
    silver_count,
    bronze_count
FROM loyalty_distribution
ORDER BY gold_count DESC, city ASC;
