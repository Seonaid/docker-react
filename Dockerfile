# This is a two-stage build that makes the production code and then launches nginx
# for migration to production

# Step 1 - building
FROM node:alpine AS builder

WORKDIR '/app'

COPY package.json .
RUN npm install

# unlike in the development environment, we now need to copy over all the dependencies
# because we won't be changing code on the fly
COPY . .

RUN npm run build

# All the files we need at the end will be in /app/build, so we need to copy from that
# during the run phase

# Step 2 - running with nginx FROM statement automatically terminates the earlier block
FROM nginx
EXPOSE 80

# copy from the earlier phase into a static html for nginx to serve. 
# nginx starts up automatically, so no run statement is required

COPY --from=builder /app/build /usr/share/nginx/html      
