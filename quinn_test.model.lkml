connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"


explore: inventory_items {}

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} AND ${orders.status} = "complete";;
    relationship: many_to_one
  }
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
}

explore: products {}

explore: users {}

explore: native_dt {}

explore: inventory_star {
  join: order_items {
    relationship: one_to_one
    sql_on: ${order_items.id} = ${inventory_star.oi_id} ;;
  }
  join: products {
    relationship: one_to_one
    sql_on: ${products.id} = ${inventory_star.p_id} ;;
  }
}
