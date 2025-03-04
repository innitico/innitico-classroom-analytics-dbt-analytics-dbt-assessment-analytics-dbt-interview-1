with 
providers as (
    select * from {{ ref('providers') }}
),

provider_addresses as (
    select * from {{ ref('provider_addresses') }}
),

addresses as (
    select * from {{ ref('addresses') }}
),

joined_addresses as (
    select 
        pa.id,
        json_group_array(
            json_object(
                'address_id', a.id,
                'street', a.street
            )
        ) as addresses
    from provider_addresses pa
    left join addresses a on pa.address_id = a.id
    group by pa.id
),

-- providers with no addresses are available
final as (
    select 
        p.customer_id,
        p.first_name,
        p.last_name,
        p.degrees,
        coalesce(ja.addresses, json_array()) as addresses
    from providers p
    left join joined_addresses ja on p.customer_id = ja.id
)

select * from final
