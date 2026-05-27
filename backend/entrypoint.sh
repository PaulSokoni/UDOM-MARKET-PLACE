#!/bin/sh
python manage.py migrate --noinput

# Create superuser if DJANGO_SUPERUSER_PASSWORD is set and no superuser exists
if [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
  python manage.py createsuperuser --noinput \
    --username "${DJANGO_SUPERUSER_USERNAME:-admin}" \
    --email "${DJANGO_SUPERUSER_EMAIL:-admin@udom.ac.tz}" 2>/dev/null || true
fi

exec gunicorn core.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 120
