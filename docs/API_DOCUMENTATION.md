# API Documentation - File Processor API

## Visão Geral

A File Processor API é um serviço RESTful desenvolvido em Ruby on Rails que processa arquivos de dados de pedidos e retorna informações estruturadas agrupadas por usuário.

**Base URL**: `http://localhost:3000/api/v1`

## Endpoints

### POST /orders/process_file

Processa um arquivo de dados de pedidos e retorna os dados estruturados, com opção de aplicar filtros.

#### Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `file` | File | Sim | Arquivo a ser processado (CSV ou largura fixa) |
| `order_ids` | String | Não | IDs de pedidos separados por vírgula (ex: "1,2,3") |
| `start_date` | String | Não | Data inicial do filtro (formato: YYYY-MM-DD) |
| `end_date` | String | Não | Data final do filtro (formato: YYYY-MM-DD) |

#### Exemplo de Requisição

```bash
curl -X POST http://localhost:3000/api/v1/orders/process_file \
  -F "file=@data.txt" \
  -F "order_ids=1,2,3" \
  -F "start_date=2023-01-01" \
  -F "end_date=2023-12-31"
```

#### Exemplo de Resposta (Sucesso)

```json
{
	"message": "File processed successfully",
	"data": [
		{
			"user_id": 75,
			"name": "Bobbie Batz",
			"orders": [
				{
					"order_id": 798,
					"total": "1578.57",
					"date": "2021-11-16",
					"products": [
						{
							"product_id": 2,
							"value": "1578.57"
						}
					]
				}
			]
		},
  ]
}
```

#### Exemplo de Resposta (Erro)

```json
{
  "error": "File parameter is required"
}
```


## Filtros Disponíveis

### Filtro por IDs de Pedido

Filtra apenas os pedidos com IDs especificados:

```bash
curl -X POST http://localhost:3000/api/v1/orders/process_file \
  -F "file=@data.txt" \
  -F "order_ids=1,5,10"
```

### Filtro por Data

Filtra pedidos dentro de um intervalo de datas:

```bash
# Apenas data inicial
curl -X POST http://localhost:3000/api/v1/orders/process_file \
  -F "file=@data.txt" \
  -F "start_date=2023-01-01"

# Apenas data final
curl -X POST http://localhost:3000/api/v1/orders/process_file \
  -F "file=@data.txt" \
  -F "end_date=2023-12-31"

# Intervalo completo
curl -X POST http://localhost:3000/api/v1/orders/process_file \
  -F "file=@data.txt" \
  -F "start_date=2023-01-01" \
  -F "end_date=2023-12-31"
```

### Combinação de Filtros

É possível combinar filtros de ID e data:

```bash
curl -X POST http://localhost:3000/api/v1/orders/process_file \
  -F "file=@data.txt" \
  -F "order_ids=1,2,3" \
  -F "start_date=2023-01-01" \
  -F "end_date=2023-06-30"
```

## Validações

### Arquivo
- Arquivo é obrigatório
- Deve ser um tipo suportado (text/plain)
- Deve conter dados válidos

## Tratamento de Erros

### Erros de Validação (400 Bad Request)

```json
{
  "error": "File parameter is required"
}
```

### Erros Internos (500 Internal Server Error)

```json
{
  "error": "Internal server error while processing file"
}
```

## Exemplos de Uso

### JavaScript (Fetch API)

```javascript
const formData = new FormData();
formData.append('file', fileInput.files[0]);
formData.append('order_ids', '1,2,3');
formData.append('start_date', '2023-01-01');
formData.append('end_date', '2023-12-31');

fetch('http://localhost:3000/api/v1/orders/process_file', {
  method: 'POST',
  body: formData
})
.then(response => response.json())
.then(data => {
  if (data.error) {
    console.error('Erro:', data.error);
  } else {
    console.log('Dados processados:', data.data);
  }
});
```

## Monitoramento e Logs

- Logs de erro são registrados no Rails.logger
- Recomenda-se monitoramento de uso de memória para arquivos grande