FROM weaveworksdemos/msd-java:8u131

WORKDIR /usr/src/app
COPY *.jar ./app.jar

#RUN	chown -R ${SERVICE_USER}:${SERVICE_GROUP} ./app.jar
RUN	chown -R root:root ./app.jar

#USER ${SERVICE_USER}
USER root

ENV JAVA_OPTS "-Djava.security.egd=file:/dev/urandom"
ENTRYPOINT ["/usr/local/bin/java.sh","-jar","./app.jar", "--port=80"]
