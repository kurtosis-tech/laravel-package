FROM php:8.1-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV user="foo"
ENV uid="1000"
# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip 

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Create system user to run Composer and Artisan Commands
# RUN useradd -G www-data,root -u $uid -d /home/$user $user
# RUN mkdir -p /home/$user/.composer && \
#     chown -R $user:$user /home/$user


# Set working directory
WORKDIR /var/www

#USER $user
# RUN ls -l
# RUN rm -rf vendor composer.lock
COPY . /var/www
# RUN composer install
# RUN php artisan key:generate

# RUN chmod -R 777 /var/www/storage
# RUN chown -R www-data:www-data /var/www/storage
# RUN chmod -R guo+w storage
# RUN php artisan cache:clear

#CMD bash -c "chmod -R guo+w storage && php-fpm"
CMD bash -c "composer install && php artisan key:generate && chmod -R guo+w storage && php artisan migrate && php-fpm"