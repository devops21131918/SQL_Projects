# SQL Data Analytics Portfolio

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Analytics-orange)
![Projects](https://img.shields.io/badge/Projects-4-blue)
![Queries](https://img.shields.io/badge/Business%20Queries-80-green)
![Python](https://img.shields.io/badge/Python-Data%20Cleaning-3776AB?logo=python&logoColor=white)

A collection of four end-to-end SQL projects that turn raw relational data into business insights. Each project is built on a different domain (e-commerce, retail, food delivery, and book retail) and progresses from fundamental queries to advanced analytics with CTEs and window functions.

Across the portfolio there are **80 business-focused SQL queries** running on **PostgreSQL**, covering sales performance, customer behaviour, product profitability, delivery operations, and inventory management.

---

## Table of Contents

- [Projects at a Glance](#projects-at-a-glance)
- [Repository Structure](#repository-structure)
- [Tech Stack](#tech-stack)
- [Project 1: Amazon E-commerce Analysis](#project-1-amazon-e-commerce-analysis)
- [Project 2: SuperStore Orders Analysis](#project-2-superstore-orders-analysis)
- [Project 3: Zomato Food Delivery Analysis](#project-3-zomato-food-delivery-analysis)
- [Project 4: Online Bookstore Analysis](#project-4-online-bookstore-analysis)
- [SQL Skills Demonstrated](#sql-skills-demonstrated)
- [Getting Started](#getting-started)
- [Data Notes](#data-notes)
- [Author](#author)

---

## Projects at a Glance

| # | Project | Domain | Scale | Queries | Level | Highlights |
|---|---|---|---|---|---|---|
| 1 | [Amazon E-commerce Analysis](./Amazon_Ecommerce_Analysis/) | E-commerce | 10 tables, 60K orders, 180K order items | 20 | Beginner to Professional | Window functions, CTEs, self-join market basket analysis |
| 2 | [SuperStore Orders Analysis](./SuperStore_SQL_Project/) | Global retail | 51,290 order lines, 2011 to 2014 | 20 | Basic to Intermediate | Python cleaning and EDA, then SQL; discount and profitability analysis |
| 3 | [Zomato Food Delivery Analysis](./Zomato_Data_Analysis-main/) | Food delivery | 5 tables, 10K orders | 20 | Advanced | Churn, rider KPIs, growth ratios, segmentation |
| 4 | [Online Bookstore Analysis](./OnlineBookStore__SQL__Project/) | Book retail | 3 tables, 500 rows each | 20 | Basic to Advanced | Joins, aggregation, stock reconciliation |

---

## Repository Structure

```text
SQL_Projects/
│
├── README.md
│
├── Amazon_Ecommerce_Analysis/
│   ├── README.md
│   ├── dataset/                        # 10 CSV files
│   └── sql/
│       └── amazon_ecommerce_analysis.sql
│
├── SuperStore_SQL_Project/
│   ├── README.md
│   ├── requirements.txt
│   ├── data/                           # raw and cleaned CSV
│   ├── notebook/
│   │   └── 01_superstore_cleaning_and_eda.ipynb
│   ├── sql/
│   │   └── superstore_analysis.sql
│   └── docs/
│       └── SuperStore_SQL_Questions.pdf
│
├── Zomato_Data_Analysis-main/
│   ├── README.md
│   ├── zomato_schema.sql
│   ├── zomato_solution_of_problems.sql
│   ├── Zomato 20 Advanced Business Problems.pdf
│   └── *.csv                           # customers, orders, deliveries, restaurants, riders
│
└── OnlineBookStore__SQL__Project/
    ├── README.md
    ├── OnlineBookStore.sql             # schema, import, and 20 solved queries
    └── *.csv                           # Books, Customers, Orders
```

---

## Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database and query engine |
| pgAdmin / psql | Database management, CSV import, query execution |
| SQL | Data analysis and business insights |
| Python (pandas, NumPy, Matplotlib, Seaborn) | Data cleaning and exploratory analysis (SuperStore) |
| Jupyter Notebook | Documented cleaning and EDA workflow |
| Git and GitHub | Version control and portfolio presentation |

---

## Project 1: Amazon E-commerce Analysis

**Folder:** [`Amazon_Ecommerce_Analysis`](./Amazon_Ecommerce_Analysis/) | **Database:** `amazon_ecommerce_db`

### Overview

An Amazon-style marketplace database with ten interconnected tables. The analysis covers sales, customers, sellers, payments, shipping, reviews, and inventory, organised into four difficulty levels.

### Dataset

| Table | Rows | Description |
|---|---|---|
| `customers` | 15,000 | Customer profiles, location, Prime membership |
| `orders` | 60,000 | Order header, status, amount, delivery city |
| `order_items` | 180,000 | Products, quantities, discounts, subtotals |
| `products` | 8,000 | Price, cost price, brand, rating |
| `category` | 25 | Product categories |
| `sellers` | 500 | Seller profile, rating, verification |
| `payments` | 60,000 | Payment method, status, amount |
| `shipping` | 60,000 | Courier, estimated and actual delivery |
| `reviews` | 120,000 | Customer ratings and review text |
| `inventory` | 8,000 | Stock level and reorder level by warehouse |

Order history spans **January 2022 to June 2026**.

### Analysis Roadmap

| Level | Queries | Topics |
|---|---|---|
| Beginner | Q1 to Q5 | Order status, top products, customers by country, order statistics, payment methods |
| Intermediate | Q6 to Q14 | Monthly revenue, top cities, top customers, category sales and profit, best sellers, seller performance, cancellation rate, courier on-time delivery |
| Advanced | Q15 to Q17 | Inventory restocking, catalogue vs customer rating, repeat vs one-time customers |
| Professional | Q18 to Q20 | Product ranking within categories (`RANK`), month-over-month growth (`LAG`), frequently bought-together products (self-join) |

### Key Findings

- **Order outcomes:** 59.9% of orders were delivered (35,930), 10.1% returned, and **4.86% cancelled**.
- **Order value:** average order value is about **₹53.7K**, and delivered orders generated roughly **₹1.93B** in revenue.
- **Growth:** delivered revenue grew from ₹108.9M in 2022 to ₹636.1M in 2025, almost 6x. January to June 2026 alone reached about 87% of full-year 2025 revenue.
- **Category concentration:** Electronics contributes about **40%** of delivered sales and roughly half of estimated profit.
- **Payments:** **UPI** is the most used method (32% of transactions), followed by Credit Card and Debit Card.
- **Customer loyalty:** about **93%** of customers who ordered are repeat customers.
- **Delivery performance:** courier on-time rates sit in a narrow 49% to 52% band, so no courier clearly outperforms the others.
- **Inventory:** **4,374 of 8,000** inventory records (55%) are at or below their reorder level.
- **Customer vs catalogue rating:** the average customer rating is 3.94, with an average gap of about 0.6 stars from the catalogue rating.

### Query Highlight: Month-over-Month Revenue Growth

```sql
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
           SUM(total_amount)               AS revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY month
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 2) AS growth_percentage
FROM monthly_sales
ORDER BY month;
```

---

## Project 2: SuperStore Orders Analysis

**Folder:** [`SuperStore_SQL_Project`](./SuperStore_SQL_Project/) | **Database:** `superstore_db`

### Overview

An end-to-end workflow on a global retail dataset: data cleaning and exploration in Python, followed by 20 business questions answered in PostgreSQL. This is the only project in the portfolio that combines Python and SQL.

### Dataset

| Item | Detail |
|---|---|
| Period | January 2011 to December 2014 |
| Raw data | 51,290 order lines, 21 columns |
| Cleaned data | 51,290 order lines, 18 columns |
| Coverage | 25,754 orders, 795 customers, 147 countries, 7 markets |

### Workflow

1. **Clean and explore (Python):** convert `sales` from text to numeric, parse dates, validate data quality, fix **659 reused order IDs**, and drop four irrelevant columns (`year`, `state`, `region`, `product_id`).
2. **Load (PostgreSQL):** create a single table with `PRIMARY KEY`, `NOT NULL`, and `CHECK` constraints, then import the cleaned CSV.
3. **Analyse (SQL):** answer 20 questions across five themes.

### Analysis Themes

| Theme | Queries | Focus |
|---|---|---|
| A. Business Overview | Q1 to Q4 | KPIs, yearly trend, year-over-year growth, seasonality |
| B. Products | Q5 to Q9 | Category and sub-category performance, top products, rankings |
| C. Geography | Q10 to Q12 | Market performance, top countries, loss-making countries |
| D. Customers | Q13 to Q16 | Segments, top customers, average order value, value tiers |
| E. Discounts and Shipping | Q17 to Q20 | Discount impact, ship modes, order priority, heavy-discount losses |

### Key Findings

- **Scale:** 12.64M in sales and 1.47M in profit, an overall margin of **11.62%**.
- **Growth:** sales rose about **90%** from 2011 to 2014, with year-over-year growth of 18.5%, 27.2%, and 26.3%.
- **Products:** Technology earns the most profit (663.8K). Furniture has the lowest margin (6.98%), and **Tables** is the only loss-making sub-category (-64.1K).
- **Discounts:** order lines discounted by more than 20% lose money on average, and above 40% the average loss is about **90 per line**. This is the most actionable finding in the project.
- **Markets:** APAC is the largest market. EMEA has the weakest margin (5.45%), and Turkey and Nigeria show the largest country-level losses.
- **Seasonality:** sales peak in November and December.
- **Customers:** Medium-value customers generate about **65%** of sales.
- **Shipping:** Standard Class averages 5.0 days versus 2.2 days for First Class, at roughly half the shipping cost.

### Recommendations

1. Cap discounts at around 20% and review the pricing of Tables.
2. Investigate cost and pricing issues in EMEA, Turkey, and Nigeria.
3. Plan inventory and campaigns around the November to December peak.

### Query Highlight: Discount Impact on Profit

```sql
SELECT
    CASE
        WHEN discount = 0    THEN '1. No discount'
        WHEN discount <= 0.2 THEN '2. Up to 20%'
        WHEN discount <= 0.4 THEN '3. 21% to 40%'
        ELSE                      '4. Above 40%'
    END                    AS discount_band,
    COUNT(*)               AS order_lines,
    SUM(profit)            AS total_profit,
    ROUND(AVG(profit), 2)  AS avg_profit_per_line
FROM superstore_orders
GROUP BY discount_band
ORDER BY discount_band;
```

---

## Project 3: Zomato Food Delivery Analysis

**Folder:** [`Zomato_Data_Analysis-main`](./Zomato_Data_Analysis-main/) | **Database:** `zomato`

### Overview

A food-delivery database used to solve 20 advanced business problems on customer behaviour, restaurant performance, order trends, and rider efficiency. The problem statements are listed in the included PDF, and every solution is in `zomato_solution_of_problems.sql`.

### Dataset

| Table | Rows | Description |
|---|---|---|
| `customers` | 33 | Customer name and registration date |
| `restaurants` | 71 | Restaurant name, city, opening hours |
| `riders` | 34 | Rider name and sign-up date |
| `orders` | 10,000 | Dish, date, time, status, order amount |
| `deliveries` | 9,750 | Delivery status, delivery time, assigned rider |

Orders span **January 2023 to January 2024** across 11 city names.

### The 20 Business Problems

| Theme | Problems |
|---|---|
| Customer analytics | Top dishes per customer, AOV of high-frequency customers, high-value customers, churn (2023 vs 2024), Gold/Silver segmentation, customer lifetime value |
| Orders and revenue trends | Popular 2-hour time slots, peak day of week, month-over-month sales trend, seasonal dish popularity, most popular dish by city, city revenue ranking |
| Restaurant performance | Undelivered orders, revenue ranking within city, cancellation rate comparison (year over year), monthly growth ratio |
| Rider performance | Average delivery time, monthly earnings (8% of order value), star ratings by delivery speed, efficiency (fastest vs slowest) |

### Key Findings

- **Revenue:** about **₹3.23M** from 10,000 orders, with an average order value of **₹322.82**. Monthly revenue is stable at roughly ₹230K to ₹290K.
- **Fulfilment:** 97.5% of orders were completed and 2.5% were not fulfilled.
- **Peak hours:** the busiest slot is **14:00 to 16:00** (1,188 orders), followed by 18:00 to 20:00 and 22:00 to midnight.
- **Peak day:** Sunday has the highest order volume (1,506 orders).
- **Geography:** Mumbai generated about **47%** of 2023 revenue (₹1.52M), ahead of Bengaluru (₹0.72M) and Delhi (₹0.39M).
- **Menu:** Paneer Butter Masala leads in Mumbai and Delhi, Chicken Biryani leads in Bengaluru and Hyderabad.
- **Customers:** 14 customers spent more than ₹100K each. The top customer spent about ₹269K across 807 orders.
- **Riders:** average delivery time is about **40 minutes**, ranging from 32 to 52 minutes between riders. Only about 2.6% of deliveries finish within 15 minutes, which is the 5-star threshold.

### Query Highlight: Most Popular Dish in Each City

```sql
SELECT *
FROM (
    SELECT r.city,
           o.order_item                                           AS dish,
           COUNT(order_id)                                        AS total_orders,
           RANK() OVER (PARTITION BY r.city
                        ORDER BY COUNT(order_id) DESC)            AS rank
    FROM orders AS o
    JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

---

## Project 4: Online Bookstore Analysis

**Folder:** [`OnlineBookStore__SQL__Project`](./OnlineBookStore__SQL__Project/) | **Database:** `OnlineBookStore`

### Overview

A compact three-table database (books, customers, orders) that covers SQL fundamentals: filtering, aggregation, joins, and stock reconciliation. It is the entry point of the portfolio and demonstrates a clean, readable query style.

### Dataset

| Table | Rows | Description |
|---|---|---|
| `Books` | 500 | Title, author, genre, publication year, price, stock |
| `Customers` | 500 | Name, contact details, city, country |
| `Orders` | 500 | Customer, book, order date, quantity, total amount |

Orders span **December 2022 to December 2024** across 7 genres and 215 countries.

### Analysis Questions

| Level | Questions |
|---|---|
| Basic (11) | Fiction books, books published after 1950, customers from Canada, November 2023 orders, total stock, most expensive book, orders with quantity above 1, orders above $20, distinct genres, lowest-stock book, total revenue |
| Advanced (9) | Books sold per genre, average Fantasy price, customers with 2 or more orders, most frequently ordered book, top 3 Fantasy books by price, quantity sold per author, cities of customers who spent over $30, top-spending customer, remaining stock after orders |

### Key Findings

- **Revenue:** **$75,628.66** from 500 orders, an average of **$151.26** per order.
- **Genres:** Mystery sells the most units (504), and Fiction the fewest (225).
- **Customers:** 307 customers placed orders and 139 of them ordered more than once. The top spender is Kim Turner at $1,398.90.
- **Authors:** Patrick Contreras has the most copies sold (28).
- **Inventory:** the catalogue holds **25,056** units. After reconciling orders against stock, **30 titles are ordered beyond their available stock** and 5 titles have zero stock, which highlights a clear restocking need.

### Query Highlight: Remaining Stock After Orders

```sql
SELECT b.Book_ID, b.Title, b.Stock,
       COALESCE(SUM(o.Quantity), 0)                    AS Order_Quantity,
       b.Stock - COALESCE(SUM(o.Quantity), 0)          AS Remaining_Quantity
FROM Books AS b
LEFT JOIN Orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;
```

---

## SQL Skills Demonstrated

| Skill | Amazon | SuperStore | Zomato | Bookstore |
|---|:---:|:---:|:---:|:---:|
| Schema design (PK, FK, constraints) | ✔ | ✔ | ✔ | ✔ |
| Multi-table `JOIN`s | ✔ | n/a (single table) | ✔ | ✔ |
| `LEFT JOIN` and NULL handling (`COALESCE`, `NULLIF`) | ✔ | | ✔ | ✔ |
| Aggregation, `GROUP BY`, `HAVING` | ✔ | ✔ | ✔ | ✔ |
| `CASE WHEN` logic | ✔ | ✔ | ✔ | |
| Subqueries | ✔ | | ✔ | |
| Common Table Expressions (CTEs) | ✔ | ✔ | ✔ | |
| Window functions (`RANK`, `DENSE_RANK`, `LAG`) | ✔ | ✔ | ✔ | |
| Self-join (market basket analysis) | ✔ | | | |
| Date and time analysis | ✔ | ✔ | ✔ | ✔ |
| Conditional aggregation / pivoting | ✔ | | ✔ | |
| Data cleaning with Python | | ✔ | | |

---

## Getting Started

### Prerequisites

- PostgreSQL 12 or later
- pgAdmin or the `psql` command-line client
- Python 3.9+ with Jupyter (only for the SuperStore notebook)

### General Workflow

1. Create the database.
2. Create the tables using the project's SQL script.
3. Import the CSV files (pgAdmin **Import/Export Data**, or `\copy` in `psql`). Load parent tables before child tables so foreign keys resolve.
4. Verify row counts.
5. Run the analysis queries one at a time and review the output.

### Project-Specific Notes

**Amazon E-commerce**

```bash
createdb -U postgres amazon_ecommerce_db
```

Run the `CREATE TABLE` section of `sql/amazon_ecommerce_analysis.sql`, then import the CSVs in this order: `category`, `customers`, `sellers`, `products`, `orders`, `order_items`, `payments`, `shipping`, `reviews`, `inventory`. The 20 queries follow after the table checks.

**SuperStore**

```bash
cd SuperStore_SQL_Project
pip install -r requirements.txt            # optional, to re-run the notebook
psql -U postgres -f sql/superstore_analysis.sql
```

Run from the project root so the relative `\copy` path resolves.

**Zomato**

```bash
createdb -U postgres zomato
cd Zomato_Data_Analysis-main
psql -U postgres -d zomato -f zomato_schema.sql
```

Then load the CSVs from `psql` in this order: `riders`, `restaurants`, `customers`, `orders`, `deliveries`.

```sql
\copy riders      FROM 'riders.csv'      CSV HEADER
\copy restaurants FROM 'restaurants.csv' CSV HEADER
\copy customers   FROM 'customers.csv'   CSV HEADER
\copy orders      FROM 'orders.csv'      CSV HEADER
\copy deliveries  FROM 'deliveries.csv'  CSV HEADER
```

Finally run `zomato_solution_of_problems.sql`.

**Online Bookstore**

Open `OnlineBookStore.sql` and update the three `COPY` file paths to the location of your CSV files, then run the script in sections.

---

## Data Notes

- **Datasets are synthetic or practice datasets.** They are designed for SQL learning and portfolio work, so some results (for example, near-equal courier on-time rates or a high estimated margin in the Amazon data) reflect how the data was generated rather than real market behaviour.
- **Amazon:** currency is not stored in the data. Amounts are shown in rupees (₹) because all customers are in India. Estimated profit uses only `cost_price` and excludes shipping, seller fees, and returns.
- **Zomato:** the data ends in **January 2024**. Queries that use `CURRENT_DATE - INTERVAL '1 year'` (Q1 and Q6) need the reference date changed to the latest order date to reproduce meaningful results. The 2024 portion contains only 25 orders, so the churn query (2023 vs 2024) should be read with that in mind.
- **Zomato:** the city field contains both "Bengaluru" and "Bangalore", and `deliveries` contains an extra `Order` status for 254 rows. Standardising these values is a worthwhile cleaning step before extending the analysis.
- **Bookstore:** `Total_Amount` equals `Quantity x Price` for every order, and stock levels are static, which is why some titles show negative remaining stock.

---

*These projects were built for practical SQL learning, business analytics, and portfolio development. Feedback and suggestions are welcome.*
