FROM gradle:7.4.0-jdk11-alpine as build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build -x test --no-daemon --stacktrace

FROM openjdk:11-jre-slim
EXPOSE 8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/forum-0.0.1-SNAPSHOT.jar /app/forum.jar
ENTRYPOINT ["java", "$JAVA_OPTS -XX:+UseContainerSupport","-Xmx300m","-Xss512k", "-Dserver.port=$PORT", "-Dspring.profiles.active=prod", "-jar","/app/forum.jar"]