# Project namespace
NAMESPACE=vaultwarden

BACKUP_PVC="${NAMESPACE}-backup-pvc"
BACKUP_PVC_SIZE="5Gi"
BACKUP_KEEP_DAYS=30

APP_RESSOURCE="deployment.apps/vaultwarden-release"
APP_PVC="vaultwarden-data-vaultwarden-release-0"

DB_RESSOURCE="statefulset.apps/mariadb"
DB_PVC="data-mariadb-0"

test -d runtime && echo ERROR remove ./runtime dir first
test -d ./runtime && exit 1
mkdir ./runtime
chmod 700 ./runtime
for y in *.yml
do
  cp -av $y ./runtime/$y
  sed -i "s/__NAMESPACE__/$NAMESPACE/g"               ./runtime/$y

  sed -i "s#__APP_RESSOURCE__#$APP_RESSOURCE#g"       ./runtime/$y
  sed -i "s/__APP_PVC__/$APP_PVC/g"                   ./runtime/$y

  sed -i "s#__DB_RESSOURCE__#$DB_RESSOURCE#g"       ./runtime/$y
  sed -i "s/__DB_PVC__/$DB_PVC/g"                   ./runtime/$y

  sed -i "s/__BACKUP_KEEP_DAYS__/$BACKUP_KEEP_DAYS/g" ./runtime/$y
  sed -i "s/__BACKUP_PVC__/$BACKUP_PVC/g"             ./runtime/$y
  sed -i "s/__BACKUP_PVC_SIZE__/$BACKUP_PVC_SIZE/g"   ./runtime/$y
done

ls -l ./runtime

cd ./runtime
for y in *.yml
do
  echo $y
  kubectl apply -f $y
done

