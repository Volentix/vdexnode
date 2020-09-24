FROM python:3.6

WORKDIR "/gateway"

COPY requirements.txt ./

COPY .  /gateway

RUN pip install --no-cache-dir -r requirements.txt \
    && mv docker-entrypoint.sh /usr/local/bin/ \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]


