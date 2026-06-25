FROM php:8.2-apache

# تعطيل وحدات MPM المتعارضة قبل تفعيل واحدة فقط
RUN a2dismod mpm_event mpm_worker mpm_prefork && \
    a2enmod mpm_prefork

# تثبيت إضافات قاعدة البيانات
RUN docker-php-ext-install mysqli pdo pdo_mysql

# نسخ ملفات المشروع
COPY . /var/www/html/

# ضبط الصلاحيات (لتجنب مشاكل الوصول للملفات)
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
