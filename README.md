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

 Após subir o projeto Rails pelo método de sua escolha, baixe o arquivo da collection `goldencloud.json` disponível na raiz do projeto e importe para o Postman, então execute os requests apontando para `localhost:3000`.

- Endpoints:

	`POST http://localhost:3000/debts/import`
	
	Envie o arquivo csv através do Postman, definindo o tipo do body como "form-data", com uma key do tipo "File" e fazendo o upload do arquivo do seu computador para o value. 

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
