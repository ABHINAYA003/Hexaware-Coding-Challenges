1. CREATE DATABASE PetPals;
GO
use PetPals;
Go

4. DROP TABLE IF EXISTS Pets;
DROP TABLE IF EXISTS Shelters;
DROP TABLE IF EXISTS Donations;
DROP TABLE IF EXISTS AdoptionEvents;
DROP TABLE IF EXISTS Participants;

2,3. CREATE TABLE Pets(
     ShelterID INT,
    PetID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Age INT NOT NULL,
    Breed VARCHAR(255) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    AvailableForAdoption BIT NOT NULL,
	OwnerID INT
);
INSERT INTO Pets (PetID,ShelterID,Name, Age, Breed, Type, AvailableForAdoption,OwnerID) VALUES
(1,21,'Buddy', 3, 'Golden Retriever', 'Dog', 3,31),
(2,22,'Luna', 2, 'Siamese', 'Cat', 1,NULL),
(3,23,'Charlie', 4, 'Beagle', 'Dog', 0,33),
(4,23,'Charlie', 1, 'Beagle', 'Cat', 1,34),
(5,25,'Rocky', 5, 'Bulldog', 'Dog', 1,36),
(6,25,'Rocky', 2, 'Bulldog', 'Dog', 0,36),
(7,27,'Daisy', 3, 'Poodle', 'Dog', 1,37),
(8,28,'Max', 4, 'German Shepherd', 'Dog', 1,NULL),
(9,29,'Shadow', 6, 'Ragdoll', 'Cat', 0,39),
(0,30,'Simba', 1, 'Maine Coon', 'Cat', 1,40);


CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL
);
INSERT INTO Shelters (ShelterID,Name, Location) VALUES
(21,'Happy Tails', 'New York'),
(22,'Furry Friends', 'Los Angeles'),
(23,'Paws Haven', 'Chicago'),
(24,'Safe Paws', 'Houston'),
(25,'Home for Paws', 'San Diego'),
(26,'Rescue Me Shelter', 'Dallas'),
(27,'Forever Home', 'San Francisco'),
(28,'Angel Paws', 'Seattle'),
(29,'Hope for Paws', 'Boston'),
(30,'Paw Prints Shelter', 'Miami');


CREATE TABLE Donations (
    ShelterID INT,
    DonationID INT PRIMARY KEY,
    DonorName VARCHAR(255) NOT NULL,
    DonationType VARCHAR(50) NOT NULL,
    DonationAmount DECIMAL(10,2) NULL,
    DonationItem VARCHAR(255) NULL,
    DonationDate DATETIME NOT NULL
);
INSERT INTO Donations (ShelterID,DonationID,DonorName, DonationType, DonationAmount, DonationItem, DonationDate) VALUES
(11,1,'John Doe', 'Cash', 100.00, NULL, '2024-03-01 10:30:00'),
(12,2,'Jane Smith', 'Item', NULL, 'Dog Food', '2024-03-02 14:45:00'),
(13,3,'Alice Johnson', 'Cash', 200.00, NULL, '2024-03-03 09:15:00'),
(14,4,'Bob Brown', 'Item', NULL, 'Cat Toys', '2024-03-04 11:00:00'),
(15,5,'Emily White', 'Cash', 150.00, NULL, '2024-03-05 16:20:00'),
(16,6,'Michael Green', 'Cash', 50.00, NULL, '2024-03-06 13:10:00'),
(17,7,'Sarah Lee', 'Item', NULL, 'Pet Beds', '2024-03-07 15:25:00'),
(18,8,'David Clark', 'Cash', 300.00, NULL, '2024-04-08 12:30:00'),
(19,9,'Laura Adams', 'Item', NULL, 'Leashes', '2024-04-09 17:40:00'),
(20,10,'James Wilson', 'Cash', 75.00, NULL, '2024-04-10 14:50:00');



CREATE TABLE AdoptionEvents (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(255) NOT NULL,
    EventDate DATETIME NOT NULL,
    Location VARCHAR(255) NOT NULL
);
INSERT INTO AdoptionEvents (EventID,EventName, EventDate, Location) VALUES
(1,'Spring Adoption Fair', '2024-04-01 10:00:00', 'New York'),
(2,'Summer Pet Drive', '2024-05-15 12:00:00', 'Los Angeles'),
(3,'Paws for Love', '2024-06-10 11:30:00', 'Chicago'),
(4,'Adopt & Save', '2024-07-20 09:45:00', 'Houston'),
(5,'Forever Home Fest', '2024-08-05 14:00:00', 'San Diego'),
(6,'Rescue Rally', '2024-09-10 10:15:00', 'Dallas'),
(7,'Furry Friends Day', '2024-10-22 13:00:00', 'San Francisco'),
(8,'Holiday Pet Gala', '2024-11-30 16:00:00', 'Seattle'),
(9,'New Year’s Pet Drive', '2025-01-05 11:45:00', 'Boston'),
(10,'Valentine’s Adoption Special', '2025-02-14 15:30:00', 'Miami');


CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY,
    ParticipantName VARCHAR(255) NOT NULL,
    ParticipantType VARCHAR(50) NOT NULL,
    EventID INT,
    FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID)
);
INSERT INTO Participants (ParticipantID,ParticipantName, ParticipantType, EventID) VALUES
(1,'Happy Tails', 'Shelter', 1),
(2,'Furry Friends', 'Shelter', 2),
(3,'Paws Haven', 'Shelter', 3),
(4,'Safe Paws', 'Shelter', 4),
(5,'Home for Paws', 'Shelter', 5),
(6,'Rescue Me Shelter', 'Shelter', 6),
(7,'Forever Home', 'Shelter', 7),
(8,'Angel Paws', 'Shelter', 8),
(9,'Hope for Paws', 'Shelter', 9),
(10,'Paw Prints Shelter', 'Shelter', 10);


5. SELECT Name, Age, Breed, Type FROM Pets WHERE AvailableForAdoption = 0;

6. SELECT p.ParticipantName, p.ParticipantType 
FROM Participants p
JOIN AdoptionEvents e ON p.EventID = e.EventID
WHERE e.EventID = '5';

7.  -- Check if the ShelterID exists
    IF NOT EXISTS (SELECT 1 FROM Shelters WHERE ShelterID = 31)
BEGIN
    THROW 50000, 'Shelter ID not found', 1;
    RETURN;
END
    -- Update shelter details
    UPDATE Shelters 
    SET Name = 'abhi', Location = 'Ooty'
    WHERE ShelterID = '24';

SELECT * FROM Shelters;

8. SELECT s.Name AS ShelterName, 
       COALESCE(SUM(d.DonationAmount), 0) AS TotalDonation
FROM Shelters s
LEFT JOIN Donations d ON s.ShelterID = d.ShelterID
GROUP BY s.Name;

9. SELECT Name, Age, Breed, Type 
FROM Pets 
WHERE OwnerID IS NULL;

10. SELECT 
    FORMAT(DonationDate, 'MMMM yyyy') AS MonthYear,
    SUM(DonationAmount) AS TotalDonation
FROM Donations
WHERE DonationAmount IS NOT NULL
GROUP BY FORMAT(DonationDate, 'MMMM yyyy')
ORDER BY MIN(DonationDate);

11. SELECT DISTINCT Breed 
FROM Pets 
WHERE (Age BETWEEN 1 AND 3) OR (Age > 5);

12. SELECT p.Name AS PetName, p.Age, p.Breed, p.Type, s.Name AS ShelterName, s.Location
FROM Pets p
JOIN Shelters s ON p.ShelterID = s.ShelterID
WHERE p.AvailableForAdoption = 1;

13. SELECT COUNT(p.ParticipantID) AS TotalParticipants
FROM Participants p
JOIN AdoptionEvents e ON p.EventID = e.EventID
JOIN Shelters s ON e.Location = s.Location
WHERE s.Location = 'New York';

14. SELECT DISTINCT Breed 
FROM Pets
WHERE Age BETWEEN 1 AND 5;

15. SELECT * 
FROM Pets 
WHERE OwnerID IS NULL;

16. CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY,
    OwnerName VARCHAR(255) NOT NULL
);
INSERT INTO Owners (OwnerID, OwnerName) VALUES
(31, 'John Doe'),
(33, 'Jane Smith'),
(34, 'Emily Davis'),
(36, 'Michael Johnson'),
(37, 'Sarah Brown'),
(39, 'David Wilson'),
(40, 'Laura Adams');
SELECT P.Name AS PetName, O.OwnerName AS AdopterName
FROM Pets P
JOIN Owners O ON P.OwnerID = O.OwnerID
WHERE P.OwnerID IS NOT NULL;

17. SELECT S.ShelterID, S.Name AS ShelterName, COUNT(P.PetID) AS AvailablePets
FROM Shelters S
LEFT JOIN Pets P ON S.ShelterID = P.ShelterID AND P.AvailableForAdoption = 1
GROUP BY S.ShelterID, S.Name;

18. SELECT P1.PetID AS Pet1_ID, P1.Name AS Pet1_Name, 
       P2.PetID AS Pet2_ID, P2.Name AS Pet2_Name, 
       P1.ShelterID, P1.Breed
FROM Pets P1
JOIN Pets P2 
    ON P1.ShelterID = P2.ShelterID 
    AND P1.Breed = P2.Breed 
    AND P1.PetID < P2.PetID; 

19. SELECT S.ShelterID, S.Name AS ShelterName, 
       A.EventID, A.EventName, A.EventDate, A.Location AS EventLocation
FROM Shelters S
CROSS JOIN AdoptionEvents A;

20. SELECT P.ShelterID, S.Name AS ShelterName, COUNT(P.PetID) AS AdoptedPetCount
FROM Pets P
JOIN Shelters S ON P.ShelterID = S.ShelterID
WHERE P.OwnerID IS NOT NULL
GROUP BY P.ShelterID, S.Name
HAVING COUNT(P.PetID) = (  
    SELECT MAX(AdoptedCount)  
    FROM (SELECT COUNT(PetID) AS AdoptedCount FROM Pets WHERE OwnerID IS NOT NULL GROUP BY ShelterID) AS Subquery  
);
