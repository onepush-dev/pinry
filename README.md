# Pinry on Railway

[Pinry](https://github.com/pinry/pinry) (BSD-2-Clause): a self-hosted Pinterest-style image board to save, tag and share images. Deploy it on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/92HfsJ)

## What this template runs
- **pinry**: `ghcr.io/onepush-dev/pinry:2.1.14`, the official `getpinry/pinry:2.1.14` image (application unmodified). nginx on port 8080 + gunicorn. One volume at `/data` holds the SQLite database, uploaded images and `local_settings.py` (with the generated `SECRET_KEY`).

On first boot a wrapper step creates the admin user `admin` with the password from `PINRY_ADMIN_PASSWORD` and closes public sign-up (`ALLOW_NEW_REGISTRATIONS = False`), so nobody else can claim the instance.

## After deploy
Open the Railway URL, log in as `admin` with the `PINRY_ADMIN_PASSWORD` variable, then change the password under your profile. Edit `/data/local_settings.py` to change settings such as `PUBLIC`.

Not affiliated with Pinry.
