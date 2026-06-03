# Retail Sales Data Cleaning & Business Intelligence Analysis

## 📌 Project Overview
This project simulates real-world database maintenance and analytical reporting inside SQL Server Management Studio (SSMS). It demonstrates how to safely teardown sandboxed environments, replicate production schemas, inject controlled missing data (null values) for pipeline testing, and run advanced business intelligence queries.

## 🛠️ Tech Stack & Tools
* **Database Engine:** Microsoft SQL Server (T-SQL)
* **Interface:** SQL Server Management Studio (SSMS)
* **Methodologies:** Common Table Expressions (CTEs), Window Functions, Database Views

## 🧹 Key Features Implemented
* **Robust Environment Setup:** Drop-if-exists logic to dynamically reset testing spaces without table locks.
* **Controlled Data Anomaly Testing:** Strategic generation of `NULL` fields across critical financial attributes using mathematical modulus constraints.
* **Data Verification Blocks:** Validation scripts leveraging analytical conditional aggregates (`SUM(CASE WHEN...)`) to check data integrity prior to code execution.

## 📊 Business Intelligence Insights Added
* **Dynamic Item Performance:** Leveraging `DENSE_RANK() OVER (PARTITION BY...)` to capture top product assets dynamically within distinct operational categories.
* **Customer Lifetime Segments:** Strategic categorization models dividing consumer records into explicit commercial categories based on volume metrics.
* **Daily Performance Variance (CTE):** Advanced transactional analysis evaluating individual operational dates against baseline standard averages.
*
