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

# إعدادات PHP-FPM (البحث عن php.ini وتعديله)
RUN find /usr -name "php.ini" 2>/dev/null | head -1 | xargs sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' 2>/dev/null || true

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
