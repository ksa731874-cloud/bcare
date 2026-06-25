FROM php:8.2-fpm

# تثبيت nginx و Supervisord
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مجلد www
RUN mkdir -p /var/www/html

# نسخ ملفات المشروع
COPY . /var/www/html/

# ضبط الصلاحيات
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# إنشاء مجلد للـ socket
RUN mkdir -p /run/php && chmod 755 /run/php

# إعدادات PHP-FPM - إيقاف chroot وإعدادات أخرى
RUN echo "[www]" >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo "listen = 9000" >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo "listen.mode = 0660" >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo "user = www-data" >> /usr/local/etc/php-fpm.d/zz-docker.conf \
    && echo "group = www-data" >> /usr/local/etc/php-fpm.d/zz-docker.conf

# إنشاء ملف إعدادات nginx
COPY nginx.conf /etc/nginx/nginx.conf

# إنشاء ملف إعدادات supervisord في المكان الصحيح
COPY supervisord_root.conf /etc/supervisord.conf

# إنشاء مجلد logs
RUN mkdir -p /var/log/supervisor

# فتح المنفذ
EXPOSE 80

# بدء الخدمات مع تحديد مسار ملف الإعداد
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
