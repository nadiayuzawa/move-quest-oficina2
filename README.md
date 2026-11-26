# Move Quest — Guia de configuração para desenvolvedores

Este documento apresenta as instruções para desenvolvedores que desejam acessar o ambiente do Move Quest, configurar as credenciais necessárias e executar o backend responsável pela autenticação Google.

## 1. Acessos necessários

Para executar o projeto, o desenvolvedor precisa ter acesso a:

| Serviço | Finalidade |
|---|---|
| GitHub | Obter o código-fonte do projeto |
| Supabase | Acessar as configurações e os serviços de autenticação |
| Google Cloud | Consultar a configuração do OAuth, quando necessário |
| Python | Executar o backend |
| GameMaker | Executar o jogo |

O administrador do projeto deverá conceder os acessos individuais aos desenvolvedores.

## 2. Como acessar o Supabase

1. Acesse https://supabase.com/dashboard.
2. Entre com sua conta autorizada.
3. Localize o projeto Move Quest.
4. Abra o projeto.

### 2.1 Obter a URL e a chave pública

No painel do projeto:

1. Acesse **Project Settings**.
2. Entre em **API Keys**.
3. Localize **Project URL**.
4. Copie o endereço.
5. Localize **Publishable Key**.
6. Copie a chave pública.

Esses valores serão utilizados nas variáveis de ambiente do backend.

### 2.2 Obter a chave secreta

Ainda em **Project Settings → API Keys**:

1. Localize a seção **Secret Keys**.
2. Identifique a chave utilizada pelo backend.
3. Solicite ao administrador a disponibilização segura dessa credencial, caso sua conta não tenha permissão para acessá-la.

**Importante:** a chave secreta não deve ser compartilhada pelo GitHub, incluída no código-fonte ou enviada ao GameMaker. Ela deve ser disponibilizada somente aos desenvolvedores autorizados que realmente precisam executar o backend localmente.

## 3. Configurar o arquivo .env

Na pasta Backend, crie um arquivo chamado `.env`.

Utilize o seguinte modelo:

```env
SUPABASE_URL=https://SEU-PROJETO.supabase.co

SUPABASE_KEY=sb_publishable_SUA_CHAVE

SUPABASE_SECRET_KEY=sb_secret_SUA_CHAVE

BACKEND_URL=http://127.0.0.1:8000
```

Substitua os valores de exemplo pelas credenciais disponibilizadas pelo administrador.

| Variável | Origem |
|---|---|
| SUPABASE_URL | Supabase → Project Settings → API Keys |
| SUPABASE_KEY | Supabase → Publishable Key |
| SUPABASE_SECRET_KEY | Supabase → Secret Keys, mediante autorização |
| BACKEND_URL | Endereço local do backend |

O arquivo `.env` é individual para cada desenvolvedor e não deve ser enviado ao repositório.

## 4. Configuração do Google OAuth

O Google OAuth já está configurado no projeto Supabase.

O desenvolvedor não precisa criar outro aplicativo OAuth nem gerar novas credenciais para executar o projeto.

Caso precise consultar as configurações:

1. Acesse https://console.cloud.google.com/.
2. Entre no projeto Google Cloud do Move Quest.
3. Acesse Google Auth Platform.
4. Consulte a seção Clients para visualizar o cliente OAuth cadastrado, conforme suas permissões.

As credenciais Client ID e Client Secret são administradas pelo responsável pelo projeto e já estão cadastradas no Supabase.

### 4.1 Usuários de teste

Se o aplicativo Google estiver em modo Testing:

1. Acesse Google Auth Platform → Audience.
2. Verifique se o e-mail do desenvolvedor está cadastrado em Test users.
3. Caso não esteja, solicite ao administrador que o adicione.

Sem essa autorização, o login poderá ser bloqueado pelo Google.

## 5. Instalar e executar o backend Python

### 5.1 Pré-requisitos

Instale o Python:

https://www.python.org/downloads/

Recomenda-se utilizar Python 3.11 ou superior.

### 5.2 Abrir a pasta Backend

No VS Code:

1. Abra o projeto Move Quest.
2. Entre na pasta Backend.
3. Abra um terminal integrado.

