
-- This Big Query script creates a table with all the public transport nodes in the USA
-- and exports it to a CSV file in a GCS bucket.

BEGIN

DROP TABLE IF EXISTS `my-project.my-dataset.osm_public_transport_usa_for_export`;
CREATE TABLE `my-project.my-dataset.osm_public_transport_usa_for_export`
As
SELECT g.geoid, ST_X(g.geom) longitude, ST_Y(g.geom) latitude,
    cast(p.do_date as string) do_date, p.version, p.amenity,
    p.public_transport, tags.key tags_key, tags.value tags_value,
    'US' as country_iso2
FROM `carto-do-public-data.openstreetmap.pointsofinterest_nodes_usa_latlon_v1_quarterly_v1` p,
UNNEST(all_tags) tags
JOIN `carto-do-public-data.openstreetmap.geography_usa_latlon_v1` g
    ON p.geoid = g.geoid
WHERE public_transport IN ('platform', 'station', 'stop_position')
    OR amenity IN ('bus_station') OR (tags.key IN ('highway')
    AND  tags.value IN ('bus_stop'));

EXPORT DATA
  OPTIONS (
    uri = 'gs://my-gc-storage/osm_public_transport_usa/*.parquet',
    format = 'PARQUET',
    overwrite = true,
    compression = 'SNAPPY'
  )
AS (
  SELECT *
  FROM `my-project.my-dataset.osm_public_transport_usa_for_export`
);

DROP TABLE IF EXISTS `my-project.my-dataset.osm_public_transport_usa_for_export`;

END;
