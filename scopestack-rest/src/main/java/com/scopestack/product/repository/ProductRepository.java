package com.scopestack.product.repository;

import com.scopestack.product.model.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for Product entities.
 * Provides standard CRUD operations and custom query methods.
 */
@Repository
public interface ProductRepository extends JpaRepository<ProductEntity, Long> {
} 