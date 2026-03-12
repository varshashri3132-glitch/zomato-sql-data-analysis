# Zomato-


# Zomato Data Analysis Using SQL

## Project Overview

This project analyzes operational data from a food delivery platform similar to Zomato to uncover insights about customer behavior, ordering trends, restaurant performance, and delivery operations.

Using MySQL, multiple datasets were integrated and analyzed to answer business questions such as identifying popular dishes, peak ordering hours, restaurant performance, and city-wise order distribution.

The project demonstrates practical SQL skills including data cleaning, joins, aggregations, and stored procedures.

---

## Business Objectives

The analysis focuses on the following areas:

* Customer behavior and ordering patterns
* Order and sales analysis
* Restaurant performance evaluation
* Rider and delivery operations
* Operational efficiency insights

---

## Dataset

The analysis uses five datasets representing different parts of the platform.

### Customers

Contains information about customers using the platform.

### Orders

The master table that connects all entities and records each order placed.

### Deliveries

Contains delivery details for each order.

### Restaurants

Includes restaurant information such as location and operating hours.

### Riders

Contains information about delivery partners.

---

## Database Setup

The project was implemented using **MySQL**.

### Data Import Methods

Two methods were used to import the datasets:

1. **Table Data Import Wizard**

   * Used for smaller datasets such as Customers, Restaurants, and Riders.

2. **Command Prompt Import**

   * Used for larger datasets such as Orders and Deliveries.

Example command used:

```
SET GLOBAL local_infile = 1;
```

Data was then imported using the `LOAD DATA` command.

---

## Data Cleaning

Data cleaning was performed to ensure consistency and usability.

### Date and Time Conversion

Some date and time attributes were stored as text. These were converted using:

```
STR_TO_DATE()
```

This function converts string values into proper date or datetime formats.

### Restaurant Opening Hours

The `opening_hours` column was split into:

* Opening Time
* Closing Time

SQL text functions used include:

* TRIM
* LEFT
* SUBSTRING
* LOCATE

---

## Key Analysis Performed

### Most Ordered Items

The analysis identified the most and least frequently ordered dishes.

**Insights**

* Chicken Biryani and Paneer Butter Masala are the most ordered items.
* Chicken Tikka is the least ordered item.

---

### Popular Order Time Slots

Order patterns were analyzed to identify peak hours.

**Insights**

* Peak ordering hours occur around **2 PM and 7 PM**
* Order volume is lowest between **11 PM and 6 AM**
* Another dip occurs around **4 PM**

---

### Customer Discount Strategy

Customers with total order values below the platform average were identified.

A **stored procedure** was created to generate a list of such customers so that promotional discounts can be offered to increase order volume.

Benefits of stored procedures:

* Reusability
* Improved performance
* Better security

---

### Restaurant Performance Analysis

Restaurants were analyzed based on total order volume.

**Insights**

* Masala Library and Bademia have the highest number of orders.
* Truffles and Empire Restaurant Café have the lowest order counts.

---

### City-wise Order Analysis

Order volumes were compared across cities.

**Insights**

* Mumbai records the highest number of orders.
* Chennai and Hyderabad show comparatively lower order volumes.

---

## Tools & Technologies

| Tool       | Purpose                                |
| ---------- | -------------------------------------- |
| MySQL      | Data storage and querying              |
| SQL        | Data analysis and querying             |
| CSV Files  | Raw dataset                            |
| PowerPoint | Project documentation and presentation |

---

## Key SQL Concepts Used

* Joins
* Aggregate functions
* Group By
* Subqueries
* Stored Procedures
* Data Cleaning Functions
* Text Functions
* Date Functions

---

## Project Structure

```
Zomato-SQL-Analysis
│
├── datasets
│   ├── customers.csv
│   ├── orders.csv
│   ├── deliveries.csv
│   ├── restaurants.csv
│   └── riders.csv
│
├── sql_queries
│   └── zomato_analysis.sql
│
├── presentation
│   └── zomato_analysis.pptx
│
└── README.md
```

---

## Project Outcome

This project demonstrates how SQL can be used to analyze operational data from a food delivery platform to uncover meaningful insights related to customer behavior, restaurant performance, and order trends.

The analysis highlights the importance of structured data querying in supporting data-driven business decisions.

