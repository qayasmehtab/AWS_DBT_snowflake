{% set configs = [
    {
        "model": "sliver_bookings",
        "columns": "sliver_bookings.BOOKING_ID, 
                  sliver_bookings.LISTING_ID, 
                  sliver_bookings.BOOKING_DATE, 
                  sliver_bookings.TOTAL_AMOUNT, 
                  sliver_bookings.BOOKING_STATUS, 
                  sliver_bookings.SERVICE_FEE, 
                  sliver_bookings.CLEANING_FEE, 
                  sliver_bookings.CREATED_AT AS BOOKING_CREATED_AT",
        "alias": "sliver_bookings"
    },
    {
        "model": "sliver_listings",
        "columns": "sliver_listings.HOST_ID, 
                  sliver_listings.PROPERTY_TYPE, 
                  sliver_listings.ROOM_TYPE, 
                  sliver_listings.CITY, 
                  sliver_listings.COUNTRY, 
                  sliver_listings.ACCOMMODATES, 
                  sliver_listings.BEDROOMS, 
                  sliver_listings.BATHROOMS, 
                  sliver_listings.PRICE_PER_NIGHT, 
                  sliver_listings.PRICE_LEVEL, 
                  sliver_listings.CREATED_AT AS LISTING_CREATED_AT",
        "alias": "sliver_listings",
        "join_condition": "sliver_bookings.listing_id = sliver_listings.listing_id"
    },
    {
        "model": "sliver_hosts",
        "columns": "sliver_hosts.HOST_NAME, 
                  sliver_hosts.HOST_SINCE, 
                  sliver_hosts.IS_SUPERHOST, 
                  sliver_hosts.RESPONSE_RATE, 
                  sliver_hosts.RESPONSE_RATE_QUALITY, 
                  sliver_hosts.CREATED_AT AS HOST_CREATED_AT",
        "alias": "sliver_hosts",
        "join_condition": "sliver_listings.host_id = sliver_hosts.host_id"
    }
] %}

SELECT
    {% for config in configs -%}
    {{ config.columns }}{%- if not loop.last %}, {% endif %}
    {% endfor %}
FROM {{ ref(configs[0].model) }} AS {{ configs[0].alias }}
{% for config in configs[1:] -%}
LEFT JOIN {{ ref(config.model) }} AS {{ config.alias }}
    ON {{ config.join_condition }}
{% endfor %}
