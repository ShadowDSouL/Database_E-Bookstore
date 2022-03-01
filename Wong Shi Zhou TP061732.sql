-- WONG SHI ZHOU TP061732
USE APU_E_Bookstore

-- DDL 
-- Manager Table
CREATE TABLE Manager(
ManagerID nvarchar(6) NOT NULL,
ManagerName varchar(50) NOT NULL,
ManagerContact varchar(15) UNIQUE,
CONSTRAINT PK_Manager PRIMARY KEY (ManagerID));


-- ManagerOrder Table
CREATE TABLE ManagerOrder(
OrderID nvarchar(6) NOT NULL,
ManagerID nvarchar(6) NOT NULL,
CONSTRAINT PK_ManagerOrder PRIMARY KEY (OrderID),
CONSTRAINT FK_ManagerOrder_Manager FOREIGN KEY (ManagerID) REFERENCES Manager (ManagerID));


-- Order Table
CREATE TABLE [Order](
OrderID nvarchar(6) NOT NULL,
BookID nvarchar(6) NOT NULL,
OrderQuantity int NOT NULL,
CONSTRAINT PK_Order PRIMARY KEY (BookID, OrderID),
CONSTRAINT FK_Order_Book FOREIGN KEY (BookID) REFERENCES Book (BookID),
CONSTRAINT FK_Order_ManagerOrder FOREIGN KEY (OrderID) REFERENCES ManagerOrder (OrderID),
CONSTRAINT CHECK_OrderQuantity CHECK(OrderQuantity > 0));


--BookArrived Table
CREATE TABLE BookArrived(
BookID nvarchar(6) NOT NULL,
OrderID nvarchar(6) NOT NULL,
DateArrived date NOT NULL,
ReceiveQuantity int NOT NULL,
CONSTRAINT PK_BookArrived PRIMARY KEY (BookID, OrderID, DateArrived),
CONSTRAINT FK_BookArrived_Book FOREIGN KEY (BookID) REFERENCES Book (BookID),
CONSTRAINT FK_BookArrived_Order FOREIGN KEY (OrderID) REFERENCES ManagerOrder (OrderID),
CONSTRAINT CHECK_ReceiveQuantity CHECK(ReceiveQuantity > 0));


-- DML
INSERT INTO Manager
VALUES ('MNG001', 'Bently', '012-8899776'),
	   ('MNG002', 'Kriss', '012-1023567'),
	   ('MNG003', 'Francky', '014-7893362'),
	   ('MNG004', 'Jackson', '017-3546278'),
	   ('MNG005', 'Jesslyn', '017-7123498');

	   
INSERT INTO ManagerOrder
VALUES ('OID001', 'MNG004'),
	   ('OID002', 'MNG002'),
	   ('OID003', 'MNG005'),
	   ('OID004', 'MNG001'),
	   ('OID005', 'MNG003');


INSERT INTO [Order]
VALUES ('OID001', 'BOK007', '30'),
	   ('OID001', 'BOK009', '25'),
	   ('OID002', 'BOK012', '35'),
	   ('OID002', 'BOK015', '20'),
	   ('OID002', 'BOK004', '30'),
	   ('OID003', 'BOK013', '35'),
	   ('OID003', 'BOK008', '30'),
	   ('OID003', 'BOK014', '35'),
	   ('OID004', 'BOK006', '30'),
	   ('OID005', 'BOK009', '40');


INSERT INTO BookArrived
VALUES ('BOK007', 'OID001', '26-Sep-21', '30'),
	   ('BOK009', 'OID001', '26-Sep-21', '25'),
	   ('BOK012', 'OID002', '4-Oct-21', '35'),
	   ('BOK015', 'OID002', '4-Oct-21', '20'),
	   ('BOK004', 'OID002', '6-Oct-21', '30'),
	   ('BOK013', 'OID003', '24-Oct-21', '35'),
	   ('BOK008', 'OID003', '26-Oct-21', '30'),
	   ('BOK014', 'OID003', '27-Oct-21', '35'),
	   ('BOK006', 'OID004', '14-Nov-21', '30'),
	   ('BOK009', 'OID005', '25-Nov-21', '40');


-- DQL
-- Find the total number of books ordered by store manager from each publisher.BY WONG SHI ZHOU
SELECT b.PublisherID, mo.ManagerID, SUM(o.OrderQuantity) AS TotalOrder
FROM ManagerOrder mo INNER JOIN [Order] o
ON mo.OrderID = o.OrderID
INNER JOIN Book b
ON o.BookID = b.BookID
INNER JOIN Publisher p
ON b.PublisherID = p.PublisherID
GROUP BY mo.ManagerID, b.PublisherID;


-- Find the total number of books ordered by each member.BY WONG SHI ZHOU
SELECT m.MemberID, mo.MemberOrderQuantity AS Total_Number_of_Books_Ordered
FROM MemberOrder m INNER JOIN MemberOrderDetail mo
ON m.MemberOrderID = mo.MemberOrderID
GROUP BY m.MemberID, mo.MemberOrderQuantity;


-- Find the bestselling book(s).BY WONG SHI ZHOU
SELECT b.BookID, b.BookTitle, mo.MemberOrderQuantity AS Total_Number_Of_Books_Sold
FROM MemberOrderDetail mo INNER JOIN Book b
ON mo.BookID = b.BookID
WHERE mo.MemberOrderQuantity = (SELECT MAX(MemberOrderQuantity) FROM MemberOrderDetail);
