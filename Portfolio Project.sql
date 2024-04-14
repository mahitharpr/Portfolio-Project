-- Explore the data
SELECT * FROM crime.crimedata;

-- Explore relavant columns
SELECT `DATE OCC`, `AREA NAME`, `Crm Cd Desc`, `Vict Age`, `Vict Sex`, `Status Desc`
FROM crime.crimedata
ORDER BY 2,1;

-- Count of Offenses
SELECT `Crm Cd Desc`, count(`Crm Cd Desc`) AS `Count of Occurence`
FROM crime.crimedata
GROUP BY `Crm Cd Desc`
ORDER BY 1,2;

-- Average age of victims grouped gender
SELECT avg(`Vict Age`), `Vict Sex`
FROM crime.crimedata
GROUP BY `Vict Sex`
ORDER BY 2,1;

-- Average age of victims grouped gender of sexual crimes
SELECT avg(`Vict Age`), `Vict Sex`
FROM crime.crimedata
WHERE `Crm Cd Desc` LIKE '%SEXUAL%'
GROUP BY `Vict Sex`
ORDER BY 2,1;

-- Count of Offenses by Area 
SELECT `AREA NAME`, count(`Crm Cd Desc`) AS `Count of Occurence`
FROM crime.crimedata
GROUP BY `AREA NAME`
ORDER BY 1,2;

-- Investigation Status Count
SELECT `Status Desc`, count(`Crm Cd Desc`) AS `Count of Occurence`
FROM crime.crimedata
GROUP BY `Status Desc`
ORDER BY 1,2;

-- Crimes involving Juvenile
SELECT `Crm Cd Desc`, count(`Crm Cd Desc`) AS `Count of Occurence`
FROM crime.crimedata
WHERE `Status Desc` LIKE '%Juv%'
GROUP BY `Crm Cd Desc`
ORDER BY 1,2;

-- Percentage of Crimes over Total Crimes
SELECT `Crm Cd Desc`, count(`Crm Cd Desc`)/(SELECT count(`Crm Cd Desc`) FROM  crime.crimedata) * 100 AS CrimePercentage
FROM crime.crimedata
GROUP BY `Crm Cd Desc`

-- AreAS with highest crime rates
SELECT `AREA NAME`, count(`Crm Cd Desc`) AS `Frequency of Occurence`
FROM crime.crimedata
GROUP BY `AREA NAME`
ORDER BY `Frequency of Occurence` DESC
limit 10;

-- Year wise trend of crime rate
SELECT (right (`DATE OCC`,4)) AS `Year Of Occurence`, count(`Crm Cd Desc`) AS TotalCrimes
FROM crime.crimedata
GROUP BY `Year Of Occurence`
ORDER BY `Year Of Occurence`, TotalCrimes;

-- Month wise trends of crime rate
SELECT (mid(`DATE OCC`,4,2)) AS `Month Of Occurence`, count(`Crm Cd Desc`) AS TotalCrimes
FROM crime.crimedata
GROUP BY `Month Of Occurence`
ORDER BY TotalCrimes DESC;

-- Correlation between crime and demograhpics
SELECT `Crm Cd Desc`, `Vict Age`, `Vict Sex`, COUNT(`Crm Cd Desc`) AS total_occurrences
FROM crime.crimedata
GROUP BY `Crm Cd Desc`, `Vict Age`, `Vict Sex`
ORDER BY total_occurrences DESC;

-- Emerging Crime Locations
SELECT `AREA NAME`, COUNT(`Crm Cd Desc`) AS total_crimes
FROM crime.crimedata
WHERE `DATE OCC` BETWEEN '01-01-2023' AND '04-01-2024'
GROUP BY `AREA NAME`
ORDER BY total_crimes DESC
LIMIT 10;

-- Distribution of Arrests 
SELECT `Vict Sex`, `Vict Age`, COUNT(`Status Desc`) AS total_arrests
FROM crime.crimedata
WHERE `Status Desc` LIKE '%arrest%'
GROUP BY `Vict Age`, `Vict Sex`
ORDER BY total_arrests DESC;

-- Most Prevalant Typle of Crime
SELECT `Crm Cd Desc`, COUNT(`Crm Cd Desc`) AS total_occurrences
FROM crime.crimedata
GROUP BY `Crm Cd Desc`
ORDER BY total_occurrences DESC
LIMIT 10;

--  Percentage of Crime by Category over Total Crimes
SELECT `AREA NAME`, count(`Crm Cd Desc`)/(SELECT count(`Crm Cd Desc`) FROM  crime.crimedata) * 100 AS CrimePercentage
FROM crime.crimedata
GROUP BY `AREA NAME`
ORDER BY CrimePercentage DESC;

-- Highest Crime Count by Year and Area
SELECT  `AREA NAME`, (right (`DATE OCC`,4)) AS `Year Of Occurence`,count(`Crm Cd Desc`) AS CrimeCount
FROM crime.crimedata
GROUP BY `AREA NAME`, `Year Of Occurence`
ORDER BY count(`Crm Cd Desc`) DESC;

-- Assigning Null to values where Weapon Desc is blank
UPDATE crime.crimedata SET `Weapon Desc` = NULL WHERE `Weapon Desc` = ''; 

-- Weapons used
SELECT `Weapon Desc`, count(`Crm Cd Desc`) AS CrimeCount
FROM crime.crimedata
WHERE `Weapon Desc` IS NOT NULL
GROUP BY `Weapon Desc`
ORDER BY count(`Crm Cd Desc`) DESC;

-- Occurences where weapons used OVER Total Crimes
SELECT (right (`DATE OCC`,4)) AS `Year Of Occurence`, 
((SELECT (COUNT(`Crm Cd Desc`)) 
FROM crime.crimedata 
WHERE `Weapon Desc` IS NOT NULL ) /
(SELECT count(`Crm Cd Desc`) FROM  crime.crimedata))*100 AS Weapon_Usage
FROM crime.crimedata
GROUP BY `Year Of Occurence`;


