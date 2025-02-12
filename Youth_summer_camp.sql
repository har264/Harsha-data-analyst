--create database for the project
create database summercamp;
-- create the participants table
CREATE TABLE Participants (
    ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50) NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')) NOT NULL,
    PersonalPhone VARCHAR(15) UNIQUE NOT NULL);
 --create the camps table
 create table Camps_Table 
   (CampID INT IDENTITY(1,1) PRIMARY KEY,
    CampTitle NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Capacity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL);
-- create the register table for the registration
CREATE TABLE Registrations (
    RegistrationID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CampID INT NOT NULL,
    RegistrationDate DATETIME DEFAULT GETDATE(),---to get current date and time while register
    FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID) ON DELETE CASCADE,--when we delete participant then it automatically delete details other tables
    FOREIGN KEY (CampID) REFERENCES Camps_Table(CampID) ON DELETE CASCADE);

	-- Create the people table
CREATE TABLE people (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50),
    gender VARCHAR(10),
    age INT
);

-- Insert 5000 random records
INSERT INTO people (name, gender, age)
SELECT 
    'Person_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR) AS name,
    CASE 
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 65 THEN 'Female' -- 65% Female
        ELSE 'Male' -- 35% Male
    END AS gender,
    CASE 
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 18 THEN FLOOR(RAND(CHECKSUM(NEWID())) * 6) + 7  -- 7-12 years (18%)
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 45 THEN FLOOR(RAND(CHECKSUM(NEWID())) * 2) + 13 -- 13-14 years (27%)
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 65 THEN FLOOR(RAND(CHECKSUM(NEWID())) * 3) + 15 -- 15-17 years (20%)
        ELSE FLOOR(RAND(CHECKSUM(NEWID())) * 2) + 18  -- 18-19 years (35%)
    END AS age
FROM master.dbo.spt_values
WHERE type = 'P' AND number BETWEEN 1 AND 5000;
select * from people;
WITH GenerationCounts AS (
    SELECT 
        CASE 
            WHEN Age BETWEEN 40 AND 55 THEN 'Gen X'
            WHEN Age BETWEEN 25 AND 39 THEN 'Millennials'
            WHEN Age BETWEEN 10 AND 24 THEN 'Gen Z'
            WHEN Age < 10 THEN 'Gen Alpha'
        END AS Generation,
        gender,
        COUNT(*) AS Count
    FROM people
    GROUP BY 
        CASE 
            WHEN Age BETWEEN 40 AND 55 THEN 'Gen X'
            WHEN Age BETWEEN 25 AND 39 THEN 'Millennials'
            WHEN Age BETWEEN 10 AND 24 THEN 'Gen Z'
            WHEN Age < 10 THEN 'Gen Alpha'
        END,
        gender
)

SELECT 
    Generation,
    round(SUM(CASE WHEN gender = 'Male' THEN Count ELSE 0 END) * 100.0 / SUM(Count),0) AS Male_Percentage,
    round(SUM(CASE WHEN gender = 'Female' THEN Count ELSE 0 END) * 100.0 / SUM(Count),0) AS Female_Percentage
FROM GenerationCounts
GROUP BY Generation;
