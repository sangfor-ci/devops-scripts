

BASE_DIR=/root/mysql-8.0.31-linux-glibc2.12-x86_64  \
    /root/mysql-8.0.31-linux-glibc2.12-x86_64/bin/mysqld     \
    --initialize  \
    --basedir="$BASE_DIR"   \
    --datadir="$BASE_DIR/data"       \
    --character-set-server=utf8       \
    --lower_case_table_names=1


BASE_DIR=/root/mysql-8.0.31-linux-glibc2.12-x86_64  \
  /root/mysql-8.0.31-linux-glibc2.12-x86_64/bin/mysqld_safe    \
    --no-defaults       \
    --log-error="$BASE_DIR/mysql-error.log"       \
    --basedir="$BASE_DIR"       \
    --user=root       \
    --datadir="$BASE_DIR/data"     \
    --lower_case_table_names=1   \
    --port="2323"     \
    --max_connections=1000       \
    --interactive-timeout=2592000       \
    --wait_timeout=2592000       \
    --explicit_defaults_for_timestamp       \
    --event_scheduler=1

