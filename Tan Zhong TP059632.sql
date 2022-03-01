-- Tan Zhong's part

-- DDL commands
USE APU_E_Bookstore

-- Member Table
CREATE TABLE Member
(
MemberID nvarchar(6) NOT NULL,
MemberName varchar(50) NOT NULL,
MemberGender varchar(6) NOT NULL,
MemberContact varchar(15) UNIQUE,
MemberAddress varchar(100) NOT NULL,
CONSTRAINT PK_Member PRIMARY KEY (MemberID),
CONSTRAINT CHK_MemberGender CHECK (MemberGender = 'Male' OR MemberGender = 'Female')
);


-- Feedback Table
CREATE TABLE Feedback
( 
BookID nvarchar(6) NOT NULL,
MemberID nvarchar(6) NOT NULL,
Rating integer,
Comment text
CONSTRAINT PK_Feedback PRIMARY KEY (BookID, MemberID),
CONSTRAINT FK_Feedback_BookID FOREIGN KEY (BookID) REFERENCES Book (BookID),
CONSTRAINT FK_Feedback_MemberID FOREIGN KEY (MemberID) REFERENCES Member (MemberID),
CONSTRAINT CK_Rating CHECK (Rating >= 0 OR Rating <= 10)
);


-- Delivery Table
CREATE TABLE Delivery
(
DeliveryID nvarchar(10) NOT NULL,
DeliveryStatus varchar(20) NOT NULL,
CONSTRAINT PK_Delivery PRIMARY KEY (DeliveryID),
CONSTRAINT CK_DeliveryStatus CHECK (DeliveryStatus = 'Delivered' OR DeliveryStatus = 'Transit' OR DeliveryStatus = 'Pending')
);


-- DML commands

-- Member
SELECT * FROM Member

INSERT INTO Member
VALUES ('APU001', 'John', 'Male', '012-3456789', 'No 54, Jalan KIP 9, Taman Perindustrian KIP, 52200, Kuala Lumpur'),
	   ('APU002', 'Lily', 'Female', '013-7846427', 'No 3805, Jalan 3D Kampung Baru, Subang, 40000, Shah Alam'),
	   ('APU003', 'Ali', 'Male', '019-2963893', 'No 17-21, Jalan Semantan 2, Lurah Semantan, 28000, Temerloh'),
	   ('APU004', 'Thomas', 'Male', '019-7141212', 'Pt155 1St Floor, Jalan Sultanah Zainab, Kota Bharu, 15000, Kota Bharu'),
	   ('APU005', 'Jenny', 'Female', '013-5634425', 'B11, Jalan Ss 15/8A, Subang Jaya, 4000, Selangor'),
	   ('APU006', 'Lawrence', 'Male', '015-5489622', 'No 136, Jalan Tasek Timur, Taman Tasek Indra, 31400, Ipoh'),
	   ('APU007', 'Daniel', 'Male', '011-1111111', 'No 3805, Jalan 3D Kampung Baru, Subang, 40000, Shah Alam');


-- Feedback
SELECT * FROM Feedback

INSERT INTO Feedback
VALUES ('BOK007', 'APU004', 9, 'Excellent'),
	   ('BOK015', 'APU007', 10, 'Best'),
	   ('BOK009', 'APU004', 3, 'Boring'),
	   ('BOK012', 'APU006', 8, 'Interesting'),
	   ('BOK004', 'APU003', 6, NULL),
	   ('BOK008', 'APU002', 7, 'Interesting'),
	   ('BOK013', 'APU005', 6, 'Good'),
	   ('BOK014', 'APU007', 9, 'Excellent'),
	   ('BOK006', 'APU005', 9, 'Excellent'),
	   ('BOK006', 'APU002', 9, 'Excellent')


-- Delivery
SELECT * FROM Delivery

INSERT INTO Delivery
VALUES ('DID0001', 'Delivered'),
	   ('DID0002', 'Pending'),
	   ('DID0003', 'Pending'),
	   ('DID0004', 'Pending'),
	   ('DID0005', 'Delivered'),
	   ('DID0006', 'Transit'),
	   ('DID0007', 'Delivered'),
	   ('DID0008', 'Transit'),
	   ('DID0009', 'Pending'),
	   ('DID0010', 'Delivered')



-- Query

-- vii.	Show list of total customers based on gender who are registered as members in APU E-Bookstore. 
--		The list should show total number of registered members and total number of gender (male and female).
SELECT member.[Total Members], male.[Total Male], female.[Total Female]
FROM (SELECT COUNT (MemberID) AS [Total Members] FROM Member) AS member,
	 (SELECT COUNT (MemberGender) AS [Total Male] FROM Member WHERE MemberGender = 'Male') AS male,
	 (SELECT COUNT (MemberGender) AS [Total Female] FROM Member WHERE MemberGender = 'Female') AS female;


-- viii. Show a list of purchased books that have not been delivered to members. 
--		 The list should show member identification number, address, contact number, 
--       book serial number, book title, quantity, date and status of delivery.
SELECT Member.MemberID, Member.MemberAddress, Member.MemberContact, Book.BookSerial, Book.BookTitle, 
	   MemberOrderDetail.MemberOrderQuantity, MemberOrder.MemberOrderDate, Delivery.DeliveryStatus
FROM Member INNER JOIN MemberOrder
ON Member.MemberID = MemberOrder.MemberID 
INNER JOIN Delivery
ON MemberOrder.DeliveryID = Delivery.DeliveryID
INNER JOIN MemberOrderDetail
ON MemberOrder.MemberOrderID = MemberOrderDetail.MemberOrderID  
INNER JOIN Book
ON MemberOrderDetail.BookID = Book.BookID
WHERE Delivery.DeliveryStatus != 'Delivered';



-- ix.	Show the member who spent most on buying books. 
--		Show member id, member name and total expenditure.
SELECT TOP 1 Member.MemberID, Member.MemberName, SUM(Payment.Amount) AS [Total Expenditure] 
FROM Member INNER JOIN MemberOrder
ON Member.MemberID = MemberOrder.MemberID
INNER JOIN Payment
ON MemberOrder.PaymentID = Payment.PaymentID
GROUP BY Member.MemberID, member.memberName
ORDER BY [Total Expenditure] DESC


-- Used for checking
--SELECT * FROM Member
--SELECT * FROM MemberOrder
--SELECT * FROM MemberOrderDetail
--SELECT * FROM [Order]
--SELECT * FROM Delivery
--SELECT * FROM Feedback
--SELECT * FROM Inventory
--SELECT * FROM Publisher
--SELECT * FROM Book
--SELECT * FROM BookArrived
--SELECT * FROM Manager
--SELECT * FROM ManagerOrder
--SELECT * FROM ShoppingCart
