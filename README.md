# docker-mfprint2

Docker image and tools for MapFish Print **VERSION 2** legacy.
This version is still used in quite some contexts. Find the [MapFish Print v2 docs here](http://www.mapfish.org/doc/print/).

## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile) but this is not really necessary as
you may use your own ``docker build`` commandline.

Build arguments with values if not passed to build:

- **IMAGE_TIMEZONE** - timezone of Docker image, default ``"Europe/Amsterdam"``
- **IMAGE_LOCALE** - locale of Docker image, default ``"nl_NL.UTF-8"``
- **MFPRINT_VERSION** - MapFish Print (Servlet) version, default ``"2.1-SNAPSHOT"``

### Build Options

The files under the  [config](config) dir are automatically integrated in the Docker image as follows:

- [config/tomcat/*](config/tomcat): override any files in the standard Tomcat install (see below)
- [config/tomcat/bin/setenv.sh](config/tomcat/bin/setenv.sh): Tomcat options like for memory, proxies etc
- [config/tomcat/conf/server.xml](config/tomcat/bin/setenv.sh): server settings like port (default 8080) and threads
- [config/webapp/WEB-INF/web.xml](config/webapp/WEB-INF/web.xml): override web.xml for Tomcat MFP .war
- [config/webapp/index.html](config/webapp/index.html): override index.html, the demo page

## Running

See the [examples directory](examples) for how to run with your own config.

## Credits

Kartoza team: https://github.com/kartoza for providing good examples of Dockerfiles for FOSS geospatial Java .war's.

TT Fonts addition: https://github.com/panosoft/docker-prince-server/blob/master/Dockerfile

