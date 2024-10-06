# 1. Use an official Python runtime as a base image
FROM python:3.12-slim

# 2. Install system dependencies (if needed)
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Set the working directory in the container
WORKDIR /app

# 4. Copy the current directory contents into the container at /app
COPY . /app

# 5. Install any Python dependencies in your project
# First, upgrade pip and then install the dependencies from requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /app/requirements.txt

# 6. Set environment variables for Django
ENV DJANGO_SETTINGS_MODULE=student_management.settings
ENV PYTHONUNBUFFERED=1

# 7. Expose the port on which the Django app will run
EXPOSE 8000

# 8. Collect static files
RUN python manage.py collectstatic --noinput

# 9. Run migrations
RUN python manage.py migrate

# 10. Use Gunicorn to serve the application in production
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi"]
