# How to use Nexus 3 in the Maven project

## Repositories

Add the following xml snippet to ```pom.xml```, which tells Maven where to load the dependencies


```xml
<project>

  <properties>
    <nexus.url>http://ec2-34-214-69-114.us-west-2.compute.amazonaws.com:8081</nexus.url>
  </properties>
  
  <repositories>
    <repository>
      <id>apache-repo</id>
      <name>Apache Repository</name>
      <url>https://repository.apache.org/content/repositories/releases</url>
      <releases>
        <enabled>false</enabled>
      </releases>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
    </repository>
    <repository>
      <id>datapassports-releases</id>
      <name>datapassports-releases</name>
      <url>${nexus.url}/repository/maven-releases/</url>
      <releases>
        <enabled>true</enabled>
      </releases>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
    </repository>

    <repository>
      <id>datapassports-snapshots</id>
      <name>datapassports-snapshots</name>
      <url>${nexus.url}/repository/maven-snapshots/</url>
      <releases>
        <enabled>true</enabled>
      </releases>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
    </repository>

    <repository>
      <id>datapassports-central</id>
      <name>datapassports-central</name>
      <url>${nexus.url}/repository/maven-central/</url>
      <releases>
        <enabled>false</enabled>
      </releases>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
    </repository>

  </repositories>
</project>

```

## Publish the artifacts

### Add ```distributionManagement``` element to ```pom.xml```

```xml
<project>
    ...
      <distributionManagement>
        <repository>
          <id>datapassports-releases</id>
          <url>${nexus.url}/repository/maven-releases/</url>
        </repository>
        <snapshotRepository>
          <id>datapassports-snapshots</id>
          <url>${nexus.url}/repository/maven-snapshots/</url>
        </snapshotRepository>
      </distributionManagement>
</project>
```

### Add server information to Maven ```settings.xml``` file

Create ```~/.m2/settings.xml``` file if not present. Add the following xml snippet to it

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          https://maven.apache.org/xsd/settings-1.0.0.xsd">
    <servers>
       <server>
          <id>datapassports-releases</id>
          <username>admin</username>
          <password>admin123</password>
       </server>
      <server>
        <id>datapassports-snapshots</id>
        <username>admin</username>
        <password>admin123</password>
      </server>
    </servers>

</settings>
```

```server.id``` should equal to ```repository.id``` or ```snapshotRepository.id```

### Use ```nexus-staging-maven-plugin``` plugin in the ```pom.xml``` file

Add the following xml snippet to ```pom.xml``` file

```xml
<project>
    <properties>
        <nexus.staging.plugin.version>1.6.8</nexus.staging.plugin.version>
    </properties>
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                  <groupId>org.sonatype.plugins</groupId>
                  <artifactId>nexus-staging-maven-plugin</artifactId>
                  <version>${nexus.staging.plugin.version}</version>
                  <executions>
                    <execution>
                      <id>default-deploy</id>
                      <phase>deploy</phase>
                      <goals>
                        <goal>deploy</goal>
                      </goals>
                    </execution>
                  </executions>
                </plugin>
            </plugins>
        </pluginManagement>    
    </build>
</project>
```

### Disable Maven deploy plugin

Disable the following plugin

```xml
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-deploy-plugin</artifactId>
          <version>???</version>
        </plugin>
```