# Base image
FROM python:3.9-alpine

# Set working directory
WORKDIR /app

# Copy backend files
COPY flask-python-backend /app

# Install required packages for building Python packages
RUN apk add --no-cache build-base libffi-dev

# Install Python dependencies
COPY flask-python-backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Remove unnecessary packages to reduce image size
RUN apk del build-base libffi-dev

# Install Node.js and NPM
RUN apk add --no-cache nodejs npm
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy frontend files
COPY vue-frontend /app/vue-frontend

# Install Node.js dependencies and build the frontend
RUN cd /app/vue-frontend \
    && npm install \
    && npm run build \
    && rm -rf node_modules

# Set environment variables
ENV FLASK_APP app.py
ENV FLASK_ENV production
ENV FLASK_RUN_HOST 0.0.0.0

# Expose port for Flask
EXPOSE 5000

# Start Flask
CMD ["flask", "run"]
