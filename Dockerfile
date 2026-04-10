# Etapa 1: Construcción
FROM node:18-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# --- AÑADIR ESTAS DOS LÍNEAS ---
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
# -------------------------------

RUN npm run build

# Etapa 2: Servidor Web Ligero
FROM nginx:alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
