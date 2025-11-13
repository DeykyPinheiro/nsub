# language: pt
Funcionalidade: Registro de usuário
  Como um novo usuário
  Quero me registrar na plataforma
  Para poder acessar o sistema

  Cenário: Registro bem-sucedido com dados válidos
    Quando eu envio uma requisição POST para "/api/auth/register" com o payload:
      """
      {
        "username": "joao.silva",
        "email": "joao.silva@example.com",
        "password": "Senha@123",
        "fullName": "João Silva"
      }
      """
    Então a resposta deve ter status 201
    E o corpo da resposta deve conter:
      | campo   | valor                      |
      | message | Usuário registrado com sucesso |
    E o campo "userId" deve existir

  Cenário: Falha ao registrar com email duplicado
    Dado que existe um usuário com email "maria@example.com"
    Quando eu envio uma requisição POST para "/api/auth/register" com o payload:
      """
      {
        "username": "maria.santos",
        "email": "maria@example.com",
        "password": "Senha@456",
        "fullName": "Maria Santos"
      }
      """
    Então a resposta deve ter status 409
    E o corpo da resposta deve conter o campo "error" com valor "Email já cadastrado"

  Cenário: Falha ao registrar com senha fraca
    Quando eu envio uma requisição POST para "/api/auth/register" com o payload:
      """
      {
        "username": "pedro.costa",
        "email": "pedro@example.com",
        "password": "123",
        "fullName": "Pedro Costa"
      }
      """
    Então a resposta deve ter status 400
    E o corpo da resposta deve conter o campo "error"

  Esquema do Cenário: Validação de campos obrigatórios
    Quando eu envio uma requisição POST para "/api/auth/register" com o payload:
      """
      {
        "username": "<username>",
        "email": "<email>",
        "password": "<password>",
        "fullName": "<fullName>"
      }
      """
    Então a resposta deve ter status 400

    Exemplos:
      | username    | email              | password   | fullName    |
      |             | test@example.com   | Senha@123  | Test User   |
      | testuser    |                    | Senha@123  | Test User   |
      | testuser    | test@example.com   |            | Test User   |
      | testuser    | test@example.com   | Senha@123  |             |