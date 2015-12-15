#! /bin/sh -e

. ./common.sh

hive -e "DROP DATABASE ${DBNAME}_hive CASCADE" 2>/dev/null || :
hive -e "CREATE DATABASE ${DBNAME}_hive"
