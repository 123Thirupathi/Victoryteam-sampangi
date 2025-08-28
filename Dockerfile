FROM php:8.2-apache

# Install required system packages
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libpq-dev curl \
    && docker-php-ext-install pdo pdo_pgsql intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first
COPY composer.json composer.lock ./

# Install dependencies (production mode)
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Copy the rest of the project
COPY . .

# Permissions
RUN chown -R www-data:www-data var

# Run migrations then start Apache
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
