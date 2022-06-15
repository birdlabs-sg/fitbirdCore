FROM node:lts

# Sets the working directory to the root directory
WORKDIR /

# Copy all the host files
COPY package.json package-lock.json ./
COPY ./dist/ .
COPY ./prisma/ .

# Install dependencies
RUN npm install
RUN npx prisma generate

#Expose port 8080
EXPOSE 8080

CMD npm run prod