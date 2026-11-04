# Amazon E-commerce SQL Analysis

## Project Overview

This project focuses on analyzing an Amazon-style e-commerce database using **PostgreSQL** to extract meaningful business insights through SQL.

The project covers customer behavior, sales performance, product profitability, seller performance, payment methods, shipping efficiency, and inventory management.

It is designed to demonstrate SQL skills from beginner to professional level through practical business questions.

## Project Objectives

- Analyze overall e-commerce sales and order performance.
- Identify top-performing products, categories, and sellers.
- Understand customer purchasing behavior.
- Analyze payment methods and cancellation rates.
- Evaluate shipping and delivery performance.
- Identify inventory and restocking requirements.
- Perform advanced analysis using SQL window functions and CTEs.
- Develop business insights that support data-driven decisions.

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL | Relational database |
| pgAdmin | Database management and query execution |
| SQL | Data analysis and business insights |
| Git & GitHub | Version control and portfolio presentation |

## Database Overview

The database contains 10 interconnected tables:

| Table | Description |
|---|---|
| `customers` | Customer information |
| `orders` | Order transactions |
| `order_items` | Products and quantities within orders |
| `products` | Product details and pricing |
| `category` | Product category information |
| `sellers` | Seller information |
| `payments` | Payment transactions |
| `shipping` | Shipment and delivery details |
| `reviews` | Customer product reviews |
| `inventory` | Product stock and warehouse information |

**Database Name:** `amazon_ecommerce_db`

## SQL Analysis Roadmap

The project includes 20 business-focused SQL queries organized into four levels.

### Beginner Level

1. Order Status Analysis
2. Top 10 Expensive Products
3. Customers by Country
4. Overall Order Statistics
5. Most Popular Payment Methods

### Intermediate Level

6. Monthly Revenue Analysis
7. Top Revenue-Generating Cities
8. Highest-Spending Customers
9. Category-Wise Sales Analysis
10. Best-Selling Products
11. Category-Wise Estimated Profit
12. Seller Performance Analysis
13. Order Cancellation Rate
14. Courier Delivery Performance

### Advanced Level

15. Inventory Restocking Analysis
16. Product Rating Comparison
17. Repeat vs One-Time Customers

### Professional Level

18. Product Ranking Within Categories
19. Month-over-Month Revenue Growth
20. Frequently Bought-Together Products

## SQL Concepts Covered

### Basic SQL
- SELECT
- WHERE
- ORDER BY
- LIMIT
- DISTINCT

### Aggregation
- COUNT()
- SUM()
- AVG()
- ROUND()
- GROUP BY
- HAVING

### Intermediate SQL
- INNER JOIN
- CASE WHEN
- Aggregate filtering
- Business calculations

### Advanced SQL
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- LAG()
- Date and time analysis

## Key Business Questions

This project answers questions such as:

- Which products generate the highest sales?
- Which categories contribute most to business revenue?
- Who are the highest-value customers?
- What percentage of orders are cancelled?
- Which payment methods are most popular?
- Which sellers generate the most sales?
- Which couriers deliver orders on time?
- Which products require restocking?
- How is monthly sales performance changing?
- Which products are frequently purchased together?

## Project Workflow

1. Create the PostgreSQL database.
2. Create the database tables.
3. Import the CSV datasets.
4. Verify table structures and imported records.
5. Execute SQL queries individually.
6. Analyze query results.
7. Document important business insights.

## Repository Structure

```text
Amazon_Ecommerce_SQL_Analysis/
│
├── README.md
├── amazon_ecommerce_analysis.sql
│
└── datasets/
    ├── customers.csv
    ├── orders.csv
    ├── order_items.csv
    ├── products.csv
    ├── category.csv
    ├── sellers.csv
    ├── payments.csv
    ├── shipping.csv
    ├── reviews.csv
    └── inventory.csv
```

## Business Value

The analysis can help an e-commerce business:

- Improve sales performance.
- Identify profitable products and categories.
- Understand customer purchasing patterns.
- Reduce order cancellations.
- Improve delivery efficiency.
- Optimize inventory management.
- Support strategic business decisions.

## Project Status

**Status:** SQL Analysis and Business Insights

The database has been created, and the dataset has been imported and verified. The next stage is executing and interpreting the 20 SQL queries.

---

*This project is developed for practical SQL learning, business analytics, and portfolio development.*