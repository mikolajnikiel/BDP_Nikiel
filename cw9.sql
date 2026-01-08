CREATE EXTENSION POSTGIS;
CREATE EXTENSION POSTGIS_RASTER;


CREATE TABLE "scalone" AS
SELECT 1 as id, ST_Union(
        ST_SnapToGrid("rast", 0, 0), 'MAX'
    ) AS rast
FROM "Exports";




