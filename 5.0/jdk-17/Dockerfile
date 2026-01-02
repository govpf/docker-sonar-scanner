FROM govpf/maven:3-jdk-17

ENV SONAR_SCANNER_VERSION=5.0.1.3006
ENV SONAR_RUNNER_HOME=/opt/sonar-scanner
ENV PATH=$PATH:/opt/sonar-scanner/bin
ENV SONAR_SCANNER_OPTS="-Xmx512m"
ENV _JAVA_OPTIONS='-Djdk.tls.maxCertificateChainLength=25'

RUN apt update && apt install -y --no-install-recommends wget unzip \
 && wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip \
 && unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip \
 && mv sonar-scanner-$SONAR_SCANNER_VERSION /opt/sonar-scanner \
 && rm -rf /var/lib/apt/lists/* sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip

ENTRYPOINT ["sonar-scanner"]
