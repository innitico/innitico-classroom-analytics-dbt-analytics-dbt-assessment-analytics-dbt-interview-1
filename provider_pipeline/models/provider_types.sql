with providers as (
    select * from {{ ref('providers') }}
),

degree_types as (
    select * from {{ ref('degree_types') }}
),

-- Split degrees column into an array and join with degree_types
exploded_degrees as (
    select 
        p.customer_id,
        p.first_name,
        p.last_name,
        trim(value.column_name) as degree  -- Replace `column_name` with the actual name of the field inside the STRUCT.
    from providers p
    cross join unnest(split(p.degrees, ',')) as value(column_name)  -- Explicitly define the STRUCT column name here.
),

-- Join with degree_types to get rank
degrees_with_rank as (
    select 
        ed.customer_id,
        ed.first_name,
        ed.last_name,
        ed.degree,
        dt.ptui,
        dt.rank
    from exploded_degrees ed
    left join degree_types dt on ed.degree = dt.degree
),

-- Get the lowest rank degree per provider
ranked_degrees as (
    select 
        customer_id,
        first_name,
        last_name,
        ptui,
        rank() over (partition by customer_id order by rank asc) as rnk
    from degrees_with_rank
)

-- Select only the lowest ranked degree per provider
select 
    customer_id,
    first_name,
    last_name,
    ptui
from ranked_degrees
where rnk = 1
