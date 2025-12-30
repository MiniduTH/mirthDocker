FROM nextgenhealthcare/connect:latest

# 1. Define versions for easy updates
ENV JMX_AGENT_VERSION=1.0.1
ENV JMX_PORT=9404

# 2. Download the JMX Exporter Java Agent
# We use ADD because it can download files directly (cleaner than installing wget)
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_AGENT_VERSION}/jmx_prometheus_javaagent-${JMX_AGENT_VERSION}.jar /opt/jmx_prometheus_javaagent.jar

# 3. Copy your config file into the image
COPY jmx-exporter.yaml /opt/jmx-exporter.yaml

# 4. Set permissions (Mirth runs as a non-root user usually)
USER root
RUN chmod 644 /opt/jmx_prometheus_javaagent.jar /opt/jmx-exporter.yaml
USER mirth

# 5. Inject the Agent
# This variable tells Java: "Load this agent and read this config file on this port"
ENV JAVA_TOOL_OPTIONS="-javaagent:/opt/jmx_prometheus_javaagent.jar=${JMX_PORT}:/opt/jmx-exporter.yaml"

# 6. Expose the metrics port
EXPOSE ${JMX_PORT}