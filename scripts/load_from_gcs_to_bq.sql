
LOAD DATA OVERWRITE `carto-ps-bq-developers.sdsc_bootcamp_data.osm_public_transport_usa`
FROM FILES (
  format = 'PARQUET',
  uris = ['gs://carto-sdsc-bootcamp-data/osm_public_transport_usa/*.parquet']);