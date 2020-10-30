


  if [ "$ENV" != "prod" ]; then
    return
  fi

  now=`date +%Y-%m-%d.%H:%M:%S`

  echo -e "backup in progress\nplease wait.."

  if [ -d $DATA_PATH/ovecdata ]; then
      sudo tar -czf /tmp/ovecdata-$now.tar.gz $DATA_PATH/ovecdata
  fi

  if [ -d $DATA_PATH/postgis-db ]; then
      sudo tar -czf /tmp/postgis-db-$now.tar.gz $DATA_PATH/postgis-db
  fi

  echo "REMEMBER: check in /tmp yours ovecdata-$now and postgis-db-$now tar.gz backups"

