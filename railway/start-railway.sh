#!/bin/bash
# Railway wrapper for Pinry: closes public sign-up, trusts the Railway HTTPS domain for CSRF,
# and creates the instance admin from PINRY_ADMIN_PASSWORD on first boot. Then runs upstream's start.sh.
set -e
export DJANGO_SETTINGS_MODULE=pinry.settings.docker
bash /pinry/docker/scripts/bootstrap.sh
S=/data/local_settings.py
if ! grep -q "railway-wrapper" "$S"; then
  sed -i 's/^ALLOW_NEW_REGISTRATIONS = True/ALLOW_NEW_REGISTRATIONS = False/' "$S"
  cat >> "$S" <<'PY'

# --- railway-wrapper ---
import os as _os
_domain = _os.environ.get("RAILWAY_PUBLIC_DOMAIN", "")
CSRF_TRUSTED_ORIGINS = (["https://" + _domain] if _domain else []) + [o for o in _os.environ.get("PINRY_EXTRA_ORIGINS", "").split(",") if o]
USE_X_FORWARDED_HOST = True
PY
fi
# keep the domain list current if the domain changes
if grep -q "railway-wrapper" "$S"; then
  cp "$S" /pinry/pinry/settings/local_settings.py
fi
cd /pinry
python manage.py migrate --noinput
python manage.py shell <<'PY'
import os
from django.contrib.auth import get_user_model
U = get_user_model()
pw = os.environ.get("PINRY_ADMIN_PASSWORD")
if pw and not U.objects.exists():
    name = os.environ.get("PINRY_ADMIN_USERNAME", "admin")
    U.objects.create_superuser(username=name, email=os.environ.get("PINRY_ADMIN_EMAIL", "admin@example.com"), password=pw)
    print("[railway] created Pinry admin user '%s' from PINRY_ADMIN_PASSWORD (first boot)" % name)
PY
exec /pinry/docker/scripts/start.sh
