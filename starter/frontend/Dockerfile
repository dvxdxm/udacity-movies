# Specify a base image
FROM node:14 as build-stage

# Set a working directory
WORKDIR /app

# Copy package.json and package-lock.json before other files
# Utilize Docker cache to save re-installing dependencies if unchanged
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the "public" and "src" directories and other necessary files
COPY  /public  /public
COPY src/ src/
COPY .env ./

# Build the project
ARG REACT_APP_MOVIE_API_URL
RUN ls -al /app/public/

RUN npm run build
