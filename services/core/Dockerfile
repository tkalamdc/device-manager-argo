# ---- Build stage ----
FROM eclipse-temurin:21-jdk-alpine AS builder
ADD . /usr/app
WORKDIR /usr/app

# Download dependencies (cached unless build files change)
RUN --mount=type=cache,target=/root/.gradle chmod +x gradlew && ./gradlew clean :services:core:build -x test

# ---- Runtime stage ----
FROM eclipse-temurin:21-jre-alpine

COPY --from=builder /usr/app/services/core/build/libs/core*.jar /devicetrust-device-manager.jar

RUN addgroup -S devicetm-user && adduser -S devicetm-user -G devicetm-user
USER devicetm-user

ENTRYPOINT ["java", "-jar", "/devicetrust-device-manager.jar"]
