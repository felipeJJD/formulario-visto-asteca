# Estágio de compilação
FROM node:16-alpine as build

WORKDIR /app

# Copiar arquivos de configuração
COPY package*.json ./

# Instalar dependências
RUN npm ci

# Copiar código fonte
COPY . .

# Compilar aplicação
RUN npm run build

# Estágio de produção
FROM node:16-alpine

WORKDIR /app

# Copiar arquivos necessários do estágio de build
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./
COPY --from=build /app/server.js ./

# Instalar apenas dependências de produção
RUN npm ci --only=production

# Expor porta usada pela aplicação
EXPOSE 8080

# Configurar variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=8080

# Comando para iniciar a aplicação
CMD ["node", "server.js"]
