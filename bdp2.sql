--baze danych stworzyłem korzystająć z interfejsu użytkownika pgAdmin

CREATE EXTENSION postgis;

CREATE TABLE buildings(
	id int Primary key,
	geometry Geometry,
	name Varchar(30)
);

CREATE TABLE roads(
 	id Int Primary Key,
	geometry Geometry,
	name Varchar(30)
);

CREATE TABLE poi(
 	id Int Primary Key,
	geometry Geometry,
	name Varchar(30)
);

--ST_GeomFromText('') - tworzy obiekt ST_Geometry


INSERT INTO buildings (id, geometry, name) VALUES
(1,ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'), 'BuildingA'),
(2,ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))'), 'BuildingB'),
(3,ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))'), 'BuildingC'),
(4,ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))'), 'BuildingD'),
(5,ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))'), 'BuildingF');

INSERT INTO roads (id, geometry, name) VALUES
(1,ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'), 'RoadX'),
(2,ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)'), 'RoadY');


INSERT INTO poi (id, geometry, name) VALUES
(1,ST_GeomFromText('POINT(1 3.5)'), 'G'),
(2,ST_GeomFromText('POINT(5.5 1.5)'), 'H'),
(3,ST_GeomFromText('POINT(6.5 6)'), 'J'),
(4,ST_GeomFromText('POINT(6 9.5)'), 'K'),
(5,ST_GeomFromText('POINT(9.5 6)'), 'I');

--a
SELECT SUM(ST_Length(geometry)) AS "Długość dróg"
FROM roads;

--b
SELECT id, name,
	ST_AsText(geometry) AS "Geometria",
	ST_Area(geometry) AS "Pole powierzchni",
	ST_Perimeter(geometry) AS "Obwód"
FROM buildings
WHERE name = 'BuildingA';
	
--c
SELECT name, ST_Area(geometry) AS "Pole powierzchni"
FROM buildings
ORDER BY name; 

--d
SELECT name, ST_Area(geometry) AS "Pole powierzchni"
FROM buildings
ORDER BY "Pole powierzchni" DESC
LIMIT 2;

--e
SELECT ST_Distance(
	(SELECT geometry FROM buildings WHERE name = 'BuildingC'),
	(SELECT geometry FROM poi WHERE name = 'K')
); 

--f
SELECT ST_Area(
	ST_Difference((SELECT geometry FROM buildings WHERE name = 'BuildingC'),
	ST_Buffer((SELECT geometry FROM buildings WHERE name = 'BuildingB'), 0.5))
) AS "Pole C bez buforu B";

--g
SELECT b.name
FROM buildings b, roads r
WHERE r.name = 'RoadX' AND ST_Y(ST_Centroid(b.geometry)) > ST_YMax(r.geometry);


--h
SELECT ST_Area(ST_SymDifference((
	SELECT geometry from buildings WHERE name = 'BuildingC'),
	ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))
) AS "Powierzchnia bez części wspólnych";



