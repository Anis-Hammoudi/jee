# =========================================================================
# STAGE 1: Build the application using Maven and a full JDK
# =========================================================================
FROM maven:3.8-eclipse-temurin-17 AS build
  
  # Set the working directory inside the container
WORKDIR /app
  
  # Copy the pom.xml to leverage Docker's layer caching
  # This step only re-runs if the dependencies in pom.xml change
COPY pom.xml .
RUN mvn dependency:go-offline
  
  # Copy the rest of the application source code
COPY src ./src
  
  # Package the application, skipping the tests (they should be run in a CI/CD pipeline)
RUN mvn package -DskipTests
  
  # =========================================================================
  # STAGE 2: Create the final, lightweight image with a JRE
  # =========================================================================
FROM eclipse-temurin:17-jre-jammy
  
  # Set the working directory
WORKDIR /app
  
  # Create a non-root user for security
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
  
  # Copy the built JAR file from the 'build' stage
COPY --from=build /app/target/*.jar app.jar
  
  # Change ownership of the app directory to the new user
RUN chown -R appuser:appgroup /app
  
  # Switch to the non-root user
USER appuser
  
  # Expose the port the application runs on
EXPOSE 8085
  
  # The command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
