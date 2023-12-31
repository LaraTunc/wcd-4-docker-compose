FROM node:16-alpine
# Example modification to invalidate cache (add a dummy command)
RUN echo 'Forcing cache invalidatiozsdfdsfsn'
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH


# install app dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn install 

# add app
COPY . .

# start app
CMD ["yarn", "start"]

EXPOSE 3000