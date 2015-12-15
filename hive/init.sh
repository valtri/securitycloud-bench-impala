#! /bin/sh -e

. ./common.sh

hive ${HIVE_ARGS} -e "DROP DATABASE ${DBNAME}_hive CASCADE" >/dev/null 2>&1 || :
hive ${HIVE_ARGS} -e "CREATE DATABASE ${DBNAME}_hive" 2>&1
