# 1. Specify the base image
FROM node:18-alpine

# 2. Set the working directory
WORKDIR /reddit-clone

# 3. Copy and install dependencies
COPY package*.json ./
RUN npm install

# 4. Copy the rest of the application code
COPY . .

# 5. Build the application (if necessary for production)
RUN npm run build

# 6. Expose the port
EXPOSE 3000

# 7. Define the command to run the application
CMD ["npm", "run", "start", "--", "-H", "0.0.0.0", "-p", "3000"]
~                                                                  
