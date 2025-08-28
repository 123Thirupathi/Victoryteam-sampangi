FROM php:8.2-apache

# 1. Install OS packages and PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libpq-dev curl \
    && docker-php-ext-install pdo pdo_pgsql intl

# 2. Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 3. Set working directory
WORKDIR /var/www/html

# 4. Copy Composer config and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-interaction --no-dev --optimize-autoloader

# 5. Copy rest of the project
COPY . .

# 6. Fix file permissions
RUN chown -R www-data:www-data var

# 7. Run migrations before Apache starts
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
