FROM php:8.2-apache

# تعطيل جميع وحدات MPM
RUN a2dismod mpm_event 2>/dev/null || true && \
    a2dismod mpm_worker 2>/dev/null || true && \
    a2dismod mpm_prefork 2>/dev/null || true && \
    a2enmod mpm_prefork

# تثبيت إضافات قاعدة البيانات
RUN docker-php-ext-install mysqli pdo pdo_mysql

# نسخ ملفات المشروع
COPY . /var/www/html/

# ضبط الصلاحيات
RUN chown -R www-data:www-data /var/www/html

# إصلاح أذونات ملفات Apache
RUN chmod -R 755 /var/www/html

EXPOSE 80
