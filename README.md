
Para iniciar o banco de dados rode o comando com o docker instalado
```bash
cd db
docker-compose up -d
```
Para criar as tabelas no banco de dados configure o arquivo `db/schema.prisma` na propriedade url, colocando o `usuario:senha@servidor:porta/nome_database`

```prisma
datasource db {
  provider = "mysql"
  url      = "mysql://root:123456@localhost:3306/dart_backend"
}
```
Após a configuração rode em seu terminal

! Para instalação do prisma acesse https://www.prisma.io/
```bash
prisma db pull
```

Configure o `.env` com suas credenciais
```.env
host=localhost
port=3306
user=root
password=123456
db=dart_backend
```

Para executar o serviço basta rodar 
```
dart run bin/backend.dart 
```

Para ler a documentação da API acesse `http://localhost:8080/swagger/`d

Para compilar o serviço no docker basta rodar 
```bash
 docker build -t backend-dart .
 docker run --rm -p 8080:8080 -v /C/projetos/dart/backend/.env-prod:/.env backend-dart
``` 

Ou para compilar o serviço pelo bash
```bash
dart pub get --offline
dart compile exe bin/backend.dart -o bin/server
./bin/server
```