FROM kimai/kimai2:apache

ENV APACHE_DOCUMENT_ROOT=/opt/kimai/public
ENV TRUSTED_PROXIES=127.0.0.1,REMOTE_ADDR

# Railway lo VOLUME support ledu 🚫 (so skip)
# VOLUME [ "/opt/kimai/var" ]

EXPOSE 8080

CMD ["apache2-foreground"]
