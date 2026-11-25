# Pinry on Railway: the official getpinry/pinry:2.1.14 image (BSD-2-Clause), application unmodified.
# Railway layer: closes public sign-up, trusts the Railway domain for CSRF and creates the admin user
# from PINRY_ADMIN_PASSWORD on first boot, so nobody else can claim the instance. nginx listens on 80.
FROM getpinry/pinry:2.1.14
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/pinry"
COPY --chmod=755 railway/start-railway.sh /railway-start.sh
ENV PINRY_ADMIN_USERNAME=admin \
    PINRY_ADMIN_EMAIL=admin@example.com
CMD ["/railway-start.sh"]
