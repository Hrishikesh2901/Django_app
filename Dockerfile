FROM python:3.8

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
# 1. WhiteNoise install ensure karo (agar requirements mein nahi hai)
RUN pip install whitenoise 

COPY . .

# 2. DESIGN FIX: Isse design files collect ho jayengi
RUN python manage.py collectstatic --noinput

EXPOSE 8000

# Gunicorn setup perfect hai!
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "demo.wsgi:application"]