FROM node:16-alpine
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY yarn.lock ./
COPY client/build ./client/build
RUN yarn 
RUN yarn global add react-scripts@4.0.3 

# add app
COPY . .

# start app
CMD ["yarn", "start"]

EXPOSE 3000