# ====Product--Supplier--Category====


# Vetex Suppliers Collection
select CONVERT(SupplierID, char) as _key,
       'Suppliers'               as _type,
       'Suppliers'               as _src,
       CompanyName               as _search,
       SupplierID,
       CompanyName,
       ContactName,
       ContactTitle,
       Address,
       City,
       Region,
       PostalCode,
       Country,
       Phone,
       Fax,
       HomePage
from Suppliers
;


# Vetex Categories Collection
select CONVERT(CategoryID, char) as _key,
       'Categories'              as _type,
       'Categories'              as _src,
       CategoryName            as _search,
       CategoryID,
       CategoryName,
       Description,
       Picture
from Categories;

# Vetex Products Collection
select CONVERT(ProductID, char) as _key,
       'Products'               as _type,
       'Products'               as _src,
       ProductName            as _search,
       ProductID,
       ProductName,
       SupplierID,
       CategoryID,
       QuantityPerUnit,
       UnitPrice,
       UnitsInStock,
       UnitsOnOrder,
       ReorderLevel,
       Discontinued
from Products;


# Edge Orders
select CONVERT(OrderID, char) as _key,
       'Orders'               as _type,
       'Orders'               as _src,
       OrderID                as _search,
       OrderID,
       CustomerID,
       EmployeeID,
       OrderDate,
       RequiredDate,
       ShippedDate,
       ShipVia,
       Freight,
       ShipName,
       ShipAddress,
       ShipCity,
       ShipRegion,
       ShipPostalCode,
       ShipCountry
from Orders
;


#Vetex Shippers
select CONVERT(ShipperID, char) as _key,
       'Shippers'               as _type,
       'Shippers'               as _src,
       CompanyName              as _search,
       ShipperID,
       CompanyName,
       Phone
from Shippers
;

# Vetex Customers
select CONVERT(CustomerID, char) as _key,
       'Customers'               as _type,
       'Customers'               as _src,
       CompanyName               as _search,
       CustomerID,
       CompanyName,
       ContactName,
       ContactTitle,
       Address,
       City,
       Region,
       PostalCode,
       Country,
       Phone,
       Fax
FROM Customers
;


# Vetex Employees
select CONVERT(EmployeeID, char)        as _key,
       'Employees'                      as _type,
       'Employees'                      as _src,
       concat(FirstName, ' ', LastName) as _search,
       EmployeeID,
       LastName,
       FirstName,
       Title,
       TitleOfCourtesy,
       BirthDate,
       HireDate,
       Address,
       City,
       Region,
       PostalCode,
       Country,
       HomePhone,
       Extension,
       Photo,
       Notes,
       ReportsTo,
       PhotoPath,
       Salary
from Employees
;
#Vetex Territories
select CONVERT(TerritoryID, char) as _key,
       'Territories'              as _type,
       'Territories'              as _src,
       TerritoryDescription       as _search,
       TerritoryID,
       TerritoryDescription,
       RegionID
from Territories
;


# Vetex Region
select CONVERT(RegionID, char) as _key,
       'Region'                as _type,
       'Region'                as _src,
       RegionDescription       as _search,
       RegionID,
       RegionDescription
FROM Region
;


# Edge product --> supplier ProductSupplier
select CONCAT_WS('/', 'Products', ProductID)   as _from,
       CONCAT_WS('/', 'Suppliers', SupplierID) as _to,
       'ProductSupplier'                       as _type,
       'Products'                              as _src,
       CONCAT_WS('-', ProductID, SupplierID)   as _key
from Products
;
# Edge product --> category ProductCategory
select CONCAT_WS('/', 'Products', ProductID)    _from,
       CONCAT_WS('/', 'Categories', CategoryID) _to,
       'ProductCategory'                     as _type,
       'Products'                            as _src,
       CONCAT_WS('-', ProductID, CategoryID) as _key
from Products
;

# Edge OrderDetails (Orders -- Products) OrderProduct
select CONCAT_WS('-', OrderID, ProductID)    as _key,
       CONCAT_WS('/', 'Orders', OrderID)     as _from,
       CONCAT_WS('/', 'Products', ProductID) as _to,
       'OrderProduct'                        as _type,
       'OrderDetails'                        as _src,
       OrderID,
       ProductID,
       UnitPrice,
       Quantity,
       Discount
from OrderDetails
;


# Edge Order --> Customer OrderCustomer
select CONCAT_WS('-', OrderID, CustomerID) as  _key,
       CONCAT_WS('/', 'Orders', OrderID)       _from,
       CONCAT_WS('/', 'Customers', CustomerID) _to,
       'OrderCustomer'                     as  _type,
       'Orders'                            as  _src,
       OrderID,
       CustomerID,
       OrderDate,
       RequiredDate
from Orders
;

# Edge Order --> Shipper OrderShipper
select CONCAT_WS('-', OrderID, ShipVia)    as _key,
       CONCAT_WS('/', 'Orders', OrderID)   as _from,
       CONCAT_WS('/', 'Shippers', ShipVia) as _to,
       'OrderShipper'                      as _type,
       'Orders'                            as _src,
       OrderID,
       ShipVia,
       ShippedDate,
       Freight,
       ShipName,
       ShipAddress,
       ShipCity,
       ShipRegion,
       ShipPostalCode,
       ShipCountry
from Orders
;


# Edge Orders --> Employee OrderEmployee
select CONCAT_WS('-', OrderID, EmployeeID)     as _key,
       CONCAT_WS('/', 'Orders', OrderID)       as _from,
       CONCAT_WS('/', 'Employees', EmployeeID) as _to,
       'OrderEmployee'                         as _type,
       'Orders'                                as _src,
       OrderID,
       EmployeeID
from Orders
;

# (Emp --> Emp) ReportTo
select CONCAT_WS('-', EmployeeID, ReportsTo)   as _key,
       CONCAT_WS('/', 'Employees', EmployeeID) as _from,
       CONCAT_WS('/', 'Employees', ReportsTo)  as _to,
       'ReportTo'                              as _type,
       'Employees'                             as _src,
       EmployeeID,
       ReportsTo
from Employees
where ReportsTo is not null
;

# Edge EmployeeTerritories(Emp --> Territory) EmployeeTerritory
select CONCAT_WS('-', EmployeeID, TerritoryID)    as _key,
       CONCAT_WS('/', 'Employees', EmployeeID)    as _from,
       CONCAT_WS('/', 'Territories', TerritoryID) as _to,
       'EmployeeTerritory'                        as _type,
       'EmployeeTerritories'                      as _src,
       EmployeeID,
       TerritoryID
from EmployeeTerritories
;


# Edge Territories-->Region TerritoryRegion
select CONCAT_WS('-', TerritoryID, RegionID)      as _key,
       CONCAT_WS('/', 'Territories', TerritoryID) as _from,
       CONCAT_WS('/', 'Region', RegionID)         as _to,
       'TerritoryRegion'                          as _type,
       'Territories'                              as _src,
       TerritoryID,
       TerritoryDescription,
       RegionID
from Territories
;