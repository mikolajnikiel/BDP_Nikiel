CREATE EXTENSION postgis;

--Dane zaimportowane zostały przy pomocy ipmort/export menagera

--1) budynek jest nowy lub wyremontowany więc jego geometria z 2018 i 2019 będzie różna

CREATE TABLE noweB AS

SELECT bud2019.* 
FROM t2019_kar_buildings bud2019
LEFT JOIN t2018_kar_buildings bud2018 
ON ST_Equals(bud2019.geom, bud2018.geom) --dopasowanie 18 do 19, tam gdzie nie są zgodne zostaje NULL
WHERE bud2018.geom IS NULL;


--2) 
--Wynik pierwszego zadania zapisujemy do nowej tabeli dla wygody

CREATE TABLE nowePOI AS
SELECT poi2019.* 
FROM t2019_kar_poi_table poi2019
LEFT JOIN t2018_kar_poi_table poi2018
ON ST_Equals(poi2019.geom, poi2018.geom) 
WHERE poi2018.geom IS NULL;

SELECT nP.type AS Kategoria, COUNT(*) AS Ilosc
FROM nowePOI nP
JOIN noweB nB
ON ST_DWithin(nP.geom::geography, nB.geom::geography, 500) --typ geography liczy w metrach
GROUP BY nP.type;


--3)

CREATE TABLE streets_reprojected AS
SELECT gid, link_id, st_name, ref_in_id, nref_in_id, func_class,
	speed_cat, fr_speed_l, to_speed_l, dir_travel, 
	ST_Transform(geom, 3068) as geom
FROM t2019_kar_streets;


--4) 

-- Tworzymy tabele z punktami o 'starych' współrzędnych i w kolejnym punkcie 
-- zmieniamy je na takie w układzie DHDN.Berlin/Cassini

CREATE TABLE input_points(
	id INT Primary Key,
    geom geometry(Point, 4326)
);

INSERT INTO input_points (id, geom) VALUES
(1, ST_SetSRID(ST_MakePoint(8.36093, 49.03174), 4326)),
(2, ST_SetSRID(ST_MakePoint(8.39876, 49.00644), 4326));


--5)
ALTER TABLE input_points 
ALTER COLUMN geom TYPE GEOMETRY(Point, 3068) 
USING ST_Transform(geom, 3068);


--6)

-- na poczatku zmieniamy układ współrzędnych tabeli Street_node
ALTER TABLE t2019_kar_street_node
ALTER COLUMN geom TYPE GEOMETRY(Point, 3068) 
USING ST_Transform(geom, 3068);

-- potem tworzymy linię z tych
WITH input_linia AS (
    SELECT ST_MakeLine(geom) AS linia
    FROM input_points
)
SELECT n.*
FROM streets_reprojected n
JOIN input_linia l
ON ST_DWithin(n.geom, l.linia, 200); 
--z tego co rozumiem dla tego SRID nie potrzebujemy używać ::geography 
--bo ten układ operuje w metrach


--7)

SELECT COUNT(*) AS Ilosc_sklepow
FROM t2019_kar_poi_table poi
JOIN t2019_kar_land_use_a p
ON ST_DWithin(poi.geom::geography, p.geom::geography, 300)
WHERE poi.type = 'Sporting Goods Store';
--teraz gdy używamy układu 4326 to znowu dodałem geography


--8
CREATE TABLE t2019_kar_bridges AS
SELECT ST_Intersection(r.geom::geography, w.geom::geography) AS geom 
FROM t2019_kar_railways AS r
JOIN t2019_kar_water_lines AS w
ON ST_Intersects(r.geom::geography, w.geom::geography); 




