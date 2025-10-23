# Bike_store.advanced.SQL

Overview

This project represents a Bike Store database system implemented in PostgreSQL.
It is designed to simulate a realistic retail environment, covering customers, products, stores, staff, orders, and order items.
The project demonstrates intermediate-to-advanced SQL skills, including data modeling, relational design, and analytics-ready schema creation.

Database Structure

The database consists of the following tables:

Brands
Stores product brand information. Linked to products.

Categories
Groups products into logical categories. Linked to products.

Products
Stores product details such as name, brand, category, model year, and price. Linked to brands and categories.

Stores
Stores information about each physical store location.

Staffs
Stores employee details, including manager relationships and associated store. Linked to stores and orders.

Customers
Contains customer personal and contact information. Linked to orders.

Orders
Represents sales orders made by customers. Linked to stores, staff, and customers.

Order Items
Contains individual line items for each order, including product, quantity, price, and discount. Linked to orders and products.

Key SQL Features Used

Joins (INNER, LEFT, RIGHT, FULL) – Combine related tables to retrieve comprehensive datasets.

Window Functions (RANK, DENSE_RANK, ROW_NUMBER, SUM OVER) – Rank, aggregate, and calculate running totals.

Aggregate Functions (SUM, COUNT, AVG, ROUND) – Summarize key metrics like total revenue, average sales, and quantity sold.

Date Functions (DATE_TRUNC, EXTRACT, AGE) – Group and analyze data by date periods.

CTEs (Common Table Expressions) – Simplify complex queries into modular, readable blocks.

Project Setup---

Install PostgreSQL (version 14 or above recommended).

Create a new database:

CREATE DATABASE bikestore;


Set the search path or schema if using a custom schema.

Import your schema SQL files to create all tables and relationships.

Optionally, import sample data to test queries and analytics.

Use pgAdmin, DBeaver, or psql for running queries and managing the database.

CASE Statements – Implement conditional logic for categorization or status evaluation.

ORDER BY with Window Frames – Perform rolling calculations and trend analysis.


Folder Structure
/BikeStore_SQL_Project
│
├── schema/       https://drive.google.com/file/d/1XPLhR1zMvci-RpM1DgPletxC8OjxkwfC/view?usp=drive_link    
├──queries/       https://drive.google.com/file/d/1Z7-bA3uqV_2eYjC25RSKhcHqADs1g3We/view?usp=drive_link
 
