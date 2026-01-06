# Real Estate Data Analytics Project
## Analyzing property listings to understand pricing trends, affordability, and market insights using Snowflake, Snow SQL, SQL Python, Google Sheets, Bright data

## Project Overview

The goal of the project is to **analyze property listing data** and answer common **real-world business questions** related to the **real estate market in Poland**.

The project workflow:
- Data ingestion
- Data cleaning and transformation
- Analytical querying
- Visualization and insights

---

## Data Source
The data is based on **property listings from the Otodom website**:

Data was collected using the **Bright Data platform** the same approach can be applied to **any similar dataset**.

---

## Tools & Technologies Used
- **Snowflake** – Data warehouse and SQL analytics
- **SQL** – Data loading, transformation, and analysis
- **Python** – Data enrichment (geocoding, automation)
- **Google Sheets** – Translation at scale using Google APIs
- **Bright Data** – Web data extraction
- **SnowSQL** – Snowflake command-line tool

---

## Project Workflow
1. Scrape property listing data from Otodom using Bright Data  
2. Load raw data into Snowflake  
3. Flatten nested JSON data using SQL  
4. Transformed data using Python (geocoding)  
5. Translate text using Google Sheets  
6. Transform and model data in Snowflake  
7. Answer business questions using SQL  
8. Build dashboards and visual insights  

---
### **Steps**

### **Step 1 – Data Ingestion & Flattening**
- Scrape data using Bright Data  
- Load JSON data into Snowflake  
- Flatten semi-structured data using SQL  

### **Step 2 – Data Transformation**
- Clean and enrich data using SQL  
- Convert location coordinates into address fields using Python  
- Translate non-English text using Google Sheets  

### **Step 3 – Data Analysis & Reporting**
- Perform analytical queries using SQL  
- Answer real business questions about the property market  
- Build charts and dashboards  

---

## Business Questions Answered
Some of the questions answered in this project include:
- Average rental prices by city and apartment size  
- Affordable neighborhoods for different budgets  
- Rental vs sale price comparison  
- Apartment size expectations for a given rent  
- Distribution of private vs business listings  
- High-end and budget-friendly areas in Warsaw  

---

## Learnings
- Work with semi-structured data in Snowflake  
- Design end-to-end analytics pipelines  
- Combine SQL with Python and Google Sheets  
