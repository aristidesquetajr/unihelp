# UNIHELP — Instruções para OpenCode

## Build & Run
- `mvn clean package` → produz `target/UNIHELP.war`
- Docker: `docker build -t unihelp .`
- Variáveis de ambiente para BD: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`
  - Defaults: localhost:3306, db_unihelp, root, sem password
- SSL: local (`useSSL=false`), remoto (`useSSL=true`) — muda automaticamente em `ConexaoBD.java:38-55`
- Container Tomcat 10.1, exposto na porta 8080

## Arquitectura
- **MVC puro**: `controller/` (Servlets `@WebServlet`) → `dao/` (JDBC raw) → MySQL
- **Views** em `/WEB-INF/views/` (protegidas de acesso directo)
- **Filtro** `FiltroAutenticacao` (`/*`): rotas públicas = `/`, `/login`, `/logout`, `/assets/*`, `/erro/*`; resto por role
- **Roles**: `/estudante/*` → ESTUDANTE, `/funcionario/*` → FUNCIONARIO, `/admin/*` → ADMIN
- **Sem connection pooling** — cada DAO abre/fecha `ConexaoBD.getConexao()`
- **CDI** declarado (`beans.xml`) mas **não usado** — DAOs instanciados com `new` manualmente nos Servlets
- **DTOs** em `dto/` para queries com JOIN; modelos em `model/` para tabelas individuais
- Timezone: `Africa/Luanda`; locale: `pt-AO`
- Passwords: MySQL `MD5()` (fraco — não alterar sem acordo explícito)

## Convenções
- Código, comentários e UI em **português**
- Sem Lombok, sem ORM — JDBC puro com `PreparedStatement` + `mapRow(ResultSet)` manual
- Servlets fazem `forward` para JSP no `doGet`; `redirect` ou `forward` com erro no `doPost`
- `SELECT` e `INSERT` multi-tabela transaccional em `EstudanteDAO.java`, `FuncionarioDAO.java`

## Funcionalidades no UI sem backend
Links existentes nas JSPs que redireccionam para servlets/menus **não implementados**:
- `admin/`: disciplinas, periodos, turmas, utilizadores, inscricoes, registar-funcionario
- `funcionario/`: estudantes (lista/pesquisa), lancar-nota

## Testes
- Nenhum framework configurado. Sem cobertura.
