package com.scopestack.product.config;

import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Configuration;

/**
 * Configures an additional HTTP connector for redirecting to HTTPS.
 */
@Configuration
public class TomcatHttpConnectorConfig implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    @Value("${server.http.port:8080}")
    private int httpPort;

    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        Connector connector = new Connector(TomcatServletWebServerFactory.DEFAULT_PROTOCOL);
        connector.setPort(httpPort);
        factory.addAdditionalTomcatConnectors(connector);
    }
} 