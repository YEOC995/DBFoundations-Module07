--*************************************************************************--
-- Title: Assignment07
-- Author: Carolyn Yeo
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2020-18-08,Carolyn Yeo,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_CarolynYeo')
	 Begin 
	  Alter Database [Assignment07DB_CarolynYeo] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_CarolynYeo;
	 End
	Create Database Assignment07DB_CarolynYeo;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_CarolynYeo;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5 pts): What function can you use to show a list of Product names, 
-- and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!
/*
(1) SELECT ProductName, UnitPrice FROM vProducts;
(2) SELECT ProductName, FORMAT (UnitPrice, 'C', 'en-US') AS 'UnitPrice' FROM vProducts;

*/
-- <Put Your Code Here> --

SELECT 
	ProductName, 
	FORMAT (UnitPrice, 'C', 'en-US') AS 'UnitPrice' 
FROM vProducts;
go

-- Question 2 (10 pts): What function can you use to show a list of Category and Product names, 
-- and the price of each product, with the price formatted as US dollars?
-- Order the result by the Category and Product!
/*
(1) SELECT CategoryName, ProductName, UnitPrice FROM vProducts;
(2) SELECT CategoryName, ProductName, UnitPrice FROM vProducts AS P INNER JOIN vCategories AS C ON C.CategoryID = P.CategoryID;
(3) SELECT CategoryName, ProductName, FORMAT (UnitPrice, 'C', 'en-US') AS UnitPrice FROM vProducts AS P INNER JOIN vCategories AS C ON C.CategoryID = P.CategoryID;
(4) SELECT CategoryName, ProductName, FORMAT (UnitPrice, 'C', 'en-US') AS UnitPrice FROM vProducts AS P INNER JOIN vCategories AS C ON C.CategoryID = P.CategoryID ORDER BY CategoryName, ProductName;

*/

-- <Put Your Code Here> --
SELECT 
	CategoryName, 
	ProductName, 
	FORMAT (UnitPrice, 'C', 'en-US') AS UnitPrice 
	FROM vProducts AS P 

INNER JOIN vCategories AS C ON C.CategoryID = P.CategoryID

ORDER BY CategoryName, ProductName;
go

-- Question 3 (10 pts): What function can you use to show a list of Product names, 
-- each Inventory Date, and the Inventory Count, with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!

/*
(1) SELECT ProductName, InventoryDate, [Count] FROM vInventories;
(2) SELECT ProductName, InventoryDate, [Count] FROM vInventories AS I INNER JOIN vProducts AS P ON P.ProductID = I.ProductID;
(3) SELECT ProductName, InventoryDate, [Count] FROM vInventories AS I INNER JOIN vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, InventoryDate, [Count];
(4) SELECT ProductName, [InventoryDate] = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM vInventories AS I 
	INNER JOIN vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, MONTH(InventoryDate), [Count];

*/

-- <Put Your Code Here> --
Select * From vInventories;
go

SELECT 
	ProductName, 
	[InventoryDate] = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate),
	[Count] 
	
FROM vInventories AS I 

INNER JOIN vProducts AS P ON P.ProductID = I.ProductID 

ORDER BY ProductName, MONTH(InventoryDate), [Count];

go

-- Question 4 (10 pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

/*
SELECT Statement:
(1) SELECT ProductNames, InventoryDate, [Count] FROM vInventories;
(2) SELECT ProductName, InventoryDate, [Count] FROM vInventories AS I INNER JOIN vProducts AS P ON P.ProductID = I.ProductID;
(3) SELECT ProductName, InventoryDate, [Count] FROM vInventories AS I INNER JOIN vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, InventoryDate, [Count];
(4)SELECT ProductName, InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM vInventories AS I 
	INNER JOIN vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, InventoryDate, [Count];

(5) SELECT ProductName, InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM vInventories AS I 
	INNER JOIN vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, MONTH(InventoryDate), [Count];
*/

--<Select Code here>--

SELECT 
	ProductName, 
	InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), 
	[Count] 
FROM vInventories AS I 
	
INNER JOIN vProducts AS P ON P.ProductID = I.ProductID 

ORDER BY ProductName, MONTH(InventoryDate), [Count];

GO

