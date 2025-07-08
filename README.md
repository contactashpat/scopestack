# ScopeStack - Spring Boot Multi-Module Project

A Spring Boot application with a multi-module Maven structure for managing products with RESTful APIs.

## Features

- **RESTful API** with full CRUD operations
- **Multi-module Maven project** structure
- **Spring Boot 3.2.0** with Spring Data JPA
- **HTTPS/SSL/TLS encryption** with self-signed certificate
- **HTTP/2 protocol support** for improved performance
- **H2 in-memory database** with sample data
- **Pagination support** for large datasets
- **Docker support** with docker-compose
- **OpenBao (Vault) integration** for secrets management
- **Swagger/OpenAPI documentation**

## Project Structure

```
scopestack/
├── scopestack-common/          # Common models and DTOs
│   ├── src/main/java/com/scopestack/common/
│   │   ├── dto/               # Data Transfer Objects
│   │   └── enums/             # Enumerations
│   └── pom.xml
├── scopestack-rest/            # REST API module
│   ├── src/main/java/com/scopestack/product/
│   │   ├── config/            # Configuration classes
│   │   ├── controller/        # REST controllers
│   │   ├── dto/              # Module-specific DTOs
│   │   ├── model/            # Entity models
│   │   ├── repository/       # Data access layer
│   │   └── service/          # Business logic layer
│   ├── src/main/resources/
│   │   ├── application.yml   # Application configuration
│   │   └── data.sql          # Initial data
│   ├── Dockerfile
│   └── pom.xml
├── docker-compose.yml         # Docker orchestration
├── pom.xml                    # Parent POM
└── README.md
```

## Prerequisites

- Java 17 or higher
- Maven 3.6+
- Docker (optional, for containerized deployment)

## Quick Start

### 1. Build the Project

```bash
# Build all modules
./mvnw clean install

# Or build specific modules
./mvnw clean install -pl scopestack-common
./mvnw clean install -pl scopestack-rest
```

### 2. Run the Application

```bash
# Run the REST API module
./mvnw spring-boot:run -pl scopestack-rest
```

The application will start on `https://localhost:8443`

### 3. Using Docker

```bash
# Build and run with Docker Compose
docker compose up --build

# Or run individual services
docker compose up scopestack-rest
```

### 4. Secrets Management with OpenBao

The project includes OpenBao (a HashiCorp Vault alternative) for secrets management using Docker:

```bash
# Start OpenBao
./setup-openbao.sh start

# Initialize secrets
./setup-openbao.sh init

# Check status
./setup-openbao.sh status

# Stop OpenBao
./setup-openbao.sh stop
```

**OpenBao Access:**
- **URL**: http://localhost:8200
- **UI**: http://localhost:8200/ui
- **Root Token**: `scopestack-dev-token`

**Available Commands:**
- `./setup-openbao.sh start` - Start OpenBao container
- `./setup-openbao.sh stop` - Stop OpenBao container
- `./setup-openbao.sh restart` - Restart OpenBao container
- `./setup-openbao.sh status` - Check OpenBao status
- `./setup-openbao.sh init` - Initialize secrets
- `./setup-openbao.sh logs` - View OpenBao logs
- `./setup-openbao.sh help` - Show help

## API Documentation

### Base URL
```
https://localhost:8443/api/products
```

### Endpoints

#### Get All Products (Paginated)
```http
GET /api/products?page=0&size=20
```

**Response:**
```json
{
  "content": [
    {
      "id": 1,
      "name": "Sample Product",
      "description": "Product description",
      "price": 29.99,
      "category": "ELECTRONICS",
      "createdAt": "2024-01-01T10:00:00",
      "updatedAt": "2024-01-01T10:00:00"
    }
  ],
  "pageable": {
    "pageNumber": 0,
    "pageSize": 20
  },
  "totalElements": 1,
  "totalPages": 1
}
```

#### Get Product by ID
```http
GET /api/products/{id}
```

**Response:**
```json
{
  "id": 1,
  "name": "Sample Product",
  "description": "Product description",
  "price": 29.99,
  "category": "ELECTRONICS",
  "createdAt": "2024-01-01T10:00:00",
  "updatedAt": "2024-01-01T10:00:00"
}
```

#### Create Product
```http
POST /api/products
Content-Type: application/json

{
  "name": "New Product",
  "description": "Product description",
  "price": 49.99,
  "category": "BOOKS"
}
```

#### Update Product
```http
PUT /api/products/{id}
Content-Type: application/json

{
  "name": "Updated Product",
  "description": "Updated description",
  "price": 59.99,
  "category": "ELECTRONICS"
}
```

