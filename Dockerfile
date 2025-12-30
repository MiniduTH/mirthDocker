FROM eclipse-temurin:8-jdk

ENV MIRTH_VERSION=4.5.2.b363
ENV MIRTH_HOME=/opt/mirth-connect

RUN apt-get update && apt-get install -y wget tar && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget https://s3.amazonaws.com/downloads.mirthcorp.com/connect/${MIRTH_VERSION}/mirthconnect-${MIRTH_VERSION}-unix.tar.gz \
 && tar -xzf mirthconnect-${MIRTH_VERSION}-unix.tar.gz \
 && mv "Mirth Connect" mirth-connect \
 && rm mirthconnect-${MIRTH_VERSION}-unix.tar.gz

WORKDIR $MIRTH_HOME

EXPOSE 8080 8443 32500

ENV JMX_HOSTNAME=localhost
ENV JMX_PORT=32500

CMD ["sh", "-c", "exec java \
 -Djava.awt.headless=true \
 -Dcom.sun.management.jmxremote=true \
 -Dcom.sun.management.jmxremote.port=${JMX_PORT} \
 -Dcom.sun.management.jmxremote.rmi.port=${JMX_PORT} \
 -Dcom.sun.management.jmxremote.authenticate=false \
 -Dcom.sun.management.jmxremote.ssl=false \
 -Dcom.sun.management.jmxremote.local.only=false \
 -Djava.rmi.server.hostname=${JMX_HOSTNAME} \
 -jar mirth-server-launcher.jar"]
