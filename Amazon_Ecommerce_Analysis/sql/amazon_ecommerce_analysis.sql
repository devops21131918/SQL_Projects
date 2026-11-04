CREATE DATABASE amazon_ecommerce_db;

--1. Category Table
CREATE TABLE category (
	category_id INT PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL
);

--2. Customer Table
CREATE TABLE customers (
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	gender VARCHAR(20),
	email VARCHAR(255),
	phone VARCHAR(30),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	zipcode VARCHAR(20),
	registration_date DATE,
	prime_member BOOLEAN,
	age SMALLINT
);

--3. Sellers Table
CREATE TABLE sellers (
	seller_id INT PRIMARY KEY,
	seller_name VARCHAR(200) NOT NULL,
	seller_rating NUMERIC(4, 2),
	seller_city VARCHAR(100),
	seller_country VARCHAR(100),
	seller_join_date DATE,
	verified BOOLEAN,
	total_products INT
);

--4. Products Table
CREATE TABLE products (
	product_id INT PRIMARY KEY,
	product_name VARCHAR(255) NOT NULL,
	category_id INT REFERENCES category(category_id),
	seller_id INT REFERENCES sellers(seller_id),
	brand VARCHAR(100),
	price NUMERIC(12, 2),
	cost_price NUMERIC(12, 2),
	weight NUMERIC(10, 2),
	rating NUMERIC(3, 1),
	review_count INT,
	launch_date DATE,
	status VARCHAR(30)
);

-- 5. ORDERS TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP,
    order_status VARCHAR(30),
    total_amount NUMERIC(12,2),
    shipping_address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    zipcode VARCHAR(20)
);

-- 6. ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(12,2),
    discount NUMERIC(12,2),
    subtotal NUMERIC(12,2)
);

-- 7. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_method VARCHAR(50),
    payment_date TIMESTAMP,
    payment_status VARCHAR(30),
    transaction_id VARCHAR(100),
    amount NUMERIC(12,2)
);

-- 8. SHIPPING TABLE
CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    courier VARCHAR(100),
    shipping_date TIMESTAMP,
    estimated_delivery TIMESTAMP,
    actual_delivery TIMESTAMP,
    delivery_status VARCHAR(30),
    shipping_cost NUMERIC(12,2),
    tracking_number VARCHAR(100)
);

-- 9. REVIEWS TABLE
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    customer_id INT REFERENCES customers(customer_id),
    rating SMALLINT,
    review_title VARCHAR(255),
    review_text TEXT,
    review_date DATE,
    verified_purchase BOOLEAN
);

-- 10. INVENTORY TABLE
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    warehouse VARCHAR(100),
    stock_quantity INT,
    reorder_level INT,
    last_updated TIMESTAMP
);

-- VERIFY TABLE CREATION
SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;


SELECT * FROM category;
SELECT * FROM customers;
SELECT * FROM inventory;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM products;
SELECT * FROM reviews;
SELECT * FROM sellers;
SELECT * FROM shipping;

-- Amazon E-commerce SQL Analysis — 20 Queries
--01. Order Status Analysis
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

--Q2. Top 10 Expensive Products
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 10;

--Q3. Customers by Country
SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;

--Q4. Overall Order Statistics
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    ROUND(SUM(total_amount), 2) AS total_order_value
FROM orders;

--Q5. Most Popular Payment Methods
SELECT payment_method, COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;

--Level 2 — Intermediate
--Q6. Monthly Revenue Analysis
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY month
ORDER BY month;

--Q7. Top 10 Revenue-Generating Cities
SELECT
    city,
    state,
    ROUND(SUM(total_amount), 2) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY city, state
ORDER BY revenue DESC
LIMIT 10;

--Q8. Top 10 Highest-Spending Customers
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

--Q9. Category-Wise Sales Analysis
SELECT
    c.category_name,
    SUM(oi.subtotal) AS total_sales
FROM category c
JOIN products p 
ON c.category_id = p.category_id
JOIN order_items oi 
ON p.product_id = oi.product_id
JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.category_name
ORDER BY total_sales DESC;

--Q10. Best-Selling Products
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 10;

--Q11. Category-Wise Estimated Profit
SELECT
    c.category_name,
    ROUND(SUM(oi.subtotal - oi.quantity * p.cost_price), 2) AS estimated_profit
FROM category c
JOIN products p 
ON c.category_id = p.category_id
JOIN order_items oi 
ON p.product_id = oi.product_id
JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.category_name
ORDER BY estimated_profit DESC;

--Q12. Seller Performance Analysis
SELECT
    s.seller_name,
    ROUND(SUM(oi.subtotal), 2) AS total_sales
FROM sellers s
JOIN products p 
ON s.seller_id = p.seller_id
JOIN order_items oi 
ON p.product_id = oi.product_id
JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY s.seller_id, s.seller_name
ORDER BY total_sales DESC
LIMIT 10;

--Q13. Order Cancellation Rate
SELECT
    COUNT(*) FILTER (WHERE order_status = 'Cancelled') AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_status = 'Cancelled')
        / COUNT(*), 2
    ) AS cancellation_percentage
FROM orders;

--Q14. Courier Delivery Performance
SELECT
    courier,
    COUNT(*) AS delivered_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE actual_delivery <= estimated_delivery
        ) / COUNT(*), 2
    ) AS on_time_percentage
FROM shipping
WHERE delivery_status = 'Delivered'
  AND actual_delivery IS NOT NULL
GROUP BY courier
ORDER BY on_time_percentage DESC;

--Level 3 — Advanced
--Q15. Inventory Restocking Analysis
SELECT
    p.product_name,
    i.warehouse,
    i.stock_quantity,
    i.reorder_level
FROM inventory i
JOIN products p 
ON i.product_id = p.product_id
WHERE i.stock_quantity <= i.reorder_level
ORDER BY i.stock_quantity;

--Q16. Product Rating Comparison
SELECT
    p.product_name,
    p.rating AS catalogue_rating,
    ROUND(AVG(r.rating), 2) AS customer_rating
FROM products p
JOIN reviews r 
ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.rating
ORDER BY customer_rating DESC;

--Q17. Repeat vs One-Time Customers
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) AS customer_orders
GROUP BY customer_type;

--Level 4 — Professional
--Q18. Rank Products Within Each Category
SELECT
    category_name,
    product_name,
    total_sales,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY total_sales DESC
    ) AS product_rank
FROM (
    SELECT
        c.category_name,
        p.product_name,
        SUM(oi.subtotal) AS total_sales
    FROM category c
    JOIN products p ON c.category_id = p.category_id
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.category_name, p.product_id, p.product_name
) AS sales;

--Q19. Month-over-Month Revenue Growth
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(total_amount) AS revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
        2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY month;

--Q20. Frequently Bought-Together Products
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(DISTINCT oi1.order_id) AS orders_together
FROM order_items oi1
JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
    AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
JOIN orders o ON oi1.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p1.product_name, p2.product_name
ORDER BY orders_together DESC
LIMIT 20;