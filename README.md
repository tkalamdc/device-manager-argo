# Device Manager — Argo

Spring Boot 4.x multi-module service, built with Gradle 9.6.0 and Java 21.

---

## Prerequisites

| Tool | Version |
|------|---------|
| Java (JDK) | 21+ |
| Docker | 24+ |
| Helm | 3+ |
| Kubernetes cluster | 1.28+ |

> No Gradle installation required — all commands use the included `./gradlew` wrapper.

---

## Gradle Commands

### Build

```bash
# Build all modules
./gradlew build

# Build only the core service (skip tests)
./gradlew :services:core:build -x test

# Produce the executable JAR
./gradlew :services:core:bootJar
```

### Run

```bash
# Run the core service locally
./gradlew :services:core:bootRun
```

### Test

```bash
# Run all tests
./gradlew test

# Run tests for core only
./gradlew :services:core:test
```

### Clean

```bash
./gradlew clean
```

---

## Docker

> All `docker` commands must be run from the **repository root** so the build context includes all modules.

### Build the image

```bash
docker build \
  -f services/core/Dockerfile \
  -t device-manager:latest \
  .
```

### Build with a specific version tag

```bash
docker build \
  -f services/core/Dockerfile \
  -t device-manager:1.0.0 \
  .
```

### Run the container

```bash
docker run --rm \
  -p 8080:8080 \
  -e SPRING_APPLICATION_NAME=core \
  device-manager:latest
```

### Run with a custom Spring profile

```bash
docker run --rm \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  device-manager:latest
```

---

## ArgoCD

Install ArgoCD on your local cluster using the provided Helm values:

```bash
cd scripts/argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values values.yaml
```

Add the hostname to `/etc/hosts`:

```bash
echo "127.0.0.1  argocd.local" | sudo tee -a /etc/hosts
```

Retrieve the admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode && echo
```

Open `http://argocd.local` — login with `admin` and the password above.

Deploy the ArgoCD Application manifest:

```bash
kubectl apply -f scripts/argocd/applications/application.yaml
```

> See [`scripts/argocd/README.md`](scripts/argocd/README.md) for full details.

---

## Project Structure

```
device-manager-argo/
├── build.gradle                  # Root build — shared config for all subprojects
├── settings.gradle
├── gradle/
│   └── libs.versions.toml        # Version catalog
├── buildSrc/                     # Convention plugins
└── services/
    └── core/                     # Core Spring Boot service
        ├── build.gradle
        ├── Dockerfile
        └── src/
            └── main/
                └── resources/
                    ├── application.yaml
                    └── logback-spring.xml
```

