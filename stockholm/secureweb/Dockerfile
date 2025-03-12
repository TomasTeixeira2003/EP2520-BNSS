FROM debian:bullseye

# Install Apache and mod_auth_openidc
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-auth-openidc \
    && rm -rf /var/lib/apt/lists/*

# Enable necessary Apache modules
RUN a2enmod auth_openidc ssl headers proxy proxy_http rewrite mpm_event

# Copy custom mod_auth_openidc configuration
COPY mod_auth_openidc.conf /etc/apache2/conf-available/mod_auth_openidc.conf

# Enable the OpenID Connect configuration
RUN a2enconf mod_auth_openidc

# Expose HTTP and HTTPS ports
EXPOSE 80 443