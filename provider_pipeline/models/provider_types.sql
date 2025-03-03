with providers as (
    select
        id as provider_id,
        string_to_array(degrees, ',') as degree_array
    from {{ ref('providers') }}
),
 
degree_types as (
    select
        id as degree_id,
        degree,
        ptui,
        rank
    from {{ ref('degree_types') }}
),
 
exploded as (
    select
        p.provider_id,
        unnest(p.degree_array) as degree
    from providers p
),
 
joined as (
    select
        e.provider_id,
        dt.ptui,
        dt.rank,
        row_number() over (partition by e.provider_id order by dt.rank asc) as rn
    from exploded e
join degree_types dt on e.degree = dt.degree
)
 
select provider_id, ptui
from joined
where rn = 1