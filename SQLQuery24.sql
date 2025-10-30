USE AdventureWorks2022;
GO



DELETE FROM Sales.SalesOrderHeader
WHERE OrderDate IS NULL
   OR CustomerID IS NULL;

UPDATE Sales.SalesOrderHeader
SET SubTotal = ABS(SubTotal)
WHERE SubTotal < 0;

UPDATE Sales.SalesOrderHeader
SET TaxAmt = ABS(TaxAmt)
WHERE TaxAmt < 0;

UPDATE Sales.SalesOrderHeader
SET Freight = ABS(Freight)
WHERE Freight < 0;

SELECT COUNT(*) AS CleanedOrders
FROM Sales.SalesOrderHeader
WHERE OrderDate IS NOT NULL
  AND CustomerID IS NOT NULL
  AND SubTotal >= 0
  AND TaxAmt >= 0
  AND Freight >= 0;
GO

DELETE FROM Sales.SalesOrderDetail
WHERE OrderQty IS NULL
   OR ProductID IS NULL
   OR UnitPrice IS NULL
   OR UnitPriceDiscount IS NULL;

UPDATE Sales.SalesOrderDetail
SET OrderQty = ABS(OrderQty)
WHERE OrderQty < 0;

UPDATE Sales.SalesOrderDetail
SET UnitPrice = ABS(UnitPrice)
WHERE UnitPrice < 0;

UPDATE Sales.SalesOrderDetail
SET UnitPriceDiscount = ABS(UnitPriceDiscount)
WHERE UnitPriceDiscount < 0;

UPDATE Sales.SalesOrderDetail
SET CarrierTrackingNumber = 'Not Shipped'
WHERE CarrierTrackingNumber IS NULL;

SELECT COUNT(*) AS CleanedOrderDetails
FROM Sales.SalesOrderDetail
WHERE OrderQty >= 0
  AND ProductID IS NOT NULL
  AND UnitPrice >= 0
  AND UnitPriceDiscount >= 0
  AND CarrierTrackingNumber IS NOT NULL;
GO

DELETE FROM Production.Product
WHERE ListPrice IS NULL
   OR StandardCost IS NULL;

UPDATE Production.Product
SET ListPrice = ABS(ListPrice)
WHERE ListPrice < 0;

UPDATE Production.Product
SET StandardCost = ABS(StandardCost)
WHERE StandardCost < 0;

SELECT COUNT(*) AS CleanedProducts
FROM Production.Product
WHERE ListPrice >= 0
  AND StandardCost >= 0;
GO

DELETE FROM Sales.SalesTerritory
WHERE TerritoryID IS NULL
   OR Name IS NULL;

SELECT COUNT(*) AS CleanedTerritories
FROM Sales.SalesTerritory
WHERE TerritoryID IS NOT NULL
  AND Name IS NOT NULL;
GO

IF OBJECT_ID('Sales.SalesSummary', 'U') IS NOT NULL
    DROP TABLE Sales.SalesSummary;
GO

SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalDue) AS TotalSales,
    COUNT(SalesOrderID) AS TotalOrders
INTO Sales.SalesSummary
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate);
GO

SELECT *
FROM Sales.SalesSummary
ORDER BY DATEFROMPARTS(SalesYear, SalesMonth, 1);
GO

SELECT
    (SELECT COUNT(*) FROM Sales.SalesOrderHeader) AS TotalOrders,
    (SELECT COUNT(*) FROM Sales.SalesOrderDetail) AS TotalOrderDetails,
    (SELECT COUNT(*) FROM Production.Product) AS TotalProducts,
    (SELECT COUNT(*) FROM Sales.SalesTerritory) AS TotalTerritories,
    (SELECT COUNT(*) FROM Sales.SalesSummary) AS TotalSummaryRows;
GO
