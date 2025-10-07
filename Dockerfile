# Use a build stage to compile the app (multi-stage build). Saves final image size.
FROM eclipse-temurin:17 AS build
WORKDIR /app

# Copy source (including pom, mvnw, etc)
COPY . .

# If you're using Maven wrapper:
RUN ./mvnw clean package -DskipTests

# The jar will be in target/ (assuming standard layout)
# You can also use spring-boot:repackage etc.

FROM eclipse-temurin:17-jdk-jammy as runtime
WORKDIR /opt/app

# Copy the jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Spring Boot default)
EXPOSE 8080


# Use “java -jar” to run
ENTRYPOINT ["java","-jar","/opt/app/app.jar"]
