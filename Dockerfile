FROM govpf/maven:3-jdk-8

ENV SONAR_SCANNER_VERSION 3.2.0.1227
ENV SONAR_RUNNER_HOME=/opt/sonar-scanner
ENV PATH $PATH:/root/sonar-scanner-$SONAR_SCANNER_VERSION/bin
ENV SONAR_SCANNER_OPTS "-Xmx512m -XX:MaxPermSize=128m"

# Install sonar-scanner
RUN wget -c https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip \
    && unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip \
    && mv sonar-scanner-$SONAR_SCANNER_VERSION /opt/sonar-scanner \
    && rm -f sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip

COPY sonar-scanner.properties ./sonar-scanner-${SONAR_SCANNER_VERSION}/conf/sonar-scanner.properties

ADD docker-entrypoint.sh /docker-entrypoint

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
