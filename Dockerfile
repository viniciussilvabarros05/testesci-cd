#Definindo versão da imagem node que deseja usar no container
FROM node:18 AS build

#Definindo diretorio 
WORKDIR /usr/src/app

#Copiando package.json na interface para o container
COPY package*.json ./
RUN npm install

#Copiando tudo na interface para o container
COPY . . 

RUN npm run build
RUN npm install workspaces focus --production && npm cache clean --force
FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD [ "npm", "run", "start:prod" ]