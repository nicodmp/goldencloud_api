## Dividas-API

Este projeto é uma API desenvolvida em Ruby on Rails, conectada a um banco PostgreSQL, que importa registros de dívida a partir de um arquivo csv, aceita baixas de dívidas individuais via webhook, e agenda envio de emails para lembrete de dívidas em aberto.

### 🚀 Pré-requisitos

- Docker (no Linux, necessita de usuário não-root com acesso ao grupo docker: https://docs.docker.com/engine/install/linux-postinstall/)

- VS Code com extensão Dev Containers (https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) ou outro editor de texto com suporte a Dev Containers.

- (Opcional) Ruby 3.4.5 + Ruby on Rails 8.0.2 + Postgres configurados localmente, para executar localmente sem Docker.


### 🐳 Executando com Docker

Ao abrir o VS Code na pasta raiz do projeto com a extensão Dev Containers instalada, o editor irá sugerir reabrir a pasta em um dev container. Clique no botão "Reopen in Container" e o container será criado e executado, instalando todas as dependências necessárias.

Então, basta executar `rails s` no terminal da sessão do Docker para subir a aplicação.

### Acessando a API

 Após subir o projeto Rails pelo método de sua escolha, baixe o arquivo da collection `goldencloud.postman_collection.json` disponível na raiz do projeto e importe para o Postman, então execute os requests apontando para `localhost:3000`.

### Endpoints:

`POST http://localhost:3000/debts/import`
	
Envie o arquivo csv através do Postman, definindo o tipo do body como "form-data", com uma key do tipo "File" e fazendo o upload do arquivo do seu computador para o value. Um arquivo CSV com 100000 linhas leva cerca de 10 segundos para ser processado.

- Exemplo de resposta:

```
{
	"imported_count": 100000,
	"errors": []
}
```



`POST http://localhost:3000/debts/pay`
   
   - Exemplo de request:
```
{
	"debtId": "debt-1-1903",
	"paidAt": "2025-07-19 10:00:00",
	"paidAmount": 2261.57,
	"paidBy": "Fulano"
}
```


- Exemplo de resposta:

```
{
	"imported_count": 100000,
	"errors": []
}
```

`GET http://localhost:3000/debts`
	
Retorna uma lista de debts. É possível filtrar por params usando o debt_id, por exemplo, `http://localhost:3000/debts?debt_id=debt-1-1234`

- Exemplo de resposta:

```
[
    {
        "id": 1,
        "name": "Cliente 1",
        "government_id": "11111111112",
        "debt_amount": "2261.57",
        "created_at": "2025-07-23T04:10:27.003Z",
        "updated_at": "2025-07-23T04:10:27.003Z",
        "paid_status": false,
        "paid_at": null,
        "paid_by": null,
        "email": "cliente1@seeyu.com.br",
        "debt_id": "debt-1-1093",
        "debt_due_date": "2025-08-08"
    },
    {
        "id": 2,
        "name": "Cliente 2",
        "government_id": "11111111113",
        "debt_amount": "1653.73",
        "created_at": "2025-07-23T04:10:27.003Z",
        "updated_at": "2025-07-23T04:10:27.003Z",
        "paid_status": false,
        "paid_at": null,
        "paid_by": null,
        "email": "cliente2@seeyu.com.br",
        "debt_id": "debt-2-975",
        "debt_due_date": "2026-04-05"
    }
]
```

`GET http://localhost:3000/debts`
	
Retorna uma lista de debts. É possível filtrar por params usando o debt_id, por exemplo, `http://localhost:3000/debts?debt_id=debt-1-1234`

- Exemplo de resposta:

```
[
    {
        "id": 1,
        "name": "Cliente 1",
        "government_id": "11111111112",
        "debt_amount": "2261.57",
        "created_at": "2025-07-23T04:10:27.003Z",
        "updated_at": "2025-07-23T04:10:27.003Z",
        "paid_status": false,
        "paid_at": null,
        "paid_by": null,
        "email": "cliente1@seeyu.com.br",
        "debt_id": "debt-1-1093",
        "debt_due_date": "2025-08-08"
    },
    {
        "id": 2,
        "name": "Cliente 2",
        "government_id": "11111111113",
        "debt_amount": "1653.73",
        "created_at": "2025-07-23T04:10:27.003Z",
        "updated_at": "2025-07-23T04:10:27.003Z",
        "paid_status": false,
        "paid_at": null,
        "paid_by": null,
        "email": "cliente2@seeyu.com.br",
        "debt_id": "debt-2-975",
        "debt_due_date": "2026-04-05"
    }
]
```

`GET http://localhost:3000/debts/:id`
	
Retorna um único debt por id.

- Exemplo de resposta:

```
{
    "id": 1,
    "name": "Cliente 1",
    "government_id": "11111111112",
    "debt_amount": "2261.57",
    "created_at": "2025-07-23T04:10:27.003Z",
    "updated_at": "2025-07-23T04:10:27.003Z",
    "paid_status": false,
    "paid_at": null,
    "paid_by": null,
    "email": "cliente1@seeyu.com.br",
    "debt_id": "debt-1-1093",
    "debt_due_date": "2025-08-08"
}
```