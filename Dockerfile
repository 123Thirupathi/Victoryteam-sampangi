FROM php:8.2-apache

# Install required packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev libpq-dev libzip-dev unzip git curl \
    libxml2-dev libxslt1-dev libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl pdo pdo_pgsql zip gd xsl \
    && docker-php-ext-enable intl gd xsl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Increase Composer memory limit
ENV COMPOSER_MEMORY_LIMIT=-1
# Allow composer plugins when running as root (needed for Symfony Flex)
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache rewrite
RUN a2enmod rewrite

# Increase PHP memory limit (custom php.ini)
COPY php.ini /usr/local/etc/php/conf.d/php-memory-limit.ini

WORKDIR /var/www/kimai

# Copy Kimai code
COPY . /var/www/kimai

# Install PHP dependencies (optimized autoloader for production)
RUN composer install --no-dev --optimize-autoloader --classmap-authoritative --no-interaction

# Set proper permissions
RUN chown -R www-data:www-data /var/www/kimai \
    && chmod -R 755 /var/www/kimai/var

# Update Apache DocumentRoot to Kimai's public folder
RUN sed -i 's|/var/www/html|/var/www/kimai/public|g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80

# Run Apache in foreground (production mode)
CMD ["apache2-foreground"]
