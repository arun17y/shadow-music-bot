FROM python:3.11-slim

# Prevent Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1

# Install system dependencies: ffmpeg, libopus, git, curl, unzip, deno
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libopus0 \
    libopus-dev \
    curl \
    git \
    unzip \
    && curl -fsSL -o /tmp/deno.zip "https://github.com/denoland/deno/releases/latest/download/deno-x86_64-unknown-linux-gnu.zip" \
    && unzip /tmp/deno.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/deno \
    && curl -L -o /usr/local/bin/bgutil-pot "https://github.com/jim60105/bgutil-ytdlp-pot-provider-rs/releases/download/v0.8.1/bgutil-pot-linux-x86_64" \
    && chmod +x /usr/local/bin/bgutil-pot \
    && mkdir -p /etc/yt-dlp/plugins /root/.yt-dlp/plugins \
    && curl -L -o /tmp/plugin.zip "https://github.com/jim60105/bgutil-ytdlp-pot-provider-rs/releases/download/v0.8.1/bgutil-ytdlp-pot-provider-rs.zip" \
    && unzip /tmp/plugin.zip -d /etc/yt-dlp/plugins/ \
    && unzip /tmp/plugin.zip -d /root/.yt-dlp/plugins/ \
    && rm -f /tmp/plugin.zip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose Render web health port
EXPOSE 3005 10000

# Run the bot
CMD ["python", "bot.py"]
