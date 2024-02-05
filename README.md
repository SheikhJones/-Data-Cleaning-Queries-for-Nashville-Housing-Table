# -Data-Cleaning-Queries-for-Nashville-Housing-Table
Title: In-Depth Data Cleaning Queries for Nashville Housing Table

Description:

This set of SQL queries provides a detailed and comprehensive data cleaning process for the Nashville Housing table, focusing on enhancing data quality and consistency. Each query addresses specific aspects of data cleaning, ensuring a thorough transformation of the dataset.

Handling NULL Values:

Identifies and removes rows with NULL values in crucial columns (PropertyAddress and SaleDate).
Ensures data integrity by eliminating incomplete records.
Removing Duplicates Based on a Subset:

Utilizes a Common Table Expression (CTE) to identify and remove duplicate records.
Duplicates are determined based on a subset of columns (ParcelID and SaleDate), preserving data accuracy.
Whitespace Cleanup:

Removes leading and trailing whitespaces from address-related columns (PropertyAddress and OwnerAddress).
Enhances consistency and readability in address fields.
Handling Outliers in SalePrice:

Identifies and removes outliers in the SalePrice column (values below 0).
Adjusts extreme SalePrice values to a specified threshold for improved data distribution.
Converting SalePrice to Decimal:

Converts the SalePrice column to a decimal format with two decimal places.
Ensures uniform data type representation for financial information.
Exploratory Extra Queries:

Explores additional queries for a deeper understanding of data cleaning.
Addresses various scenarios, including NULL handling, duplicate removal, whitespace cleanup, and outlier management.
Comprehensive Result Analysis:

Performs a final SELECT operation to showcase the cleaned Nashville Housing dataset.
Allows for a thorough examination of the data after applying the cleaning queries.
These queries collectively form a robust data cleaning pipeline, ensuring the Nashville Housing dataset is consistent, accurate, and well-prepared for subsequent analyses or applications.
