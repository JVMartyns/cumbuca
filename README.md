# Cumbuca

Desafios de Contratação Cumbuca Backend

- [Documentação do desafio](https://github.com/appcumbuca/desafios/blob/master/desafio-back-end.md)

API de conta bancária:

- [Documentação da API](https://documenter.getpostman.com/view/20194093/2s935rKNiR) disponível no Gigalixir.

### Como executar a aplicação localmente:

Requisitos:

- [Docker](https://docs.docker.com/get-docker/) - versão 23.0 ou superior
- [Docker Compose](https://docs.docker.com/compose/) - versão 2.15 ou superior

Construir o container

```
make build
```

Criar o banco de dados

```
docker compose run --rm cumbuca mix ecto.create
```

Execute as migrações

```
docker compose run --rm cumbuca mix ecto.migrate
```

Iniciar a aplicação

```
docker compose up
```

A aplicação está executando em [`localhost:4000`](http://localhost:4000)

Você poderá acessar os mesmos endpoints encontrados na [documentação da API](https://documenter.getpostman.com/view/20194093/2s935rKNiR).
