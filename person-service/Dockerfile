from bryandollery/maven-repo as build

WORKDIR /usr/src/app

arg rebuild

run git clone https://github.com/saloyiana/level-2-project.git && \
    cd level-2-project/person-service/  && \
    mvn clean package

from adoptopenjdk/openjdk11:alpine

copy --from=build "/usr/src/app/level-2-project/person-service/target/person-service-1.0.0.jar" /

cmd ["java", "-jar", "person-service-1.0.0.jar"]

expose 80
