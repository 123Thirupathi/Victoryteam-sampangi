FROM php:8.2-apache

# Install required packages
RUN apt-get update && apt-get install -y \
    libicu-dev libpq-dev libzip-dev unzip git curl \
    && docker-php-ext-install intl pdo pdo_pgsql zip \
    && docker-php-ext-enable intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/kimai

# Copy Kimai code
COPY . /var/www/kimai

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Apache config update (DocumentRoot = public/)
RUN sed -i 's|/var/www/html|/var/www/kimai/public|g' /etc/apache2/sites-available/000-default.conf \
    && chown -R www-data:www-data /var/www/kimai

EXPOSE 80
