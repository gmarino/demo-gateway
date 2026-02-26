FROM eclipse-temurin:17
COPY target/demo-gateway-0.0.1-SNAPSHOT.jar demo-gateway-0.0.1-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java -jar /demo-gateway-0.0.1-SNAPSHOT.jar"]
