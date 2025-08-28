FROM kimai/kimai2:apache

# Document root
ENV APACHE_DOCUMENT_ROOT=/opt/kimai/public
ENV TRUSTED_PROXIES=127.0.0.1,REMOTE_ADDR

# Render PORT use cheyali (dynamic ga set avuthundi)
ENV PORT=8080

# Apache ki Render port attach cheyadam
RUN echo "Listen ${PORT}" > /etc/apache2/ports.conf

# Railway/Rander PORT use cheyali
EXPOSE 8080

# Start Apache
CMD ["apache2-foreground"]
