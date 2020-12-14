#|/bin/bash
#
# CALL FROM THE GIT_PATH folder, otherwise the tag is not written:
#  cd /home/$1/git/LandSupport
#  /opt/lsenv/lssed_dev.sh release # in case .05. below

# ATTENTION:
# Before to change the script, ensure that the cycles described in NOTES are still valid.

# NOTES
# The cycles of SED scripts is as follow:
# .01. from DEV-ENV/release   to   PROD-ENV/lspros: lssed_prod.sh
# .02. from DEV-ENV/ariespace to   PROD-ENV/lspros: lssed_prod.sh
# .03. to   DEV-ENV/ariespace from PROD-ENV/lspros: lssed_tmp.sh
# .04. to   DEV-ENV/release   from PROD-ENV/lspros: lssed_dev.sh
# .05. from DEV-ENV/ariespace to   DEV-ENV/release: lssed_dev.sh
# .06. to   DEV-ENV/ariespace from DEV-ENV/release: lssed_tmp.sh

# PARAMETERS:
#USER_PROD_HOME=lsprod
#USER_DEV_HOME=release
#USER_TMP_HOME=ariespace
#GIT_PATH=/home/$USER_DEV_HOME/git/LandSupport
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
git tag |  gawk  'END {print "{\"version\" : \"" $1 "\"}" }' > $GUI_PATH/plugins/landsupport/etc/version.json

# (1-a) client rasdaman:
# grep -inR "rasdaman.landsupport" --include \*.json ./
# 		https://rasdaman.landsupport.eu/rasdaman/ows (not rasdev, untill a copy of data is in rasdev)
#sed -i 's/$RAS_PUB_URL_PROD/$RAS_PUB_URL_PROD/g' $GUI_PATH/etc/datasets.json
sed -i 's/rasdaman.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/etc/datasets.json

# (1-b) server rasdaman:
# grep -inR "rasdaman.landsupport" --include \*.php ./
# 		https://rasdaman.landsupport.eu/rasdaman/ows (not rasdev, untill a copy of data is in rasdev)
#sed -i 's/$RAS_PUB_URL_PROD/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/ls_describe.php
#sed -i 's/$RAS_PUB_URL_PROD/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/respatch.php
#sed -i 's/$RAS_PUB_URL_PROD/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/wcps.php
#sed -i 's/$RAS_PUB_URL_PROD/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
#sed -i 's/$RAS_PUB_URL_PROD/$RAS_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/dispatchlib.php
sed -i 's/rasdaman.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/ls_describe.php
sed -i 's/rasdaman.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/respatch.php
sed -i 's/rasdaman.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/wcps.php
sed -i 's/rasdaman.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
sed -i 's/rasdaman.landsupport.eu/rasdaman.landsupport.eu/g' $GUI_PATH/plugins/landsupport/dispatchlib.php
sed -i 's/rasdev.landsupport.eu/rasdev.landsupport.eu/g' $GUI_PATH/plugins/landsupport/landsupport.php

# (2-a) client geoserver:
# grep -inR "geoserver.landsupport" --include \*.json ./
#		https://geodev.landsupport.eu/geoserver/wms (use geoserver instead, because ARIES states that the persistency rsync is not sufficient)
#sed -i 's/$GEO_PUB_URL_PROD/$GEO_PUB_URL_PROD/g' $GUI_PATH/etc/custom.json
sed -i 's/geoserver.landsupport.eu/geodev.landsupport.eu/g' $GUI_PATH/etc/custom.json

# (2-b) server geoserver:
# grep -inR "geoserver.landsupport" --include \*.php ./
#		https://geodev.landsupport.eu/geoserver/wms (use geoserver instead, because ARIES states that the persistency rsync is not sufficient)
#sed -i 's/$GEO_PUB_URL_PROD/$GEO_PUB_URL_PROD/g' $GUI_PATH/plugins/landsupport/landsupport.php
#sed -i 's/$GEO_PUB_URL_PROD/$GEO_PUB_URL_PROD/g' $GUI_PATH/server/req.php
sed -i 's/geoserver.landsupport.eu/geodev.landsupport.eu/g' $GUI_PATH/plugins/landsupport/landsupport.php
sed -i 's/geoserver.landsupport.eu/geodev.landsupport.eu/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
sed -i 's/geoserver.landsupport.eu/geodev.landsupport.eu/g' $GUI_PATH/server/req.php

# (3) switch apache web application:
# grep -inR "/var/www/html/tmp" --include \*.php ./gui/landsupportgui/plugins/landsupport
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/landsupport.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/disquery.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_5.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_5_3035.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_gs_5.php
#sed -i 's/\/var\/www\/html\/$APACHE_ROOT_PATH/\/var\/www\/html\/$APACHE_ROOT_PATH/g' $GUI_PATH/plugins/landsupport/dispatch_gl.php
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
#sed -i 's/\/home\/$USER_PROD_HOME/\/home\/$USER_DEV_HOME/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php

# (5) useless: we now avoid ssh on local host and call a container for the execution of a CMD.
# substitute ariespace@192.168.30.11 with lsprod@192.168.20.11
#sed -i 's/$USER_PROD_HOME\@192\.168\.$IP_DEV\.11/$USER_DEV_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/ras_coverage.php
#sed -i 's/$USER_PROD_HOME\@192\.168\.$IP_DEV\.11/$USER_DEV_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatch_gl.php
#sed -i 's/$USER_PROD_HOME\@192\.168\.$IP_DEV\.11/$USER_DEV_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatchgen.php
#sed -i 's/$USER_PROD_HOME\@192\.168\.$IP_DEV\.11/$USER_DEV_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatchmeta.php
#sed -i 's/$USER_PROD_HOME\@192\.168\.$IP_DEV\.11/$USER_DEV_HOME\@192\.168\.$IP_PROD\.11/g' $GUI_PATH/plugins/landsupport/dispatchlib.php

# (6) main web application URL
# grep -inR "tmp.landsupport.eu" --include \*.php ~/git/LandSupport/gui/landsupportgui/plugins/
sed -i 's/tmp.landsupport.eu/dev.landsupport.eu/g' $GUI_PATH/plugins/landsupport/landsupport.php
sed -i 's/tmp.landsupport.eu/dev.landsupport.eu/g' $GUI_PATH/plugins/join/join.php


# (7) Jupyter config modifications across {TMP,DEV,PROD} lines
sed -i 's/\"prod\"/\"dev\"/g' $GIT_PATH/middleware/api/PPProcessor/etc/conf/prepost_global_config.json


