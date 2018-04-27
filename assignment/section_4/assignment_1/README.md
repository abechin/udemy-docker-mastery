# Assignment: Named Volumes #

* Database upgrade with containers
* Create a postgres container with named volume psql-data using version 9.6.1
* Use Docker Hub to learn VOLUME path and versions needed to run it
* Check logs, **stop container**
* Create a new postgres container with same named volume using 9.6.2
* Check logs to validate

## Note ##

* <span style="color:blue">This only works with patch versions, most SQL DB's require manual commands to upgrade DB's to major/minor versions, i.e. it's a DB limitation not a container one</span>

## Reference ##

* [postgres - docker hub official repository](https://hub.docker.com/_/postgres/)
* [postgres - docker store](https://store.docker.com/images/postgres)
* [postgress 9.6 Dockerfile](https://github.com/docker-library/postgres/blob/ef4545c07bd97e5585bb9e7f2680a4859b9ccf3c/9.6/Dockerfile)