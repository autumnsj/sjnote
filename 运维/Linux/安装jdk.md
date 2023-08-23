# Installing Oracle JRE or JDK 8 on Debian or Ubuntu Systems

Configure your system to use the latest version of [Oracle Java SE 8 JRE or JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (1.8u151minimum). Java 9 and later are not supported.

**Note:** After installing the JDK, you may need to set JAVA_HOME to your profile:

- For shell or bash: `export JAVA_HOME=path_to_java_home`
- For csh (C shell): `setenv JAVA_HOME=path_to_java_home`

1. Check which version of the JDK your system is using:

   ```bash
   java -version
   ```

   If the OpenJDK is used, the results should look like:

   ```
   openjdk version "1.8.0_242"
   OpenJDK Runtime Environment (build 1.8.0_242-b09)
   OpenJDK 64-Bit Server VM (build 25.242-b09, mixed mode)
   ```

   If Oracle Java is used, the results should look like:

   ```
   java version "1.8.0_241"
   Java(TM) SE Runtime Environment (build 1.8.0_241-b07)
   Java HotSpot(TM) 64-Bit Server VM (build 25.241-b07, mixed mode)
   ```

2. If necessary, go to [Oracle Java SE Downloads](https://www.oracle.com/technetwork/java/javase/downloads/index.html), accept the license agreement, and download the installer for your distribution.

   The Oracle JDK License has changed for releases starting April 16, 2019. See [Java SE Development Kit 8 Downloads](https://www.oracle.com/technetwork/java/javase/downloads/index.html).

   **Note:** If installing the Oracle JDK in a cloud environment, download the installer to your local client, and then use scp (secure copy) to transfer the file to your cloud machines.

   https://www.oracle.com/java/technologies/downloads/#java8

3. Make a directory for the JDK:

   ```bash
   sudo mkdir -p /usr/lib/jvm
   ```

4. Extract the tarball and install the JDK:

   ```bash
   sudo tar zxvf jdk-version-linux-x64.tar.gz -C /usr/lib/jvm
   ```

   The JDK files are installed into a directory called /usr/lib/jvm/jdk-8u_version.

5. Tell the system that there's a new Java version available:

   ```bash
   sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_version/bin/java" 1
   ```

   **Note:** If updating from a previous version that was removed manually, execute the above command twice, because you'll get an error message the first time.

6. Set the new JDK as the default:

   ```bash
   sudo update-alternatives --set java /usr/lib/jvm/jdk1.8.0_version/bin/java
   ```

7. Verify the version of the JRE or JDK:

   ```bash
   java -version
   ```

   ```
   java version "1.8.0_241"
   Java(TM) SE Runtime Environment (build 1.8.0_241-b07)
   Java HotSpot(TM) 64-Bit Server VM (build 25.241-b07, mixed mode)
   ```

## Manually install Oracle JDK 17 on Ubuntu 22.04|20.04|18.04

The official Oracle JDK is a development environment for building applications and components using the Java programming language. This toolkit includes tools for developing and testing programs written in the Java programming language and running on the Java platform.

We’ll [download Oracle JDK 17 ](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)Debian installer

```
wget https://download.oracle.com/java/17/archive/jdk-17.0.3_linux-x64_bin.deb
```

Run the installer after it’s downloaded:



```
sudo apt install ./jdk-17.0.3_linux-x64_bin.deb
```

Additional dependencies should be installed automatically:

```
Reading package lists... Done
Building dependency tree
Reading state information... Done
Note, selecting 'jdk-17' instead of './jdk-17.0.3_linux-x64_bin.deb'
The following additional packages will be installed:
  libc6-i386 libc6-x32 libxtst6
The following NEW packages will be installed:
  jdk-17 libc6-i386 libc6-x32 libxtst6
0 upgraded, 4 newly installed, 0 to remove and 63 not upgraded.
Need to get 5517 kB/161 MB of archives.
After this operation, 346 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
```

Set JAVA environment

```
echo 'export JAVA_HOME=/usr/lib/jvm/jdk-17/' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile
```

Source the file and confirm Java version:



```
$ source /etc/profile

$ echo $JAVA_HOME
/usr/lib/jvm/jdk-17/

$ java -version
java version "17.0.2" 2022-01-18 LTS
Java(TM) SE Runtime Environment (build 17.0.2+8-LTS-86)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.2+8-LTS-86, mixed mode, sharing)
```

## Set Default Java Version on Ubuntu 22.04|20.04|18.04

Setting the default Java version applies in instances where you have multiple Java versions installed on your system.

First, you need to list all the available versions.

```
sudo update-alternatives --config java
```

Output:



```
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                         Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java   1111      auto mode
  1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java   1111      manual mode
  2            /usr/lib/jvm/java-17-oracle/bin/java          1091      manual mode

Press <enter> to keep the current choice[*], or type selection number: 2
```

From the output, select the Java version you want to set as your default version by entering the number as shown above.

Verify the set version

```
$ java -version
java version "17.0.1" 2021-10-19 LTS
Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.1+12-LTS-39, mixed mode, sharing)
```

## Setting JAVA_HOME Environment Variable.

Setting the JAVA_HOME environment variable is important as it is used by Java applications to determine the install location of Java and the exact version to use when running the applications.



We will set a persistent path so we edit the file **/etc/profile** as below.

```
sudo vi /etc/profile
```

In the file, add the Java path as shown.

```
JAVA_HOME="/path/to/java/install"
```

In this case, my Java path will be.



```
JAVA_HOME="/usr/lib/jvm/java-17-oracle"
```

For these changes to apply, you require to log in and log out or use the source command.

```
source /etc/environment
```

Verify the set variables.

```
$ echo $JAVA_HOME
/usr/lib/jvm/java-17-oracle
```

## Test the Java Installation

We will now test the Java installation using a simple HTML file. In this guide, we will create an HTML file with the name **Hello_World.java**.



```
cat > Hello_World.java <<EOF
public class helloworld {
  public static void main(String[] args) {
    System.out.println("Hello Java World from Kenya! Java 17 is amazing!");
  }
}
EOF
```

Compile the code:

```
java Hello_World.java
```

Sample Output:

```
$ java Hello_World.java
Hello Java World from Kenya! Java 17 is amazing!
```

## Conclusion

Congratulations! You have triumphantly installed Java 17 (OpenJDK 17) on Ubuntu 22.04|20.04|18.04. In addition to that, you have learned how to configure Java alternatives and set the JAVA_HOME Environment Variable. I hope this was helpful