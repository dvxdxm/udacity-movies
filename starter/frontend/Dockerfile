FROM  public.ecr.aws/docker/library/node:18.14.2-alpine3.17

ENV REACT_APP_MOVIE_API_URL='a3a279b35d8b344548365b286586a651-474046780.us-east-1.elb.amazonaws.com'

WORKDIR /app

# Copy dependdency files
COPY package*.json ./

# Install packages
RUN npm ci

# Copy code
COPY . .

# Build the app
RUN npm run build

# Expose the port used by the React app
EXPOSE 3000

# Start the React app when the container starts
CMD ["npm", "run", "serve"]