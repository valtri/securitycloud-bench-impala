#! /bin/sh -e

. ./common.sh

hive ${HIVE_ARGS} -e "DROP DATABASE ${DBNAME}_hive CASCADE" 2>/dev/null || :
hive ${HIVE_ARGS} -e "CREATE DATABASE ${DBNAME}_hive" 2>&1
