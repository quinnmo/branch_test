include: "quinn_test.model.lkml"
view: native_dt {
  derived_table: {
    explore_source: order_items {
      column: user_id {field: order_items.id}
      column: lifetime_number_of_orders {field: order_items.count}
      column: lifetime_customer_value {field: order_items.sale_price}
    }
  }
    # Define the view's fields as desired
    dimension: user_id {type: number}
    dimension: lifetime_number_of_orders {type: number}
    dimension: lifetime_customer_value {type: number}

}
