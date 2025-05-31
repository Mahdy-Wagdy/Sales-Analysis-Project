# 🛒 PostgreSQL Sales Analysis Project

## 📌 Overview
This project contains SQL scripts to analyze retail sales data using PostgreSQL.  
It covers various business questions and analytical use cases commonly used in BI and data analysis.
---

## 🗂️ Data Schema

The analysis is based on 3 core tables:

- `gold.fact_sales`: contains sales transactions
- `gold.dim_customers`: contains customer details
- `gold.dim_products`: contains product details

---

## 🧪 Analysis Covered

### 1. Change Over Time (`01_change_over_time.sql`)
- Trend of sales and customer count by year/month

### 2. Cumulative Analysis (`02_cumulative_analysis.sql`)
- Running total and moving average for sales

### 3. Performance Analysis (`03_performance_analysis.sql`)
- Comparison with average performance and YoY changes

### 4. Part to Whole (`04_part_to_whole.sql`)
- Category contribution to total sales

### 5. Data Segmentation (`05_data_segmentation.sql`)
- Segmenting customers based on spend & lifespan

---

## 📊 Reporting Views

### `report_customers.sql`
- Customer KPIs, segments, recency, AOV, average spend

### `report_products.sql`
- Product KPIs, segments, recency, AOR, average monthly revenue

---

## 🛠️ Tools Used
- PostgreSQL
- SQL (Window Functions, Aggregations, CTEs)

---

Mahdy Wagdy | Data Analyst  
[LinkedIn](https://www.linkedin.com/in/mahdy-wagdy/)

