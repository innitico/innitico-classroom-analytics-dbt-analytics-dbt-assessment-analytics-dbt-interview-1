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
        pa.customer_id,
        json_group_array(
            json_object(
                'address_id', a.address_id,
                'street', a.street,
                'city', a.city,
                'state', a.state,
                'zip', a.zip
            )
        ) as addresses
    from provider_addresses pa
    left join addresses a on pa.address_id = a.address_id
    group by pa.customer_id
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
    left join joined_addresses ja on p.customer_id = ja.customer_id
)

select * from final;