/*
VIEW:
(1) CREATE VIEW vProductInventories WITH SCHEMABINDING AS (SELECT ProductName, InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM vInventories AS I 
	INNER JOIN vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, MONTH(InventoryDate), [Count]);

(2) CREATE VIEW vProductInventories WITH SCHEMABINDING AS (SELECT TOP 100000000 ProductName, InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM dbo.vInventories AS I 
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID ORDER BY ProductName, MONTH(InventoryDate), [Count]);
*/


-- <Put Your Code Here> --

CREATE 
VIEW vProductInventories 
WITH SCHEMABINDING 
	AS 
	(SELECT TOP 100000000
		ProductName, 
		InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), 
		[Count] 
	FROM dbo.vInventories AS I 
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID 
	
	ORDER BY ProductName, MONTH(InventoryDate), [Count]);
go

-- Check that it works: Select * From vProductInventories;
SELECT * FROM vProductInventories;

go

-- Question 5 (15 pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?
/*
SELECT Statement:
(1) SELECT CategoryName, InventoryDate, [Count] FROM dbo.vInventories;
(2) SELECT CategoryName, InventoryDate, [Count] FROM dbo.vInventories AS I INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID;
(3) SELECT CategoryName, InventoryDate, [Count] FROM dbo.vInventories AS I INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID INNER JOIN dbo.Categories AS C ON C.CategoryID = P.CategoryID;
(4) SELECT CategoryName, InventoryDate  = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM dbo.vInventories AS I 
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID INNER JOIN dbo.Categories AS C ON C.CategoryID = P.CategoryID;

(5) SELECT CategoryName, InventoryDate  = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count] FROM dbo.vInventories AS I 
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID INNER JOIN dbo.Categories AS C ON C.CategoryID = P.CategoryID ORDER BY CategoryName, MONTH(InventoryDate), [Count];

(6) SELECT CategoryName, InventoryDate  = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), SUM([Count]) AS InventoryCountByCategory FROM dbo.vInventories AS I 
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID INNER JOIN dbo.Categories AS C ON C.CategoryID = P.CategoryID GROUP BY CategoryName, InventoryDate 
	ORDER BY CategoryName, MONTH(InventoryDate), InventoryCountByCategory;

*/

-- <Select Code here> --
SELECT 
	CategoryName, 
	InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), 
	SUM([Count]) AS InventoryCountByCategory
FROM vInventories AS I 
	
INNER JOIN vProducts AS P ON P.ProductID = I.ProductID
INNER JOIN vCategories AS C ON C.CategoryID = P.CategoryID

GROUP BY CategoryName, InventoryDate
ORDER BY CategoryName, MONTH(InventoryDate), InventoryCountByCategory;

GO
/*
CREATE VIEW vCategoryInventories WITH SCHEMABINDING AS (SELECT TOP 100000000 CategoryName, InventoryDate  = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), SUM([Count]) AS InventoryCountByCategory FROM dbo.vInventories AS I 
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID INNER JOIN dbo.Categories AS C ON C.CategoryID = P.CategoryID GROUP BY CategoryName, InventoryDate 
	ORDER BY CategoryName, MONTH(InventoryDate), InventoryCountByCategory);
*/

-- <Put Your Code Here> --

CREATE 
VIEW vCategoryInventories 
WITH SCHEMABINDING 
AS (SELECT TOP 100000000
		CategoryName, 
		InventoryDate  = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), 
		SUM([Count]) AS InventoryCountByCategory 
	FROM dbo.vInventories AS I 
	
	INNER JOIN dbo.vProducts AS P ON P.ProductID = I.ProductID 
	INNER JOIN dbo.vCategories AS C ON C.CategoryID = P.CategoryID
	
	GROUP BY CategoryName, InventoryDate
	ORDER BY CategoryName, MONTH(InventoryDate), InventoryCountByCategory);

GO


-- Check that it works: Select * From vCategoryInventories;
SELECT * FROM vCategoryInventories;
go

