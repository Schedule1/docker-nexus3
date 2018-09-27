# How to deploy the Nexus server

## Requirements
 * Oracle Java 8
 * pwgen
 
## build the docker image

run the shell script: ```build_container.sh```. The script will generate password, keystore, and a bunch of other files under the relative directory ```ssl/```

## run the docker container

run the shell script: ```run.sh```

Now the port ```8081``` is for the normal access, and the port ```8443``` is for the ssl access

## import certificate into Java cacerts

To publish artifacts through https endpoint, the certificate generated should be imported into the default Java keystore ```cacerts``` on which SBT is running

Use the following command:

```
sudo keytool -import -alias schedule1 -file ssl/schedule1.pem -keystore /Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/jre/lib/security/cacerts -storepass changeit
```

To remove the ```schedule1``` nexus certificate, run the following command:

```
sudo keytool -delete -alias schedule1 -keystore /Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home/jre/lib/security/cacerts -storepass changeit
```  

## publish artifacts through https endpoint from SBT

add the following expressions into the ```build.sbt``` file

```
publishTo := {

    if(isSnapshot.value)
      Some("Schedule1 Nexus Releases" at "https://localhost:8443/repository/maven-snapshots")
    else
      Some("Schedule1 Nexus Releases" at "https://localhost:8443/repository/maven-releases")
  },
  publishConfiguration := publishConfiguration.value.withOverwrite(true), // this is optional. also need to enable overwriting in Nexus
  credentials += Credentials(Path.userHome / ".sbt" / ".credentials")
``` 

The file ```.credentials``` looks like this:
```
realm=Sonatype Nexus Repository Manager
host=localhost
user=admin
password=admin123
```


## set up sbt proxy repository

Create a file ```repositories``` under the path ```~/.sbt/```

Put the following lines to the file:

```
[repositories]
  local
  my-maven-proxy-releases: http://$host:8081/repository/maven-central/
```

If ivy can't find the libraries on local directory, the maven-central proxy will be used to retrieve the libraries. And the proxy also caches the downloaded libraries for the future usage.

## set up maven repository

Add the following lines to maven file 

```
    <repositories>
        <repository>
            <id>nexus-proxy</id>
            <name>nexus-proxy</name>
            <url>http://$host:8081/repository/maven-central</url>
        </repository>
    </repositories>
```