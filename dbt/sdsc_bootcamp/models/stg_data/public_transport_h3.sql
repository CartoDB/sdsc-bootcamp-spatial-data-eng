{{ config(
    cluster_by = 'h3',
) }}

with points_dataset as (

    select id, geom from {{ ref('public_transport') }}
    where geom is not null

)

, add_h3 as (

    select
        id, `carto-un`.carto.H3_FROMGEOGPOINT(geom, 6) as h3
    from points_dataset
)

, h3_agg as (

    select
        h3, count(*) as n_stops
    from add_h3
    group by h3

)

select
    h3
    , n_stops
from h3_agg