### Assignment: Bind Mounts ###
* Use a Jekyll "Static Site Generator" to start a local web server
* Don't have to be web developer: this is example of bridging the gap between local file access and apps running in containers
* Source code is in the course repo under bindmount-sample-1
* We edit files with editor on our host using native tools
* Container detects changes with host files and updates web server
* Start container with docker run -p 80:4000 -v $(pwd):/site bretfisher/jekyll-serve
* Refresh our browser to see changes
#### NOTE ####
* [jekyll](https://jekyllrb.com/)
* [jekyll source code](https://github.com/jekyll/jekyll)
* [jekyll docker](https://hub.docker.com/r/jekyll/jekyll/)
  * [jekyll docker README.md](https://github.com/envygeeks/jekyll-docker/blob/master/README.md)
* [abechin jekyll-serve fork](https://github.com/abechin/jekyll-serve)
  * [Dockerfile reference](https://docs.docker.com/engine/reference/builder/#usage)
  * docker build -t abechin/jekyll-serve .
  * docker container run --rm --publish 8888:4000 -v $(pwd):/site abechin/jekyll-serve