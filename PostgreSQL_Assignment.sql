

-- rangers table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) CHECK (conservation_status IN ('Endangered', 'Vulnerable', 'Historic'))
);

-- sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(150) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);





-- Species
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Bagh (Bengal Tiger)', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Maya Horin (Spotted Deer)', 'Axis axis', '1766-01-01', 'Vulnerable'),
('Choto Baluka (Small Wildcat)', 'Felis chaus', '1825-01-01', 'Vulnerable'),
('Bon Hati (Asian Elephant)', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Sightings
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Katka Watch Tower', '2024-05-10 07:45:00', 'Seen from a distance near riverbank'),
(2, 2, 'Nilgiri Trail', '2024-05-12 16:20:00', 'Group of 4 seen crossing path'),
(3, 3, 'Lawachara Forest', '2024-05-15 09:10:00', 'Hiding under dense bush'),
(1, 2, 'Tiger Pass', '2024-05-18 18:30:00', NULL);



-- Problem 1: 

INSERT INTO rangers (name, region) VALUES
('Mizanur Rahman', 'Sundarbans'),
('Farzana Akter', 'Chattogram Hill Tracts'),
('Jamil Hossain', 'Sylhet Forest'),
('Derek Fox', 'Coastal Barisal'); 

--Problem 2:
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- 🔹 Problem 3
SELECT * FROM sightings WHERE location ILIKE '%Pass%';

-- 🔹 Problem 4
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name;

-- 🔹 Problem 5
SELECT s.common_name
FROM species s
LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE si.sighting_id IS NULL;

-- Problem 6
SELECT sp.common_name, si.sighting_time, r.name
FROM sightings si
JOIN species sp ON si.species_id = sp.species_id
JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

-- Problem 8
SELECT sighting_id,
       CASE
           WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);
