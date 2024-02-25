# NxFilter #

## Fork ##
This is a fork of [Deepwoods' NxFilter-docker](https://github.com/DeepWoods/nxfilter-docker).
The only changes involve tagging in Docker Hub.  

While Deepwoods puts all updates under the "latest" tag ([Deepwoods's Docker Hub](https://hub.docker.com/r/deepwoods/nxfilter)), I want each image tagged with the NxFilter verision number.



My [Docker Hub](https://hub.docker.com/r/zorbatherainy/nxfilter) and [GitHub]()


## About ##
[NxFilter](http://nxfilter.org/p3/) is a scalable and reliable DNS filtering server software by Jahastech.

Container image is based off of Ubuntu:latest minimal with the most current DEB package for NxFilter from [NxFilter](https://nxfilter.org/p3/download/).


## Usage ##

#### Interactive container for testing: ####

```
docker run -it --name nxfilter \
   -p 53:53/udp \
   -p 19004:19004/udp \
   -p 80:80 \
   -p 443:443 \
   -p 19002-19004:19002-19004 \
   zorbatherainy/nxfilter:latest
```

#### Detached container with persistent data volumes: ####

```
docker run -dt --name nxfilter \
  -e TZ=America/Chicago \
  -v nxfconf:/nxfilter/conf \
  -v nxfdb:/nxfilter/db \
  -v nxflog:/nxfilter/log \
  -p 53:53/udp \
  -p 19004:19004/udp \
  -p 80:80 \
  -p 443:443 \
  -p 19002-19004:19002-19004 \
  zorbatherainy/nxfilter:latest
```


## Configuration
* The admin GUI URL is http://[DOCKER_HOST_SERVER_IP]/admin
* The default Block Redirection IP under System -> Setup needs to match your [DOCKER_HOST_SERVER_IP] unless you're bridging your docker network to your local LAN or using MACVLAN.  
* TZ of the container defaults to UTC unless overridden by setting the environment variable to your locale.  [see List of tz time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)


---
## Docker-compose example ##

```yaml
version: '3.5'

services:
  nxfilter:
    image: zorbatherainy/nxfilter:latest
    container_name: nxfilter
    hostname: nxfilter
    restart: unless-stopped
    environment:
      TZ: "America/Chicago"
    volumes:
      - nxfconf:/nxfilter/conf
      - nxflog:/nxfilter/log
      - nxfdb:/nxfilter/db
    ports:
      - 53:53/udp
      - 19004:19004/udp
      - 80:80
      - 443:443
      - 19002-19004:19002-19004
volumes:
  nxfconf:
  nxfdb:
  nxflog:
```

### Troubleshooting ###
I noticed that with recent veriosn of NxFilter, if you use **empty** `bind mounts` instead of `volumes`, it tends to fail with an NullPointer exception.

The way I fixed this was to either (a) copy the config from another instance (for migration), or (b) start up with a `volume` and then copy the volume's contents to the `bind mount`.

Example of option B
   ```
   # Run a container with the source volume mounted
   docker run -d --name=source_container -v source_volume:/source busybox
   
   # Copy files from container to bind mount
   docker cp source_container:/source/. /tmp/target_dir
   ```

### Useful Commands ###
docker-compose to start and detach container: `docker-compose up -d`

Stop and remove container: `docker-compose down`

Restart a service: `docker-compose restart nxfilter`

View logs: `docker-compose logs`

Open a bash shell on running container name: `docker exec -it nxfilter /bin/bash`

> **Warning**
> Commands below will delete all data volumes not associated with a container!
> 
> Remove container & persistent volumes(clean slate): `docker-compose down && docker volume prune`

## Updating ##
1. Pull the latest container.  `docker pull zorbatherainy/nxfilter:latest`
2. Stop and remove the current container.  `docker stop nxfilter && docker rm nxfilter`
> **Note** If using docker-compose:  `docker-compose down`
3. Run the new container with the same command from above.  [Detached container](#detached-container-with-persistent-data-volumes)
> **Note** If using docker-compose:  `docker-compose up -d`
4. Make sure that the container is running.  `docker ps`
5. Check the container logs if unable to access the GUI for some reason.  `docker logs nxfilter`
> **Note** If using docker-compose:  `docker-compose logs`
