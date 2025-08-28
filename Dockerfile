FROM php:8.2-apache

# 1. Install required system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libxml2-dev libxslt-dev \
    && docker-php-ext-install pdo pdo_pgsql zip gd xsl intl \
    && docker-php-ext-enable gd xsl

# 2. Enable Apache mod_rewrite
RUN a2enmod rewrite

# 3. Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 4. Set workdir
WORKDIR /var/www/html

# 5. Copy composer config
COPY composer.json composer.lock ./

# 6. Install PHP dependencies
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --no-dev --optimize-autoloader

# 7. Copy the rest of the app
COPY . .

# 8. Run migrations + start Apache
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
