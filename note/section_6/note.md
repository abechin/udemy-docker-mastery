# Swarm Mode: Built-In Orchestration #

## Reference ##

* [Run Docker Engine in swarm mode](https://docs.docker.com/engine/swarm/swarm-mode/)

## Note ##

* Swarm Mode is a clustering soluton built inside Docker

* Not related to Swarm "classic" for pre-1.12 versions

* Added in 1.12 (Summer 2016) via SwarmKit toolkit

* Enhanced in 1.13 (January 2017) via Stacks and Secrets

* Not enabled by default, new commands once enabled 
  * docker swarm
  * docker node
  * docker service
  * docker stack
  * docker secret

* How to tell whether Swarm mode is enabled or not?
  * Use "docker info" command to check
    ```yaml
    Swarm: active
    NodeID: ysml64drjw9njzmyini77vvv1
    Is Manager: true
    ClusterID: 0fnsx6m1fnqfga3fh76nw2phb
    Managers: 1
    Nodes: 1
    Orchestration:
    Task History Retention Limit: 5
    ```
  * By default, docker does not have Swarm mode enabled, need to use command "docker swarm init" to initialize it
    * For mac, it may encountered this issue:
    ```
    docker swarm init is only supported on a Docker cli with swarm features enabled
    ```
    * Solution 1: disable "Kubernetes" by navigating to the Preferences pane
    * Solution 2: 
      If you would like to use Swarm simultaneously with Kubernetes, you need to set the <span style="color:blue">DOCKER_ORCHESTRATOR</span> environment variable to swtich Swarm.
      ```bash
      export DOCKER_ORCHESTRATOR=swarm
      docker swarm init
      ```
      If Swarm mode already init but would like to find out how to create worker and join, then use "docker swarm leave" command to leave
      ```bash
      docker swarm init
      Error response from daemon: This node is already part of a swarm. Use "docker swarm leave" to leave this swarm and join another one.
      ```
      ```bash
      docker swarm leave --force
      Node left the swarm.
      ```
      ```bash
      docker swarm init
      Swarm initialized: current node (o20a9tx15gfczfvfhkkret50w) is now a manager.

      To add a worker to this swarm, run the following command:

      docker swarm join --token SWMTKN-1-2xeb08cfd9sptde0qbs8onb0mj36fcql5j2lbb81yzit1w7twp-cvg1myrrek6neqfqdh2btn6lb 192.168.65.3:2377
      ```

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
* docker swarm init : What Just Happened?
  * Lots of PKI (Public Key Infrastructure) and security automation
    * Root Signing Certificate created for Swarm
    * Certificate is issued for first Manager node
    * Join tokens are created

  * [Raft](http://container-solutions.com/raft-explained-part-1-the-consenus-problem/) database created to store root CA, configs and secrets
    * Encrypted by default on disk (1.13+)
    * No need for another key/value system to hold orchestration/secrets
    * Replicates logs amongst Managers via mutual TLS ([Transpoprt Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security))

* Related commands
```
docker_mastery🐳 $ docker node ls
ID                            HOSTNAME                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
o20a9tx15gfczfvfhkkret50w *   linuxkit-025000000001   Ready               Active              Leader              18.05.0-ce-rc1

docker_mastery🐳 $ docker node help

Usage:	docker node COMMAND

Manage Swarm nodes

Commands:
  demote      Demote one or more nodes from manager in the swarm
  inspect     Display detailed information on one or more nodes
  ls          List nodes in the swarm
  promote     Promote one or more nodes to manager in the swarm
  ps          List tasks running on one or more nodes, defaults to current node
  rm          Remove one or more nodes from the swarm
  update      Update a node

Run 'docker node COMMAND --help' for more information on a command.

docker_mastery🐳 $ docker swarm --help

Usage:	docker swarm COMMAND

Manage Swarm

Commands:
  ca          Display and rotate the root CA
  init        Initialize a swarm
  join        Join a swarm as a node and/or manager
  join-token  Manage join tokens
  leave       Leave the swarm
  unlock      Unlock swarm
  unlock-key  Manage the unlock key
  update      Update the swarm

Run 'docker swarm COMMAND --help' for more information on a command.

docker_mastery🐳 $ docker service --help

Usage:	docker service COMMAND

Manage services

Commands:
  create      Create a new service
  inspect     Display detailed information on one or more services
  logs        Fetch the logs of a service or task
  ls          List services
  ps          List the tasks of one or more services
  rm          Remove one or more services
  rollback    Revert changes to a service's configuration
  scale       Scale one or multiple replicated services
  update      Update a service

Run 'docker service COMMAND --help' for more information on a command.
```
```
docker_mastery🐳 $ docker service create alpine ping 8.8.8.8
cmgu5tv9xh6pexmwl1e838oy1
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged

docker_mastery🐳 $ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
cmgu5tv9xh6p        vibrant_heyrovsky   replicated          1/1                 alpine:latest

docker_mastery🐳 $ docker service update cmgu5tv9xh6p --replicas 3
cmgu5tv9xh6p
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged

docker_mastery🐳 $ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
cmgu5tv9xh6p        vibrant_heyrovsky   replicated          3/3                 alpine:latest

docker_mastery🐳 $ docker service ps
"docker service ps" requires at least 1 argument.
See 'docker service ps --help'.

Usage:  docker service ps [OPTIONS] SERVICE [SERVICE...] [flags]

List the tasks of one or more services

docker_mastery🐳 $ docker service ps vibrant_heyrovsky
ID                  NAME                  IMAGE               NODE                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
zubygtqebght        vibrant_heyrovsky.1   alpine:latest       linuxkit-025000000001   Running             Running 8 minutes ago
y3r7mhx31fls        vibrant_heyrovsky.2   alpine:latest       linuxkit-025000000001   Running             Running about a minute ago
5iv3xwmchtcx        vibrant_heyrovsky.3   alpine:latest       linuxkit-025000000001   Running             Running about a minute ago

docker_mastery🐳 $ docker update --help

Usage:	docker update [OPTIONS] CONTAINER [CONTAINER...]

Update configuration of one or more containers

Options:
      --blkio-weight uint16        Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)
      --cpu-period int             Limit CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int              Limit CPU CFS (Completely Fair Scheduler) quota
      --cpu-rt-period int          Limit the CPU real-time period in microseconds
      --cpu-rt-runtime int         Limit the CPU real-time runtime in microseconds
  -c, --cpu-shares int             CPU shares (relative weight)
      --cpus decimal               Number of CPUs
      --cpuset-cpus string         CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string         MEMs in which to allow execution (0-3, 0,1)
      --kernel-memory bytes        Kernel memory limit
  -m, --memory bytes               Memory limit
      --memory-reservation bytes   Memory soft limit
      --memory-swap bytes          Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --restart string             Restart policy to apply when a container exits

docker_mastery🐳 $ docker service update --help

Usage:	docker service update [OPTIONS] SERVICE

Update a service

Options:
      --args command                       Service command args
      --config-add config                  Add or update a config file on a service
      --config-rm list                     Remove a configuration file
      --constraint-add list                Add or update a placement constraint
      --constraint-rm list                 Remove a constraint
      --container-label-add list           Add or update a container label
      --container-label-rm list            Remove a container label by its key
      --credential-spec credential-spec    Credential spec for managed service account (Windows only)
  -d, --detach                             Exit immediately instead of waiting for the service to converge
      --dns-add list                       Add or update a custom DNS server
      --dns-option-add list                Add or update a DNS option
      --dns-option-rm list                 Remove a DNS option
      --dns-rm list                        Remove a custom DNS server
      --dns-search-add list                Add or update a custom DNS search domain
      --dns-search-rm list                 Remove a DNS search domain
      --endpoint-mode string               Endpoint mode (vip or dnsrr)
      --entrypoint command                 Overwrite the default ENTRYPOINT of the image
      --env-add list                       Add or update an environment variable
      --env-rm list                        Remove an environment variable
      --force                              Force update even if no changes require it
      --generic-resource-add list          Add a Generic resource
      --generic-resource-rm list           Remove a Generic resource
      --group-add list                     Add an additional supplementary user group to the container
      --group-rm list                      Remove a previously added supplementary user group from the container
      --health-cmd string                  Command to run to check health
      --health-interval duration           Time between running the check (ms|s|m|h)
      --health-retries int                 Consecutive failures needed to report unhealthy
      --health-start-period duration       Start period for the container to initialize before counting retries towards unstable (ms|s|m|h)
      --health-timeout duration            Maximum time to allow one check to run (ms|s|m|h)
      --host-add list                      Add a custom host-to-IP mapping (host:ip)
      --host-rm list                       Remove a custom host-to-IP mapping (host:ip)
      --hostname string                    Container hostname
      --image string                       Service image tag
      --isolation string                   Service container isolation mode
      --label-add list                     Add or update a service label
      --label-rm list                      Remove a label by its key
      --limit-cpu decimal                  Limit CPUs
      --limit-memory bytes                 Limit Memory
      --log-driver string                  Logging driver for service
      --log-opt list                       Logging driver options
      --mount-add mount                    Add or update a mount on a service
      --mount-rm list                      Remove a mount by its target path
      --network-add network                Add a network
      --network-rm list                    Remove a network
      --no-healthcheck                     Disable any container-specified HEALTHCHECK
      --no-resolve-image                   Do not query the registry to resolve image digest and supported platforms
      --placement-pref-add pref            Add a placement preference
      --placement-pref-rm pref             Remove a placement preference
      --publish-add port                   Add or update a published port
      --publish-rm port                    Remove a published port by its target port
  -q, --quiet                              Suppress progress output
      --read-only                          Mount the container's root filesystem as read only
      --replicas uint                      Number of tasks
      --reserve-cpu decimal                Reserve CPUs
      --reserve-memory bytes               Reserve Memory
      --restart-condition string           Restart when condition is met ("none"|"on-failure"|"any")
      --restart-delay duration             Delay between restart attempts (ns|us|ms|s|m|h)
      --restart-max-attempts uint          Maximum number of restarts before giving up
      --restart-window duration            Window used to evaluate the restart policy (ns|us|ms|s|m|h)
      --rollback                           Rollback to previous specification
      --rollback-delay duration            Delay between task rollbacks (ns|us|ms|s|m|h)
      --rollback-failure-action string     Action on rollback failure ("pause"|"continue")
      --rollback-max-failure-ratio float   Failure rate to tolerate during a rollback
      --rollback-monitor duration          Duration after each task rollback to monitor for failure (ns|us|ms|s|m|h)
      --rollback-order string              Rollback order ("start-first"|"stop-first")
      --rollback-parallelism uint          Maximum number of tasks rolled back simultaneously (0 to roll back all at once)
      --secret-add secret                  Add or update a secret on a service
      --secret-rm list                     Remove a secret
      --stop-grace-period duration         Time to wait before force killing a container (ns|us|ms|s|m|h)
      --stop-signal string                 Signal to stop the container
  -t, --tty                                Allocate a pseudo-TTY
      --update-delay duration              Delay between updates (ns|us|ms|s|m|h)
      --update-failure-action string       Action on update failure ("pause"|"continue"|"rollback")
      --update-max-failure-ratio float     Failure rate to tolerate during an update
      --update-monitor duration            Duration after each task update to monitor for failure (ns|us|ms|s|m|h)
      --update-order string                Update order ("start-first"|"stop-first")
      --update-parallelism uint            Maximum number of tasks updated simultaneously (0 to update all at once)
  -u, --user string                        Username or UID (format: <name|uid>[:<group|gid>])
      --with-registry-auth                 Send registry authentication details to swarm agents
  -w, --workdir string                     Working directory inside the container

docker_mastery🐳 $ docker container ls --last 5
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
8132950f0208        alpine:latest       "ping 8.8.8.8"      21 minutes ago      Up 21 minutes                           vibrant_heyrovsky.3.5iv3xwmchtcxao3e3e5d2j6j7
6943a5ff7052        alpine:latest       "ping 8.8.8.8"      21 minutes ago      Up 21 minutes                           vibrant_heyrovsky.2.y3r7mhx31flsxkys2n7985bcn
48d5aa3b6519        alpine:latest       "ping 8.8.8.8"      28 minutes ago      Up 29 minutes                           vibrant_heyrovsky.1.zubygtqebght5tk98nznv89i6

docker_mastery🐳 $ docker container rm -f vibrant_heyrovsky.1.zubygtqebght5tk98nznv89i6
dvibrant_heyrovsky.1.zubygtqebght5tk98nznv89i6

docker_mastery🐳 $ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
cmgu5tv9xh6p        vibrant_heyrovsky   replicated          3/3                 alpine:latest

docker_mastery🐳 $ docker service ps vibrant_heyrovsky
ID                  NAME                      IMAGE               NODE                    DESIRED STATE       CURRENT STATE            ERROR                         PORTS
o4s4ju1q68ji        vibrant_heyrovsky.1       alpine:latest       linuxkit-025000000001   Running             Running 6 seconds ago
zubygtqebght         \_ vibrant_heyrovsky.1   alpine:latest       linuxkit-025000000001   Shutdown            Failed 11 seconds ago    "task: non-zero exit (137)"
y3r7mhx31fls        vibrant_heyrovsky.2       alpine:latest       linuxkit-025000000001   Running             Running 23 minutes ago
5iv3xwmchtcx        vibrant_heyrovsky.3       alpine:latest       linuxkit-025000000001   Running             Running 23 minutes ago

docker_mastery🐳 $ docker service rm vibrant_heyrovsky
vibrant_heyrovsky

docker_mastery🐳 $ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS

docker_mastery🐳 $ docker container ls
CONTAINER ID        IMAGE                                                    COMMAND                  CREATED             STATUS              PORTS               NAMES
847d1d04d660        alpine:latest                                            "ping 8.8.8.8"           6 minutes ago       Up 6 minutes                            vibrant_heyrovsky.1.o4s4ju1q68jio8oax1tlk0d65
8132950f0208        alpine:latest                                            "ping 8.8.8.8"           29 minutes ago      Up 29 minutes                           vibrant_heyrovsky.3.5iv3xwmchtcxao3e3e5d2j6j7
6943a5ff7052        alpine:latest                                            "ping 8.8.8.8"           29 minutes ago      Up 29 minutes                           vibrant_heyrovsky.2.y3r7mhx31flsxkys2n7985bcn

docker_mastery🐳 $ docker container ls
CONTAINER ID        IMAGE                                                    COMMAND                  CREATED             STATUS              PORTS               NAMES
```

## Creating 3-Node Swarm: Host Options ##

* A. play-with-docker.com
  * Only needs a browser, but resets after 4 hours

* B. docker-machine + VirtualBox
  * Free and runs locally, but requires a machine with 8GB memory

* C. Digital Ocean + Docker install
  * Most like a production setup, but costs $5-$10/node/month while learning

* D. Roll your own
  * docker-machine can provision machines for Amazon, Azure, DO, Google, etc.
  * install docker anywhere with get.docker.com

* Related Command

  ```bash
  docker-machine create node1

  docker-machine ssh node1

  docker-machine en node1

  docker swarm init --advertise <IP address>

  docker node ls

  docker node update --role manager node2

  docker node ls

  docker swarm join-token manager

  docker node ls

  docker service create --replicas 3 apline ping 8.8.8.8

  docker service ls

  docker node ps

  docker ps node2

  docker service ps <service name>

  ```