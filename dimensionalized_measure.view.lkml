view: dimensionalized_measure {
  derived_table: {
    sql: SELECT
        users.state  AS `users.state`,
        COUNT(*) AS `users.count`
      FROM demo_db.users  AS users

      GROUP BY 1
      ORDER BY COUNT(*) DESC

       ;;
  }

  dimension: users_state {
    type: string
    sql: ${TABLE}.`users.state` ;;
  }

  dimension: users_count {
    type: number
    sql: ${TABLE}.`users.count` ;;
  }

  set: detail {
    fields: [users_state, users_count]
  }
}
