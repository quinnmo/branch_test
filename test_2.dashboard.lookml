# - dashboard: field_filter_test
#   title: field_filter test
#   layout: newspaper
#   elements:
#   - title: test
#     name: test
#     model: quinn_test
#     explore: orders
#     type: table
#     fields:
#     - orders.status
#     - orders.count
#     - orders.id
#     - orders.created_date
#     sorts:
#     - orders.created_date desc
#     limit: 500
#     query_timezone: UTC
#     listen:
#       date: orders.created_date_string
#     row: 0
#     col: 0
#     width: 8
#     height: 6
#   filters:
#   - name: date
#     title: date
#     type: field_filter
#     default_value: ''
#     model: quinn_test
#     explore: orders
#     field: orders.date_test_string
#     listens_to_filters: []
#     allow_multiple_values: true
#     required: false
