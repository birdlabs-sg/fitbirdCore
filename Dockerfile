FROM node:lts

# Sets the working directory to the root directory
WORKDIR /

# Copy all the host files
COPY . ./fitbirdCore
WORKDIR /fitbirdCore

# Install dependencies
RUN npm install
RUN npx prisma generate
RUN tsc

#Expose port 8080
EXPOSE 8080

CMD ["/bin/sh", "entrypoint.sh"]