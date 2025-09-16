# Use the official Pandoc image as base
FROM pandoc/latex:latest

# Install Python, pip, and WeasyPrint dependencies using apk (Alpine Linux)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-setuptools \
    py3-wheel \
    py3-weasyprint \
    pango \
    cairo \
    gdk-pixbuf \
    libffi-dev \
    shared-mime-info \
    font-noto \
    font-noto-cjk \
    font-noto-emoji \
    font-dejavu \
    font-liberation \
    libwebp \
    libwebp-dev \
    freetype \
    harfbuzz

# Verify WeasyPrint installation
RUN weasyprint --version
