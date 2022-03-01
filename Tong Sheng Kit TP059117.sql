-- Publisher Table 
CREATE TABLE Publisher(
PublisherID nvarchar(6) NOT NULL,
PublisherName varchar(50) NOT NULL,
PublisherContact varchar(15) NOT NULL,
PublisherAddress varchar(100) NOT NULL,
CONSTRAINT PK_Publisher PRIMARY KEY (PublisherID));


--Book Table
CREATE TABLE Book(
BookID nvarchar(6) NOT NULL,
BookTitle varchar(50) NOT NULL,
BookSerial varchar(10) NOT NULL,
Author varchar(50),
BookPrice money NOT NULL,
PublisherID nvarchar(6),
CONSTRAINT PK_Book PRIMARY KEY (BookID),
CONSTRAINT FK_Book_Publisher FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID));


--Inventory Table
CREATE TABLE Inventory(
BookID nvarchar(6) NOT NULL,
InventoryQuantity int NOT NULL,
CONSTRAINT PK_Inventory PRIMARY KEY (BookID),
CONSTRAINT FK_Inventory_Book FOREIGN KEY (BookID) REFERENCES Book (BookID));


-- Member Table
CREATE TABLE Member(
MemberID nvarchar(6) NOT NULL,
MemberName varchar(50) NOT NULL,
MemberGender varchar(6) NOT NULL,
MemberContact varchar(15) NOT NULL,
MemberAddress varchar(100) NOT NULL,
CONSTRAINT PK_Member PRIMARY KEY (MemberID),
CONSTRAINT CHK_MemberGender CHECK (MemberGender = 'Male' OR MemberGender = 'Female'));


-- Shopping Cart Table
CREATE TABLE ShoppingCart(
BookID nvarchar(6) NOT NULL,
MemberID nvarchar(6) NOT NULL, 
BookQuantity int NOT NULL,
TotalCost money NOT NULL,
MemberOrderID nvarchar(5),
CONSTRAINT PK_ShoppingCart PRIMARY KEY (BookID, MemberID),
CONSTRAINT FK_ShoppingCart_Book FOREIGN KEY (BookID) REFERENCES Book (BookID),
CONSTRAINT FK_ShoppingCart_Member FOREIGN KEY (MemberID) REFERENCES Member (MemberID),
CONSTRAINT FK_ShoppingCart_MemberOrder FOREIGN KEY (MemberOrderID) REFERENCES MemberOrder (MemberOrderID));


-- Publisher Table 
INSERT INTO Publisher VALUES 
('PBL001','Tertib Publishing','	03-26941020','9349 Permatang Tok Bidan Sungai Dua 13800 Butterworth Pulau Pinang Malaysia'), 
('PBL002','Roaring Brook Press','014-3660013','New Milford, United States'),
('PBL003','Disney Press','014-4006463','Los Angeles, United States'),
('PBL004','Little Brown','011-88892565','56B 2/F Jalan BRP 1/2 Bukit Rahman Putra 47000 Sungai Buloh Malaysia'),
('PBL005','Viz Media, Subs. of Shogakukan Inc','03-61573808','61A Jln Pj1(Pekan Jitra 2) 06000 Jitra Jitra Kedah Malaysia'),
('PBL006','Pearson Education Limited','010-7125518','31 Lrg Balok Sejahtera 2 Taman Balok Jaya 263100 Beserah Pahang Malaysia'),
('PBL007','Cengage Learning, Inc','	03-26945267','Jalan 1/65A, Off Jalan Tun Razak, Wilayah Persekutuan 50700');



-- Book Table 
INSERT INTO Book VALUES 
('BOK001','I LOST MY WAY','1471173720','Yasmin Mogahed', 40.80,'PBL001'),
('BOK002','Harry Potter AND THE CURSED CHILD','1338099132','J.K.Rowling',121.90,'PBL004'),
('BOK003','The Hating Game','0063063530','Sally Thorne',52.21,'PBL004'),
('BOK004','Muslim Astronauts in Space','9672420722','Dr.Sheikh Muszaphar Shukor',57.20,'PBL001'),
('BOK005','Kind of a Big Deal','1250206235','Shannon Hale',81.20,'PBL002'),
('BOK006','Forzen','0736431187','Junior Novelization',30.32,'PBL003'),
('BOK007','Tokyo Ghoul,  Vol.1','1421580365','Sui Ishida',55.49,'PBL005'),
('BOK008','Modern Operating Systems','1641726407','Andrew Tanenbaum',431.29,'PBL006'),
('BOK009','Where is the Green Sheep','0152067043','Judy Horacek',35.09,'PBL007'),
('BOK010','A Juz A Day','9672420250','Yahya Adel Ibrahim',78.20,'PBL001'),
('BOK011','Fundamentals of Database System','0470624701','Ramez Elmasri',302.93,'PBL006'),
('BOK012','ISE Database Systme Concepts','1260515044','Abraham Silberschatz',302.21,NULL),
('BOK013','Real Friends','1626727856','Shannon Hale',45.85,'PBL002'),
('BOK014','My Hero Academia,Vol.1','1421582694','Kohei Horikoshi',90.32,'PBL005'),
('BOK015','Haikyu!!,Vol.1','1421587661','Haruichi Furudate',45.23,'PBL005');


-- Inventory Table 
INSERT INTO Inventory VALUES
('BOK001',6),
('BOK002',16),
('BOK003',2),
('BOK004',13),
('BOK005',9),
('BOK006',0),
('BOK007',32),
('BOK008',21),
('BOK009',1),
('BOK010',6),
('BOK011',10),
('BOK012',5),
('BOK013',11),
('BOK014',8),
('BOK015',4);



-- Shopping Cart Table
INSERT INTO ShoppingCart VALUES
('BOK013','APU007',1,45.85,'NULL'),
('BOK004','APU007',2,114.40,'NULL'),
('BOK001','APU001',12,489.6,'M001'),
('BOK003','APU003',1,52.21,'NULL'),
('BOK003','APU006',1,52.21,'NULL'),
('BOK009','APU002',15,526.35,'M002');



-- List the book(s) which has the highest rating. Show book id, book name, and the rating. BY Tong Sheng Kit
SELECT b.BookID, b.BookTitle, f.Rating
FROM Book b INNER JOIN Feedback f
ON b.BookID = f.BookID
WHERE Rating = (SELECT MAX(Rating) FROM Feedback)



-- Find the total number of feedback per member. Show member id, member name, and total number of feedback per member. BY Tong Sheng Kit
SELECT m.MemberID, m.MemberName, COUNT(f.MemberID) AS Total_Feedback
FROM Member m INNER JOIN Feedback f
ON m.MemberID = f.MemberID
GROUP BY m.MemberID,m.MemberName



-- Find the total number of book published by each publisher. Show publisher id, publisher name, and number of book published. BY Tong Sheng Kit
SELECT p.PublisherID, p.PublisherName, COUNT(b.PublisherID) AS book_published
FROM Publisher p INNER JOIN  Book b
ON p.PublisherID = b.PublisherID
GROUP BY p.PublisherID, p.PublisherName