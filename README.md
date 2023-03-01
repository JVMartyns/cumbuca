# Cumbuca

Desafios de Contratação Cumbuca Backend

- [Documentação do desafio](desafio-back-end.md)

API de conta bancária:

- [Documentação da API](https://documenter.getpostman.com/view/20194093/2s935rKNiR) disponível no Gigalixir.

### Como executar a aplicação localmente:

Requisitos:

- [Docker](https://docs.docker.com/get-docker/) - versão 23.0 ou superior
- [Docker Compose](https://docs.docker.com/compose/) - versão 2.15 ou superior

Criar o arquivo `.env`

```
cp .env-sample .env
```

Sobre o arquivo `.env`

- TOKEN_SALT - Chave secreta usada pelo algorítimo gerador de Token. Deve ser uma string encriptada em base_64
- TOKEN_TTL - Determina o tempo de expiração do token em `segundos`. Deve ser um número inteiro.
- CRYPTO_SECRET - Chave secreta usada pelo algorítimo de encritação. Deve ser um binário de tamanho 16 encriptado em base_64.

Exemplo de CRYPTO_SECRET:

```elixir
iex(1)> bynary = :crypto.strong_rand_bytes(16)
<<171, 227, 62, 87, 54, 205, 190, 182, 124, 73, 196, 29, 30, 119, 252, 221>>
iex(2)> Base.encode64(bynary)
"q+M+VzbNvrZ8ScQdHnf83Q=="
```

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
