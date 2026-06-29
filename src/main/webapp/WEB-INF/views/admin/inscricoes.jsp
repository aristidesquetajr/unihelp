<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gerir Inscrições — Admin | UNIHELP</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/modal.css">
    </head>
    <body>
        <div class="sidebar-overlay" onclick="toggleSidebar()"></div>

        <div class="wrapper">
            <aside class="sidebar" id="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-logo">UH</div>
                    <div class="brand-text">
                        <strong>UNIHELP</strong>
                    </div>
                </div>

                <nav class="sidebar-nav">
                    <span class="nav-section-label">Painel</span>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"            class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <span class="nav-section-label">Utilizadores</span>
                    <a href="${pageContext.request.contextPath}/admin/utilizadores"         class="sidebar-link"><i class="bi bi-people"></i> Gerir Utilizadores</a>
                    <a href="${pageContext.request.contextPath}/admin/registar-funcionario" class="sidebar-link"><i class="bi bi-person-badge"></i> Registar Funcionário</a>
                    <span class="nav-section-label">Estrutura Académica</span>
                    <a href="${pageContext.request.contextPath}/admin/cursos"               class="sidebar-link"><i class="bi bi-mortarboard"></i> Cursos</a>
                    <a href="${pageContext.request.contextPath}/admin/disciplinas"          class="sidebar-link"><i class="bi bi-book"></i> Disciplinas</a>
                    <a href="${pageContext.request.contextPath}/admin/turmas"               class="sidebar-link"><i class="bi bi-collection"></i> Turmas</a>
                    <a href="${pageContext.request.contextPath}/admin/periodos"             class="sidebar-link"><i class="bi bi-calendar3"></i> Períodos Letivos</a>
                    <a href="${pageContext.request.contextPath}/admin/inscricoes"           class="sidebar-link active"><i class="bi bi-journal-check"></i> Inscrições</a>
                </nav>
            </aside>

            <div class="main-content">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <div>
                            <div class="page-title">Gerir Inscrições</div>
                            <div class="page-subtitle">Inscrever estudantes em turmas</div>
                        </div>
                    </div>
                    <div class="topbar-user">
                        <i class="bi bi-person-circle"></i>
                        <span>${sessionScope.utilizadorLogado.nome}</span>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="btn btn-outline btn-sm"
                           data-confirm="Deseja terminar a sessão?">
                            <i class="bi bi-box-arrow-right"></i>
                        </a>
                    </div>
                </header>

                <main class="page-content">
                    <c:if test="${not empty mensagem}">
                        <c:choose>
                            <c:when test="${mensagem.startsWith('Erro') || mensagem.startsWith('Não')}">
                                <div class="alert alert-danger" data-dismiss>
                                    <i class="bi bi-exclamation-circle-fill"></i><div>${mensagem}</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success" data-dismiss>
                                    <i class="bi bi-check-circle-fill"></i><div>${mensagem}</div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <div style="display:grid;grid-template-columns:1fr;gap:1.25rem;align-items:start">

                        <!-- Lista -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="bi bi-journal-check" style="margin-right:.4rem"></i>Inscrições
                                    <c:if test="${not empty param.periodoId or not empty param.estado or not empty param.cursoId or not empty param.nomeEstudante or not empty param.numeroEstudante}">
                                        <span class="tag-filtro"><i class="bi bi-funnel"></i> Filtro activo</span>
                                    </c:if>
                                </h3>
                                <span class="tag">${not empty totalInscricoes ? totalInscricoes : 0} registo(s)</span>
                                <div style="display:flex;gap:.6rem">
                                    <button type="button" id="btnAbrirFiltros" class="btn btn-primary btn-md" style="gap:.4rem">
                                        <i class="bi bi-funnel"></i> Filtrar
                                    </button>
                                    <button type="button" id="btnNovaInscricao" class="btn btn-primary btn-md" style="gap:.4rem">
                                        <i class="bi bi-plus-circle"></i> Nova Inscrição
                                    </button>
                                </div>
                            </div>
                            <div class="table-wrap">
                                <table class="uni-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Estudante</th>
                                            <th>Turma</th>
                                            <th>Período</th>
                                            <th style="text-align:center">Estado</th>
                                            <th style="text-align:center">Acções</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty inscricoes}">
                                                <tr>
                                                    <td colspan="6">
                                                        <div class="empty-state">
                                                            <i class="bi bi-journal-x"></i>
                                                            <h3>Sem inscrições</h3>
                                                            <p>Nenhuma inscrição encontrada. Use o formulário para inscrever um estudante.</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="i" items="${inscricoes}" varStatus="s">
                                                    <tr>
                                                        <td class="muted">${s.count}</td>
                                                        <td><strong>${i.nomeEstudante}</strong><br><span class="muted" style="font-size:.78rem">${i.numeroEstudante}</span></td>
                                                        <td class="muted">${not empty i.nomeTurma ? i.nomeTurma : '—'}</td>
                                                        <td class="muted">${not empty i.nomePeriodo ? i.nomePeriodo : '—'}</td>
                                                        <td style="text-align:center">
                                                            <c:choose>
                                                                <c:when test="${i.estado == 'ACTIVO'}">
                                                                    <span class="badge badge-success">Activo</span>
                                                                </c:when>
                                                                <c:when test="${i.estado == 'CONCLUIDO'}">
                                                                    <span class="badge badge-primary">Concluído</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-warning">Trancado</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                                <form action="${pageContext.request.contextPath}/admin/inscricoes" method="post" style="display:inline">
                                                                    <input type="hidden" name="acao" value="alterar_estado">
                                                                    <input type="hidden" name="id" value="${i.id}">
                                                                    <select name="novoEstado" class="form-control" style="max-width:130px;display:inline-block"
                                                                            onchange="this.form.submit()" title="Alterar estado">
                                                                        <option value="">Estado…</option>
                                                                        <option value="ACTIVO">Activo</option>
                                                                        <option value="CONCLUIDO">Concluído</option>
                                                                        <option value="TRANCADO">Trancado</option>
                                                                    </select>
                                                                </form>
                                                                <form action="${pageContext.request.contextPath}/admin/inscricoes" method="post" style="display:inline">
                                                                    <input type="hidden" name="acao" value="eliminar">
                                                                    <input type="hidden" name="id" value="${i.id}">
                                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar"
                                                                            data-confirm="Eliminar a inscrição de ${i.nomeEstudante}?">
                                                                        <i class="bi bi-trash"></i>
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>

                    <!-- Modal de Filtros -->
                    <div class="modal-overlay" id="modalFiltros">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="bi bi-funnel"></i> Filtrar Inscrições</h3>
                                <button type="button" class="modal-close" id="btnFecharFiltros">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/inscricoes" method="get">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label" for="filtroNome">Nome do Estudante</label>
                                        <input type="text" id="filtroNome" name="nomeEstudante" class="form-control"
                                               placeholder="Pesquisar por nome…" maxlength="80"
                                               value="${param.nomeEstudante}">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroNumero">Número do Estudante</label>
                                        <input type="text" id="filtroNumero" name="numeroEstudante" class="form-control"
                                               placeholder="Ex: 2023001" maxlength="20"
                                               value="${param.numeroEstudante}">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroCurso">Curso</label>
                                        <select id="filtroCurso" name="cursoId" class="form-control">
                                            <option value="">Todos os cursos</option>
                                            <c:forEach var="c" items="${cursos}">
                                                <option value="${c.id}" ${param.cursoId eq c.id ? 'selected' : ''}>${c.nome}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroPeriodo">Período Letivo</label>
                                        <select id="filtroPeriodo" name="periodoId" class="form-control">
                                            <option value="">Todos os períodos</option>
                                            <c:forEach var="p" items="${periodos}">
                                                <option value="${p.id}" ${param.periodoId eq p.id ? 'selected' : ''}>${p.nomeFormatado}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filtroEstado">Estado</label>
                                        <select id="filtroEstado" name="estado" class="form-control">
                                            <option value="">Todos os estados</option>
                                            <option value="ACTIVO"    ${param.estado eq 'ACTIVO'    ? 'selected' : ''}>Activo</option>
                                            <option value="CONCLUIDO" ${param.estado eq 'CONCLUIDO' ? 'selected' : ''}>Concluído</option>
                                            <option value="TRANCADO"  ${param.estado eq 'TRANCADO'  ? 'selected' : ''}>Trancado</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" onclick="window.location='${pageContext.request.contextPath}/admin/inscricoes'">
                                        <i class="bi bi-x-circle"></i> Limpar Filtros
                                    </button>
                                    <button type="button" class="btn btn-outline" id="btnCancelarFiltros">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-search"></i> Aplicar Filtros
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Modal de Nova Inscrição -->
                    <div class="modal-overlay" id="modalNovaInscricao">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="bi bi-plus-circle"></i> Nova Inscrição</h3>
                                <button type="button" class="modal-close" id="btnFecharNovaInscricao">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/inscricoes" method="post">
                                <input type="hidden" name="acao" value="inscrever">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label" for="periodoId">Período Letivo <span class="req">*</span></label>
                                        <select id="periodoId" name="periodoId" class="form-control" required>
                                            <option value="">— Seleccione o período —</option>
                                            <c:forEach var="p" items="${periodos}">
                                                <option value="${p.id}">${p.nomeFormatado}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="turmaId">Turma <span class="req">*</span></label>
                                        <select id="turmaId" name="turmaId" class="form-control" required>
                                            <option value="">— Seleccione a turma —</option>
                                            <c:forEach var="t" items="${turmas}">
                                                <option value="${t.id}" data-periodo="${t.idPeriodoLetivo}">${t.nome} — ${t.nomeCurso}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="estudanteInput">Estudante <span class="req">*</span></label>
                                        <input type="search" id="estudanteInput" list="estudantesList" class="form-control"
                                               placeholder="Pesquisar estudante por nome ou número…" required autocomplete="off"
                                               oninput="selecionarEstudante(this)">
                                        <input type="hidden" name="estudanteId" id="estudanteHidden">
                                        <datalist id="estudantesList">
                                            <c:forEach var="e" items="${estudantes}">
                                                <option value="${e.nome} — ${e.numeroEstudante}" data-id="${e.id}">
                                            </c:forEach>
                                        </datalist>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" id="btnCancelarNovaInscricao">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> Inscrever Estudante
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/scripts/unihelp.js"></script>
        <script src="${pageContext.request.contextPath}/assets/scripts/modal.js"></script>
        <script>
            (function () {
                'use strict';

                // --- Modal ---
                var overlay = document.getElementById('modalNovaInscricao');
                var btnAbrir = document.getElementById('btnNovaInscricao');
                var btnFechar = document.getElementById('btnFecharNovaInscricao');
                var btnCancelar = document.getElementById('btnCancelarNovaInscricao');

                function abrir() {
                    var form = document.getElementById('modalNovaInscricao').querySelector('form');
                    if (form) {
                        form.reset();
                        document.getElementById('estudanteHidden').value = '';
                        if (typeof filtrarTurmas === 'function') filtrarTurmas();
                    }
                    overlay.classList.add('open');
                    document.body.style.overflow = 'hidden';
                }

                function fechar() {
                    overlay.classList.remove('open');
                    document.body.style.overflow = '';
                }

                if (btnAbrir) btnAbrir.addEventListener('click', abrir);
                if (btnFechar) btnFechar.addEventListener('click', fechar);
                if (btnCancelar) btnCancelar.addEventListener('click', fechar);

                overlay.addEventListener('click', function (e) {
                    if (e.target === overlay) fechar();
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && overlay.classList.contains('open')) fechar();
                });

                // --- Filtrar turmas por período ---
                var periodoSelect = document.getElementById('periodoId');
                var turmaSelect = document.getElementById('turmaId');
                var turmaOptions = Array.prototype.slice.call(turmaSelect.options);

                function filtrarTurmas() {
                    var periodoId = periodoSelect.value;
                    turmaSelect.innerHTML = '<option value="">— Seleccione a turma —</option>';
                    for (var i = 1; i < turmaOptions.length; i++) {
                        var opt = turmaOptions[i];
                        if (!periodoId || opt.getAttribute('data-periodo') === periodoId) {
                            turmaSelect.appendChild(opt.cloneNode(true));
                        }
                    }
                    turmaSelect.disabled = turmaSelect.options.length === 1;
                }

                if (periodoSelect) {
                    periodoSelect.addEventListener('change', filtrarTurmas);
                    filtrarTurmas();
                }

                // --- Selecção de estudante ---
                window.selecionarEstudante = function (input) {
                    var list = document.getElementById('estudantesList');
                    var hidden = document.getElementById('estudanteHidden');
                    var val = input.value.trim();
                    if (!val) { hidden.value = ''; return; }
                    for (var i = 0; i < list.options.length; i++) {
                        if (list.options[i].value === val) {
                            hidden.value = list.options[i].getAttribute('data-id');
                            return;
                        }
                    }
                    hidden.value = '';
                };
            })();
        </script>
    </body>
</html>
