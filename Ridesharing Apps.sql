CREATE DATABASE ride_sharing_db;
USE ride_sharing_db;
show databases;
CREATE TABLE Passenger (
    Passenger_ID    INT PRIMARY KEY,
    Passenger_Name  VARCHAR(50)  NOT NULL,
    Passenger_Phone VARCHAR(15)  NOT NULL,
    Email           VARCHAR(100)
);

CREATE TABLE Driver (
    Driver_ID     INT PRIMARY KEY,
    Driver_Name   VARCHAR(50)  NOT NULL,
    Driver_Phone  VARCHAR(15)  NOT NULL,
    License_No    VARCHAR(30)  NOT NULL UNIQUE
);

CREATE TABLE Vehicle (
    Vehicle_ID    INT PRIMARY KEY,
    Driver_ID     INT          NOT NULL,
    Vehicle_No    VARCHAR(20)  NOT NULL UNIQUE,
    Vehicle_Type  VARCHAR(30)  NOT NULL,
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID)
);

CREATE TABLE Ride (
    Ride_ID       INT PRIMARY KEY,
    Passenger_ID  INT            NOT NULL,
    Driver_ID     INT            NOT NULL,
    Vehicle_ID    INT            NOT NULL,
    Pickup        VARCHAR(100)   NOT NULL,
    Destination   VARCHAR(100)   NOT NULL,
    Ride_Date     DATETIME       NOT NULL,
    Fare          DECIMAL(10,2)  NOT NULL,
    Status        VARCHAR(20)    NOT NULL,
    CHECK (Fare >= 0),
    CHECK (Status IN ('Requested', 'Ongoing', 'Completed', 'Cancelled')),
    FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID),
    FOREIGN KEY (Driver_ID)    REFERENCES Driver(Driver_ID),
    FOREIGN KEY (Vehicle_ID)   REFERENCES Vehicle(Vehicle_ID)
);

CREATE TABLE Payment (
    Payment_ID      INT PRIMARY KEY,
    Ride_ID         INT            NOT NULL UNIQUE,
    Amount          DECIMAL(10,2)  NOT NULL,
    Payment_Method  VARCHAR(30)    NOT NULL,
    Payment_Status  VARCHAR(20)    NOT NULL,
    CHECK (Amount >= 0),
    FOREIGN KEY (Ride_ID) REFERENCES Ride(Ride_ID)
);

CREATE TABLE Rating (
    Rating_ID  INT PRIMARY KEY,
    Ride_ID    INT           NOT NULL,
    Rating     INT           NOT NULL,
    Review     VARCHAR(255),
    CHECK (Rating BETWEEN 1 AND 5),
    FOREIGN KEY (Ride_ID) REFERENCES Ride(Ride_ID)
);

INSERT INTO Passenger VALUES
(1, 'Rahul Patil', '9876504321', 'rahul.patil@example.com'),
(2, 'Priya Kulkarni', '9876512345', 'priya.k@example.com'),
(3, 'Karan Mehta', '9876523456', 'karan.m@example.com'),
(4, 'Neha Joshi', '9876534567', 'neha.j@example.com'),
(5, 'Arjun Deshmukh', '9876545678', 'arjun.d@example.com'),
(6, 'Meera Shah', '9876556789', 'meera.s@example.com');

INSERT INTO Driver VALUES
(1, 'Amit Jadhav', '9123401001', 'MH1220200001'),
(2, 'Sneha More', '9123401002', 'MH1420210002'),
(3, 'Rohan Pawar', '9123401003', 'MH1220190003'),
(4, 'Kavita Rane', '9123401004', 'MH1420220004');
 
INSERT INTO Vehicle VALUES
(1, 1, 'MH12AB1234', 'Sedan'),
(2, 2, 'MH14XY4567', 'Hatchback'),
(3, 3, 'MH12CD7890', 'SUV'),
(4, 1, 'MH12EF2468', 'Hatchback'),
(5, 4, 'MH14GH1357', 'Sedan');
 
INSERT INTO Ride VALUES
(101, 1, 1, 1, 'College', 'Station', '2026-09-01 09:15:00', 180.00, 'Completed'),
(102, 1, 2, 2, 'Mall', 'College', '2026-09-03 17:40:00', 220.00, 'Completed'),
(103, 1, 1, 1, 'Home', 'Airport', '2026-09-05 04:30:00', 450.00, 'Completed'),
(104, 2, 3, 3, 'Station', 'Mall', '2026-09-06 11:00:00', 150.00, 'Completed'),
(105, 2, 1, 4, 'Home', 'College', '2026-09-08 08:20:00', 130.00, 'Completed'),
(106, 3, 2, 2, 'Airport', 'Hotel', '2026-09-10 22:10:00', 500.00, 'Completed'),
(107, 4, 3, 3, 'College', 'Home', '2026-09-12 18:05:00', 0.00, 'Cancelled'),
(108, 4, 4, 5, 'Mall', 'Station', '2026-09-14 13:25:00', 170.00, 'Completed'),
(109, 5, 4, 5, 'Home', 'Office', '2026-10-22 09:00:00', 210.00, 'Ongoing'),
(110, 1, 1, 1, 'Station', 'Home', '2026-09-18 19:45:00', 160.00, 'Completed');
 
