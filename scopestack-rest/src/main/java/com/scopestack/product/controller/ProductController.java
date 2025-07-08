package com.scopestack.product.controller;

import com.scopestack.common.dto.ProductRequest;
import com.scopestack.common.dto.ProductResponse;
import com.scopestack.product.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
@Tag(name = "Product Management", description = "APIs for managing products")
public class ProductController {

    @Autowired
    private ProductService productService;

    // Using OpenBao secret in controller layer
    @Value("${jwt-secret:default-secret}")
    private String jwtSecret;

    @Value("${app.feature-flags.enable-premium-features:false}")
    private boolean enablePremiumFeatures;

    @GetMapping
    @Operation(summary = "Get all products", description = "Retrieve a list of all products")
    public ResponseEntity<List<ProductResponse>> getAllProducts() {
        List<ProductResponse> products = productService.getAllProducts();
        return ResponseEntity.ok(products);
    }

    @GetMapping("/page")
    @Operation(summary = "Get products with pagination", description = "Retrieve products with pagination support")
    public ResponseEntity<Page<ProductResponse>> getProductsWithPagination(
            @Parameter(description = "Page number (0-based)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Page size") @RequestParam(defaultValue = "10") int size,
            @Parameter(description = "Sort field") @RequestParam(defaultValue = "id") String sortBy) {
        Page<ProductResponse> products = productService.getProductsWithPagination(page, size, sortBy);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get product by ID", description = "Retrieve a specific product by its ID")
    public ResponseEntity<ProductResponse> getProductById(
            @Parameter(description = "Product ID") @PathVariable Long id) {
        Optional<ProductResponse> product = productService.getProductById(id);
        return product.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @Operation(summary = "Create a new product", description = "Create a new product")
    public ResponseEntity<ProductResponse> createProduct(
            @Parameter(description = "Product details") @RequestBody ProductRequest request) {
        ProductResponse createdProduct = productService.createProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduct);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update a product", description = "Update an existing product")
    public ResponseEntity<ProductResponse> updateProduct(
            @Parameter(description = "Product ID") @PathVariable Long id,
            @Parameter(description = "Updated product details") @RequestBody ProductRequest request) {
        Optional<ProductResponse> updatedProduct = productService.updateProduct(id, request);
        return updatedProduct.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a product", description = "Delete a product by its ID")
    public ResponseEntity<Void> deleteProduct(
            @Parameter(description = "Product ID") @PathVariable Long id) {
        boolean deleted = productService.deleteProduct(id);
        return deleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    @GetMapping("/category/{category}")
    @Operation(summary = "Get products by category", description = "Retrieve products filtered by category")
    public ResponseEntity<List<ProductResponse>> getProductsByCategory(
            @Parameter(description = "Product category") @PathVariable String category) {
        List<ProductResponse> products = productService.getProductsByCategory(category);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/search")
    @Operation(summary = "Search products by name", description = "Search products by name (case-insensitive)")
    public ResponseEntity<List<ProductResponse>> searchProductsByName(
            @Parameter(description = "Search term") @RequestParam String name) {
        List<ProductResponse> products = productService.searchProductsByName(name);
        return ResponseEntity.ok(products);
    }

    // New endpoint to demonstrate secret usage
    @GetMapping("/secrets/info")
    @Operation(summary = "Get secret information", description = "Demonstrate OpenBao secret usage (for testing only)")
    public ResponseEntity<Map<String, Object>> getSecretInfo() {
        Map<String, Object> secretInfo = new HashMap<>();
        secretInfo.put("jwtSecretLength", jwtSecret.length());
        secretInfo.put("jwtSecretPreview", jwtSecret.substring(0, Math.min(10, jwtSecret.length())) + "...");
        secretInfo.put("premiumFeaturesEnabled", enablePremiumFeatures);
        secretInfo.put("serviceSecretInfo", productService.getSecretInfo());
        return ResponseEntity.ok(secretInfo);
    }
} 