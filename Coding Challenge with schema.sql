--4)FOR ERROR HANDLING
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PetPals')
BEGIN
--CREATING DATABASE PetPals
    CREATE DATABASE PetPals;
END
GO
USE PetPals;
GO
--1)Creating Schema
 CREATE SCHEMA petpalsSchema;
 
4) -- FOR ERROR HANDLING
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'petpalsSchema.Pets') 
DROP TABLE petpalsSchema.Pets;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'petpalsSchema.Shelters') 
DROP TABLE petpalsSchema.Shelters;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'petpalsSchema.Donations') 
DROP TABLE petpalsSchema.Donations;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'petpalsSchema.AdoptionEvents') 
DROP TABLE petpalsSchema.AdoptionEvents;
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'petpalsSchema.Participants') 
DROP TABLE petpalsSchema.Participants;
GO
--2,3
-- CREATATING TABLE PETS
CREATE TABLE petpalsSchema.Pets (
    Pet_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Breed VARCHAR(50),
    Type VARCHAR(50),
    AvailableForAdoption BIT
);
--INSERTING RECORDS INTO TABLE PETS
INSERT INTO petpalsSchema.Pets (Pet_ID, Name, Age, Breed, Type, AvailableForAdoption)
VALUES 
(1, 'Bella', 2, 'Labrador', 'Dog', 1),
(2, 'Max', 5, 'German Shepherd', 'Dog', 1),
(3, 'Kitty', 3, 'Persian', 'Cat', 1),
(4, 'Charlie', 4, 'Beagle', 'Dog', 0),
(5, 'Milo', 1, 'Bengal', 'Cat', 1);
GO
-- CREATING TABLE SHELTERS
CREATE TABLE petpalsSchema.Shelters (
    ShelterID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Location NVARCHAR(255)
);
--INSERT RECORDS INTO SHELTERS TABLE
INSERT INTO petpalsSchema.Shelters (ShelterID, Name, Location)
VALUES 
(1, 'Happy Tomie', 'Madurai'),
(2, 'Paws & Claws Shelter', 'Bangalore'),
(3, 'Furry Friends Shelter', 'Mumbai'),
(4, 'Shelter for Paws', 'Delhi'),
(5, 'The Animal Haven', 'Chennai');
GO
-- CREATING TABLE DONATIONS 
CREATE TABLE petpalsSchema.Donations (
    Donation_ID INT PRIMARY KEY,
    Donor_Name VARCHAR(100),
    Donation_Type VARCHAR(50),
    Donation_Amount DECIMAL(10, 2),
    Donation_Item VARCHAR(100),
    Donation_Date DATETIME
);
--INSERTINF RECORDS INTO DONATIONS TABLE
INSERT INTO petpalsSchema.Donations (Donation_ID, Donor_Name, Donation_Type, Donation_Amount, Donation_Item, Donation_Date)
VALUES
(1, 'Abhi', 'Cash', 5000.00, NULL, '2025-03-01 10:00:00'),
(2, 'Navee', 'Item', NULL, 'Pet Food', '2025-03-05 14:30:00'),
(3, 'Tomie', 'Cash', 2000.00, NULL, '2025-03-10 09:00:00'),
(4, 'MickeyChoki', 'Item', NULL, 'Toys', '2025-03-12 16:00:00'),
(5, 'ChokiMickey', 'Cash', 1000.00, NULL, '2025-03-15 11:45:00');
GO
-- CREATING TABLE ADOPTIONEVENTS
CREATE TABLE petpalsSchema.AdoptionEvents (
    Event_ID INT PRIMARY KEY,
    Event_Name VARCHAR(100),
    Event_Date DATETIME,
    Location VARCHAR(255)
);
--INSERTING RECORDS INTO ADOPTIONEVENTS TABLE
INSERT INTO petpalsSchema.AdoptionEvents (Event_ID, Event_Name, Event_Date, Location)
VALUES
(1, 'Spring Adoption Drive', '2025-04-01 09:00:00', 'Chennai'),
(2, 'Pet Adoption Fair', '2025-04-10 10:00:00', 'Mumbai'),
(3, 'Adopt a Pet Event', '2025-04-15 11:00:00', 'Bangalore'),
(4, 'Pets for Adoption', '2025-04-20 12:00:00', 'Chennai'),
(5, 'Adopt and Love', '2025-04-25 13:00:00', 'Delhi');
GO
-- CREATING TABLE PARTICIPANTS
CREATE TABLE petpalsSchema.Participants (
    Participant_ID INT PRIMARY KEY,
    Participant_Name VARCHAR(100),
    Participant_Type VARCHAR(50),
    Event_ID INT,
    FOREIGN KEY (Event_ID) REFERENCES petpalsSchema.AdoptionEvents(Event_ID) ON DELETE CASCADE);

--INSERTING RECORDS INTO PARTICIPANTS TABLE
INSERT INTO petpalsSchema.Participants (Participant_ID, Participant_Name, Participant_Type, Event_ID)
VALUES
(1, 'MickeyChoki', 'Shelter', 1),
(2, 'sobana', 'Shelter', 2),
(3, 'Aaron sam', 'Adopter', 3),
(4, 'Mickey', 'Adopter', 4),
(5, 'Choki', 'Shelter', 5);
GO

--5) RETRIEVE AVAILABLE PETS
SELECT Name, Age, Breed, Type
FROM petpalsSchema.Pets
WHERE AvailableForAdoption = 1;
GO

