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

# إعدادات PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /usr/local/etc/php/php.ini

# إنشاء ملف إعدادات nginx
COPY nginx.conf /etc/nginx/nginx.conf

# إنشاء ملف إعدادات supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# إنشاء مجلد logs
RUN mkdir -p /var/log/supervisor

# فتح المنفذ
EXPOSE 80

# بدء الخدمات
CMD ["/usr/bin/supervisord", "-n"]
