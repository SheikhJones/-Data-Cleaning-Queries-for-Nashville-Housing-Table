-- Cleaning Data in SQL Queries

Select * from NashvilleHousing

-- Select all columns from the NashvilleHousing table
SELECT *
FROM NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- Select SaleDateConverted and convert SaleDate to Date format
SELECT saleDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHousing

-- Update SaleDate column to the standardized Date format
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- If it doesn't Update properly, alter the table and add SaleDateConverted Date column
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

-- Update SaleDateConverted column
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

-- Select all columns from NashvilleHousing where PropertyAddress is null, ordered by ParcelID
SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

-- Select data to populate PropertyAddress from the table where it is null
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

-- Update PropertyAddress with populated data
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- Select PropertyAddress from NashvilleHousing
SELECT PropertyAddress
FROM NashvilleHousing

-- Select Address and City columns by breaking down PropertyAddress
SELECT
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM NashvilleHousing

-- Alter the table and add PropertySplitAddress and PropertySplitCity columns
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

-- Update PropertySplitAddress column
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

-- Alter the table and add PropertySplitCity column
ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

-- Update PropertySplitCity column
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- Select all columns from NashvilleHousing
SELECT *
FROM NashvilleHousing

-- Select OwnerAddress from NashvilleHousing
SELECT OwnerAddress
FROM NashvilleHousing

-- Select OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState by parsing OwnerAddress
SELECT
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as OwnerSplitAddress,
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as OwnerSplitCity,
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as OwnerSplitState
FROM NashvilleHousing

-- Alter the table and add OwnerSplitAddress column
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

-- Update OwnerSplitAddress column
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

-- Alter the table and add OwnerSplitCity column
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

-- Update OwnerSplitCity column
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

-- Alter the table and add OwnerSplitState column
ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

-- Update OwnerSplitState column
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Select all columns from NashvilleHousing
SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

-- Show distinct values and their counts in SoldAsVacant column
SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- Update SoldAsVacant column to replace Y with Yes and N with No
UPDATE NashvilleHousing
SET SoldAsVacant = CASE
                     WHEN SoldAsVacant = 'Y' THEN 'Yes'
                     WHEN SoldAsVacant = 'N' THEN 'No'
                     ELSE SoldAsVacant
                  END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

-- Create a Common Table Expression (CTE) with row numbers for duplicate rows
WITH RowNumCTE AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
           ORDER BY UniqueID
         ) row_num
  FROM NashvilleHousing
)
-- Select all columns from the CTE where row number is greater than 1
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- Select all columns from NashvilleHousing
SELECT *
FROM NashvilleHousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

-- Select all columns from NashvilleHousing
SELECT *
FROM NashvilleHousing

-- Alter the table and drop specified columns
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- extra query to understand data cleaning  

-- Remove rows with NULL values in specific columns
DELETE FROM NashvilleHousing
WHERE PropertyAddress IS NULL OR SaleDate IS NULL;

-- Remove duplicates based on a subset of columns
WITH DuplicateCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, SaleDate ORDER BY UniqueID) AS row_num
    FROM NashvilleHousing
)
DELETE FROM DuplicateCTE
WHERE row_num > 1;

-- Remove leading and trailing whitespaces from columns
UPDATE NashvilleHousing
SET PropertyAddress = TRIM(PropertyAddress),
    OwnerAddress = TRIM(OwnerAddress);

-- Identify and handle outliers in SalePrice (e.g., remove values below a certain threshold)
DELETE FROM NashvilleHousing
WHERE SalePrice < 0;

-- Update SalePrice to a specific value for outliers
UPDATE NashvilleHousing
SET SalePrice = 1000000
WHERE SalePrice > 1000000;

-- Convert SalePrice to decimal with two decimal places
UPDATE NashvilleHousing
SET SalePrice = CAST(SalePrice AS DECIMAL(10, 2));


SELECT *
FROM NashvilleHousing

