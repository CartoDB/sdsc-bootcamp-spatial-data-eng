{{ config(
    cluster_by = 'geom',
) }}

with raw_source as (

    select * from {{ source('sdsc_bootcamp_data', 'raw_public_transportation') }}
    where geoid is not null

)
, filter_cols as (

    select
        cast(geoid as int64) as id
        , cast(latitude as float64) as latitude
        , cast(longitude as float64) as longitude
        , cast(do_date as timestamp) as version_date
        , amenity
        , public_transport
        , tags_key
        , tags_value
        , country_iso2 as country

    from raw_source

)

, add_geometry as (

    select
        *
        , st_geogpoint(longitude, latitude) as geom
    from filter_cols
    where latitude is not null or longitude is not null

)

select
    id
    , version_date
    , amenity
    , public_transport
    , tags_key
    , tags_value
    , geom

from add_geometry

