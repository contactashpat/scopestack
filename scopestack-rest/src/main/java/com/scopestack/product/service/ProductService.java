package com.scopestack.product.service;

import com.scopestack.common.dto.ProductRequest;
import com.scopestack.common.dto.ProductResponse;
import com.scopestack.product.model.ProductEntity;
import com.scopestack.product.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    // Using OpenBao secret in service layer
    @Value("${jwt-secret:default-secret}")
    private String jwtSecret;

    // Using another secret for business logic
    @Value("${app.feature-flags.enable-premium-features:false}")
    private boolean enablePremiumFeatures;

    public List<ProductResponse> getAllProducts() {
        List<ProductEntity> products = productRepository.findAll();
        return products.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public Page<ProductResponse> getProductsWithPagination(int page, int size, String sortBy) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy));
        Page<ProductEntity> products = productRepository.findAll(pageable);
        return products.map(this::convertToResponse);
    }

    public Optional<ProductResponse> getProductById(Long id) {
        return productRepository.findById(id)
                .map(this::convertToResponse);
    }

    public ProductResponse createProduct(ProductRequest request) {
        ProductEntity product = new ProductEntity(
                request.getName(),
                request.getDescription(),
                request.getPrice(),
                request.getCategory()
        );

        // Use secret in business logic
        if (enablePremiumFeatures) {
            System.out.println("Premium features enabled with secret: " + jwtSecret.substring(0, 10) + "...");
        }

        ProductEntity savedProduct = productRepository.save(product);
        return convertToResponse(savedProduct);
    }

    public Optional<ProductResponse> updateProduct(Long id, ProductRequest request) {
        return productRepository.findById(id)
                .map(product -> {
                    product.setName(request.getName());
                    product.setDescription(request.getDescription());
                    product.setPrice(request.getPrice());
                    product.setCategory(request.getCategory());
                    return convertToResponse(productRepository.save(product));
                });
    }

    public boolean deleteProduct(Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public List<ProductResponse> getProductsByCategory(String category) {
        // Filter products by category using stream
        List<ProductEntity> products = productRepository.findAll();
        return products.stream()
                .filter(product -> category.equals(product.getCategory()))
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    public List<ProductResponse> searchProductsByName(String name) {
        // Search products by name using stream
        List<ProductEntity> products = productRepository.findAll();
        return products.stream()
                .filter(product -> product.getName().toLowerCase().contains(name.toLowerCase()))
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    private ProductResponse convertToResponse(ProductEntity product) {
        return new ProductResponse(
                product.getId(),
                product.getName(),
                product.getDescription(),
                product.getPrice(),
                product.getCategory(),
                product.getCreatedAt(),
                product.getUpdatedAt()
        );
    }

    // Method to demonstrate secret usage
    public String getSecretInfo() {
        return "JWT Secret length: " + jwtSecret.length() + 
               ", Premium features: " + enablePremiumFeatures;
    }
} 