FROM php:8.2-apache

# إنشاء ملف تكوين MPM مخصص
RUN echo "# Force only mpm_prefork" > /etc/apache2/conf-available/mpm.conf && \
    echo "LoadModule mpm_prefork_module /usr/lib/apache2/modules/mod_mpm_prefork.so" >> /etc/apache2/conf-available/mpm.conf && \
    echo "<IfModule mpm_prefork_module>" >> /etc/apache2/conf-available/mpm.conf && \
    echo "    StartServers             5" >> /etc/apache2/conf-available/mpm.conf && \
    echo "    MinSpareServers          5" >> /etc/apache2/conf-available/mpm.conf && \
    echo "    MaxSpareServers         10" >> /etc/apache2/conf-available/mpm.conf && \
    echo "    MaxRequestWorkers       150" >> /etc/apache2/conf-available/mpm.conf && \
    echo "    MaxConnectionsPerChild   0" >> /etc/apache2/conf-available/mpm.conf && \
    echo "</IfModule>" >> /etc/apache2/conf-available/mpm.conf && \
    a2disconf mpm_event mpm_worker mpm_prefork 2>/dev/null || true && \
    a2enconf mpm.conf

# تعطيل أي تكوين MPM قد يسبب مشاكل
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
         /etc/apache2/mods-enabled/mpm_worker.load \
         /etc/apache2/mods-enabled/mpm_prefork.load \
         /etc/apache2/mods-enabled/mpm_event.conf \
         /etc/apache2/mods-enabled/mpm_worker.conf \
         /etc/apache2/mods-enabled/mpm_prefork.conf 2>/dev/null || true

# تثبيت إضافات قاعدة البيانات
RUN docker-php-ext-install mysqli pdo pdo_mysql

# نسخ ملفات المشروع
COPY . /var/www/html/

# ضبط الصلاحيات
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80
