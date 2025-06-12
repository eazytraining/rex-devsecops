# Étape 1 : Build de l'application
FROM node:20-alpine AS builder

WORKDIR /app

# Copie les fichiers nécessaires pour installer les dépendances ET builder
COPY package*.json ./
COPY tsconfig*.json ./
COPY vite.config.* ./

RUN npm install

# Copie le reste du code source pour le build
COPY . .

ARG VITE_API_URL 
ENV VITE_API_URL=${VITE_API_URL}
# Build l'app (TypeScript + Vite)
RUN npm run build

# Étape 2 : Image finale ultra-légère (serveur statique)
FROM nginx:alpine AS production

# Copie le build Vite (par défaut dans /app/dist) vers le dossier statique Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copie une config Nginx si besoin (optionnel)
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
