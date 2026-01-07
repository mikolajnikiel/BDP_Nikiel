--1
Select count(*) from uk_250k2;

Select * from national_parks;

-- 6
CREATE TABLE uk_lake_district AS
SELECT
    ST_Clip(r.rast, p.geom, true) AS rast
FROM
    uk_250k AS r,
    national_parks AS p
WHERE
    p.id = 1 
    AND ST_Intersects(r.rast, p.geom);

Select * from uk_lake_district

------
CREATE TABLE sentinel_green_clip1 AS
SELECT
    ST_Clip(r.rast, ST_Transform(p.geom, ST_SRID(r.rast)), true) AS rast
FROM
    sentinel_green1 r,
    national_parks p
WHERE
    p.id = 1
    AND ST_Intersects(r.rast, ST_Transform(p.geom, ST_SRID(r.rast)));


SELECT AddRasterConstraints('sentinel_green_clip1', 'rast');
CREATE INDEX sentinel_green_clip_idx1 ON sentinel_green_clip1 USING GIST (ST_ConvexHull(rast));


CREATE TABLE sentinel_nir_clip1 AS
SELECT
    ST_Clip(r.rast, ST_Transform(p.geom, ST_SRID(r.rast)), true) AS rast
FROM
    sentinel_nir1 r,
    national_parks p
WHERE
    p.id = 1
    AND ST_Intersects(r.rast, ST_Transform(p.geom, ST_SRID(r.rast)));

SELECT AddRasterConstraints('sentinel_nir_clip1', 'rast');
CREATE INDEX sentinel_nir_clip_idx1 ON sentinel_nir_clip1 USING GIST (ST_ConvexHull(rast));

--------
Select count(*) From lake_district_ndwi;


DROP TABLE lake_district_ndwi;
------


CREATE TABLE lake_district_ndwi_v21 AS
SELECT
   
    ST_SetSRID(ST_MapAlgebra(
            a.rast,
            b.rast,
            '([rast1] - [rast2]) / NULLIF([rast1] + [rast2], 0)::float'),
        ST_SRID(a.rast)
    ) AS rast
FROM
    sentinel_green_clip1 a,
    sentinel_nir1  b
WHERE
    ST_Intersects(a.rast, b.rast);

SELECT AddRasterConstraints('lake_district_ndwi_v21', 'rast');

Select count(*) from lake_district_ndwi_v21;
