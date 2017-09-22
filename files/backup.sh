#!/usr/bin/env bash

fail() {
    echo "$1"
    exit 1
}

APP_DIR="/opt/seafile"
BACKUP_DIR="${APP_DIR}/backup"
TOKEN="${APP_DIR}/TOKEN"

[ -f ${TOKEN} ] || fail "File [${TOKEN}] doesn't exist. Are you sure you already init your data directory ?"

/usr/bin/sqlite3 ${APP_DIR}/seahub.db ".backup ${BACKUP_DIR}/seahub.db"
/usr/bin/sqlite3 ${APP_DIR}/seafile-data/seafile.db ".backup ${BACKUP_DIR}/seafile.db"
/usr/bin/sqlite3 ${APP_DIR}/ccnet/OrgMgr/orgmgr.db ".backup ${BACKUP_DIR}/orgmgr.db"
/usr/bin/sqlite3 ${APP_DIR}/ccnet/GroupMgr/groupmgr.db ".backup ${BACKUP_DIR}/groupmgr.db"
/usr/bin/sqlite3 ${APP_DIR}/ccnet/PeerMgr/usermgr.db ".backup ${BACKUP_DIR}/usermgr.db"
/usr/bin/sqlite3 ${APP_DIR}/ccnet/misc/config.db ".backup ${BACKUP_DIR}/config.db"

echo "Backup finished."
