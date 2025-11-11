CREATE EXTENSION postgis;

CREATE TABLE obiekty(
	nazwa Varchar(25),
	geometry Geometry
);

INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt1',ST_GeomFromText('COMPOUNDCURVE(
	LINESTRING(0 1, 1 1),
    CIRCULARSTRING(1 1, 2 0, 3 1),
	CIRCULARSTRING(3 1, 4 2, 5 1),
    LINESTRING(5 1, 6 1))')
);

INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt2', ST_GeomFromText('CURVEPOLYGON(
	COMPOUNDCURVE(
		LINESTRING(10 6, 14 6),
		CIRCULARSTRING(14 6, 16 4, 14 2),
		CIRCULARSTRING(14 2, 12 0, 10 2),
		LINESTRING(10 2, 10 6)
	),
	CIRCULARSTRING(11 2, 12 3, 13 2, 12 1, 11 2))')
);

INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt3', ST_GeomFromText('POLYGON((
	7 15, 10 17, 12 13, 7 15))')
);

INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt4',ST_GeomFromText('LINESTRING(
	20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')
);

INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt5', ST_GeomFromText('MULTIPOINT Z(
	(38 32 234), (30 30 59))')
);



INSERT INTO obiekty (nazwa, geometry) VALUES 
('obiekt6',ST_GeomFromText('GEOMETRYCOLLECTION(           
	LINESTRING(1 1, 3 2),     
    POINT(4 2))')
);

--2

SELECT ST_Area(
	ST_Buffer(
		ST_ShortestLine(trzy.geometry, cztery.geometry), 5
	)
)
FROM obiekty trzy, obiekty cztery
WHERE trzy.nazwa = 'obiekt3' AND cztery.nazwa='obiekt4';


--3 aby stworzyć poligon obiekt musi zostać 'domknięty'
UPDATE obiekty
SET geometry = ST_GeomFromText('LINESTRING(
	20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20)')
WHERE nazwa = 'obiekt4';

UPDATE obiekty
SET geometry = ST_MakePolygon(geometry)
WHERE nazwa = 'obiekt4';

--4
INSERT INTO obiekty (nazwa, geometry) 
SELECT 'obiekt7', ST_Union(trzy.geometry,cztery.geometry)
FROM obiekty trzy, obiekty cztery 
WHERE trzy.nazwa = 'obiekt3' AND cztery.nazwa='obiekt4';

--5
SELECT nazwa, ST_Area(ST_Buffer(geometry,5)) AS pole
FROM obiekty
WHERE ST_HasArc(geometry) = false;