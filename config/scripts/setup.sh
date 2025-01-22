#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logger functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%dT%H:%M:%S%z')] ERROR: $1${NC}"
    exit 1
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%dT%H:%M:%S%z')] WARNING: $1${NC}"
}

# Version checking function
check_version() {
    local required=$1
    local current=$2
    if [ "$(printf '%s\n' "$required" "$current" | sort -V | head -n1)" = "$required" ]; then 
        return 0
    else
        return 1
    fi
}

# Get OS type
get_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*) echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

# Get installation instructions based on OS
get_install_instructions() {
    local tool=$1
    local os=$(get_os)
    
    case $tool in
        flutter)
            case $os in
                macos) echo "brew install flutter" ;;
                linux) echo "sudo snap install flutter --classic" ;;
                windows) echo "1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows\n    2. Extract the file and add to Path\n    3. Run 'flutter doctor'" ;;
            esac
            ;;
        go)
            case $os in
                macos) echo "brew install go" ;;
                linux) echo "sudo apt-get update && sudo apt-get install golang-go" ;;
                windows) echo "1. Download Go from https://golang.org/dl/\n    2. Run the installer\n    3. Restart your terminal" ;;
            esac
            ;;
        rust)
            case $os in
                macos|linux) echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" ;;
                windows) echo "1. Download Rust from https://rustup.rs/\n    2. Run rustup-init.exe\n    3. Follow the installation instructions" ;;
            esac
            ;;
        docker)
            case $os in
                macos) echo "brew install docker docker-compose" ;;
                linux) echo "1. curl -fsSL https://get.docker.com -o get-docker.sh\n    2. sudo sh get-docker.sh\n    3. sudo usermod -aG docker $USER" ;;
                windows) echo "Download and install Docker Desktop from https://www.docker.com/products/docker-desktop" ;;
            esac
            ;;
        protoc)
            case $os in
                macos) echo "brew install protobuf" ;;
                linux) echo "sudo apt-get install protobuf-compiler" ;;
                windows) echo "1. Download protoc from https://github.com/protocolbuffers/protobuf/releases\n    2. Extract and add to Path" ;;
            esac
            ;;
    esac
}

# Check system requirements
check_requirements() {
    log "Checking system requirements..."
    local requirements_met=true
    local os=$(get_os)
    
    log "Detected OS: $(uname -s) ($os)"

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        warn "Flutter is not installed"
        warn "To install Flutter:"
        warn "$(get_install_instructions flutter)"
        requirements_met=false
    else
        local flutter_version=$(flutter --version | head -n 1 | awk '{print $2}')
        if ! check_version "3.19.0" "$flutter_version"; then
            warn "Flutter version $flutter_version is lower than required (3.19.0)"
            requirements_met=false
        else
            log "Flutter $flutter_version found"
        fi
    fi

    # Check Go
    if ! command -v go &> /dev/null; then
        warn "Go is not installed"
        warn "To install Go:"
        warn "$(get_install_instructions go)"
        requirements_met=false
    else
        local go_version=$(go version | awk '{print $3}' | sed 's/go//')
        if ! check_version "1.21.0" "$go_version"; then
            warn "Go version $go_version is lower than required (1.21.0)"
            requirements_met=false
        else
            log "Go $go_version found"
        fi
    fi

    # Check Rust
    if ! command -v rustc &> /dev/null; then
        warn "Rust is not installed"
        warn "To install Rust:"
        warn "$(get_install_instructions rust)"
        requirements_met=false
    else
        local rust_version=$(rustc --version | awk '{print $2}')
        if ! check_version "1.75.0" "$rust_version"; then
            warn "Rust version $rust_version is lower than required (1.75.0)"
            requirements_met=false
        else
            log "Rust $rust_version found"
        fi
    fi

    # Check Docker
    if ! command -v docker &> /dev/null; then
        warn "Docker is not installed"
        warn "To install Docker:"
        warn "$(get_install_instructions docker)"
        requirements_met=false
    else
        log "Docker found"
    fi

    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        warn "Docker Compose is not installed"
        requirements_met=false
    else
        log "Docker Compose found"
    fi

    if [ "$requirements_met" = false ]; then
        warn "Some requirements are not met. Please install missing dependencies."
        read -p "Do you want to continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            error "Setup cancelled"
        fi
    else
        log "All requirements met!"
    fi
}

# Create project directory structure
create_project_structure() {
    log "Creating project structure..."

    local directories=(
        # "apps/skillflow/lib/src/screens"
        # "apps/skillflow/lib/src/widgets"
        # "apps/skillflow/lib/src/models"
        # "apps/skillflow/lib/src/services"
        # "apps/skillflow/lib/src/utils"
        # "apps/skillflow/test"
        "apps"
        "services"
        # "services/auth"
        # "services/profile"
        # "services/tracker"
        # "services/analytics"
        # "services/notifications"
        "assets/modules"
        "environments/dev"
        "environments/prod"
        "environments/global"
        "docs/api"
        "docs/postman"
        "docs/architecture"
        "docs/patterns"
        "docs/guidelines"
    )

    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        log "Created directory: $dir"
    done
}

# # Initialize Flutter project
# init_flutter_project() {
#     log "Initializing Flutter project..."

#     # Check if Flutter project already exists
#     if [ -f "apps/skillflow/pubspec.yaml" ]; then
#         warn "Flutter project already exists in apps/skillflow, skipping initialization"
#         return 0
#     fi

#     cd apps/skillflow

#     # Create Flutter project
#     flutter create . \
#         --org com.skillflow \
#         --platforms=android,ios,web \
#         --project-name skillflow

#     # Add dependencies
#     flutter pub add \
#         firebase_core \
#         firebase_auth \
#         cloud_firestore \
#         go_router \
#         flutter_riverpod \
#         freezed_annotation \
#         json_annotation

#     # Add dev dependencies
#     flutter pub add --dev \
#         build_runner \
#         freezed \
#         json_serializable

#     # Enable web support
#     flutter config --enable-web

#     cd ../..
    
#     log "Flutter project initialized successfully"
# }

# # Initialize Go services
# init_go_services() {
#     log "Initializing Go services..."

#     local services=("auth" "user-profile")
    
#     for service in "${services[@]}"; do
#         if [ ! -f "services/go-services/$service/go.mod" ]; then
#             cd "services/go-services/$service"
#             go mod init "skillflow/$service"
#             go get -u github.com/gin-gonic/gin
            
#             if [ "$service" = "auth" ]; then
#                 go get -u github.com/golang-jwt/jwt/v5
#             fi
            
#             cd ../../..
#             log "Initialized Go service: $service"
#         else
#             warn "Go module already exists for $service, skipping initialization"
#         fi
#     done
# }

# # Initialize Rust services
# init_rust_services() {
#     log "Initializing Rust services..."

#     local services=("tracker" "analytics" "notifications")
    
#     for service in "${services[@]}"; do
#         if [ ! -f "services/rust-services/$service/Cargo.toml" ]; then
#             cd "services/rust-services/$service"
#             cargo init --bin
#             cd ../../..
#             log "Initialized Rust service: $service"
#         else
#             warn "Rust project already exists for $service, skipping initialization"
#         fi
#     done
# }

# Main execution
main() {
    log "Starting Skillflow project setup..."
    
    check_requirements
    create_project_structure
    
    log "Project setup completed successfully!"
    log "Next steps:"
    log "1. Run 'make setup' to install dependencies"
    log "2. Run 'make dev' to start the development environment"
    log "3. Check README.md for more commands and information"
}

# Execute main function
main