#!/bin/bash
#
# CALL FROM THE GIT_PATH folder, otherwise the tag is not written:
#  cd /home/$1/git/LandSupport
#  /opt/lsenv/lssed_dev.sh release # in case .05. below

# ATTENTION:
# Before to change the script, ensure that the cycles described in NOTES is still valid.

# NOTES
# The cycles of SED scripts is as follow:
# from DEV-ENV/release   to   PROD-ENV/lspros: landsupport_sed_prod.sh
# from DEV-ENV/ariespace to   PROD-ENV/lspros: landsupport_sed_prod.sh
# to   DEV-ENV/ariespace from PROD-ENV/lspros: landsupport_sed_tmp.sh
# to   DEV-ENV/release   from PROD-ENV/lspros: landsupport_sed_dev.sh
# from DEV-ENV/ariespace to   DEV-ENV/release: landsupport_sed_dev.sh
# to   DEV-ENV/ariespace from DEV-ENV/release: landsupport_sed_tmp.sh

# PARAMETERS:
#USER_PROD_HOME=lsprod
#USER_DEV_HOME=release
#USER_TMP_HOME=ariespace
#GIT_PATH=/home/$USER_PROD_HOME/git/LandSupport
GIT_PATH=/home/$1/git/LandSupport
GUI_PATH=$GIT_PATH/gui/landsupportgui
#GEO_PUB_URL_PROD=geoserver.landsupport.eu 
#RAS_PUB_URL_PROD=rasdaman.landsupport.eu   # rasdmana:9009
#GEO_PUB_URL_DEV=geodev.landsupport.eu 
#RAS_PUB_URL_DEV=rasdev.landsupport.eu
#APACHE_ROOT_PATH=root
#APACHE_TMP_PATH=tmp
# IP_DEV=30 #192.168.30.11
#IP_PROD=20 #192.168.20.11

# (0) apply version tag to the GUI:
git describe --tags | gawk  'END {print "{\"version\" : \"" $1 "\"}" }' > $GUI_PATH/plugins/landsupport/etc/version.json

# (1-a) client rasdaman:
# grep -inR "rasdaman.landsupport" --include \*.json ./
# 		https://rasdaman.landsupport.eu/rasdaman/ows (not rasdev, untill a copy of data is in rasdev)
#sed -i 's/$RAS_PUB_URL_DEV/$RAS_PUB_URL_PROD/g' $GUI_PATH/etc/datasets.json
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/etc/datasets.json

# (1-b) server rasdaman:
# grep -inR "rasdaman.landsupport" --include \*.php ./
# 		https://rasdaman.landsupport.eu/rasdaman/ows (not rasdev, untill a copy of data is in rasdev)
#sed -i 's/$RAS_PUB_URL_DEV/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/ls_describe.php
#sed -i 's/$RAS_PUB_URL_DEV/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/respatch.php
#sed -i 's/$RAS_PUB_URL_DEV/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/wcps.php
#sed -i 's/$RAS_PUB_URL_DEV/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
#sed -i 's/$RAS_PUB_URL_DEV/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/dispatchlib.php
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/ls_describe.php
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/respatch.php
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/wcps.php
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/dispatchlib.php
sed -i 's/rasdev.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/landsupport.php


# (2-a) client geoserver:
# grep -inR "geoserver.landsupport" --include \*.json ./
#		https://geodev.landsupport.eu/geoserver/wms (use geoserver instead, because ARIES states that the persistency rsync is not sufficient)
#sed -i 's/$GEO_PUB_URL_DEV/$GEO_PUB_URL_PROD/g' $GUI_PATH/etc/custom.json
sed -i 's/geodev.landsupport.eu/geoserver.landsupport.eu/g' $GUI_PATH/etc/custom.json

# (2-b) server geoserver:
# grep -inR "geoserver.landsupport" --include \*.php ./
#		https://geodev.landsupport.eu/geoserver/wms (use geoserver instead, because ARIES states that the persistency rsync is not sufficient)
#sed -i 's/$GEO_PUB_URL_DEV/$GEO_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/landsupport.php
#sed -i 's/$GEO_PUB_URL_DEV/$GEO_PUB_URL_PROD/g' $GUI_PATH/server/req.php
sed -i 's/geodev.landsupport.eu/geoserver.landsupport.eu/g' $GUI_PATH/plugins/landsupport/landsupport.php
sed -i 's/geodev.landsupport.eu/geoserver.landsupport.eu/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
sed -i 's/geodev.landsupport.eu/geoserver.landsupport.eu/g' $GUI_PATH/server/req.php

# (3) switch apache web application:
# grep -inR "/var/www/html/root" --include \*.php ./
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/landsupport.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/disquery.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_5.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_5_3035.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_gs_5.php
#sed -i 's/\/var\/www\/html\/$APACHE_TMP_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_gl.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/landsupport.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatch.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/disquery.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatch_5.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatch_5_3035.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatch_gs_5.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatch_gl.php
sed -i 's/\/var\/www\/html\/tmp/\/var\/www\/html\/root/g' $GUI_PATH/plugins/landsupport/dispatch_*.php

# (4) useless: we now avoid ssh on local host and call a container for the execution of a CMD.
# ./gui/landsupportgui/plugins/landsupport/dispatchmeta.php
#sed -i 's/\/home\/$USER_TMP_HOME/\/home\/$USER_PROD_HOME/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php

# (5) useless: we now avoid ssh on local host and call a container for the execution of a CMD.
# substitute ariespace@192.168.30.11 with lsprod@192.168.20.11
#sed -i 's/$USER_DEV_HOME\@192\.168\.$IP_DEV\.11/$USER_PROD_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/ras_coverage.php
#sed -i 's/$USER_DEV_HOME\@192\.168\.$IP_DEV\.11/$USER_PROD_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatch_gl.php
#sed -i 's/$USER_DEV_HOME\@192\.168\.$IP_DEV\.11/$USER_PROD_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatchgen.php
#sed -i 's/$USER_DEV_HOME\@192\.168\.$IP_DEV\.11/$USER_PROD_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
#sed -i 's/$USER_DEV_HOME\@192\.168\.$IP_DEV\.11/$USER_PROD_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatchlib.php


# (6) main web application URL
# grep -inR "dev.landsupport.eu" --include \*.php ~/git/LandSupport/gui/landsupportgui/plugins/
sed -i 's/dev.landsupport.eu/app.landsupport.eu/g' $GUI_PATH/plugins/landsupport/landsupport.php
sed -i 's/dev.landsupport.eu/app.landsupport.eu/g' $GUI_PATH/plugins/join/join.php
sed -i 's/dev.landsupport.eu/app.landsupport.eu/g' $GUI_PATH/plugins/join/passwordreset.php

# (7) Jupyter config modifications across {TMP,DEV,PROD} lines
sed -i 's/\"dev\"/\"prod\"/g' $GIT_PATH/middleware/api/PPProcessor/etc/conf/prepost_global_config.json
sed -i 's/\"copyToPostgreSQL\" : \"dev\"/\"copyToPostgreSQL\" : \"prod\"/g' $GIT_PATH/middleware/api/PPProcessor/etc/conf/collaudo_config.json


