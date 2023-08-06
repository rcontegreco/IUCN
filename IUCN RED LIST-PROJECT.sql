-- The IUCN (International Union for Conservation of Nature) is an inventory of biological species' global conservation status and extinction risk.
-- all the data below are sourced from https://www.iucnredlist.org/

CREATE DATABASE IUCN_RED_LIST;
USE IUCN_RED_LIST;

CREATE TABLE species (
species_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
red_list_category VARCHAR(50) NOT NULL
);

--Taxonomy is the study of organizing and naming living things
CREATE TABLE taxonomy (
species_id INT NOT NULL,
kingdom VARCHAR(50),
phylum VARCHAR(100),
class VARCHAR(100),
order_name VARCHAR(100),
PRIMARY KEY (species_id),
FOREIGN KEY (species_id) REFERENCES species(species_id)
);

CREATE TABLE geographical_range (
species_id INT NOT NULL,
country VARCHAR(100) NOT NULL,
PRIMARY KEY (species_id, country),
FOREIGN KEY (species_id) REFERENCES species(species_id)
);

--The IUCN red list category classifies species based on their risk of extintion
CREATE TABLE red_list_category (
species_id INT NOT NULL,
red_list_category VARCHAR(50) NOT NULL,
population_trend VARCHAR(50),
publication_year INT NOT NULL,
conservation_action VARCHAR (20),
PRIMARY KEY (species_id),
FOREIGN KEY (species_id) REFERENCES species(species_id)
);

CREATE TABLE threat_description (
threat_id INT PRIMARY KEY,
threat VARCHAR(100) NOT NULL
);

CREATE TABLE threat (
species_id INT NOT NULL,
threat_id INT NOT NULL,
PRIMARY KEY (species_id, threat_id),
FOREIGN KEY (species_id) REFERENCES species(species_id),
FOREIGN KEY (threat_id) REFERENCES threat_description(threat_id)
);

INSERT INTO species 
(name)
VALUES
('Deys Moon Lichen'),
('Gladys Mountain Spikes'),
('Lilac Pinkgill'),
('Chajorra de Aluce'),
('River Quillwort'),
('Cardón de Jandía'),
('Dictyota Galapagensis'),
('Olynesian Tree Snail'),
('Croatian Dace'),
('Hawaiian Monk Seal'),
('Papuan Eagle'),
('Auckland Islands Shag');

SELECT * FROM species;

INSERT INTO taxonomy
(species_id,kingdom,phylum,class,order_name)
VALUES
('1','fungi','ascomycota','lecanoromycetes','peltigerales'),
('2','fungi','ascomycota','lecanoromycetes','peltigerales'),
('3','fungi','Basidiomycota','agaricomycetes','agaricales'),
('4','plantae','tracheophyta','magnoliopsida','amiales'),
('5','plantae','tracheophyta','lycopodiopsida','isoetales'),
('6','plantae','tracheophyta','magnoliopsida','malpighiales'),
('7','chromista','ochrophyta','phaeophyceae','dictyotales'),
('8','animalia','mollusca','gastropoda','stylommatophora'),
('9','animalia','chordata','actinopterygii','cypriniformes'),
('10','animalia','chordata','mammalia','carnivora'),
('11','animalia','chordata','aves','accipitriformes'),
('12','animalia','chordata','aves','suliformes');

SELECT * FROM taxonomy;

INSERT INTO geographical_range
(species_id,country)
VALUES
('1','United States'),
('2','United States'),
('3','Austria'),
('4','Spain'),
('5','Spain'),
('6','Ecuador'),
('7','Ecuador'),
('8','French Polynesia'),
('9','Croatia'),
('10','United States'),
('11','Indonesia'),
('12','New Zeland');

SELECT * FROM geographical_range;

INSERT INTO red_list_category
(species_id,red_list_category,population_trend,publication_year,conservation_action)
VALUES
('1','critically endangered','decrasing	','2020','yes'),
('2','endangered','stable','2020','yes'),
('3','vulnerable','decrasing','2019','no'),
('4','critically endangered','decrasing','2011','yes'),
('5','endangered','decrasing','2017','yes'),
('6','Vulnerable','increasing','2011','yes'),
('7','critically endangered','decrasing','2007','yes'),
('8','extinct in the wild','','2009','yes'),
('9','critically endangered','decrasing','2006','no'),
('10','endangered','decrasing','2015','yes'),
('11','vulnerable','decrasing','2022','yes'),
('12','vulnerable','stable','2018','yes');

SELECT * FROM red_list_category;

INSERT INTO threat_description
(threat_id,threat)
VALUES
('1','transportation'),
('2','climate change'),
('3','sever wheather'),
('4','human intrusion'),
('5','disturbance'),
('6','pollution'),
('7','agricolture'),
('8','geological events'),
('9','residential'),
('10','diseases'),
('11','invasive non-native species');

SELECT * FROM threat_description;

INSERT INTO threat
(species_id,threat_id)
VALUES
('1','1'),
('1','2'),
('1','3'),
('2','2'),
('2','3'),
('2','4'),
('2','5'),
('3','1'),
('3','6'),
('3','7'),
('4','2'),
('4','3'),
('4','7'),
('4','8'),
('5','4'),
('5','6'),
('5','7'),
('5','9'),
('6','7'),
('7','2'),
('8','10'),
('8','11'),
('9','2'),
('9','11'),
('10','2'),
('10','3'),
('10','4'),
('10','5'),
('10','8'),
('10','6'),
('10','11'),
('11','5'),
('11','7'),
('12','11');

SELECT * FROM threat;

--QUERIES
--(Using any type of join, create a view that combines multiple tables in a logical way)
--Select all species, that are critically endangered. Show their kingdom, phylum and where they are found. Lastly, order them in alphabetic order by species name.

SELECT
s.name AS species_name,
t.kingdom,
t.phylum,
gr.country AS geographical_range
FROM
species AS s
JOIN
taxonomy AS t ON s.species_id = t.species_id
JOIN
red_list_category AS rl ON s.species_id = rl.species_id
LEFT JOIN
geographical_range AS gr ON s.species_id = gr.species_id
WHERE
rl.red_list_category = 'Critically Endangered'
ORDER by s.name;

--Find the top threat that our listed species are facing.
SELECT threat_id,
COUNT(*) AS repetition_count
FROM threat
GROUP BY threat_id
ORDER BY repetition_count DESC
LIMIT 1;

-- Now, could you find out which one is threat_id 2?
SELECT * 
FROM threat_description 
WHERE threat_id='2';

-- Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis
SELECT s.name AS species_name
FROM species AS s
WHERE s.species_id IN (
SELECT species_id
FROM threat
WHERE threat_id = 5
);

--In your database, create a stored function that can be applied to
a query in your DB
CREATE FUNCTION red_list_trend (red_list_category VARCHAR (55), population_trend VARCHAR (50))
RETURNS VARCHAR (85) DETERMINISTIC
RETURN CONCAT(red_list_category, ' ', population_trend, ' ');

SELECT species_id, red_list_trend(red_list_category, population_trend) 
AS RLC
FROM red_list_category;