### 5.3 Criar ambiente virtual

Execute:

```bash
python -m venv venv
```

### 5.4 Ativar ambiente virtual

Windows PowerShell:

```powershell
.\venv\Scripts\Activate.ps1
```

Windows CMD:

```cmd
venv\Scripts\activate
```

### 5.5 Instalar dependências

Execute:

```bash
pip install -r requirements.txt
```

### 5.6 Iniciar o servidor

Execute:

```bash
uvicorn app.main:app --reload
```

Se a inicialização ocorrer corretamente, o backend estará disponível em:

```text
http://127.0.0.1:8000
```

### 5.7 Verificar a API

Acesse pelo navegador:

http://127.0.0.1:8000/docs

A documentação interativa do FastAPI permite consultar os endpoints disponibilizados pelo backend.

### 5.8 Criar as tabelas de progresso

O progresso do jogador (última fase e fases concluídas) fica no Supabase. Uma única vez:

1. Abra o Supabase → **SQL Editor** → **New query**.
2. Cole o conteúdo de `Backend/sql/progress.sql` e clique em **Run**.

| Tabela | Conteúdo |
|---|---|
| `player_progress` | Última fase (`last_level`) de cada jogador |
| `level_progress` | Status de conclusão de cada fase por jogador |

Endpoints (visíveis em `/docs`):

| Método | Rota | Função |
|---|---|---|
| GET | `/progress/{player_id}` | Retorna `last_level` e `completed_levels` |
| POST | `/progress/complete` | Registra a fase concluída (`player_id`, `level`) e atualiza `last_level` |

Se o jogo tiver mais ou menos de 3 fases, ajuste `TOTAL_LEVELS` no `.env`.

## 6. Executar o jogo no GameMaker

Com o backend em execução:

1. Abra o GameMaker.
2. Abra o projeto `moveQuestOficina.yyp`.
3. Verifique se o endereço do backend está configurado como:

```gml
backend_url = "http://127.0.0.1:8000";
```

4. Execute o jogo pelo GameMaker.
5. Acesse a interface de login.
6. Clique em Entrar com Google.
7. O navegador padrão será aberto.
8. Selecione uma conta Google autorizada.
9. Após a autenticação, retorne ao jogo.

O GameMaker consultará o backend para verificar o resultado da autenticação.

## 7. Ordem de execução

Sempre que for desenvolver ou testar a autenticação localmente, siga esta ordem:

| Ordem | Ação |
|---|---|
| 1 | Abrir o VS Code |
| 2 | Acessar a pasta Backend |
| 3 | Ativar o ambiente virtual |
| 4 | Executar o backend Python |
| 5 | Abrir o projeto no GameMaker |
| 6 | Executar o jogo |
| 7 | Testar o login Google |

**Observação:** o backend precisa permanecer em execução enquanto o jogo estiver utilizando os serviços de autenticação locais.

## 8. Problemas comuns

| Problema | Possível solução |
|---|---|
| Erro de conexão com o backend | Verificar se o servidor Python está ativo |
| Erro de credenciais Supabase | Conferir as variáveis do arquivo `.env` |
| Acesso negado pelo Google | Verificar se o e-mail está em Test users |
| Erro de redirect URL | Conferir os endereços autorizados no Supabase |
| Dependência não encontrada | Executar novamente `pip install -r requirements.txt` |
| Porta 8000 ocupada | Verificar se outro processo está utilizando a porta |

## 9. Segurança das credenciais

- Não enviar arquivos `.env` ao GitHub.
- Não compartilhar Secret Keys publicamente.
- Não inserir credenciais administrativas no GameMaker.
- Não publicar o Client Secret do Google.
- Utilizar somente credenciais disponibilizadas pelo administrador.
- Não utilizar a chave secreta de produção em ambientes locais de desenvolvimento.

Cada desenvolvedor deverá possuir suas próprias credenciais e permissões de acesso.

---

**Move Quest — Guia de desenvolvimento**

Backend: Python + FastAPI  
Autenticação: Google OAuth + Supabase Auth  
Banco de dados: Supabase PostgreSQL  
Cliente: GameMaker (Windows)