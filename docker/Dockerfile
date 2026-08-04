# Stage 1 - Extract Spring Boot application layers
FROM eclipse-temurin:17-jre AS builder

WORKDIR /application

ARG ARTIFACT_NAME

COPY ${ARTIFACT_NAME}.jar application.jar

RUN java -Djarmode=layertools \
    -jar application.jar extract


# Stage 2 - Runtime
FROM eclipse-temurin:17-jre

WORKDIR /application

ARG EXPOSED_PORT

EXPOSE ${EXPOSED_PORT}

ENV SPRING_PROFILES_ACTIVE=docker

# Run application as non-root user
RUN groupadd --system appgroup && \
    useradd --system --gid appgroup appuser

COPY --from=builder /application/dependencies/ ./
COPY --from=builder /application/spring-boot-loader/ ./
COPY --from=builder /application/snapshot-dependencies/ ./
COPY --from=builder /application/application/ ./

RUN chown -R appuser:appgroup /application

USER appuser

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
