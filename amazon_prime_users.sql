CREATE DATABASE amazon_prime;
USE amazon_prime;

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(100),
    EmailAddress VARCHAR(100),
    Username VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(50),
    Location VARCHAR(100)
);

CREATE TABLE Memberships (
    UserID INT,
    MembershipStartDate DATE,
    MembershipEndDate DATE,
    SubscriptionPlan VARCHAR(50),
    PaymentInformation VARCHAR(100),
    RenewalStatus VARCHAR(50),
    UsageFrequency VARCHAR(50),
    PurchaseHistory VARCHAR(50),
    FavoriteGenres VARCHAR(50),
    DevicesUsed VARCHAR(50),
    EngagementMetrics VARCHAR(50),
    Ratings FLOAT,
    CustomerSupportInteractions INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Explore Data
SELECT * FROM Memberships;
SELECT * FROM Users;

-- Average rating given by users grouped by their subscription plan
SELECT SubscriptionPlan, ROUND(AVG(Ratings),2) AS AverageRating
FROM Memberships
GROUP BY SubscriptionPlan;

-- Total number of users in each location
SELECT Location, COUNT(UserID) AS UserCount
FROM Users
GROUP BY Location;

-- Most popular device used by users
SELECT DevicesUsed, COUNT(DevicesUsed) AS DeviceCount
FROM Memberships
GROUP BY DevicesUsed
ORDER BY DeviceCount DESC
LIMIT 1;

-- Total number of users according to their engagement metrics
SELECT EngagementMetrics, COUNT(UserID) AS UserCount
FROM Memberships
GROUP BY EngagementMetrics
ORDER BY UserCount DESC;

-- Favorite genres of users who have a renewal status of auto-rrenew
SELECT FavoriteGenres, COUNT(FavoriteGenres) AS GenreCount
FROM Memberships
WHERE RenewalStatus = 'Auto-renew'
GROUP BY FavoriteGenres
ORDER BY GenreCount DESC;

-- Calculate the average age of users by gender
SELECT Gender, ROUND(AVG(YEAR(CURDATE()) - YEAR(DateOfBirth)),2) AS AverageAge
FROM Users
GROUP BY Gender;

-- Calculate the total number of users by age group
SELECT 
    CASE
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 0 AND 17 THEN '0-17'
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 18 AND 24 THEN '18-24'
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 25 AND 34 THEN '25-34'
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS AgeGroup, COUNT(UserID) AS UserCount
FROM Users
GROUP BY AgeGroup
ORDER BY AgeGroup ASC;

-- Join both tables
SELECT U.UserID, Name, EmailAddress, Username, 
       MembershipStartDate, MembershipEndDate, SubscriptionPlan, PaymentInformation, RenewalStatus,
       UsageFrequency, PurchaseHistory, FavoriteGenres, DevicesUsed, EngagementMetrics,
       Ratings, CustomerSupportInteractions
FROM Users U
JOIN Memberships M ON U.UserID = M.UserID;

-- List of users who have interacted with customer support more than five times
SELECT U.UserID, U.Name, M.CustomerSupportInteractions
FROM Users U
JOIN Memberships M ON U.UserID = M.UserID
WHERE M.CustomerSupportInteractions>5;

-- Calculate the average age of users by RenewalStatus
SELECT M.RenewalStatus, ROUND(AVG(YEAR(CURDATE()) - YEAR(U.DateOfBirth)),2) AS AverageAge
FROM Users U
JOIN Memberships M ON U.UserID = M.UserID
GROUP BY M.RenewalStatus;

-- Create a view for Auto-renew user
CREATE VIEW AutoRenewUsers AS
SELECT U.UserID, Name, EmailAddress, Username, DateOfBirth, Gender, Location, MembershipStartDate,SubscriptionPlan, M.FavoriteGenres,
CASE
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 0 AND 17 THEN '0-17'
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 18 AND 24 THEN '18-24'
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 25 AND 34 THEN '25-34'
        WHEN YEAR(CURDATE()) - YEAR(DateOfBirth) BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS AgeGroup
FROM Users U
JOIN Memberships M ON U.UserID = M.UserID
WHERE RenewalStatus = 'Auto-renew';

-- Total Auto-renew users by Age group
SELECT AgeGroup, COUNT(UserID)AS UserCount 
FROM AutoRenewUsers
GROUP BY AgeGroup
ORDER BY UserCount DESC;