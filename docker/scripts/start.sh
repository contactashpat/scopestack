#!/bin/bash

# ScopeStack Docker Environment Scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to start database only
start_db() {
    print_status "Starting PostgreSQL database..."
    docker-compose up -d postgres
    print_success "Database started successfully"
    print_status "Database URL: localhost:5432"
    print_status "Username: postgres"
    print_status "Password: postgres"
    print_status "Database: scopestack"
}

# Function to start database with pgAdmin
start_db_with_tools() {
    print_status "Starting PostgreSQL database with pgAdmin..."
    docker-compose --profile tools up -d postgres pgadmin
    print_success "Database and pgAdmin started successfully"
    print_status "Database URL: localhost:5432"
    print_status "pgAdmin URL: http://localhost:8081"
    print_status "pgAdmin Email: admin@scopestack.com"
    print_status "pgAdmin Password: admin"
}

# Function to start full environment
start_full() {
    print_status "Starting full ScopeStack environment..."
    docker-compose -f docker-compose.full.yml up -d
    print_success "Full environment started successfully"
    print_status "Application URL: http://localhost:8080"
    print_status "Swagger UI: http://localhost:8080/swagger-ui.html"
    print_status "pgAdmin URL: http://localhost:8081"
}

# Function to stop all services
stop_all() {
    print_status "Stopping all services..."
    docker-compose down
    docker-compose -f docker-compose.full.yml down
    print_success "All services stopped"
}

# Function to show logs
show_logs() {
    if [ -z "$1" ]; then
        print_status "Showing logs for all services..."
        docker-compose logs -f
    else
        print_status "Showing logs for service: $1"
        docker-compose logs -f "$1"
    fi
}

# Function to clean up
cleanup() {
    print_warning "This will remove all containers, networks, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_status "Cleaning up Docker environment..."
        docker-compose down -v
        docker-compose -f docker-compose.full.yml down -v
        docker system prune -f
        print_success "Cleanup completed"
    else
        print_status "Cleanup cancelled"
    fi
}

# Function to show status
show_status() {
    print_status "Docker containers status:"
    docker-compose ps
    echo ""
    print_status "Available services:"
    echo "  - PostgreSQL: localhost:5432"
    echo "  - Application: http://localhost:8080"
    echo "  - Swagger UI: http://localhost:8080/swagger-ui.html"
    echo "  - pgAdmin: http://localhost:8081"
}

# Main script logic
case "${1:-help}" in
    "db")
        check_docker
        start_db
        ;;
    "db-tools")
        check_docker
        start_db_with_tools
        ;;
    "full")
        check_docker
        start_full
        ;;
    "stop")
        stop_all
        ;;
    "logs")
        show_logs "$2"
        ;;
    "cleanup")
        cleanup
        ;;
    "status")
        show_status
        ;;
    "help"|*)
        echo "ScopeStack Docker Environment Script"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  db          Start PostgreSQL database only"
        echo "  db-tools    Start database with pgAdmin"
        echo "  full        Start full environment (app + db + tools)"
        echo "  stop        Stop all services"
        echo "  logs [svc]  Show logs (all or specific service)"
        echo "  status      Show status of services"
        echo "  cleanup     Remove all containers and volumes"
        echo "  help        Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 db              # Start database only"
        echo "  $0 full            # Start everything"
        echo "  $0 logs app        # Show app logs"
        ;;
esac 