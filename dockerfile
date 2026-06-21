#from-Despacho
# ---------- Etapa 1: Build ----------
FROM node:20-alpine AS build
WORKDIR /app

# Copiamos package.json primero para cachear las dependencias
COPY package*.json ./
RUN npm install

# Copiamos el resto del código y generamos el build de producción
COPY . .
RUN npm run build

# ---------- Etapa 2: Runtime (servidor estático con nginx) ----------
FROM nginx:alpine

# Configuración personalizada de nginx (soporte SPA / React Router)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiamos los archivos estáticos generados por Vite
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]