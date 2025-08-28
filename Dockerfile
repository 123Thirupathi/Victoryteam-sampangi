FROM kimai/kimai2:apache

# Set document root
ENV APACHE_DOCUMENT_ROOT=/opt/kimai/public
ENV TRUSTED_PROXIES=127.0.0.1,REMOTE_ADDR
ENV PORT=8080

# Update Apache configs to use correct root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable Apache modules needed by Kimai
RUN a2enmod rewrite headers env dir mime

# Permissions fix: www-data user should own files
RUN chown -R www-data:www-data /opt/kimai/var /opt/kimai/public

# Expose Render port
EXPOSE 8080

# Start Apache
CMD php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration && apache2-foreground
