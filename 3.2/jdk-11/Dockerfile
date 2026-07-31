FROM govpf/maven:3-jdk-11

ENV SONAR_SCANNER_VERSION=3.2.0.1227
ENV SONAR_RUNNER_HOME=/opt/sonar-scanner
ENV PATH=$PATH:/root/sonar-scanner-$SONAR_SCANNER_VERSION/bin
ENV SONAR_SCANNER_OPTS="-Xmx512m -XX:MaxPermSize=128m"
ENV _JAVA_OPTIONS="-Djdk.tls.maxCertificateChainLength=13"

# Install Node.js 14 + Yarn
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_14.x jammy main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg \
        | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" \
        > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        yarn \
        procps \
        make \
        g++ \
        tini \
    && npm install -g npm \
    && rm -rf /var/lib/apt/lists/*

# Install sonar-scanner
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip \
    && wget -c https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && mv sonar-scanner-${SONAR_SCANNER_VERSION} /opt/sonar-scanner \
    && rm -f sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && rm -rf /var/lib/apt/lists/*

COPY 3.2/sonar-scanner.properties /opt/sonar-scanner/conf/sonar-scanner.properties

ADD 3.2/docker-entrypoint.sh /docker-entrypoint

RUN groupadd -r sonar \
 && useradd -r -s /usr/sbin/nologin -d ${SONAR_RUNNER_HOME} -c "Sonar service user" -g sonar sonar \
 && chown -R sonar:sonar ${SONAR_RUNNER_HOME} \
 && mkdir -p /data \
 && chown -R sonar:sonar /data \
 && ln -s ${SONAR_RUNNER_HOME}/bin/sonar-scanner /usr/local/bin/sonar-scanner \
 && chmod +x /docker-entrypoint

WORKDIR /data
VOLUME /data

ENTRYPOINT ["/docker-entrypoint"]
CMD ["sonar-scanner"]