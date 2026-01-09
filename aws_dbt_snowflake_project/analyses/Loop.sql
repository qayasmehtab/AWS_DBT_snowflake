{% set cols =['NIGHTS_BOOKED', 'BOOKING_AMOUNT','bOOKING_STATUS' ] %}

SELECT
{% for col in cols %}
     {{col}}
         {% if not loop.last %},{% endif %}
 {% endfor %}
 FROM {{ref('bronze_bookings') }}
