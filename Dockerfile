FROM kimai/kimai2:apache

# Copy your custom branding (logos, css, favicon etc.)
COPY public/ /opt/kimai/public/

# Enable Apache rewrite (needed for Symfony routes)
RUN a2enmod rewrite

# Expose port 80 (Railway routes automatically)
EXPOSE 80
