# Use official PHP image
FROM php:8.2-cli

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Allow Composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER=1

# Copy composer files first for caching
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Copy rest of the project
COPY . .

# Clear Symfony cache
RUN php bin/console cache:clear

# Expose port (if web server needed)
EXPOSE 8000

# Start Symfony server (optional)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