INSERT INTO Payment VALUES
(1, 101, 180.00, 'UPI', 'Paid'),
(2, 102, 220.00, 'Card', 'Paid'),
(3, 103, 450.00, 'Cash', 'Paid'),
(4, 104, 150.00, 'UPI', 'Paid'),
(5, 105, 130.00, 'Cash', 'Paid'),
(6, 106, 500.00, 'Card', 'Paid'),
(7, 108, 170.00, 'UPI', 'Pending'),
(8, 110, 160.00, 'Cash', 'Paid');
 
INSERT INTO Rating VALUES
(1, 101, 5, 'Smooth and quick ride'),
(2, 101, 4, 'Polite passenger'),
(3, 102, 4, 'Good driving'),
(4, 103, 5, 'Reached the airport on time'),
(5, 104, 3, 'Average ride'),
(6, 105, 4, NULL),
(7, 106, 5, 'Excellent service'),
(8, 106, 5, 'Cooperative passenger'),
(9, 108, 2, 'Pickup was late'),
(10, 110, 4, 'Comfortable ride');

SELECT * FROM Passenger;
Select * From Driver;
Select * From Vehicle;
Select * From Ride;
Select * From Payment;
Select * From Rating;

SELECT r.Ride_ID, p.Passenger_Name, d.Driver_Name,
       r.Pickup, r.Destination, r.Fare
FROM Ride r
JOIN Passenger p ON r.Passenger_ID = p.Passenger_ID
JOIN Driver d    ON r.Driver_ID    = d.Driver_ID
WHERE r.Status = 'Completed'
ORDER BY r.Ride_ID;

SELECT p.Passenger_ID, p.Passenger_Name,
       COUNT(r.Ride_ID) AS Total_Rides,
       SUM(r.Fare)      AS Total_Fare
FROM Passenger p
JOIN Ride r ON p.Passenger_ID = r.Passenger_ID
WHERE r.Status = 'Completed'
GROUP BY p.Passenger_ID, p.Passenger_Name
ORDER BY Total_Fare DESC;

SELECT d.Driver_ID, d.Driver_Name, v.Vehicle_No, v.Vehicle_Type
FROM Driver d
JOIN Vehicle v ON d.Driver_ID = v.Driver_ID
ORDER BY d.Driver_ID, v.Vehicle_ID;

SELECT Ride_ID, Pickup, Destination, Fare
FROM Ride
WHERE Status = 'Completed'
  AND Fare > (SELECT AVG(Fare)
              FROM Ride
              WHERE Status = 'Completed')
ORDER BY Fare DESC;

SELECT d.Driver_ID, d.Driver_Name,
       COUNT(rt.Rating_ID)       AS Ratings_Received,
       ROUND(AVG(rt.Rating), 2)  AS Average_Rating
FROM Driver d
JOIN Ride r    ON d.Driver_ID = r.Driver_ID
JOIN Rating rt ON r.Ride_ID   = rt.Ride_ID
GROUP BY d.Driver_ID, d.Driver_Name
ORDER BY Average_Rating DESC;

SELECT Ride_ID, COUNT(*) AS Number_of_Ratings
FROM Rating
GROUP BY Ride_ID
HAVING COUNT(*) > 1;

SELECT Payment_Method,
       COUNT(*)    AS Number_of_Payments,
       SUM(Amount) AS Total_Amount
FROM Payment
WHERE Payment_Status = 'Paid'
GROUP BY Payment_Method
ORDER BY Total_Amount DESC;

SELECT p.Passenger_ID, p.Passenger_Name, p.Passenger_Phone
FROM Passenger p
LEFT JOIN Ride r ON p.Passenger_ID = r.Passenger_ID
WHERE r.Ride_ID IS NULL;

SELECT r.Ride_ID, p.Passenger_Name, pay.Amount,
       pay.Payment_Method, pay.Payment_Status
FROM Payment pay
JOIN Ride r      ON pay.Ride_ID     = r.Ride_ID
JOIN Passenger p ON r.Passenger_ID  = p.Passenger_ID
WHERE pay.Payment_Status <> 'Paid';

UPDATE Payment
SET Payment_Status = 'Paid'
WHERE Ride_ID = 108;
 
SELECT Payment_ID, Ride_ID, Amount, Payment_Status
FROM Payment
WHERE Ride_ID = 108;

INSERT INTO Ride
VALUES (111, 99, 1, 1, 'College', 'Station',
        '2026-10-22 10:00:00', 100.00, 'Requested');

SELECT Ride_ID, Pickup, Destination, Fare
FROM Ride
ORDER BY Fare DESC
LIMIT 3;
