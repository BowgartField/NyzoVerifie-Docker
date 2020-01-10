FROM ubuntu

RUN apt update

RUN apt install -y git openjdk-8-jdk supervisor

WORKDIR /root/

RUN git clone https://github.com/n-y-z-o/nyzoVerifier.git

WORKDIR /root/nyzoVerifier

RUN ./gradlew build 

RUN mkdir -p /var/lib/nyzo/production

RUN cp trusted_entry_points /var/lib/nyzo/production

RUN cp nyzoVerifier.conf /etc/supervisor/conf.d/

RUN bash -c 'echo "JBRCZ" > /var/lib/nyzo/production/nickname'

COPY /nyzo_config/* /var/lib/nyzo/production/

EXPOSE 9444/tcp
EXPOSE 9446/udp

ENTRYPOINT ["/usr/bin/java", "-jar", "-Xmx3G", "/root/nyzoVerifier/build/libs/nyzoVerifier-1.0.jar"]
