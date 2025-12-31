FROM nextgenhealthcare/connect:latest

# 1. Define versions for easy updates
ENV JMX_AGENT_VERSION=1.0.1
ENV JMX_PORT=9404
ENV MIRTH_HTTP_PORT=8080
ENV MIRTH_HTTPS_PORT=8443

# 2. Download the JMX Exporter Java Agent
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_AGENT_VERSION}/jmx_prometheus_javaagent-${JMX_AGENT_VERSION}.jar /opt/jmx_prometheus_javaagent.jar

# 3. Copy your config file into the image
COPY jmx-exporter.yaml /opt/jmx-exporter.yaml

# 4. Override Mirth properties using environment variables (preferred method)
USER root
RUN chmod 644 /opt/jmx_prometheus_javaagent.jar /opt/jmx-exporter.yaml
USER mirth

# 5. Set Mirth environment variables for port configuration
ENV https.port=8443
ENV http.port=8080

# 6. Inject the JMX Agent
ENV JAVA_TOOL_OPTIONS="-javaagent:/opt/jmx_prometheus_javaagent.jar=${JMX_PORT}:/opt/jmx-exporter.yaml"

# 7. Expose the ports
EXPOSE 9404 8080 8443