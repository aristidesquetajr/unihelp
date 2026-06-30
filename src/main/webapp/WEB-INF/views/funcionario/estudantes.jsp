<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lista de Estudantes — Funcionário | UNIHELP</title>
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
                    <span class="nav-section-label">Menu Principal</span>
                    <a href="${pageContext.request.contextPath}/funcionario/dashboard"  class="sidebar-link"><i class="bi bi-speedometer2"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/funcionario/pendentes"  class="sidebar-link"><i class="bi bi-hourglass-split"></i> Atendimentos Pendentes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/agenda"     class="sidebar-link"><i class="bi bi-calendar2-week"></i> Agenda do Dia</a>
                    <span class="nav-section-label">Estudantes</span>
                    <a href="${pageContext.request.contextPath}/funcionario/estudantes"         class="sidebar-link active"><i class="bi bi-people"></i> Lista de Estudantes</a>
                    <a href="${pageContext.request.contextPath}/funcionario/registar-estudante" class="sidebar-link"><i class="bi bi-person-plus"></i> Registar Estudante</a>
                </nav>
            </aside>

            <div class="main-content">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <div>
                            <div class="page-title">Lista de Estudantes</div>
                            <div class="page-subtitle">Pesquisar e consultar estudantes</div>
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

                    <!-- Lista -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-people" style="margin-right:.4rem"></i>Estudantes
                                <c:if test="${not empty param.q or not empty param.cursoId}">
                                    <span class="tag-filtro"><i class="bi bi-funnel"></i> Filtro activo</span>
                                </c:if>
                            </h3>
                            <span class="tag">${not empty totalEstudantes ? totalEstudantes : 0} registo(s)</span>
                            <button type="button" id="btnAbrirFiltros" class="btn btn-primary btn-md" style="gap:.4rem">
                                <i class="bi bi-funnel"></i> Filtrar
                            </button>
                            <button class="btn btn-primary btn-md" style="gap:.4rem" onclick="window.location='${pageContext.request.contextPath}/funcionario/registar-estudante'">
                                <i class="bi bi-person-plus"></i> Registar Estudante
                            </button>
                        </div>
                        <div class="table-wrap">
                            <table class="uni-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>Nº Estudante</th>
                                        <th>Curso</th>
                                        <th>Email</th>
                                        <th style="text-align:center">Estado</th>
                                        <th style="text-align:center">Acções</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty estudantes}">
                                            <tr>
                                                <td colspan="7">
                                                    <div class="empty-state">
                                                        <i class="bi bi-people"></i>
                                                        <h3>Nenhum estudante encontrado</h3>
                                                        <p>
                                                            <c:choose>
                                                                <c:when test="${not empty param.q}">Sem resultados para "<strong>${param.q}</strong>".</c:when>
                                                                <c:otherwise>Ainda não existem estudantes registados.</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="e" items="${estudantes}" varStatus="s">
                                                <tr>
                                                    <td class="muted">${s.count}</td>
                                                    <td><strong>${e.nome}</strong></td>
                                                    <td class="muted">${not empty e.numeroEstudante ? e.numeroEstudante : '—'}</td>
                                                    <td>${not empty e.nomeCurso ? e.nomeCurso : '—'}</td>
                                                    <td class="muted" style="font-size:.82rem">${e.email}</td>
                                                    <td style="text-align:center">
                                                        <c:choose>
                                                            <c:when test="${e.estadoInscricao == 'ACTIVO'}">
                                                                <span class="badge badge-success"><i class="bi bi-circle-fill" style="font-size:.45rem"></i> Activo</span>
                                                            </c:when>
                                                            <c:when test="${e.estadoInscricao == 'CONCLUIDO'}">
                                                                <span class="badge badge-primary"><i class="bi bi-check-circle-fill" style="font-size:.78rem"></i> Concluído</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-warning"><i class="bi bi-pause-circle-fill" style="font-size:.78rem"></i> Trancado</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="actions" style="display:flex;gap:.78em;justify-content:center">
                                                            <a href="${pageContext.request.contextPath}/funcionario/perfil-estudante?id=${e.id}"
                                                               class="btn btn-outline btn-sm" title="Ver perfil">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                            <button type="button"
                                                                    class="btn btn-outline btn-sm"
                                                                    title="Lançar nota"
                                                                    onclick="abrirModalNota(${e.id})">
                                                                <i class="bi bi-pencil-square"></i>
                                                            </button>
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
                    <!-- Modal de Filtros -->
                    <div class="modal-overlay" id="modalFiltros">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="bi bi-funnel"></i> Filtrar Estudantes</h3>
                                <button type="button" class="modal-close" id="btnFecharFiltros">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/funcionario/estudantes" method="get">
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label" for="filtroQ">Nome ou Nº Estudante</label>
                                        <input type="text" id="filtroQ" name="q" class="form-control"
                                               placeholder="Pesquisar…" maxlength="100"
                                               value="${param.q}">
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
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" onclick="window.location='${pageContext.request.contextPath}/funcionario/estudantes'">
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

                    <!-- Modal de Lançar Nota -->
                    <div class="modal-overlay" id="modalLancarNota">
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="bi bi-pencil-square"></i> Lançar Nota</h3>
                                <button type="button" class="modal-close" id="btnFecharNota">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/funcionario/lancar-nota" method="post">
                                <div class="modal-body">
                                    <input type="hidden" name="estudanteId" id="notaEstudanteId">

                                    <div class="form-group">
                                        <label class="form-label">Estudante <span class="req">*</span></label>
                                        <select id="notaSelectEstudante" class="form-control" disabled>
                                            <option value="">— Seleccione o estudante —</option>
                                            <c:forEach var="e" items="${estudantes}">
                                                <option value="${e.id}">${e.nome}${not empty e.numeroEstudante ? ' — '.concat(e.numeroEstudante) : ''}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="notaDisciplinaId">Disciplina <span class="req">*</span></label>
                                            <select id="notaDisciplinaId" name="disciplinaId" class="form-control" required>
                                                <option value="">— Seleccione —</option>
                                                <c:forEach var="d" items="${disciplinas}">
                                                    <option value="${d.id}">${d.nome}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="notaPeriodoId">Período Letivo <span class="req">*</span></label>
                                            <select id="notaPeriodoId" name="periodoId" class="form-control" required>
                                                <option value="">— Seleccione —</option>
                                                <c:forEach var="p" items="${periodos}">
                                                    <option value="${p.id}">${p.nome}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="notaTipo">Tipo de Avaliação <span class="req">*</span></label>
                                            <select id="notaTipo" name="tipo" class="form-control" required>
                                                <option value="">— Seleccione —</option>
                                                <option value="AVALIACAO">Avaliação Contínua</option>
                                                <option value="P1">Prova 1 (P1)</option>
                                                <option value="P2">Prova 2 (P2)</option>
                                                <option value="EXAME">Exame</option>
                                                <option value="RECURSO">Recurso</option>
                                                <option value="ESPECIAL">Época Especial</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="notaValor">Nota (0 – 20) <span class="req">*</span></label>
                                            <input type="number" id="notaValor" name="valor" class="form-control"
                                                   placeholder="Ex: 14" min="0" max="20" step="0.5" required>
                                            <span class="form-hint">Escala de 0 a 20. Aprovado: ≥ 10.</span>
                                            <span class="form-error" id="erroNotaModal" style="display:none">A nota deve estar entre 0 e 20.</span>
                                        </div>
                                    </div>

                                    <div id="previewNotaModal" style="display:none;margin-bottom:1rem">
                                        <div class="alert" id="previewAlertaModal">
                                            <i class="bi" id="previewIconeModal"></i>
                                            <div id="previewTextoModal"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline" id="btnCancelarNota">
                                        <i class="bi bi-x-circle"></i> Cancelar
                                    </button>
                                    <button type="submit" class="btn btn-primary" onclick="return validarNotaModal()">
                                        <i class="bi bi-save"></i> Lançar Nota
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
            function abrirModalNota(estudanteId) {
                document.getElementById('notaEstudanteId').value = estudanteId;
                document.getElementById('notaSelectEstudante').value = estudanteId;
                initModal('modalLancarNota', { fecharId: 'btnFecharNota', cancelarId: 'btnCancelarNota' });
                document.getElementById('modalLancarNota').classList.add('open');
                document.body.style.overflow = 'hidden';
            }

            document.getElementById('notaValor').addEventListener('input', function () {
                var v = parseFloat(this.value);
                var preview = document.getElementById('previewNotaModal');
                var alerta  = document.getElementById('previewAlertaModal');
                var icone   = document.getElementById('previewIconeModal');
                var texto   = document.getElementById('previewTextoModal');
                if (this.value === '' || isNaN(v)) { preview.style.display = 'none'; return; }
                preview.style.display = 'block';
                if (v >= 10) {
                    alerta.className = 'alert alert-success';
                    icone.className  = 'bi bi-check-circle-fill';
                    texto.innerHTML  = 'Nota <strong>' + v + '</strong> — <strong>Aprovado</strong>';
                } else {
                    alerta.className = 'alert alert-danger';
                    icone.className  = 'bi bi-x-circle-fill';
                    texto.innerHTML  = 'Nota <strong>' + v + '</strong> — <strong>Reprovado</strong>';
                }
            });

            function validarNotaModal() {
                var v = parseFloat(document.getElementById('notaValor').value);
                var err = document.getElementById('erroNotaModal');
                if (isNaN(v) || v < 0 || v > 20) {
                    err.style.display = 'block';
                    return false;
                }
                err.style.display = 'none';
                return true;
            }
        </script>
    </body>
</html>
