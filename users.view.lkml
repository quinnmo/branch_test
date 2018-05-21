view: users {
  sql_table_name: demo_db.users ;;

parameter: viewability_unit {
  type: number
 allowed_value: {
  label: "0 - 0.55"
  value: "0 - 0.55"
}
allowed_value: {
  label: "0.56 - 0.69"
  value: "0.56 - 0.69"
}
  allowed_value: {
    label: "0.7 -1"
    value: "0.7 -1"
  }
}




# dimension: city_state_display {
#   sql:
#   {%if  users.city_state._is_filtered %}
#   ${city_state}
#   {% else %}
#   'NONE'
#   {% endif %}
#   ;;


# }


# dimension: display_2 {
#   sql: ${city_state_display} ;;
#   html:
#   {% if users.city_state._is_filtered %}
#   {% if _filters['users.city_state'] contains "^" %}
#   {{ _filters['users.city_state'] | remove: "^" }}
#   {% else %}
#   {{ _filters['users.city_statee']}}
#   {% endif %}
#   {% else %}
#   NONE
#   {% endif %} ;;
# }

dimension: city_state {
  type: string
  sql: concat(${city}, ',', ${state}) ;;
}

measure: test {
  type: number
  sql: CASE WHEN {% parameter viewability_unit %} = "0.7 -1" THEN

(CASE
WHEN (date between '2017-07-01' AND '2017-09-30')
THEN
(us_desktop_impressions_totalcodeservedcount * 1.0 * 2.13 / 1000)
+
(us_mobile_impressions_totalcodeservedcount * 1.0 * 1.19 / 1000)
+
(international_impressions * 1.0 * 1.04 / 1000))

WHEN {% parameter viewability_unit %} = "0 - 0.55" THEN

(CASE WHEN (date between '2017-10-01' AND '2017-12-31')
THEN
(us_desktop_impressions_totalcodeservedcount * 1.0 * 2.24 / 1000)
+
(us_mobile_impressions_totalcodeservedcount * 1.0 * 1.39 / 1000)
+
(international_impressions_totalcodeservedcount * 1.0 * 1.09 / 1000))

WHEN {% parameter viewability_unit %} = "0.56 - 0.69" THEN

(CASE WHEN (date between '2018-01-01' AND '2018-03-31')
THEN
(us_desktop_impressions_totalcodeservedcount * 1.0 * 1.49 / 1000)
+
(us_mobile_impressions_totalcodeservedcount * 1.0 * 0.99 / 1000)
+
(international_impressions_totalcodeservedcount * 1.0 * .85 / 1000))

ELSE NULL END ;;
}



  parameter: fiscal_periods {
    type: string
    allowed_value: {
      label: "2018/01/01 to 2018/01/15 (FP1)"
      value: "2018/01/01 to 2018/01/15"
    }
    allowed_value: {
      label: "2018/01/16 to 2018/01/31 (FP2)"
      value: "2018/01/16 to 2018/01/31"
    }
    allowed_value: {
      label: "2018/02/01 to 2018/02/15 (FP3)"
      value: "2018/02/01 to 2018/02/15"
    }
  }

  dimension: date_boolean {
    type: yesno
    sql: CASE
    WHEN {% parameter fiscal_periods %} = '2018/01/01 to 2018/01/15'
          THEN  (((users.created_at ) >= (TIMESTAMP('2018-01-01')) AND (users.created_at ) < (TIMESTAMP('2018-01-15'))))

    WHEN {% parameter fiscal_periods %} = '2018/01/16 to 2018/01/31'
          THEN (((users.created_at ) >= (TIMESTAMP('2018-01-16')) AND (users.created_at ) < (TIMESTAMP('2018-01-31'))))

    WHEN {% parameter fiscal_periods %} = '2018/02/01 to 2018/02/15'
           THEN (((users.created_at ) >= (TIMESTAMP('2018-02-01')) AND (users.created_at ) < (TIMESTAMP('2018-02-15'))))
              ELSE 1 = 1 END ;;
  }





  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    style: interval
    tiers: [0,4,8,12,16,20,24]
    sql: ${age} ;;
  }

#   dimension: age_tier {
#     type: tier
#     tiers: [0, 20, 40, 60, 80]
#     style: integer
#     sql: ${age} ;;
#   }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    link: {
      label: " text_dash"
      url: "https://master.dev.looker.com/dashboards/1153"
    }
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;

  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: is_last_day_of_month {
  type: yesno
  sql: EXTRACT( day from DATEADD(day,1,${created_date}) ) = 1 ;;
  }

#   measure: test {
#     type: date
#     sql: min(${created_date}) ;;
#   }


 dimension: user_id_not_5_10 {
   type: yesno
  sql: ${TABLE}.id NOT IN (5, 10) ;;
 }

 measure: last_date {
    sql: (SELECT MAX(${created_raw})
     FROM  demo_db.users
     WHERE  demo_db.users.State =  ${TABLE}.state
    )
    ;;
  }

  measure: last_date_2 {
    type: max
    sql: ${created_raw} ;;
  }


  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, orders.count]
  }

  measure: count_last_day_month {
    type: count
    filters: {
      field: is_last_day_of_month
      value: "yes"
    }
  }

  measure: count_CA {
    type: count
    filters: {
      field: state
      value: "California"
  }
    }

measure: count_NY {
  type: count
  filters: {
    field: state
    value: "New York"
  }
}

measure: count_TX {
  type: count
  filters: {
    field: state
    value: "Texas"
  }
}

measure: sum_age {
  type: sum
  sql: ${age} ;;
}


measure: list {
  type: list
  list_field: city
}

# measure: yesno_filter{
#   type: yesno
#   sql: ${count}/${count_2} < 0.20;;
# }

# measure: last_date {
#   type: max
#   sql: ${created_date} ;;
# }


}
