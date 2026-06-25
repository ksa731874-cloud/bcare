FROM php:8.2-apache

# إزالة ملفات Apache الافتراضية التي قد تسبب تعارض
RUN rm -f /etc/apache2/mods-enabled/mpm_event.conf \
    /etc/apache2/mods-enabled/mpm_worker.conf \
    /etc/apache2/mods-enabled/mpm_prefork.conf

# تعطيل جميع MPMs
RUN a2dismod mpm_event mpm_worker mpm_prefork

# تفعيل mpm_prefork فقط
RUN a2enmod mpm_prefork

# تثبيت إضافات قاعدة البيانات
RUN docker-php-ext-install mysqli pdo pdo_mysql

# نسخ ملفات المشروع
COPY . /var/www/html/

# ضبط الصلاحيات
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80
