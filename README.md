# The LandSupport Geospatial Cyber-Infrastructure (GCI)

## Implementation of two physically distinct environments
We built two distict environments – DEV and PROD – in order to completely separate the production environment (where the official web app is) from the environment in which partners are developing codes, adding and ingesting data. The only exception is given by rasdaman since the 8-cores licence is 

1. development (DEV) environment (ENV) [using VM on pedology; in future a VM on granatellum]
2. production (PROD) environment (ENV) [on granatellum host; in future a VM on granatellum]

## URL currently in use [20-Mar-2020]
### DEV ENV
 - dev-GUI    : https://dev.landsupport.eu
 - tmp-GUI    : https://tmp.landsupport.eu
 - GeoServer  : https://geodev.landsupport.eu/geoserver/web (port:9281) 
 - Rasdaman   : https://rasdev.landsupport.eu/rasdaman/ows  (port:8090)

### PROD ENV
 - prod-GUI   : https://app.landsupport.eu
 - GeoServer  : https://geoserver.landsupport.eu/geoserver/web (port:9281)
 - Rasdaman   : https://rasdaman.landsupport.eu/rasdaman/ows   (port:8090)


## GCI structure
The GCI is built based on dockers and is made of two most fundamental pieces: data and code.

### Code
The code is managed by means of git using a private GitHub [repository](https://github.com/giulange/LandSupport). Developers within the project were added as collaborators to contribute to the development and versioning of the whole code, which includes the following main folders:
 - **db**: it contains the instructions about how to build the docker virtualization for the different database components:
    * apache: for the web applications
    * geoserver: to manage vector data
    * postgres: for postgis extension to the postgres
    * pycsw: ??ARIES??
    * rasdaman: to manage raster data
 - **granules**: it collects the models (called granules) included in the GCI
 - **env**: scripts to build the two most important environments, *DEV* and *PROD*
 - **gui**: the code of the GUI. Three different stages of the GUI are available: prod-GUI (_official app_), dev-GUI (_pre-production app_), tmp-GUI (_real-time testing app_)
 - **middleware**: it contains all the software pieces required to connect models, databases and GUI. Main pieces are:
    * *REST API*: listening at the entrance of the docker container dedicated to the run of models. It accepts the RunID from the dispatcher (which in turn is connected to the GUI).
    * *Pre-processor*: it receives the RunID from the REST API, by means of which it can retrieve the arguments of the run, prepare the geospatial and temporal context of the execution, pass the parameters and inputs to the model.
    * *Docker container(s)*: each model or each tool in the GUI (to be defined yet) requires one dedicated docker container containing the model solving the user request. The container is invoked by the Pre-processor and added in the computing chain.
    * *Post-processor*: it collects model outputs, organize and store them. Finally, it writes 'completed' in the db so that the dispatcher understands that the execution ended (the dispatcher then completes the pipeline returning results to the user over the GUI).
    * *COMPSs*: For selected models, scales, users and other particular conditions, the model can be executed in parallel using the COMPSs framework.

### Data
Docker containers, models, databases etc. use data. We distinguish between three main types of data:
 1. _input data_ to be ingested once in a database, such as vector data in GeoServer, raster data in rasdaman, other data in PostGreSQL+PostGIS. This data is shared between the two environments DEV and PROD.
 2. _persistent data_: data generated after insert of input data in databases and saved outside the docker container as persistent data. This data is copied from the DEV enviroment to the PROD environment, for all databases except rasdaman.
 3. _lib_: these are external libraries duplicated locally in the GCI to extend its functionalities. These lib data are managed outside the git repository, since very little or none modification is required.

## ??configuration??
### Apache configuration
The creation of the docker container requires 

## Background and general conditions
On 10-Mar-2020 we started the implementation of the DEV ENV.
UNA started the git-flow approach integrated within Git-Kraken, in which UNA assigned
the different feature branches to the developers, the release and master branches to myself (with the support by Francesco):
 - **feature/* branch**, assigned to developers: each user has a dedicated account in DEV ENV
 - **release branch**, assigned to Giuliano by means of the release user in DEV ENV. It might need a script to apply for an automatic release management [develop --> release].
 - **master branch**, assigned to Giuliano by means of the lsprod user on granatellum-gpu host (ASAP we'll use a VM by means of WMWare on granatellum).

## Implementation of the DEV ENV
We performed the following operations:
1. git cloned and checked out on develop to start the different features and in particular the feature/gui
2. [**GUI**] copied in gui/landsupportgui the PROD folder called landsupport-dev (origin: /media/GFTP/landsupport/apache/htdocs/)
   * created a [**dev-GUI**](https://dev.landsupport.eu) under _release_ user for __pre-production__ (it points to /home/release/git/LandSupport/gui/landsupportgui/) [**release branch**]
   * created a [**tmp-GUI**](https://tmp.landsupport.eu) under _ariespace_ user for real-time testing (it points to /home/ariespace/git/LandSupport/gui/landsupportgui/)  [**feature/gui branch**]
3. [**geoserver**] split the PROD / vector folder into input data (DEV / vector) and persistent data (DEV / ovecdata). We performed the same in PROD.
4. generally, for all dockers, we shared the input data between DEV and PROD while copied persistent data
   * exception: rasdaman community in DEV does not have a copy of the persistence to avoid both large data transfers (~20TB at that time) and slowing down the community vers.
   * we need to copy persistent data back and forth from DEV and PROD if we need an exact copy of DB data (e.g. users RoI, vector data ingested, styles, ...)
5. started all the dockers using the landsupport_rebuild_dev.sh
6. recognized two issues:
   * a hard-coded reference to IP, with reference to PROD ENV
   * a bug in a php file returning an error during the laoding of the main page of the GUI in DEV ENV
7. solved the IP dependencies on the two ENVs using an ad-hoc **sed** command to change IPs when going back and forth from DEV to PROD [__ToBeDoneYet__]

## Implementation of the PROD ENV
...




