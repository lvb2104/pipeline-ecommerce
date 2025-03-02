# Build stage 
FROM maven:3.5.3-jdk-8-alpine AS build
WORKDIR /app
# Cache dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline -B
COPY . .
RUN mvn install -DskipTests=true

# Run stage
FROM alpine:3.21.2
RUN apk add --no-cache openjdk8 \
    && adduser -D shoeshop
WORKDIR /run
COPY --from=build /app/target/shoe-ShoppingCart-0.0.1-SNAPSHOT.jar .
RUN chown -R shoeshop:shoeshop /run
USER shoeshop
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "shoe-ShoppingCart-0.0.1-SNAPSHOT.jar"]
