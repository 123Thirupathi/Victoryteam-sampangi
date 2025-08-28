FROM php:8.2-apache

# Enable Apache mods
RUN a2enmod rewrite headers

# Install dependencies (added libicu-dev for intl)
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libxml2-dev libxslt-dev libpq-dev libicu-dev \
    && docker-php-ext-install pdo pdo_pgsql zip gd xsl intl \
    && docker-php-ext-enable gd xsl intl

# Install Composer
COPY composer.json composer.lock ./
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Copy project files
COPY . .

# Set working dir
WORKDIR /var/www/html

# Run migrations before Apache starts
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
