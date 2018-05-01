# Section 5 Notes #

## References ##

* [The YAML Format: Sample Generic YAML File](http://yaml.org/start.html)
* [The YAML Format: Quick Reference](http://yaml.org/refcard.html)
* [Compose File Version Differences(Docker Docs)](https://docs.docker.com/compose/compose-file/compose-versioning/)
* [Docker Compose Release Downloads (good for Linux users that need to download manually)](https://github.com/docker/compose/releases)
* [Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/#step-2-create-a-dockerfile)
* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

## Docker Compose ##

* Comprised of 2 separate but related parts:
  * 1. YAML-formatted files that describes solution options for:
    * containers
    * networks
    * volumes
  * 2. A CLI tool docker-compose used for local dev/test automation with those YAML files

## docker-compose.yml ##

* Compose YAML format has it's own versionis
* YAML file can be used with docker-compose command for local docker automation
* With <span style="color:red">docker</span> directly in production with Swarm (as of v1.13)
* <span style="color:red">docker-compose.yml</span> is default filename, but can use **"-f"** option to specify any filename
* docker-compose.yml template
  * ```yaml
    version: '3.1'  # if no version is specificed then v1 is assumed. Recommend v2 minimum

    services:  # containers. same as docker run
      servicename: # a friendly name. this is also DNS name inside network
        image: # Optional if you use build:
        command: # Optional, replace the default CMD specified by the image
        environment: # Optional, same as -e in docker run
        volumes: # Optional, same as -v in docker run
      servicename2:

    volumes: # Optional, same as docker volume create

    networks: # Optional, same as docker network create
    ```

* docker-compose.yml example 1
  * ```yaml
    version: '2'

    # same as
    # docker run -p 80:4000 -v $(pwd):/site bretfisher/jekyll-serve

    services:
      jekyll:
        image: bretfisher/jekyll-serve
        volumes:
          - .:/site
        ports:
          - '80:4000'
      ```
* docker-compose.yml example 2
  * ```yaml
    version: '2'

    services:

      wordpress:
        image: wordpress
        ports:
          - 8080:80
        environment:
          WORDPRESS_DB_HOST: mysql
          WORDPRESS_DB_NAME: wordpress
          WORDPRESS_DB_USER: example
          WORDPRESS_DB_PASSWORD: examplePW
        volumes:
          - ./wordpress-data:/var/www/html

      mysql:
        image: mariadb
        environment:
          MYSQL_ROOT_PASSWORD: examplerootPW
          MYSQL_DATABASE: wordpress
          MYSQL_USER: example
          MYSQL_PASSWORD: examplePW
        volumes:
          - mysql-data:/var/lib/mysql

    volumes:
      mysql-data:
    ```
* docker-compose.yml example 3
  * ```yaml
    version: '3'

    services:
      ghost:
        image: ghost
        ports:
          - "80:2368"
        environment:
          - URL=http://localhost
          - NODE_ENV=production
          - MYSQL_HOST=mysql-primary
          - MYSQL_PASSWORD=mypass
          - MYSQL_DATABASE=ghost
        volumes:
          - ./config.js:/var/lib/ghost/config.js
        depends_on:
          - mysql-primary
          - mysql-secondary
      proxysql:
        image: percona/proxysql
        environment:
          - CLUSTER_NAME=mycluster
          - CLUSTER_JOIN=mysql-primary,mysql-secondary
          - MYSQL_ROOT_PASSWORD=mypass

          - MYSQL_PROXY_USER=proxyuser
          - MYSQL_PROXY_PASSWORD=s3cret
      mysql-primary:
        image: percona/percona-xtradb-cluster:5.7
        environment:
          - CLUSTER_NAME=mycluster
          - MYSQL_ROOT_PASSWORD=mypass
          - MYSQL_DATABASE=ghost
          - MYSQL_PROXY_USER=proxyuser
          - MYSQL_PROXY_PASSWORD=s3cret
      mysql-secondary:
        image: percona/percona-xtradb-cluster:5.7
        environment:
          - CLUSTER_NAME=mycluster
          - MYSQL_ROOT_PASSWORD=mypass

          - CLUSTER_JOIN=mysql-primary
          - MYSQL_PROXY_USER=proxyuser
          - MYSQL_PROXY_PASSWORD=s3cret
        depends_on:
          - mysql-primary
    ```
## docker-compose CLI ##

* CLI tool comes with Docker for Windows/Mac, but separate download for Linux

* Not a production-grade tool but ideal for local development and test

* Two most common commands are
  * <span style="color:red">docker-compose up</span>  # setup volumes/networks and start all containers
  * <span style="color:red">docker-compose down</span>  # stop all containers and remove cont/vol/net

* If all your projects had a <span style="color:red">Dockerfile</span> and <span style="color:red">docker-compose.yml</span> then "new developer onboarding" would be:
  * <span style="color:blue">git clone github.com/some/software</span>
  * <span style="color:blue">docker-compose up</span>

## Using Compose to Build ##

* Compose can also build your custom images
* Will build them with <span style="color:red">docker-compose up</span> if not found in cache
* Also rebuild with <span style="color:red">docker-compose build</span>
* Great for complex builds that have lots of vars or build args
