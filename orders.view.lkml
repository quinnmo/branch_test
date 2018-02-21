view: orders {
  sql_table_name: demo_db.orders ;;


  filter: date_filter {
    type: date
  }

  dimension: end_date {
    type: date
    sql: {% date_end date_filter %} ;;
  }

  dimension: start_date {
    type: date
    sql: {% date_start date_filter %} ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format: "-0"
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year, day_of_week_index
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: yesno_test {
    type: yesno
    sql: ${id} > 10 ;;
  }

dimension: date_test_string {
  type: string
  sql: ${created_month} ;;
  suggestions: ["2017/11", "2017/12", "2018/01" ]
}

dimension: created_date_string {
  type: string
  sql: cast(${created_month}as char) ;;
}

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id  ;;
  }

  dimension: case_test {
    sql: case when ${status} = 'Complete' THEN 'yes' ELSE ${user_id} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }

  measure: this_weeks_orders {
    type: count
    filters: {
      field: created_week
      value: "this week"
    }
  }

  measure: max_date {
    type: max
    sql: ${created_date} ;;
  }

  measure: last_weeks_orders {
    type: count
    filters: {
      field: created_week
      value: "last week"
    }
}

}
