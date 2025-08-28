# 1. Use official PHP Apache image
FROM php:8.2-apache

# 2. Enable Apache mods
RUN a2enmod rewrite headers

# 3. Install required system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libxml2-dev libxslt-dev libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql zip gd xsl intl \
    && docker-php-ext-enable gd xsl

# 4. Copy Composer config and install dependencies
COPY composer.json composer.lock ./
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-dev --optimize-autoloader

# 5. Copy rest of the project
COPY . .

# 6. Set working directory
WORKDIR /var/www/html

# 7. Run migrations before starting Apache
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
