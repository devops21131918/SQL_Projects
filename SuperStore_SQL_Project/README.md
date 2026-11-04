# SuperStore Orders – SQL Data Analysis Project

An end-to-end analysis of a global retail orders dataset: data cleaning and exploration in Python, followed by 20 business-focused SQL queries in PostgreSQL.

## Dataset

| Item | Detail |
|---|---|
| Source file | `SuperStoreOrders.csv` |
| Period | January 2011 – December 2014 |
| Raw size | 51,290 order lines, 21 columns |
| Cleaned size | 51,290 order lines, 18 columns |
| Coverage | 25,754 orders, 795 customers, 147 countries, 7 markets |

## Project Structure

```
SuperStore_SQL_Project/
├── data/
│   ├── SuperStoreOrders.csv          # Raw data
│   └── superstore_cleaned.csv        # Cleaned data (output of the notebook)
├── notebook/
│   └── 01_superstore_cleaning_and_eda.ipynb
├── sql/
│   └── superstore_analysis.sql       # Database, table, and 20 queries
├── docs/
│   └── SuperStore_SQL_Questions.pdf  # The 20 business questions
├── requirements.txt
└── README.md
```

## Workflow

1. **Clean and explore (Python)** – fix data types, validate quality, remove irrelevant columns, and analyse trends.
2. **Load (PostgreSQL)** – create a dedicated database and table, then import the cleaned CSV.
3. **Analyse (SQL)** – answer 20 business questions across five themes.

## Data Cleaning Summary

- Converted `sales` from text (e.g., `1,106`) to numeric and parsed both date columns.
- Verified no missing values, no duplicate rows, and no shipments dated before the order.
- Fixed **659 reused order IDs** (shared by different customers or dates) so that each `order_id` represents one order.
- Removed four irrelevant columns:

| Removed | Reason |
|---|---|
| `year` | Redundant; derived from `order_date` |
| `state` | Too granular (1,094 values) |
| `region` | Ambiguous and overlaps with `market` |
| `product_id` | `product_name` already identifies the product |

- Added `order_line_id` as a unique primary key.

## SQL Analysis Overview

| Theme | Queries | Focus |
|---|---|---|
| A. Business Overview | Q1 – Q4 | KPIs, yearly trend, YoY growth, seasonality |
| B. Products | Q5 – Q9 | Category, sub-category, top products, rankings |
| C. Geography | Q10 – Q12 | Markets, top countries, loss-making countries |
| D. Customers | Q13 – Q16 | Segments, top customers, order value, value tiers |
| E. Discounts & Shipping | Q17 – Q20 | Discount impact, ship modes, priority, heavy-discount losses |

Techniques used: `GROUP BY`, `HAVING`, `CASE`, CTEs, and window functions (`LAG`, `RANK`). Each query is labelled **Basic** or **Intermediate**.

## How to Run

**1. Notebook (optional – the cleaned CSV is already included)**
```bash
pip install -r requirements.txt
cd notebook
jupyter notebook 01_superstore_cleaning_and_eda.ipynb
```

**2. SQL (PostgreSQL 12 or later)**

Run from the project root so the relative `\copy` path resolves:
```bash
psql -U postgres -f sql/superstore_analysis.sql
```
The script creates `superstore_db`, builds the `superstore_orders` table, loads the data, and runs all 20 queries. If you use pgAdmin, run the script in sections and import the CSV through *Import/Export Data*.

## Key Findings

- **Scale:** 12.64M in sales and 1.47M in profit, an overall margin of 11.62%.
- **Growth:** Sales rose about 90% from 2011 to 2014, with year-over-year growth of 18.5%, 27.2%, and 26.3%.
- **Products:** Technology earns the most profit (663.8K). Furniture has the lowest margin (6.98%), and **Tables** is the only loss-making sub-category (–64.1K).
- **Discounts:** Order lines discounted by more than 20% lose money on average; above 40%, the average loss is about 90 per line.
- **Markets:** APAC is the largest market. EMEA has the weakest margin (5.45%), and Turkey and Nigeria show the largest country-level losses.
- **Seasonality:** Sales are highest in November and December and lowest in February.
- **Customers:** Segments differ little in margin or average order value (about 490). Medium-value customers generate 65% of sales.
- **Shipping:** Standard Class takes 5.0 days on average versus 2.2 for First Class, at roughly half the shipping cost.

## Recommendations

1. Cap discounts at around 20% and review the pricing of Tables.
2. Investigate cost and pricing issues in EMEA, Turkey, and Nigeria.
3. Plan inventory and campaigns around the November–December peak.

## Tools

Python (pandas, NumPy, Matplotlib, Seaborn) · Jupyter Notebook · PostgreSQL
