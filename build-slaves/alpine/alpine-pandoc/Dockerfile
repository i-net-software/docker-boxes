# Use the official Pandoc image as base
FROM pandoc/latex:latest

# Install system dependencies for WeasyPrint and Pillow with WebP support
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-setuptools \
    py3-wheel \
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
    # Build deps for Pillow with WebP
    build-base \
    python3-dev \
    zlib-dev \
    jpeg-dev \
    freetype-dev \
    harfbuzz-dev \
    cairo-dev \
    pango-dev \
    gdk-pixbuf-dev \
    libwebp \
    libwebp-dev

# Create a virtual environment for Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Pillow from source (with WebP support) + WeasyPrint
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir --no-binary :all: Pillow \
 && pip install --no-cache-dir WeasyPrint

ENV PILLOW_ONLY=1

# Verify installation
RUN weasyprint --version \
 && python3 -c "from PIL import features; print('WebP support:', features.check('webp'))"
