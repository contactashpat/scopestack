# Multi-stage build for Spring Boot application
FROM maven:3.9.6-openjdk-21 AS build

# Set working directory
WORKDIR /app

# Copy parent POM
COPY pom.xml ./
COPY scopestack-common/pom.xml ./scopestack-common/
COPY scopestack-rest/pom.xml ./scopestack-rest/

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY scopestack-common/src ./scopestack-common/src
COPY scopestack-rest/src ./scopestack-rest/src

# Build the application
RUN mvn clean package -DskipTests -pl scopestack-rest

# Runtime stage
FROM openjdk:21-jre-slim

# Create app user
RUN addgroup --system app && adduser --system --ingroup app app

# Set working directory
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/scopestack-rest/target/scopestack-rest-*.jar app.jar

# Change ownership to app user
RUN chown app:app app.jar

# Switch to app user
USER app

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
