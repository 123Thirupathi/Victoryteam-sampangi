FROM php:8.2-apache

# Required extensions for Kimai
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql intl

# Set working directory
WORKDIR /var/www/html

# Copy project files into container
COPY . .

# Permissions
RUN chown -R www-data:www-data var

# Run migrations before Apache starts
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
