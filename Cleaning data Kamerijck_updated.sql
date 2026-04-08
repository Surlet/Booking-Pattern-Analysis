SELECT *
FROM reservations_export;

-- Create a double table

CREATE TABLE reservations_export_cleaned
LIKE reservations_export;

INSERT reservations_export_cleaned
SELECT *
FROM reservations_export;

-- Delete the reservation made on name of B&B managers

SELECT `Contact informatie`, `E-mailadres`, `Gemaakt op`, `Status`, Totaalprijs
FROM reservations_export_cleaned
WHERE `E-mailadres` LIKE '%regalys%';


DELETE 
FROM reservations_export_cleaned
WHERE `E-mailadres` LIKE '%tallon%'
AND `Status` = 'Geannuleerd'
AND Totaalprijs = '-';

-- Verify unique values for countries, correct the mistakes

SELECT DISTINCT Land
FROM reservations_export_cleaned
WHERE Status != 'Geannuleerd'
ORDER BY Land;

UPDATE reservations_export_cleaned
SET Land = 'LU'
WHERE Land LIKE 'lu';

SELECT *
FROM reservations_export_cleaned
WHERE Land = 'Czech Republic' OR Land = 'Estonia' OR Land = 'Kapellen' OR Land = 'Sint-Truiden' OR Land = 'United States';

UPDATE reservations_export_cleaned
SET Stad = CASE
	WHEN Land IN ('Kapellen') THEN 'Kapellen'
    WHEN Land IN ('Sint-Truiden') THEN 'Sint-Truiden'
    ELSE Stad
END,
Land = CASE
	WHEN Land IN ('AL') THEN 'BE'
    WHEN Land IN ('Sint-Truiden') THEN 'BE'
    WHEN Land IN ('Estonia') THEN 'EE'
    WHEN Land IN ('Czech Republic') THEN 'CZ'
    WHEN Land IN ('United States') THEN 'US'
    ELSE Land
END;

UPDATE reservations_export_cleaned
SET Land = CASE
	WHEN Land IN ('Australia') THEN 'AU'
    WHEN Land IN ('Belarus') THEN 'BY'
    WHEN Land IN ('France') THEN 'FR'
    WHEN Land IN ('Germany') THEN 'DE'
    WHEN Land IN ('Luxembourg') THEN 'LU'
    WHEN Land IN ('Nederland') OR Land IN ('Netherlands') THEN 'NL'
    WHEN Land IN ('Poland') THEN 'PL'
    WHEN Land IN ('Portugal') THEN 'PT'
    WHEN Land IN ('Spain') THEN 'ES'
    WHEN Land IN ('United Kingdom') THEN 'UK'
    ELSE Land
END;

-- Inspecting the Postcode column (Postal codes)

SELECT DISTINCT(Postcode)
FROM reservations_export_cleaned
ORDER BY 1;

UPDATE reservations_export_cleaned
SET Postcode = TRIM(LEADING '?' FROM Postcode)
WHERE Postcode LIKE '%286-0221';

UPDATE reservations_export_cleaned
SET Postcode = '8730'
WHERE Postcode = ' jeanpierre.lobelle@skynet.be';

SELECT *
FROM reservations_export_cleaned
WHERE Postcode = '.';

-- Change the data type of the dates and currency columns

ALTER TABLE reservations_export_cleaned
MODIFY COLUMN Aankomst DATE;

SELECT Totaalprijs, Totaalprijs_decimal
FROM reservations_export_cleaned;

ALTER TABLE reservations_export_cleaned
MODIFY COLUMN Vertrek DATE;

ALTER TABLE reservations_export_cleaned
MODIFY COLUMN `Gemaakt op` DATETIME;

ALTER TABLE reservations_export_cleaned
ADD COLUMN Totaalprijs_decimal DECIMAL(10,2);

UPDATE reservations_export_cleaned
SET Totaalprijs_decimal = CASE
WHEN Totaalprijs = '-' OR Totaalprijs IS NULL THEN NULL
ELSE REPLACE(REPLACE(`Totaalprijs`, '€ ', ''), ',', '.')
END;

-- Create a table to filter out the cancellations

CREATE TABLE reservations_export_cleaned_no_cancel
LIKE reservations_export_cleaned;

INSERT reservations_export_cleaned_no_cancel
SELECT *
FROM reservations_export_cleaned;

DELETE 
FROM reservations_export_cleaned_no_cancel
WHERE `Status` = 'Geannuleerd';

-- Creating a date dimension table
CREATE TABLE date_calendar(
	cal_date DATE PRIMARY KEY
    );

-- Creating a table to calculate occupancy rate
CREATE TABLE occupied_rooms (
    cal_date DATE PRIMARY KEY,
    occupied_rooms INT
);

INSERT INTO date_calendar (cal_date)
SELECT DATE_ADD('2011-01-01', INTERVAL seq DAY)
FROM (
    SELECT @row := @row + 1 AS seq
    FROM information_schema.tables t1,
         information_schema.tables t2,
         (SELECT @row := -1) init
    LIMIT 5350
) numbers;

-- Creating the amount of rooms booked on each day
INSERT INTO occupied_rooms (cal_date, occupied_rooms)
SELECT 
    c.cal_date,
    SUM(r.`Aantal accommodaties`) AS occupied_rooms
FROM date_calendar c
LEFT JOIN reservations_export_cleaned r
  ON c.cal_date >= r.Aankomst
 AND c.cal_date <  r.Vertrek   -- exclut la date de départ
GROUP BY c.cal_date
ORDER BY c.cal_date;

SELECT *
FROM chambres_occupees
WHERE cal_date > '2025-04-04';

UPDATE occupied_rooms 
SET occupied_rooms = 0
WHERE occupied_rooms IS NULL;

ALTER TABLE occupied_rooms
ADD COLUMN occupancy_rate DECIMAL(5,2);

UPDATE occupied_rooms
SET occupancy_rate = ROUND(occupied_rooms / 4 * 100, 2)
WHERE cal_date >= '2020-08-01';

UPDATE occupied_rooms
SET occupancy_rate = ROUND(occupied_rooms / 6 *100, 2)
WHERE cal_date < '2020-08-01';

SELECT AVG(occupied_rooms)
FROM occupied_rooms
WHERE cal_date < '2025-01-01'
AND cal_date > '2023-12-31';