#### Delete Product
```http
DELETE /api/products/{id}
```

## Testing the API

### Browser Testing (HTTP/2)

You can test the API directly in your browser:

1. **Open**: `https://localhost:8443/api/products`
2. **Accept the security warning** (self-signed certificate)
3. **Check HTTP/2 in DevTools**:
   - Open DevTools (F12)
   - Go to Network tab
   - Reload the page
   - Look for "Protocol" column showing "h2" (HTTP/2)

### Using cURL

```bash
# Get all products
curl -k -X GET "https://localhost:8443/api/products"

# Get product by ID
curl -k -X GET "https://localhost:8443/api/products/1"

# Create a product
curl -k -X POST "https://localhost:8443/api/products" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "description": "A test product",
    "price": 25.99,
    "category": "ELECTRONICS"
  }'

# Update a product
curl -k -X PUT "https://localhost:8443/api/products/1" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Product",
    "description": "Updated description",
    "price": 35.99,
    "category": "BOOKS"
  }'

# Delete a product
curl -k -X DELETE "https://localhost:8443/api/products/1"
```

### Using Postman

1. Import the following collection:
```json
{
  "info": {
    "name": "ScopeStack Product API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Get All Products",
      "request": {
        "method": "GET",
        "url": "https://localhost:8443/api/products"
      }
    },
    {
      "name": "Get Product by ID",
      "request": {
        "method": "GET",
        "url": "https://localhost:8443/api/products/1"
      }
    },
    {
      "name": "Create Product",
      "request": {
        "method": "POST",
        "url": "https://localhost:8443/api/products",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"name\": \"Test Product\",\n  \"description\": \"A test product\",\n  \"price\": 25.99,\n  \"category\": \"ELECTRONICS\"\n}"
        }
      }
    }
  ]
}
```

## Development

### Module Dependencies

- `scopestack-common` contains shared DTOs and enums
- `scopestack-rest` depends on `scopestack-common`

### Building Order

Always build the common module first:

```bash
# 1. Build common module
./mvnw clean install -pl scopestack-common

# 2. Build REST module
./mvnw clean install -pl scopestack-rest
```

### IDE Setup

If you encounter import issues in your IDE:

1. Build the common module first
2. Reload/restart your IDE
3. Refresh Maven project dependencies

### Adding New Features

1. **New DTOs**: Add to `scopestack-common/src/main/java/com/scopestack/common/dto/`
2. **New Entities**: Add to `scopestack-rest/src/main/java/com/scopestack/product/model/`
3. **New Services**: Add to `scopestack-rest/src/main/java/com/scopestack/product/service/`
4. **New Controllers**: Add to `scopestack-rest/src/main/java/com/scopestack/product/controller/`

## Configuration

### Application Properties

Key configuration in `scopestack-rest/src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:h2:mem:testdb
    driver-class-name: org.h2.Driver
  h2:
    console:
      enabled: true
  jpa:
    hibernate:
      ddl-auto: create-drop
    show-sql: true
  cloud:
    vault:
      host: localhost
      port: 8200
      scheme: http
      authentication: TOKEN
      token: scopestack-dev-token
      fail-fast: false
      kv:
        enabled: true
        backend: secret
        application-name: scopestack-rest
        default-context: application
        profile-separator: '/'
```

### OpenBao Configuration

The application is configured to use OpenBao for secrets management:

- **Host**: localhost:8200 (Docker container)
- **Authentication**: Token-based
- **Secrets Engine**: Key-Value (version 2)
- **Backend**: `secret`
- **Fail-fast**: Disabled (for development)

**Stored Secrets:**
- Database credentials: `/secret/data/database`
- Application secrets: `/secret/data/application`

### Environment Variables

- `SPRING_PROFILES_ACTIVE`: Set to `prod` for production
- `DB_URL`: Database connection URL
- `DB_USERNAME`: Database username
- `DB_PASSWORD`: Database password

## Troubleshooting

### Common Issues

1. **Import Resolution Errors**
   ```bash
   # Rebuild common module
   ./mvnw clean install -pl scopestack-common
   
   # Reload IDE/restart language server
   ```

2. **Port Already in Use**
   ```bash
   # Change port in application.yml
   server:
     port: 8081
   ```

3. **Database Connection Issues**
   - Check H2 console at `https://localhost:8443/h2-console`
   - Verify database configuration in `application.yml`

### Logs

View application logs:
```bash
# Maven
./mvnw spring-boot:run -pl scopestack-rest

# Docker
docker-compose logs scopestack-rest
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
