FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/java-app-1.0.jar app.jar

ENTRYPOINT ["sh", "-c", "java -jar app.jar && tail -f /dev/null"]

