FROM kimai/kimai2:apache

# Document root
ENV APACHE_DOCUMENT_ROOT=/opt/kimai/public
ENV TRUSTED_PROXIES=127.0.0.1,REMOTE_ADDR

# Render's PORT env variable
ENV PORT=8080

# Update apache to listen on $PORT instead of 80
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/sites-available/000-default.conf && \
    sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf

EXPOSE 8080

CMD ["apache2-foreground"]
