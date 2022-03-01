CREATE DATABASE APU_E_Bookstore

--DDL

--Member Order Table
CREATE TABLE MemberOrder
(MemberOrderID nvarchar(5) NOT NULL,
MemberID nvarchar(6) NOT NULL,
MemberOrderDate date NOT NULL,
DeliveryID nvarchar(10) NOT NULL,
PaymentID nvarchar(6) NOT NULL,
CONSTRAINT PK_MemberOrder PRIMARY KEY (MemberOrderID),
CONSTRAINT FK_MemberOrder_MemberID FOREIGN KEY (MemberID) REFERENCES Member (MemberID),
CONSTRAINT FK_MemberOrder_DeliveryID FOREIGN KEY (DeliveryID) REFERENCES Delivery (DeliveryID),
CONSTRAINT FK_MemberOrder_PaymentID FOREIGN KEY (PaymentID) REFERENCES Payment (PaymentID));

-- Member Order Detail Table
CREATE TABLE MemberOrderDetail
(BookID nvarchar(6) NOT NULL,
MemberOrderID nvarchar(5) NOT NULL,
MemberOrderQuantity int NOT NULL,
CONSTRAINT PK_MemberOrderDetail PRIMARY KEY (BookID, MemberOrderID),
CONSTRAINT FK_MemberOrderDetail_BookID FOREIGN KEY (BookID) REFERENCES Book(BookID),
CONSTRAINT FK_MemberOrderDetail_MemberOrderID FOREIGN KEY (MemberOrderID) REFERENCES MemberOrder(MemberOrderID));

-- Payment Table
CREATE TABLE Payment
(PaymentID nvarchar(6) NOT NULL,
PaymentDate DATE NOT NULL,
Amount MONEY NOT NULL,
CardNumber nvarchar(19) NOT NULL,
CONSTRAINT PK_Payment PRIMARY KEY (PaymentID));


--DML

--MemberOrder
INSERT INTO MemberOrder VALUES
('M001', 'APU001', '12-APR-2020', 'DID0001', 'PYM001'),
('M002', 'APU002', '15-APR-2020', 'DID0002', 'PYM002'),
('M003', 'APU003', '18-APR-2020', 'DID0003', 'PYM003'),
('M004', 'APU004', '18-MAY-2020', 'DID0004', 'PYM004'),
('M005', 'APU005', '20-MAY-2020', 'DID0005', 'PYM005'),
('M006', 'APU006', '27-MAY-2020', 'DID0006', 'PYM006'),
('M007', 'APU007', '30-MAY-2020', 'DID0007', 'PYM007');

--MemberOrderDetail
INSERT INTO MemberOrderDetail VALUES
('BOK001', 'M001', '12'),
('BOK009', 'M002', '15'),
('BOK004', 'M003', '30'),
('BOK012', 'M004', '20'),
('BOK010', 'M005', '15'),
('BOK014', 'M006', '18'),
('BOK006', 'M007', '28');

--Payment
INSERT INTO Payment VALUES
('PYM001', '12-APR-2020', '489.60', '4539000754217737'),
('PYM002', '15-APR-2020', '526.35', '5317411110490659'),
('PYM003', '18-APR-2020', '1716', '4532682950400139'),
('PYM004', '18-MAY-2020', '6044.20', '4539093045390504'),
('PYM005', '20-MAY-2020', '1218', '5348173563015457'),
('PYM006', '27-MAY-2020', '1625.76', '5451145149745040'),
('PYM007', '30-MAY-2020', '848.96', '5451145123745040');

SELECT * FROM MemberOrder
SELECT * FROM Payment
SELECT * FROM MemberOrderDetail

--DQL
-- x. Show a list of total books as added by each members in the shopping cart.
SELECT m.MemberID, m.MemberName, mo.MemberOrderDate as [Order Date],  b.BookID, sc.BookQuantity as [Total Numbers of Books]
From Member as m 
Inner Join MemberOrder as mo
on m.MemberID = mo.MemberID
Inner Join ShoppingCart as sc
on m.MemberID = sc.MemberID
Inner Join Book as b
on sc.BookID = b.BookID

-- xi. Find the total number of database books that were sold in April-2020.
SELECT SUM(mode.MemberOrderQuantity) AS [Total number of database books sold in April 2020]
FROM MemberOrderDetail mode
INNER JOIN MemberOrder mo
ON mode.MemberOrderID = mo.MemberOrderID
INNER JOIN Payment p
ON mo.PaymentID = p.PaymentID
Where MONTH(p.PaymentDate) = 4 AND YEAR(p.PaymentDate) = 2020

-- xii. Show list of books that were added to the shopping but the order was not completed. 
-- Show member id, member name, book serial number, and book title.
SELECT Member.MemberID, Member.MemberName, Book.BookSerial, Book.BookTitle
FROM Member INNER JOIN ShoppingCart
ON ShoppingCart.MemberID = Member.MemberID
INNER JOIN Book 
ON ShoppingCart.BookID = Book.BookID
WHERE ShoppingCart.MemberOrderID IS NULL;
