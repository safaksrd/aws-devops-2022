# how to get project version from maven pom.xml
# 1
MVN_VERSION=$(. ./target/maven-archiver/pom.properties && echo $version)

# 2
MVN_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

# 3
MVN_VERSION=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.version}' \
    --non-recursive \
    exec:exec)

# 4
MVN_VERSION=$(mvn help:evaluate -Dexpression=project.version | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }')

