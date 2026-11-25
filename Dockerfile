# Pinry on Railway: the official getpinry/pinry:2.1.14 image (BSD-2-Clause), application unmodified.
# Railway layer: closes public sign-up, trusts the Railway domain for CSRF and creates the admin user
# from PINRY_ADMIN_PASSWORD on first boot, so nobody else can claim the instance. nginx listens on 80.
FROM getpinry/pinry:2.1.14
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/pinry"
COPY --chmod=755 railway/start-railway.sh /railway-start.sh
# One public listener on 8080 (nginx); gunicorn stays on loopback so Railway's port detection only sees the web port.
RUN sed -i 's/listen 80 default;/listen 8080 default;/' /etc/nginx/sites-enabled/default \
 && sed -i 's/-b 0.0.0.0:8000/-b 127.0.0.1:8000/' /pinry/docker/scripts/_start_gunicorn.sh \
 && grep -n "listen" /etc/nginx/sites-enabled/default && grep -n "127.0.0.1:8000" /pinry/docker/scripts/_start_gunicorn.sh
ENV PINRY_ADMIN_USERNAME=admin \
    PINRY_ADMIN_EMAIL=admin@example.com
CMD ["/railway-start.sh"]
EXPOSE 8080
