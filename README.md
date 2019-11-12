# docker-mapfish-print2

Docker image and tools for MapFish Print (MFP) **VERSION 2** legacy.

This version is still used in quite some contexts. 

* Find the [MapFish Print v2 docs here](http://www.mapfish.org/doc/print/).
* Find [Docker Images on DockerHub](https://hub.docker.com/r/justb4/mapfish-print2).
* See my repo [docker-mapfish-print](https://github.com/justb4/docker-mapfish-print) for a MFP **version 3+** Docker Image.

If you read this on DockerHub, local links will not work, [read full README here](https://github.com/justb4/docker-mapfish-print2).

## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile) but this is not really necessary as
you may use your own `docker build` commandline.

Build arguments with values if not passed to build:

- **IMAGE_TIMEZONE** - timezone of Docker image, default ``"Europe/Amsterdam"``
- **IMAGE_LOCALE** - locale of Docker image, default ``"nl_NL.UTF-8"``
- **MFPRINT_VERSION** - MapFish Print (Servlet) version, default ``"2.1-SNAPSHOT"``

## Versions
I found that `2.1-SNAPSHOT` was the highest MFP2 version that worked (for me).
These come from https://oss.sonatype.org/content/repositories/snapshots/org/mapfish/print/print-servlet/.
If you are able to get a higher version working, let me know, via [the issue-tracker](https://github.com/justb4/docker-mapfish-print2/issues).

### Build Options

The files under the  [config](config) dir are automatically integrated in the Docker image as follows:

- [config/tomcat/*](config/tomcat): override any files in the standard Tomcat install (see below)
- [config/tomcat/bin/setenv.sh](config/tomcat/bin/setenv.sh): Tomcat options like for memory, proxies etc
- [config/tomcat/conf/server.xml](config/tomcat/bin/setenv.sh): server settings like port (default 8080) and threads
- [config/webapp/WEB-INF/web.xml](config/webapp/WEB-INF/web.xml): override web.xml for Tomcat MFP .war
- [config/webapp/config/index.html](config/webapp/config/index.html): the demo page, provide your own if required

You can adapt these or use a [prebuilt Docker Image](https://hub.docker.com/r/justb4/mapfish-print2) 
and use Volume mapping or extend the image.

## Running

See the [examples directory](examples) for how to run with your own config.
The main things to do are:

* create Print config YAML file(s) see [examples](examples/webapp/config) and the [MFP v2 docs](http://www.mapfish.org/doc/print/)
* configure each config YAML within `web.xml` at bottom, use [config/webapp/WEB-INF/web.xml](config/webapp/WEB-INF/web.xml) as starter

Example:

```
    <!-- Example how to configure for your YAML config(s) -->
    <servlet>
        <servlet-name>mapfish.print.default</servlet-name>
        <servlet-class>org.mapfish.print.servlet.MapPrinterServlet</servlet-class>
        <init-param>
            <param-name>config</param-name>
            <param-value>config/config.default.yaml</param-value>
        </init-param>
    </servlet>
    <servlet-mapping>
        <servlet-name>mapfish.print.default</servlet-name>
        <url-pattern>/pdf.default/*</url-pattern>
    </servlet-mapping>

```  

* mount these files into the container using Docker Volume mount (or extend the Docker build)
* optional: provide HTML test-pages, see [examples](examples/webapp/config/test)

## Credits

* Kartoza team: https://github.com/kartoza for providing good examples of Dockerfiles for FOSS geospatial Java .war's.
* TT Fonts addition: https://github.com/panosoft/docker-prince-server/blob/master/Dockerfile
* [CampToCamp](https://www.camptocamp.com/) for developing MapFish Print and many other useful FOSS Geospatial software
