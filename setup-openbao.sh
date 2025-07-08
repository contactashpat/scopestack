#!/bin/bash

# OpenBao Setup Script for ScopeStack
# This script helps manage OpenBao using Docker Compose

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
}

# Function to start OpenBao
start_openbao() {
    print_status "Starting OpenBao using Docker Compose..."
    
    # Start OpenBao with vault profile
    docker compose --profile vault up -d openbao
    
    print_status "Waiting for OpenBao to be ready..."
    sleep 5
    
    # Check if OpenBao is running
    if curl -s http://localhost:8200/v1/sys/health > /dev/null 2>&1; then
        print_success "OpenBao is running on http://localhost:8200"
        print_status "Root token: scopestack-dev-token"
        print_status "You can access the UI at: http://localhost:8200/ui"
    else
        print_error "Failed to start OpenBao. Check logs with: docker compose logs openbao"
        exit 1
    fi
}

# Function to stop OpenBao
stop_openbao() {
    print_status "Stopping OpenBao..."
    docker compose --profile vault down openbao
    print_success "OpenBao stopped"
}

# Function to show OpenBao status
status_openbao() {
    if curl -s http://localhost:8200/v1/sys/health > /dev/null 2>&1; then
        print_success "OpenBao is running"
        echo "URL: http://localhost:8200"
        echo "UI: http://localhost:8200/ui"
        echo "Root token: scopestack-dev-token"
    else
        print_warning "OpenBao is not running"
    fi
}

# Function to initialize secrets
init_secrets() {
    print_status "Initializing secrets in OpenBao..."
    
    # Check if OpenBao is running
    if ! curl -s http://localhost:8200/v1/sys/health > /dev/null 2>&1; then
        print_error "OpenBao is not running. Start it first with: $0 start"
        exit 1
    fi
    
    # Set the token
    export VAULT_TOKEN=scopestack-dev-token
    export VAULT_ADDR=http://localhost:8200
    
    # Enable key-value secrets engine (if not already enabled)
    print_status "Enabling key-value secrets engine..."
    curl -s -X POST \
        -H "X-Vault-Token: $VAULT_TOKEN" \
        -d '{"type": "kv", "options": {"version": "2"}}' \
        http://localhost:8200/v1/sys/mounts/secret || true
    
    # Store some sample secrets
    print_status "Storing sample secrets..."
    
    # Database credentials
    curl -s -X POST \
        -H "X-Vault-Token: $VAULT_TOKEN" \
        -d '{"data": {"username": "postgres", "password": "postgres", "url": "jdbc:postgresql://localhost:5432/scopestack"}}' \
        http://localhost:8200/v1/secret/data/database
    
    # Application secrets
    curl -s -X POST \
        -H "X-Vault-Token: $VAULT_TOKEN" \
        -d '{"data": {"jwt-secret": "scopestack-jwt-secret-key-2024", "api-key": "scopestack-api-key-2024"}}' \
        http://localhost:8200/v1/secret/data/application
    
    # Feature flags
    curl -s -X POST \
        -H "X-Vault-Token: $VAULT_TOKEN" \
        -d '{"data": {"enable-cache": "true", "cache-ttl": "300", "max-connections": "50"}}' \
        http://localhost:8200/v1/secret/data/features
    
    print_success "Secrets initialized successfully!"
    print_status "You can view secrets at: http://localhost:8200/ui/vault/secrets/secret"
}

# Function to show logs
show_logs() {
    print_status "Showing OpenBao logs..."
    docker compose logs -f openbao
}

# Function to show help
show_help() {
    echo "OpenBao Management Script for ScopeStack"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start OpenBao using Docker Compose"
    echo "  stop      Stop OpenBao"
    echo "  restart   Restart OpenBao"
    echo "  status    Show OpenBao status"
    echo "  init      Initialize secrets in OpenBao"
    echo "  logs      Show OpenBao logs"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    # Start OpenBao"
    echo "  $0 init     # Initialize secrets"
    echo "  $0 status   # Check status"
}

# Main script logic
case "${1:-help}" in
    start)
        check_docker
        start_openbao
        ;;
    stop)
        stop_openbao
        ;;
    restart)
        stop_openbao
        sleep 2
        start_openbao
        ;;
    status)
        status_openbao
        ;;
    init)
        init_secrets
        ;;
    logs)
        show_logs
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac 