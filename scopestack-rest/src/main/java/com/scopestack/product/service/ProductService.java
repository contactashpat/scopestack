package com.scopestack.product.service;

import com.scopestack.common.dto.ProductRequest;
import com.scopestack.common.dto.ProductResponse;
import com.scopestack.product.model.ProductEntity;
import com.scopestack.product.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Service layer for Product business logic.
 * Handles CRUD operations, business rules, and data transformation.
 */
@Service
public class ProductService {
    
    private final ProductRepository productRepository;
    
    @Autowired
    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
    
    /**
     * Get all products with pagination
     */
    public Page<ProductResponse> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable)
                .map(this::convertToResponse);
    }
    
    /**
     * Get product by ID
     */
    public Optional<ProductResponse> getProductById(Long id) {
        return productRepository.findById(id)
                .map(this::convertToResponse);
    }
    
    /**
     * Create a new product
     */
    public ProductResponse createProduct(ProductRequest request) {
        ProductEntity entity = new ProductEntity(
                request.getName(),
                request.getDescription(),
                request.getPrice(),
                request.getCategory()
        );
        ProductEntity saved = productRepository.save(entity);
        return convertToResponse(saved);
    }
    
    /**
     * Update product
     */
    public Optional<ProductResponse> updateProduct(Long id, ProductRequest request) {
        return productRepository.findById(id)
                .map(entity -> {
                    entity.setName(request.getName());
                    entity.setDescription(request.getDescription());
                    entity.setPrice(request.getPrice());
                    entity.setCategory(request.getCategory());
                    ProductEntity saved = productRepository.save(entity);
                    return convertToResponse(saved);
                });
    }
    
    /**
     * Delete product
     */
    public boolean deleteProduct(Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }
    
    private ProductResponse convertToResponse(ProductEntity entity) {
        return new ProductResponse(
                entity.getId(),
                entity.getName(),
                entity.getDescription(),
                entity.getPrice(),
                entity.getCategory(),
                entity.getCreatedAt(),
                entity.getUpdatedAt()
        );
    }
} 