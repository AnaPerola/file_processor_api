# File Processor API

Uma API RESTful desenvolvida em Ruby on Rails para processamento de arquivos de dados de pedidos com suporte a filtros e apenas no formato txt.

## 🚀 Características

- **Filtros Avançados**: Filtro por IDs de pedidos e intervalos de data
- **Arquitetura Limpa**: Implementa padrões de design como Service Objects
- **Extensível**: Fácil adição de novos tipos de parser
- **Bem Testado**: Cobertura completa de testes com RSpec

## 📋 Pré-requisitos

- Ruby 3.1.0+
- Rails 7.0+
- Docker e Docker Compose (opcional)

## 🛠️ Instalação

Escolha uma das duas opções abaixo:

### Opção 1: Setup Local (Tradicional)

```bash
# Clone o repositório
git clone <repository-url>
cd file_processor_api

# Execute o setup automático
bin/setup

# Inicie o servidor
rails server
```

### Opção 2: Docker Compose

```bash
# Clone o repositório
git clone <repository-url>
cd file_processor_api

# Crie o arquivo .env (ou use bin/setup)
cp .env.template .env

# Build e execute os containers
docker-compose up --build
```

## 🧪 Testes

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/services/
bundle exec rspec spec/controller/

# Com documentação
bundle exec rspec --format documentation
```
