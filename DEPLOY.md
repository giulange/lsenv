# Deploy rules and procedures in the three lines {tmp,dev,prod}
## how to deploy in PROD line
 1. connect to PROD VNC
 2. open gitkraken
 3. checkout to the desired branch
 	a. on high gear, it means to finish the release branch and point to master
 	b. release branch
 	c. hotfix branch created from master, to solve an issue (https://git-scm.com/book/it/v2/Git-Branching-Basic-Branching-and-Merging)
 4. run <<landsupport_sed_prod.sh lsprod>>
 5. commit the SED modifications as "deploy in PROD line for production staging"

## how to deploy in DEV line
 1. connect to DEV VNC
 2. open gitkraken
 3. checkout to the desired branch
 	a. on high gear, it means to create the new feature/devenv from the latest develop after production staging
 	b. the release branch is created for the pre-production staging
 	c. alternatively, we points to whatever branch
 4. run <<landsupport_sed_dev.sh release>>
 5. commit the SED modifications as
 	a. "deploy in DEV line after production staging" (production staging happens in PROD)
 	b. "deploy in DEV line to start pre-production staging"

## how to deploy in TMP line
 1. connect to DEV VNC
 2. open gitkraken
 3. checkout to the desired branch
 	a. on high gear, it means to checkout the develop branch, after production staging in PROD
 4. run <<landsupport_sed_tmp.sh release>> (use release because you run it from within release user)
 5. commit the SED modifications as
 	a. "deploy in TMP line after production staging" (production staging happens in PROD)
 	
# How to update TMP line with changes from develop [fast-forward, possibly]
 1. the latest develop can come from:
  	a. release finish because of production staging
  	b. one/more merges are performed into develop (from feature/devenv and/or feature/IOmodels and so on)
 2. connect to DEV VNC
 3. open gitkraken
 4. now develop is ahead of feature/gui directly upstream (see Fig. 21 and 22 at: https://git-scm.com/book/it/v2/Git-Branching-Basic-Branching-and-Merging)
 5. checkout on develop
 6. drag-and-drop the develop branch into the feature/gui branch and select fast-forward
 	a. the fast-forward is the safest (we keep changes from develop which is ahead) and the lightest (no trace in git flow as for "merge") operation


