# Fix for Log4J

See http://geoserver.org/announcements/2021/12/13/logj4-rce-statement.html

To start: like GeoServer: this MapFish2 Docker Image **does not use Log4J2**! 
So the "(n)famous" log4J2 vulnerability does not apply!

This project uses Log4J 1.2. Quoting from the above GeoServer statement (read "MapFish" for "GeoServer" in text):

    However, Log4J 1.2 has smaller vulnerabilities, which may trigger when loading the configuration files. It happens if the attacker manages to:
    
    * Get write access to the GeoServer log configuration files.
    * Set up in them a new JMSAppender configuration, in which the TopicConnectionFactoryBindingName or TopicBindingName point to a remote server providing malicious classes.
    
    Force GeoServer to reload the logging configuration.
    Log4J 1.2.17 is also vulnerable to CVE-2019-17571. This is even narrower than the issue above, as the SocketServer class 
    needs to be run from the command line explicitly.
    
    That said, It is important to note that MapFish default configuration is not vulnerable to these and the attacker would need to go and modify the logging configuration files in order to trigger it.
    
    ~~Checking for vulnerabilities~~
    How to check if your server is vulnerable:
    
    Check the log configuration files, make sure there is no JMSAppender.
    Make sure that no one outside of your organization can get write access to the logging configuration files, e.g.:
    No one outside your organization has admin access to GeoServer. The REST API allows writing in the data directory using the resource endpoint, and if the web resource extension is installed, admins will also be allowed to edit the files via the GUI.
    No one outside your organization has console access to the server (e.g, SSH, terminal services), and if they do, they don’t have write permission to the GeoServer configuration files.
    Threat elimination
    The GeoServer project has released a sanitized version of the Log4J 1.2.17 library, which simply does not include the classes involved in vulnerabilities CVE-2021-44228 and CVE-2019-17571. This library is also usable with older versions of GeoServer.
    
    The file is available in our Nexus repository. Simply remove the existing log4j-1.2.17.jar and drop in the new log4j-1.2.17.norce.jar in the geoserver/webapps/WEB-INF/lib folder, and then restart tomcat.
    
    We are also aware that Log4J 1.2.17 is an “End Of Life” (EOL) project, and are actively looking for funding to perform an upgrade to more recent versions of them. All new logging libraries have a different API and a different configuration file layout, 
    with potential backwards compatibility issues, so this will be likely done on newer versions of GeoServer (2.21.x).

So only if the attacker has direct access into the running MapFish Docker Container would the  Log4J 1.2 vulnerability apply. At that point you already will have worse problems.

Better be safe. So we will use log4J 1.2.17 jar provided by the GeoServer project. As found in this dir: `log4j-1.2.17.norce.jar` (norce=No remote Code Execution).
