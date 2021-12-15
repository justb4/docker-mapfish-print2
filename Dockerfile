# Inspired by and thanks to: https://github.com/kartoza/docker-geoserver/blob/master/Dockerfile
# Uses Debian 8 (Jessie) Slim
FROM tomcat:8.0-jre8-slim

MAINTAINER Just van den Broecke<just@justobjects.nl>

ARG IMAGE_TIMEZONE="Europe/Amsterdam"
ARG IMAGE_LOCALE="nl_NL.UTF-8"
ARG MFPRINT_VERSION="2.1-SNAPSHOT"

ENV \
	DEBIAN_FRONTEND="noninteractive" \
	LC_ALL="$IMAGE_LOCALE" \
	LANG="$IMAGE_LOCALE"  \
	LANGUAGE="$IMAGE_LOCALE"

# Configure timezone and locale
# http://serverfault.com/questions/362903/how-do-you-set-a-locale-non-interactively-on-debian-ubuntu/801162#801162
RUN \
    export DEBIAN_FRONTEND=noninteractive \
	&& dpkg-divert --local --rename --add /sbin/initctl \
	&& echo "$IMAGE_TIMEZONE" > /etc/timezone \
    && rm /etc/localtime && ln -s /usr/share/zoneinfo/$IMAGE_TIMEZONE /etc/localtime \
	&& apt-get -y update \
	&& apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# nl_NL.UTF-8 UTF-8/nl_NL.UTF-8 UTF-8/' /etc/locale.gen \
    && echo "LANG=$IMAGE_LOCALE" > /etc/default/locale \
    && dpkg-reconfigure -f noninteractive locales \
    && update-locale LANG=$IMAGE_LOCALE


#-------------Application Specific Stuff ----------------------------------------------------

# Remove Tomcat manager, docs, and examples.
# https://oss.sonatype.org/content/repositories/snapshots/org/mapfish/print/print-servlet/2.1-SNAPSHOT/print-servlet-2.1-SNAPSHOT.war
# 	MFPRINT_WAR="https://repo1.maven.org/maven2/org/mapfish/print/print-servlet/$MFPRINT_VERSION/print-servlet-$MFPRINT_VERSION.war"
ENV \
	JAVA_HOME="/usr/lib/jvm/default-java" \
	MFPRINT_WAR="https://oss.sonatype.org/content/repositories/snapshots/org/mapfish/print/print-servlet/$MFPRINT_VERSION/print-servlet-$MFPRINT_VERSION.war" \
	TC_DEPLOY_DIR="$CATALINA_HOME/webapps" \
	TC_BIN_DIR="$CATALINA_HOME/bin" \
	MFPRINT_DEPLOY_DIR="$CATALINA_HOME/webapps/ROOT" \
	LOG4J_JAR="$MFPRINT_DEPLOY_DIR/WEB-INF/lib/log4j-1.2.17.jar" \
	JAI="jai-1_1_3-lib-linux-amd64.tar.gz" \
	JAI_IMAGEIO="jai_imageio-1_1-lib-linux-amd64.tar.gz"

# Set JAVA_HOME to /usr/lib/jvm/default-java and link it to OpenJDK installation
# Add JAI and ImageIO for great speedy speed.
# Add MS Fonts
# Install fonts
# NOTE: must enable contrib apt repository for msttcorefonts
# NOTE: must remove bitmap-fonts.conf due to fontconfig bug
# See https://github.com/panosoft/docker-prince-server/blob/master/Dockerfile
WORKDIR /tmp
RUN \
	apt-get install -y wget \
	&& ln -s /usr/lib/jvm/java-8-openjdk-amd64 $JAVA_HOME \
	&& wget http://download.java.net/media/jai/builds/release/1_1_3/$JAI \
    && wget http://download.java.net/media/jai-imageio/builds/release/1.1/$JAI_IMAGEIO \
    && gunzip -c $JAI | tar xf - \
    && gunzip -c $JAI_IMAGEIO | tar xf - \
    && mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/jre/lib/ext/ \
    && mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/jre/lib/amd64/ \
    && mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/jre/lib/ext/ \
    && mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/jre/lib/amd64/ \
    && rm /tmp/$JAI \
    && rm -r /tmp/jai-1_1_3 \
    && rm /tmp/$JAI_IMAGEIO \
    && rm -r /tmp/jai_imageio-1_1 \
	&& sed -i 's/$/ contrib/' /etc/apt/sources.list \
    && apt-get update && apt-get install --assume-yes fontconfig msttcorefonts \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf


# Make deploy dir (may have be deleted)
# Get the MFP .war
# Unzip in deploy dir e.g. /usr/local/tomcat8/webapps/print
# Optionally remove the MFP standard print apps/examples
RUN \
	rm -rf $TC_DEPLOY_DIR/* \
	&& mkdir -p $MFPRINT_DEPLOY_DIR \
	&& echo "Fetching $MFPRINT_WAR ...." \
	&& wget $MFPRINT_WAR -qO /tmp/print.war \
	&& unzip /tmp/print.war -d $MFPRINT_DEPLOY_DIR \
    && rm /tmp/print.war

# Add default config
# Includes: Security fix, see http://geoserver.org/announcements/2021/12/13/logj4-rce-statement.html
ADD config /tmp/config

# Copy configuration for Tomcat
# Copy webapp config en eigen print-apps
# https://github.com/Microsoft/vscode-arduino/issues/644
RUN cp -r /tmp/config/tomcat/* $CATALINA_HOME \
	&& rm -f $LOG4J_JAR \
	&& cp -rf /tmp/config/webapp/* $MFPRINT_DEPLOY_DIR \
	&& cp -rf /tmp/config/etc/* /etc/
