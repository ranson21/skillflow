# Skillflow

[![Flutter](https://img.shields.io/badge/Flutter-3.19.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/) [![Go](https://img.shields.io/badge/Go-1.21+-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://golang.org/) [![Rust](https://img.shields.io/badge/Rust-1.75+-000000?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/) [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

A modern skill tracking and learning management platform built with Flutter and microservices architecture, combining Go and Rust for optimal performance and maintainability.

## 📦 Repository Structure

```mermaid
graph TD
    A[Root Repository] --> B[apps]
    B --> G[skillflow]
    A --> C[services]
    A --> D[assets]
    A --> E[environments]
    A --> F[docs]
    C --> C3[auth]
    C --> C4[profile]
    C --> C5[tracker]
    C --> C6[analytics]
    C --> C7[notifications]
    D --> D1[modules]
    E --> E1[dev]
    E --> E2[prod]
    E --> E3[global]
```

### Applications
- **mobile/** - Flutter mobile application
- **web/** - Web dashboard (future expansion)

### Services
#### Go Services
- **auth/** - Authentication and authorization service
- **profile/** - User management and preferences

#### Rust Services
- **tracker/** - Activity and progress tracking
- **analytics/** - Data analysis and insights
- **notifications/** - Real-time notification system

### Prerequisites
- Git 2.x or higher
- Flutter 3.19.0 or higher
- Go 1.21 or higher
- Rust 1.75 or higher
- Docker & Docker Compose
- Firebase CLI
- Protocol Buffers compiler (protoc)

## 🚀 Getting Started

### Development Setup
```bash
# Clone the repository
git clone https://github.com/ranson21/skillflow.git
cd skillflow

# Initialize development environment
make setup

# Start development servers
make dev
```

## 🔧 Development Commands

### Core Commands
```bash
# Full development environment setup
make setup

# Start all services
make dev

# Clean all artifacts
make clean
```

## 🏗️ Infrastructure

### Docker Support
```bash
# Build all services
docker-compose build

# Run entire stack
docker-compose up
```

### Service Architecture
Each microservice follows a standardized structure:
- Clean architecture principles
- Health check endpoints
- Metrics collection
- Structured logging
- API documentation

## 📖 Documentation

### API Documentation
- Available at `/docs` endpoint for each service in development mode
- OpenAPI/Swagger specifications in `/docs/api`
- Postman collections in `/docs/postman`

### Architecture Documentation
- System design diagrams in `/docs/architecture`
- Service interaction patterns in `/docs/patterns`
- Development guidelines in `/docs/guidelines`

## 🔄 Update Strategy

1. **Regular Updates**
```bash
# Update all submodules to latest versions
git submodule update --remote
git add .
git commit -m "chore: update submodules to latest versions"
```

2. **Specific Module Updates**
```bash
cd assets/modules/tf-gcp-project
git checkout master
git pull
cd ../../..
git add assets/modules/tf-gcp-project
git commit -m "chore: update GCP project module"
```

## 🔒 Security

- Security scanning integrated into CI/CD pipeline
- Regular dependency updates and audits
- Secure configuration practices enforced
- Authentication and authorization at service boundaries

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Maintainers

For project related queries, contact [Abigail Ranson](mailto:abby@abbyranson.com)

## 🌟 Acknowledgments

- Flutter and Dart teams
- Go community
- Rust community
- Firebase team
