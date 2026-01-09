{{
    config(
        materialized = 'incremental',
        unique_key = 'BOOKING_ID'
    )
}}


SELECT
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
{{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2) }} AS TOTAL_AMOUNT,
    BOOKING_STATUS,
    SERVICE_FEE,
    CLEANING_FEE,
    CREATED_AT
FROM {{ ref('bronze_bookings') }}

{% if is_incremental() %}
  WHERE CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}