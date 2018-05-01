#!/bin/bash

create_volume() {
  name=$1
  docker volume create $name
}

create_postgres() {
  version=$1
  volume_name=$2
  echo "##########"
  echo "docker container run -d --name postgres_${version} -v ${volume_name}:/var/lib/postgresql/data postgres:${version}"
  echo "##########"
  docker container run -d --name postgres_${version} -v ${volume_name}:/var/lib/postgresql/data postgres:${version}
}

log_postgres() {
  img_name=$1
  echo "##########"
  echo "docker logs ${img_name}"
  echo "##########"
  docker logs ${img_name}
}

list_volume() {
  name=$1
  echo "##########"
  echo "docker volume ls | grep ${name}"
  echo "##########"
  docker volume ls | grep ${name}
}

stop_container() {
  img_name=$1
  echo "##########"
  echo "docker container stop ${img_name}"
  echo "##########"
  docker container stop ${img_name}
}

delete_container() {
  img_name=$1
  echo "##########"
  echo "docker container rm ${img_name}"
  echo "##########"
  docker container rm ${img_name}
}

delete_volume() {
  volume_name=$1
  echo "##########"
  echo "docker volume rm ${volume_name}"
  echo "##########"
  docker volume rm ${volume_name}
}

main() {
  local volume_name version

  volume_name='psql-data'

  # Create volume with name psql-data
  create_volume ${volume_name}

  # Create postgres 9.6.1 container
  version='9.6.1'
  create_postgres ${version} ${volume_name}

  # Display postgres log
  log_postgres postgres_${version}

  # List volume name
  list_volume ${volume_name}

  # Stop postgres container
  stop_container postgres_${version}

  # Delete postgres container
  delete_container postgres_${version}

  # Create postgres 9.6.2 container
  version='9.6.2'
  create_postgres ${version} ${volume_name}

  # Display postgres log
  log_postgres postgres_${version}

  # List volume name
  list_volume ${volume_name}

  # Stop postgres container
  stop_container postgres_${version}

  # Delete postgres container
  delete_container postgres_${version}

  # Delete volume
  delete_volume ${volume_name}
}

main "$@"
