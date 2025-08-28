# Base PHP image
FROM php:8.2-cli

# Install dependencies for PHP
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libzip-dev libpng-dev libxml2-dev libonig-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# 7. Allow Symfony/Flex plugins + install PHP dependencies
RUN composer config allow-plugins.symfony/flex true \
    && composer config allow-plugins.symfony/runtime true \
    && COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --no-dev --optimize-autoloader

# Expose port
EXPOSE 8000

# Run Symfony app
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
