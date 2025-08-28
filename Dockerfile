# 1. Base image (official PHP with Apache)
FROM php:8.2-apache

# 2. Enable Apache Rewrite
RUN a2enmod rewrite

# 3. Install required system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libxml2-dev libxslt-dev libpq-dev libicu-dev \
    && docker-php-ext-install pdo pdo_pgsql zip gd xsl intl \
    && docker-php-ext-enable gd xsl intl

# 4. Set working directory
WORKDIR /var/www/html

# 5. Copy project files
COPY . .

# 6. Install Composer (latest version)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 7. Allow Symfony/Flex plugins + install PHP dependencies
RUN composer config --no-plugins allow-plugins.symfony/flex true \
    && composer config --no-plugins allow-plugins.symfony/runtime true \
    && composer install --no-interaction --no-dev --optimize-autoloader

# 8. Run DB migrations automatically before starting Apache
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