-- Question 6 (10 pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviouMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!

/*
(1) SELECT ProductName, InventoryDate, [Count] FROM Inventories;
(2) SELECT ProductName, InventoryDate, [Count] FROM Inventories AS I INNER JOIN vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate;
(3) SELECT ProductName, InventoryDate, [Count] FROM Inventories AS I INNER JOIN vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate ORDER BY ProductName, MONTH(I.InventoryDate), [Count];
(4) SELECT ProductName, InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count], [PreviousMonthCount] FROM Inventories AS I 
	INNER JOIN vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate ORDER BY ProductName, MONTH(I.InventoryDate), [Count];

(5) SELECT ProductName, InventoryDate = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count], 
	[PreviousMonthCount] IIF(DATENAME (mm,I.InventoryDate) = 'January', 0 ,IsNull( Lag(PI.[Count]) Over (Order By ProductName,MONTH(I.InventoryDate)), 0)) FROM Inventories AS I 
	INNER JOIN vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate GROUP BY ProductName, I.InventoryDate, PI.[Count] ORDER BY ProductName, MONTH(I.InventoryDate), [Count];

--One note on this problem: Please explain the lag function more clearly if you are including this in a question. 

*/

--<Select Statement>--
SELECT 
	ProductName, 
	[InventoryDate] = DATENAME (mm,I.InventoryDate) + ' ' + DATENAME(yy,I.InventoryDate), 
	PI.[Count], 
	[PreviousMonthCount] = IIF(DATENAME (mm,I.InventoryDate) = 'January', 0 ,IsNull( Lag(PI.[Count]) Over (Order By ProductName,MONTH(I.InventoryDate)), 0))

FROM Inventories AS I 
	
INNER JOIN vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate 

GROUP BY ProductName, I.InventoryDate, PI.[Count]
ORDER BY ProductName, MONTH(I.InventoryDate);

/*
View:

(1) CREATE VIEW vProductInventoriesWithPreviouMonthCounts WITH SCHEMABINDING AS (SELECT TOP 100000000 ProductName, [InventoryDate] = DATENAME (mm,InventoryDate) + ' ' + DATENAME(yy,InventoryDate), [Count], 
	[PreviousMonthCount] = IIF(DATENAME (mm,I.InventoryDate) = 'January', 0 ,IsNull( Lag(PI.[Count]) Over (Order By ProductName,MONTH(I.InventoryDate)), 0)) FROM dbo.Inventories AS I 
	INNER JOIN dbo.vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate GROUP BY ProductName, I.InventoryDate, PI.[Count] ORDER BY ProductName, InventoryDate, [Count];

*/

-- <Put Your Code Here> --
CREATE
VIEW vProductInventoriesWithPreviouMonthCounts 
WITH SCHEMABINDING 
	AS (SELECT TOP 10000000
	ProductName, 
	[InventoryDate] = DATENAME (mm,I.InventoryDate) + ' ' + DATENAME(yy,I.InventoryDate), 
	PI.[Count], 
	[PreviousMonthCount] = IIF(DATENAME (mm,I.InventoryDate) = 'January', 0 ,IsNull( Lag(PI.[Count]) Over (Order By ProductName,MONTH(I.InventoryDate)), 0))

FROM dbo.Inventories AS I 
	
INNER JOIN dbo.vProductInventories AS PI ON PI.InventoryDate = I.InventoryDate 

GROUP BY ProductName, I.InventoryDate, PI.[Count]
ORDER BY ProductName, MONTH(I.InventoryDate));

go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;
SELECT * FROM vProductInventoriesWithPreviouMonthCounts;
go

-- Question 7 (15 pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the Product, Date, and Count!

/*
SELECT Statement:

(1) SELECT ProductName, [InventoryDate], [Count], [PreviousMonthCount] FROM vProductInventoriesWithPreviousMonthCounts;

(2) SELECT ProductName, [InventoryDate], [Count], [PreviousMonthCount], [QtyChangeKPI] = CASE WHEN [Count] > [PreviousMonthCount] THEN 1
	WHEN [Count] = [PreviousMonthCount] THEN 0 WHEN [Count] < [PreviousMonthCount] THEN -1 FROM vProductInventoriesWithPreviousMonthCounts;

(3) SELECT ProductName, [InventoryDate], [Count], [PreviousMonthCount], [QtyChangeKPI] = CASE WHEN [Count] > [PreviousMonthCount] THEN 1
	WHEN [Count] = [PreviousMonthCount] THEN 0 WHEN [Count] < [PreviousMonthCount] THEN -1 END FROM vProductInventoriesWithPreviousMonthCounts
	ORDER BY ProductName, [InventoryDate], [Count];

*/

-- <Select statement> --
SELECT 
	ProductName,
	[InventoryDate], 
	[Count], 
	[PreviousMonthCount], 
	[QtyChangeKPI] = CASE WHEN [Count] > [PreviousMonthCount] THEN 1
						  WHEN [Count] = [PreviousMonthCount] THEN 0 
						  WHEN [Count] < [PreviousMonthCount] THEN -1 
						  END
FROM vProductInventoriesWithPreviouMonthCounts
ORDER BY ProductName, MONTH (InventoryDate), [Count]
;

GO
/*
Create View:
(1) CREATE VIEW vProductInventoriesWithPreviousMonthCountsWithKPIs WITH SCHEMABINDING AS (SELECT TOP 100000000 ProductName, [InventoryDate], [Count], [PreviousMonthCount], [QtyChangeKPI] = CASE WHEN [Count] > [PreviousMonthCount] THEN 1
	WHEN [Count] = [PreviousMonthCount] THEN 0 WHEN [Count] < [PreviousMonthCount] THEN -1 END FROM vProductInventoriesWithPreviousMonthCounts
	ORDER BY ProductName, [InventoryDate], [Count];

*/

-- <Put Your Code Here> --
CREATE 
VIEW vProductInventoriesWithPreviousMonthCountsWithKPIs 
WITH SCHEMABINDING 
AS (SELECT TOP 100000000 
		ProductName, 
		[InventoryDate], 
		[Count], 
		[PreviousMonthCount], 
		[QtyChangeKPI] = CASE WHEN [Count] > [PreviousMonthCount] THEN 1
						  WHEN [Count] = [PreviousMonthCount] THEN 0 
						  WHEN [Count] < [PreviousMonthCount] THEN -1 
						  END
	FROM dbo.vProductInventoriesWithPreviouMonthCounts
	ORDER BY ProductName, MONTH(InventoryDate), [Count]);


go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
SELECT * FROM vProductInventoriesWithPreviousMonthCountsWithKPIs;
go

-- Question 8 (25 pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use you
-- ProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.

/*
SELECT Statement:
(1) SELECT ProductName, InventoryDate, [Count], [PreviousMonthCount], [QtyChangeKPI] FROM vProductInventoriesWithPreviousMonthCountsWithKPIs;

(2) SELECT ProductName, InventoryDate, [Count], [PreviousMonthCount], [QtyChangeKPI] FROM vProductInventoriesWithPreviousMonthCountsWithKPIs ORDER BY YEAR(Cast(InventoryDate as Date));

*/
SELECT 
	ProductName, 
	InventoryDate, 
	[Count], 
	[PreviousMonthCount], 
	[QtyChangeKPI] 
	
FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
ORDER BY YEAR(Cast(InventoryDate as Date));

GO

--Adding one where clause to see if the code works:
SELECT 
	ProductName, 
	InventoryDate, 
	[Count], 
	[PreviousMonthCount], 
	[QtyChangeKPI] 
	
FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
WHERE [QtyChangeKPI] = 1
ORDER BY YEAR(Cast(InventoryDate as Date));

GO

--WHERE clause works

/*

Function for value of 1:

(1) Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs (@QtyChangeKPI int) RETURNS TABLE AS RETURN 
	(SELECT ProductName, InventoryDate, [Count], [PreviousMonthCount], [QtyChangeKPI] FROM vProductInventoriesWithPreviousMonthCountsWithKPIs);

(2) Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs (@QtyChangeKPI int) RETURNS TABLE AS RETURN 
	(SELECT TOP 100000000 ProductName, InventoryDate, [Count], [PreviousMonthCount], [QtyChangeKPI] FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
	ORDER BY YEAR(Cast(InventoryDate as Date)));

(3) Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs (@QtyChangeKPI int) RETURNS TABLE AS RETURN 
	(SELECT TOP 100000000 ProductName, InventoryDate, [Count], [PreviousMonthCount], [QtyChangeKPI] FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
	WHERE [QtyChangeKPI] = @QtyChangeKPI ORDER BY YEAR(Cast(InventoryDate as Date)))

*/
-- <Put Your Code Here> --
Create 
Function fProductInventoriesWithPreviousMonthCountsWithKPIs (@QtyChangeKPI INT)
RETURNS TABLE
AS
RETURN (SELECT TOP 100000000 
			ProductName, 
			InventoryDate, 
			[Count], 
			[PreviousMonthCount], 
			[QtyChangeKPI]
		FROM dbo.vProductInventoriesWithPreviousMonthCountsWithKPIs
		WHERE [QtyChangeKPI] = @QtyChangeKPI
		ORDER BY YEAR(Cast(InventoryDate as Date)));

go

--Could have made code shorter with a select * from the view table, but decided to practice and list out columns


/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
GO

Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
GO

Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);

go

/***************************************************************************************/