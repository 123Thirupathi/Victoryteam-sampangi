FROM php:8.2-apache

# Required PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev libpq-dev libzip-dev unzip git \
    && docker-php-ext-install intl pdo pdo_pgsql zip \
    && docker-php-ext-enable intl

# Enable Apache rewrite
RUN a2enmod rewrite

# Workdir
WORKDIR /var/www/kimai

# Copy Kimai code
COPY . /var/www/kimai

# Apache config update (point to public/)
RUN sed -i 's|/var/www/html|/var/www/kimai/public|g' /etc/apache2/sites-available/000-default.conf \
    && chown -R www-data:www-data /var/www/kimai

EXPOSE 80
