# backend/Dockerfile

# Use an official Python runtime as a parent image
FROM python:3.10

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app/backend

# Update package lists and install dependencies
RUN apt-get update && \
    apt-get install -y \
    gdal-bin \
    libgdal-dev

# Optionally set the GDAL_LIBRARY_PATH if needed
ENV GDAL_LIBRARY_PATH = '/usr/lib/x86_64-linux-gnu/libgdal.so'

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Copy the pyproject.toml and poetry.lock files
COPY pyproject.toml poetry.lock ./

# Install Python dependencies
RUN poetry config virtualenvs.create false && poetry install --no-root

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 8000
