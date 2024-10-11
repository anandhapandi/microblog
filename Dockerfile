FROM python:slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    gcc \
    python3-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get remove --purge -y gcc python3-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir gunicorn pymysql cryptography

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./
RUN chmod a+x boot.sh

ENV FLASK_APP microblog.py

RUN flask translate compile

EXPOSE 5000


ENTRYPOINT ["./boot.sh"]

