{{ config(
    cluster_by = 'geom',
) }}

with raw_source as (

    select * from {{ source('sdsc_bootcamp_data', 'raw_public_transportation') }}
    where geom_wkt is not null and geoid is not null

)
, filter_cols as (

    select
        cast(geoid as int64) as id
        , geom_wkt
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
        , st_geogfromtext(geom_wkt) as geom
    from filter_cols

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

