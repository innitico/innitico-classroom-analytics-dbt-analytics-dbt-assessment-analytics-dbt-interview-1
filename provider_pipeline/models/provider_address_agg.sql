with providers as (
    select
        id as provider_id
    from {{ ref('providers') }}
),
 
provider_addresses as (
    select
        provider_id,
        address_id
    from {{ ref('provider_addresses') }}
),
 
addresses as (
    select
        id as address_id,
        street,
        rank
    from {{ ref('addresses') }}
),
 
joined as (
    select
        p.provider_id,
        coalesce(
            list(
                struct_pack(
                    address_id := a.address_id,
                    street := a.street,
                    rank := a.rank
                )
            ) filter (where a.address_id is not null), '[]'
        ) as addresses
    from providers p
    left join provider_addresses pa on p.provider_id = pa.provider_id
    left join addresses a on pa.address_id = a.address_id
    group by p.provider_id
)
 
select * from joined