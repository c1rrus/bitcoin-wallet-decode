# Start with Java 8 JDK
# See: https://hub.docker.com/_/openjdk/
FROM openjdk:8-jdk

# Install OpenJFX & Maven
# (OpenSSL & git are already in the base image)
RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
    openjfx

# Clone BitcoinJ v0.14 to /local/bitcoinj
WORKDIR /app
RUN git clone -b release-0.14 https://github.com/bitcoinj/bitcoinj.git

# Compile BitcoinJ
WORKDIR bitcoinj
RUN mvn clean install -DskipTests

# Copy shell scripts to container
COPY src/extract-keys.sh /app
COPY src/clean-up.sh /app

# Switch to a temp dir
WORKDIR /app
