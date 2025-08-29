FROM php:8.2-apache

# Install required packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libicu-dev libpq-dev libzip-dev unzip git curl \
    libxml2-dev libxslt1-dev libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl pdo pdo_pgsql zip gd xsl \
    && docker-php-ext-enable intl gd xsl

# Increase Composer memory limit
ENV COMPOSER_MEMORY_LIMIT=-1

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/kimai

# Copy Kimai code
COPY . /var/www/kimai

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader


# Update Apache DocumentRoot to Kimai's public folder
RUN sed -i 's|/var/www/html|/var/www/kimai/public|g' /etc/apache2/sites-available/000-default.conf \
    && chown -R www-data:www-data /var/www/kimai

EXPOSE 80
