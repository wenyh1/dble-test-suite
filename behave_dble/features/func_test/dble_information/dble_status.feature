# Copyright (C) 2016-2020 ActionTech.
# License: https://www.mozilla.org/en-US/MPL/2.0 MPL version 2 or higher.
# update by quexiuping at 2020/8/26

Feature:  dble_status test

   Scenario:  dble_status table #1
  #case desc dble_status
   Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_1"
      | conn   | toClose | sql                 | db               |
      | conn_0 | False   | desc dble_status    | dble_information |
    Then check resultset "dble_status_1" has lines with following column values
      | Field-0        | Type-1       | Null-2 | Key-3 | Default-4 | Extra-5 |
      | variable_name  | varchar(24)  | NO     | PRI   | None      |         |
      | variable_value | varchar(20)  | NO     |       | None      |         |
      | comment        | varchar(200) | YES    |       | None      |         |
   #case select * from dble_status
    Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_2"
      | conn   | toClose | sql                       | db                |
      | conn_0 | False   | select * from dble_status | dble_information  |
    Then check resultset "dble_status_2" has lines with following column values
      | variable_name-0         | comment-2                                                                                        |
      | uptime                  | length of time to start dble(s).                                                                 |
      | current_timestamp       | the current time of the dble system.                                                             |
      | startup_timestamp       | dble system startup time.                                                                        |
      | heap_memory_used        | heap memory usage(mb)                                                                            |
      | heap_memory_total       | the amount of heap memory(mb)                                                                    |
      | config_reload_timestamp | last config load time.                                                                           |
      | direct_memory_pool_size | size of the memory pool, is equal to the product of BufferPoolPagesize and BufferPoolPagenumber. |
      | direct_memory_pool_used | directmemory memory in the memory pool that has been used.                                       |
      | questions               | number of requests.                                                                              |
      | transactions            | the transaction number.                                                                          |

     #case compare with result
    Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_3"
      | conn   | toClose | sql                                                                                                 | db               |
      | conn_0 | False   | select variable_value,CURRENT_TIME() from dble_status where variable_name='current_timestamp'       | dble_information |
 #   Then check resultset "dble_status_3" has lines with following column values






     #case change sharding.xml and reload compare with result
#    Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_4"
#      | conn   | toClose | sql                   | db               |
#      | conn_0 | False   | select variable_value from version where variable_name='config_reload_timestamp' |dble_information  |
#    Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_5"
#      | conn   | toClose | sql                   | db               |
#      | conn_0 | False   |select last_reload_end from dble_reload_status where INDEX=0        | dble_information |
#    Then check resultsets "dble_status_4" and "dble_status_5" are same in following columns
#      |column   | column_index |
#      |version  | 0            |

