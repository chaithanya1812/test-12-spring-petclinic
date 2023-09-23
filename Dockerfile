FROM eclipse-temurin:17-jdk-jammy
MAINTAINER chaithanya
LABEL gmail  chaithanya1812@gmail.com
RUN mkdir  /app
COPY /target/spring-petclinic-3.0.0-SNAPSHOT.jar /app/spring.jar
WORKDIR /app
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app/spring.jar"]
