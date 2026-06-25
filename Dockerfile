FROM php:8.2-apache

# mpm_prefork محمل بالفعل في Base Image
# لا نحمّله مرة أخرى - فقط نتأكد من تعطيل mpm_event و mpm_worker
RUN a2dismod mpm_event mpm_worker

# تثبيت إضافات قاعدة البيانات
RUN docker-php-ext-install mysqli pdo pdo_mysql

# نسخ ملفات المشروع
COPY . /var/www/html/

# ضبط الصلاحيات
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80