--6)ASSUME YOU WILL PASS EVENTID AS A PARAMETER
DECLARE @EventID INT = 1; 
SELECT Participant_Name, Participant_Type
FROM petpalsSchema.Participants
WHERE Event_ID = @EventID;
GO

--7)STORED PROCEDURE TO ALLOW A SHELTER TO UPDATE ITS INFORMATION
CREATE PROCEDURE UpdateShelterInfo
    @ShelterID INT,
    @NewName NVARCHAR(100),
    @NewLocation NVARCHAR(255)
AS
    IF EXISTS (SELECT 1 FROM petpalsSchema.Shelters WHERE ShelterID = @ShelterID)
        UPDATE petpalsSchema.Shelters
        SET Name = @NewName, Location = @NewLocation
        WHERE ShelterID = @ShelterID;
    ELSE
        PRINT 'Shelter not found.';
GO

--8) SQL QUERY TO CALCULATE TOTAL DONATION AMOUNT BY SHELTER
SELECT S.Name AS ShelterName, 
       SUM(D.Donation_Amount) AS TotalDonationAmount
FROM petpalsSchema.Donations D,petpalsSchema.Shelters S WHERE S.ShelterID = D.Donation_ID 
GROUP BY S.Name;
GO

--9)RETRIEVE PETS WHERE PET_ID IS NULL
SELECT Name, Age, Breed, Type
FROM petpalsSchema.Pets
WHERE Pet_ID IS NULL;
GO

--10)DONATION AMOUNT GROUPED BY MONTH-YEAR
SELECT 
	FORMAT(Donation_Date, 'MMMM yyyy') AS MonthYear, 
    SUM(Donation_Amount) AS TotalDonationAmount
FROM petpalsSchema.Donations
GROUP BY FORMAT(Donation_Date, 'MMMM yyyy')
ORDER BY MonthYear;
GO

--11)RETRIEVE UNIQUE BREED OF PETS AGE BETWEEN 1 AND 3 OR AGE >5
SELECT DISTINCT Breed,Name
FROM petpalsSchema.Pets
WHERE (Age BETWEEN 1 AND 3) OR Age > 5;
GO

--12)PETS WITH THEIR SHELTER INFORMATION, AVAILABLE FOR ADOPTION
SELECT P.Name AS PetName, P.Age, P.Breed, P.Type, S.Name AS ShelterName
FROM petpalsSchema.Pets P,petpalsSchema.Shelters S
WHERE P.Pet_ID = S.ShelterID AND P.AvailableForAdoption = 1;
GO

--13)PARTICIPANTS FROM A SPECIFIC CITY
DECLARE @City NVARCHAR(100) = 'Chennai'; 
SELECT COUNT(P.Participant_ID) AS TotalParticipants
FROM petpalsSchema.Participants P
JOIN petpalsSchema.AdoptionEvents A ON P.Event_ID = A.Event_ID
JOIN petpalsSchema.Shelters S ON A.Location = S.Location
WHERE S.Location = @City;
GO

--14) RETRIEVE UNIQUE BREED OF PETS AGE BETWEEN 1 AND 5
SELECT DISTINCT Breed,Name
FROM petpalsSchema.Pets
WHERE Age BETWEEN 1 AND 5;
GO

--15)PETS THAT HAVE NOT ADOPTED
SELECT Name, Age, Breed, Type
FROM petpalsSchema.Pets
WHERE AvailableForAdoption = 1;
GO

--16)RETRIEVE UNIQUE BREED OF PETS AGED BETWEEN 1 AND 5
SELECT P.Name AS PetName, A.Event_Name
FROM petpalsSchema.Pets P,petpalsSchema.AdoptionEvents A WHERE P.Pet_ID = A.Event_ID AND A.Event_ID = 1;
GO

--17)AVAILABLE PETS COUNT PER SHELTER
SELECT S.Name AS ShelterName, 
COUNT(P.Pet_ID) AS AvailablePetsCount
FROM petpalsSchema.Shelters S
LEFT JOIN petpalsSchema.Pets P ON S.ShelterID = P.Pet_ID AND P.AvailableForAdoption = 1
GROUP BY S.Name;
GO

--18)PETS WITH THE SAME BREED
SELECT P1.Name AS Pet1, P2.Name AS Pet2, P1.Breed AS Breed, P1.Pet_ID
FROM petpalsSchema.Pets P1,petpalsSchema.Pets P2 
WHERE P1.Pet_ID = P2.Pet_ID  AND P1.Pet_ID < P2.Pet_ID AND P1.Breed = P2.Breed;  
GO

--19)SHELTERS AND ADOPTION EVENTS
SELECT S.Name AS ShelterName, A.Event_Name AS EventName
FROM petpalsSchema.Shelters S,petpalsSchema.AdoptionEvents A;
GO

--20)TOP 1 SHELTER WITH THE HIGHEST NUMBER OF ADOPTED PETS
SELECT TOP 1 S.Name AS ShelterName, COUNT(P.Pet_ID) AS AdoptedPetsCount
FROM petpalsSchema.Shelters S,petpalsSchema.Pets P 
WHERE S.ShelterID = P.Pet_ID AND P.Pet_ID IS NOT NULL
GROUP BY S.Name
ORDER BY AdoptedPetsCount DESC;
GO
