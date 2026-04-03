# Retail-Sales-Warehouse-Analytics

## 🚀 Project Overview
This project demonstrates a complete data analytics lifecycle. I transformed raw relational data into a structured **Star Schema** to perform deep-dive analysis on customer behavior, product performance, and business growth trends.

## 🛠️ Technical Architecture & Design
* **Data Modeling:** Implemented a **Star Schema** using `fact_sales`, `dim_customers`, and `dim_products`.
* **Advanced SQL:** Utilized **Window Functions** (Running Totals, Moving Averages), **CTEs**, and **SQL Views** for automated reporting.
* **Database Design:** Applied Data Warehousing principles including Date Exploration and Measure Aggregation.

## 📈 Key Analysis Features
### 1. Customer Intelligence (`Report_Customers.sql`)
Developed a comprehensive **SQL View** that calculates:
* **Recency & Lifespan:** Months since last purchase and total duration of customer relationship.
* **VIP Segmentation:** Logic-based categorization (VIP, Regular, New) based on spending thresholds.
* **Demographic Analysis:** Age-group grouping and average monthly spend per customer.

### 2. Sales Performance (`Analysis.sql`)
* **Cumulative Growth:** Analyzed monthly running totals to visualize revenue scaling.
* **Product Cost Segmentation:** Classified products into cost ranges (e.g., "Below 100", "Above 1000") to identify price-point demand.

## 💡 Strategic Business Insights
* **Retention Focus:** The segmentation logic identified a "VIP" group that contributes a disproportionate amount of revenue, suggesting a focus on loyalty programs.
* **Market Demand:** Product cost segmentation revealed that products in the "₹100 - ₹500" range have the highest turnover, while the "Above ₹1,000" segment drives premium margins.
* **Growth Scaling:** Cumulative analysis shows a steady MoM growth, with specific "Peak" months identified for seasonal inventory planning.

## 📁 Repository Structure
* **Data/**: Source CSV files for Fact and Dimension tables.
* **Scripts/**: SQL files containing core analysis and reporting views.
* **Documentation/**: Includes a **Project Roadmap** and **Technical Sketches** outlining the ETL process.

## ⚙️ How to Deploy
1. Import CSV files from `Data/` into your SQL environment.
2. Run `Report_Customers.sql` to create the analytical views.
3. Explore `Analysis.sql` for trend insights.

---
*Note: This project showcases my ability to handle complex data relationships and translate raw code into business-ready insights.*
