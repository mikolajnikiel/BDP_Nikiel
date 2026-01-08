CREATE EXTENSION POSTGIS;
CREATE EXTENSION POSTGIS_RASTER;


CREATE TABLE "raster_scal" AS
SELECT 1 as id, ST_Union(
        ST_SnapToGrid("rast", 0, 0),
    ) AS rast
FROM "Exports";

SELECT AddRasterConstraints('raster_scal'::name, 'rast'::name);
CREATE INDEX raster_scal_idx ON "raster_scal" USING gist (ST_ConvexHull(rast));

