# 📊 Retail Sales Analytics Dashboard

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures-0078D4?style=for-the-badge)
![Star Schema](https://img.shields.io/badge/Data%20Model-Star%20Schema-5C2D91?style=for-the-badge)
![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)

An end-to-end **Power BI** project that turns retail order data (Superstore, 2014–2017) into a 4-page interactive dashboard covering sales, profitability, products, customers and regions. Built on a star-schema data model with reusable DAX measures.

📄 **Full project report:** [PDF](docs/Retail_Sales_Analytics_Project_Report.pdf) · [Word](docs/Retail_Sales_Analytics_Project_Report.docx)

---

## 🎯 Business Problem

A retail business wants to know, at a glance:

- How are **sales and profit** trending over time?
- Which **categories and products** drive revenue, and which ones lose money?
- Who are the most valuable **customers and segments**?
- Which **regions, states and cities** perform best?

---

## 📈 Headline Metrics

| Total Sales | Total Profit | Total Orders | Profit Margin | Avg Discount | Customers | Avg Order Value |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **₹1.94M** | **₹222.16K** | **4,172** | **11.48%** | **17.57%** | **792** | **₹463.82** |

---

## 🖼️ Dashboard Preview

### 1. Executive Overview
KPI cards, monthly Sales & Profit trend, and breakdowns by Category and Region.

<img width="1114" height="631" alt="02 Executive Overview" src="https://github.com/user-attachments/assets/997e1587-33d8-432a-b3d0-120712100a93" />


### 2. Sales & Product Analysis
Sales and profit by Category and Sub-Category, plus the Top 10 products.

<img width="1116" height="618" alt="03 Sales   Product Analysis" src="https://github.com/user-attachments/assets/b502b354-5fd5-429c-86ac-2267d7b8ecbd" />


### 3. Customer Analysis
Customer count, Average Order Value, segment split, Top 10 customers and customer-wise profit.

<img width="1118" height="627" alt="04 Customer Analysis" src="https://github.com/user-attachments/assets/7a5ab8b0-acd9-46b7-bf33-8e8c551b9e70" />


### 4. Regional Performance
Sales and profit by Region, State and City, with a state-level map.

<img width="1119" height="632" alt="05 Regional Performance" src="https://github.com/user-attachments/assets/911908c5-d9db-41a4-9a5e-e74c1a49f93b" />

---

## 🔎 Key Insights

| # | Insight |
|---|---------|
| 1 | The business earns an **11.48% profit margin** on ₹1.94M of sales (₹222.16K profit). |
| 2 | **Technology** leads on sales (₹734K) and profit (₹125K). **Furniture** has ₹642K in sales but only ₹13K profit, about a 2% margin. |
| 3 | **Tables** generate about ₹197K in sales but lose about ₹17K. Bookcases and Supplies are also slightly negative. |
| 4 | **Phones** (₹280K) and **Chairs** (₹267K) lead sub-category sales; **Copiers** lead profit (₹52K). |
| 5 | The **Canon imageCLASS 2200 Advanced Copier** is the top product at about ₹62K, roughly 2.7× the next product. |
| 6 | Sales peak in **November (₹292K)**, with September and December also strong; January and February are the weakest months. |
| 7 | **West (₹582K)** and **East (₹576K)** lead regional sales; West also leads profit (₹81K). Central has the lowest profit (₹31K). |
| 8 | **Consumer** is the largest segment (₹972K, 409 customers). Top customer by sales is Sean Miller (~₹24.5K); most profitable is Tamara Chand (~₹8.6K). |
| 9 | **New York City** leads city sales (~₹218K); **New York** leads state profit (~₹62K). |

---

## 💡 Recommendations

1. **Fix Furniture profitability**: review pricing and discounts on Tables and Bookcases.
2. **Grow high-margin lines**: Copiers, Phones and Accessories.
3. **Plan around seasonality**: prepare for September–December and lift January–February with offers.
4. **Review the Central region**: lowest profit relative to its sales.
5. **Look beyond sales for customers**: protect the most profitable accounts, review high-sales low-profit ones.
6. **Reduce dependence on one product** (Canon imageCLASS 2200).

---

## 🗂️ Dataset

- **File:** 
- **Size:** 9,994 rows × 21 columns · **Period:** Jan 2014 – Dec 2017
- **Quality:** no missing values, no duplicate rows
- **Encoding:** Windows-1252 / Latin-1 (in Python use `pd.read_csv(..., encoding="latin-1")`)
- **Date format:** `08/08/2025`

| Group | Columns |
|-------|---------|
| Order | Row ID, Order ID, Order Date, Ship Date, Ship Mode |
| Customer | Customer ID, Customer Name, Segment |
| Location | Country, State, City, Postal Code, Region |
| Product | Product ID, Product Name, Category, Sub-Category |
| Financials | Sales, Quantity, Discount, Profit |

---

## 🧱 Data Model

Star schema: one fact table with one-to-many relationships from four dimension tables, plus a dedicated `All Measures` table.

<img width="1222" height="622" alt="01 Data Model" src="https://github.com/user-attachments/assets/72c059fe-ec4e-42e1-bc5f-6ed80a8553c5" />


| Table | Role | Key fields |
|-------|------|-----------|
| Retail Sales Analytics Dashboard | Fact | Order ID, Order Date, Sales, Quantity, Discount, Profit, keys |
| Dim_Customer | Dimension | Customer ID, Customer Name, Segment |
| Dim_Geography | Dimension | Geography Key, City, State, Region, Country, Postal Code |
| Dim_Product | Dimension | Product ID, Product Name, Category, Sub-Category |
| Dim_Date | Dimension | Date, Year, Month, Month Number, Month Short, Quarter |
| All Measures | Measure table | All DAX measures |

---

## 🧮 DAX Measures

| Measure | Definition |
|---------|-----------|
| Total Sales | Sum of Sales |
| Total Profit | Sum of Profit |
| Profit Margin % | Total Profit ÷ Total Sales |
| Average Discount % | Average of Discount |
| Total Orders | Distinct count of Order ID |
| Total Customers | Distinct count of customers |
| Average Order Value | Total Sales ÷ Total Orders |

---

## 🛠️ Tools Used

| Tool | How it was used |
|------|-----------------|
| **Power BI** | Star-schema data model, DAX measures, and a 4-page interactive report (KPI cards, combo, bar, column, donut and map visuals, slicers, cross-filtering) |
| **SQL (MySQL)** | Data quality checks, KPI validation and the analysis behind each dashboard page. All queries are in [`sql/retail_sales_analysis.sql`](sql/retail_sales_analysis.sql) |
| **Excel** | Reviewing and preparing the source CSV data |

---

## 🗄️ SQL Analysis

The full script ([`sql/retail_sales_analysis.sql`](sql/retail_sales_analysis.sql)) creates the table, loads the CSV (Latin-1, `M/D/YYYY` dates) and answers the business question behind each dashboard page.

| Dashboard page | SQL analysis |
|----------------|--------------|
| Data checks | Row count, date range, failed date parsing, duplicate rows |
| Executive Overview | Headline KPIs, sales and profit by category, monthly trend, seasonality, year-over-year growth (`LAG`) |
| Sales & Product | Sub-category margin, loss-making sub-categories, Top 10 products, discount-band impact on profit |
| Customer | Segment summary, Top 10 customers by sales and by profit |
| Regional | Region summary, region × category, Top 10 states by profit, loss-making states, Top 10 cities, ship-mode performance |

**Example: headline KPIs**

```sql
SELECT ROUND(SUM(sales), 2)                          AS total_sales,
       ROUND(SUM(profit), 2)                         AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
       ROUND(AVG(discount) * 100, 2)                 AS avg_discount_pct,
       COUNT(DISTINCT order_id)                      AS total_orders,
       COUNT(DISTINCT customer_id)                   AS total_customers,
       ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM retail_sales;
```

**Example: year-over-year growth**

```sql
WITH yearly AS (
    SELECT YEAR(order_date) AS yr, SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY YEAR(order_date)
)
SELECT yr,
       ROUND(total_sales, 2) AS total_sales,
       ROUND((total_sales - LAG(total_sales) OVER (ORDER BY yr))
             / LAG(total_sales) OVER (ORDER BY yr) * 100, 2) AS yoy_growth_pct
FROM yearly
ORDER BY yr;
```

---

## 📁 Repository Structure

```
Retail-Sales-Analytics-Dashboard/
├── README.md
├── data/        Retail_Sales_Analytics_Dashboard.csv
├── sql/         retail_sales_analysis.sql
├── dashboard/   Retail_Sales_Dashboard.pbix
├── docs/        Project report (PDF + Word)
└── images/      Data model + 4 dashboard screenshots
```

## ▶️ How to Open

1. Download or clone this repository.
2. Open `dashboard/Retail_Sales_Dashboard.pbix` in **Power BI Desktop**.
3. If prompted, point the data source to `data/Retail_Sales_Analytics_Dashboard.csv`.
4. Use the Year, Category, Segment and Region slicers to explore.

---

## 👤 Author

**Syed Ubedullah Basha** · Data Analyst | Power BI Developer | SQL Developer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://linkedin.com/in/syed-ubedullah-basha)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/syed-ubedullah)
[![Email](https://img.shields.io/badge/Email-D14836?style=flat&logo=gmail&logoColor=white)](mailto:syedubedullahbasha@gmail.com)

⭐ If you found this project useful, consider giving it a star!
