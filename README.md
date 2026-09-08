# Sales Pipeline Revenue Analysis

## 📌 Project Overview

This project analyzes a sales pipeline dataset containing 8,800 sales opportunities to understand sales performance, revenue trends, deal stages, and business performance.

The project uses **Excel, MySQL, and Power BI** to clean, analyze, and visualize the data.

## 🎯 Objectives

- Analyze overall sales pipeline performance
- Calculate key sales KPIs such as revenue and win rate
- Understand Won, Lost, Engaging, and Prospecting opportunities
- Identify high-performing sales agents
- Analyze revenue across products and sectors
- Identify monthly revenue trends
- Provide insights that can support business decision-making

## 🛠️ Tools & Technologies

- **Excel** – Data cleaning, exploration, and initial analysis
- **MySQL** – Data validation, cleaning, querying, and business analysis
- **Power BI** – Interactive dashboard and data visualization

## 📊 Dataset

The dataset contains **8,800 sales opportunities** with information including:

- Opportunity ID
- Sales Agent
- Product
- Account
- Deal Stage
- Engage Date
- Close Date
- Close Value

## 🧹 Data Cleaning

The data was checked and prepared before analysis.

Key checks included:

- Missing values
- Duplicate opportunity IDs
- Data types
- Date fields
- Deal-stage values
- Revenue values
- Data consistency

## 🗄️ SQL Analysis

MySQL was used to perform business-focused analysis including:

- Total opportunities
- Won and Lost opportunities
- Win rate
- Total revenue
- Average deal value
- Revenue by sales agent
- Revenue by product
- Revenue by sector
- Opportunities by deal stage
- Monthly revenue trends
- Sales-agent performance

Advanced SQL concepts used include:

- `GROUP BY`
- `ORDER BY`
- Aggregate functions
- `CASE WHEN`
- `HAVING`
- `JOIN`
- Subqueries
- CTEs
- Window functions

## 📈 Power BI Dashboard

The Power BI dashboard provides an interactive view of the sales pipeline.

### Key Dashboard Metrics

- Total Opportunities
- Won Opportunities
- Lost Opportunities
- Win Rate
- Total Revenue

### Key Visualizations

- Won vs Lost Opportunities
- Monthly Revenue Trend
- Revenue by Sales Agent
- Opportunities by Deal Stage
- Revenue by Sector

### Filters

- Deal Stage
- Product
- Close Date

## 💡 Key Business Questions

The analysis focuses on questions such as:

1. How many opportunities are in the sales pipeline?
2. What is the overall win rate?
3. Which sales agents generate the most revenue?
4. Which sectors contribute the most revenue?
5. Which products perform best?
6. How does revenue change over time?
7. Where are opportunities being lost in the sales pipeline?

## 📁 Project Structure

```text
Sales-Pipeline-Revenue-Analysis/
│
├── data/
│   ├── sales_pipeline.csv
│   ├── accounts.csv
│   ├── products.csv
│   └── sales_teams.csv
│
├── sql/
│   └── sales_pipeline_analysis.sql
│
├── excel/
│   └── sales_pipeline_analysis.xlsx
│
├── powerbi/
│   └── sales_pipeline_dashboard.pbix
│
├── images/
│   └── dashboard.png
│
└── README.md
