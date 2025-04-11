# Step 1: Use the official Python image from Docker Hub
FROM python:3.9-slim

# Step 2: Install required system dependencies (e.g., distutils)
RUN apt-get update && apt-get install -y \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*  # Clean up apt cache

# Step 3: Set the working directory inside the container
WORKDIR /app

# Step 4: Copy the requirements.txt (or similar) and install dependencies
COPY . .

# Step 5: Copy the rest of the application code into the container
RUN pip install --no-cache-dir -r requirements.txt       
# Step 6: Run database migrations
RUN python manage.py migrate

# Step 7: Collect static files for Django (use --noinput instead of -y)
RUN python manage.py collectstatic --noinput

# Step 8: Expose the application port
EXPOSE 8000

# Step 9: Set environment variables (to prevent buffering in logs)
ENV PYTHONUNBUFFERED 1

# Step 10: Run the Django development server (in production, use Gunicorn instead)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
