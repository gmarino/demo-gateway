# =========================
# 1) BUILD STAGE
# =========================
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# copia i file di build Maven e fai il download delle dipendenze
COPY pom.xml ./
RUN --mount=type=cache,target=/root/.m2 mvn -q -e -B -DskipTests dependency:go-offline

# copia il sorgente e compila
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn -q -e -B -DskipTests clean package

# Nome JAR prodotto (adatta se diverso)
# Esempio: target/demo-gateway-0.0.1-SNAPSHOT.jar
ARG JAR_NAME="demo-gateway-0.0.1-SNAPSHOT.jar"

# =========================
# 2) RUNTIME STAGE
# =========================
FROM eclipse-temurin:17-jre-alpine AS runtime

# crea utente non-root
RUN addgroup -S app && adduser -S app -G app
USER app
WORKDIR /app

# porta applicazione (Gateway)
EXPOSE 8765

# variabili JVM: heap proporzionato al container, exit su OOM
ENV JAVA_TOOL_OPTIONS="-XX:+ExitOnOutOfMemoryError -XX:MaxRAMPercentage=75.0"

# copia il jar dal build stage
ARG JAR_NAME="demo-gateway-0.0.1-SNAPSHOT.jar"
COPY --from=build /app/target/${JAR_NAME} /app/app.jar

# (facoltativo) healthcheck interno del container (usa actuator)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
#   CMD wget -qO- http://127.0.0.1:8765/actuator/health | grep -q '"status":"UP"' || exit 1

# avvio
ENTRYPOINT ["java","-jar","/app/app.jar"]
