{% snapshot dim_bookings_snapshot %}

{{
    config(
      target_database='AIRBNB',
      target_schema='snapshots',
      unique_key='BOOKING_ID',
      strategy='check',
      check_cols=['BOOKING_STATUS', 'BOOKING_AMOUNT', 'NIGHTS_BOOKED'],
    )
}}

select * from {{ ref('bronze_bookings') }}

{% endsnapshot %}