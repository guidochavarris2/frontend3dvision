# Etapa 1: Construcción de la aplicación
FROM node:16-alpine AS build

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia el archivo package.json y package-lock.json (si existe)
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Establece la variable de entorno
#ENV NODE_OPTIONS=--openssl-legacy-provider

# Copia el resto del código
COPY . .

# Construye la aplicación para producción
RUN npm run build

# Etapa 2: Servidor Nginx para servir los archivos estáticos
FROM nginx:alpine

# Copia los archivos generados en la etapa de construcción
COPY --from=build /app/build /usr/share/nginx/html

# Expon el puerto 80 para el contenedor
EXPOSE 80

# Comando para ejecutar Nginx
CMD ["nginx", "-g", "daemon off;"]
