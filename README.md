# E-commerce

API para gerenciamento do um carrinho de compras de e-commerce desenvolvida em Ruby e Rails

## Informações técnicas

### Dependências
- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15

### Como executar o projeto

## Executando a app com o docker
Dado que todas as as ferramentas estão instaladas e configuradas:

Para gerar containers:
```bash
docker-compose build
```

Para iniciar os containers:
```bash
docker-compose up
```

Para rodar os testes :
```bash
bundle exec rails server
```

Executar os testes:
```bash
docker-compose exec web bash -c 'RAILS_ENV=test bundle exec rspec'
```

Executar seeds:
```bash
docker-compose exec web bash -c 'bundle exec rails db:seed'
```

## Funcionalidades

### 1. Registrar um produto no carrinho
Endpoint para inserção de produtos no carrinho.

- Se não existir um carrinho para a sessão, é criado o carrinho e salvo o ID do carrinho na sessão.
- Ao adicionar o produto no carrinho é devolvido o payload com a lista de produtos do carrinho atual.


ROTA: `/cart`
Payload:
```js
{
  "product_id": 345,
  "quantity": 2,
}
```

Response
```js
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96
}
```

### 2. Listar itens do carrinho atual
Endpoint para listar os produtos no carrinho atual.

ROTA: `/cart`

Response:
```js
{
  "id": 789,
  "products": [
    {
      "id": 645,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
    {
      "id": 646,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96
}
```

### 3. Alterar a quantidade de produtos no carrinho
Um carrinho pode ter _N_ produtos, se o produto já existir no carrinho, apenas a quantidade dele é alterada.

ROTA: `/cart/add_item`

Payload
```json
{
  "product_id": 1230,
  "quantity": 1
}
```
Response:
```json
{
  "id": 1,
  "products": [
    {
      "id": 1230,
      "name": "Nome do produto X",
      "quantity": 2,
      "unit_price": 7.00,
      "total_price": 14.00,
    },
    {
      "id": 01020,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90,
      "total_price": 9.90,
    },
  ],
  "total_price": 23.9
}
```

### 3. Remover um produto do carrinho

Endpoint para excluir um produto do do carrinho.

ROTA: `/cart/:product_id`


#### Implementaçoes adicionais:

- Verifica se o produto existe no carrinho antes de tentar removê-lo.
- Se o produto não estiver no carrinho, retorna uma mensagem de erro apropriada.
- Após remover o produto, retorna o payload com a lista atualizada de produtos no carrinho.
- Certifica-se de que o endpoint lida corretamente com casos em que o carrinho está vazio após a remoção do produto.
- Garante que um produto não possa ter quantidade negativa.

### 5. Exclui carrinhos abandonados
Um carrinho é considerado abandonado quando estiver sem interação (adição ou remoção de produtos) há mais de 3 horas.

- Quando este cenário ocorre, o carrinho é marcado como abandonado.
- Se o carrinho estiver abandonado há mais de 7 dias, remove o carrinho.
- Utiliza um Job para gerenciar (marcar como abandonado e remover) carrinhos sem interação.
- Job é executado nos períodos especificados acima.
