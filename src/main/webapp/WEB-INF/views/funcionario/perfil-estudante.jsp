<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt-AO">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Perfil do Estudante — Funcionário | UNIHELP</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/unihelp.css">
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
                    <a href="${pageContext.request.contextPath}/funcionario/lancar-nota"        class="sidebar-link"><i class="bi bi-pencil-square"></i> Lançar Nota</a>
                </nav>
            </aside>

            <div class="main-content">
                <header class="topbar">
                    <div class="topbar-left">
                        <button class="btn-sidebar-toggle" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <div>
                            <div class="page-title">Perfil do Estudante</div>
                            <div class="page-subtitle">
                                <c:if test="${not empty estudante}">${estudante.nome}</c:if>
                            </div>
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

                    <c:choose>
                        <c:when test="${empty estudante}">
                            <div class="card">
                                <div class="card-body">
                                    <div class="empty-state">
                                        <i class="bi bi-person-x"></i>
                                        <h3>Estudante não encontrado</h3>
                                        <p>O estudante solicitado não existe no sistema.</p>
                                        <a href="${pageContext.request.contextPath}/funcionario/estudantes"
                                           class="btn btn-primary mt-2">
                                            <i class="bi bi-arrow-left"></i> Voltar
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:when>

                        <c:otherwise>

                            <!-- Cabeçalho do perfil + acções -->
                            <div class="card mb-2">
                                <div class="card-body">
                                    <div class="perfil-header-bar">
                                        <div class="profile-head">
                                            <div class="avatar-lg">${estudante.nome.substring(0,1).toUpperCase()}</div>
                                            <div>
                                                <div class="fw-7 profile-name">${estudante.nome}</div>
                                                <div class="muted text-sm">${not empty estudante.numeroEstudante ? estudante.numeroEstudante : ''}</div>
                                                <div class="mt-1">
                                                    <c:choose>
                                                        <c:when test="${estudante.status == 'ACTIVO'}">
                                                            <span class="badge badge-success"><i class="bi bi-circle-fill badge-dot"></i> Activo</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger"><i class="bi bi-circle-fill badge-dot"></i> Bloqueado</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${not empty estudante.estadoInscricao}">
                                                        <c:choose>
                                                            <c:when test="${estudante.estadoInscricao == 'ACTIVO'}">
                                                                <span class="badge badge-success gap-1"><i class="bi bi-check-circle"></i> Inscrição Activa</span>
                                                            </c:when>
                                                            <c:when test="${estudante.estadoInscricao == 'CONCLUIDO'}">
                                                                <span class="badge badge-primary gap-1"><i class="bi bi-check2-all"></i> Curso Concluído</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-warning gap-1"><i class="bi bi-lock"></i> Matrícula Trancada</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                    <c:if test="${not empty estudante.nomeCurso}">
                                                        <span class="badge badge-primary gap-1">
                                                            <i class="bi bi-mortarboard"></i> ${estudante.nomeCurso}
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="action-bar">
                                            <a href="${pageContext.request.contextPath}/funcionario/estudantes"
                                               class="btn btn-outline btn-sm">
                                                <i class="bi bi-arrow-left"></i> Voltar
                                            </a>
                                            <a href="${pageContext.request.contextPath}/funcionario/lancar-nota?estudanteId=${estudante.id}"
                                               class="btn btn-primary btn-sm">
                                                <i class="bi bi-pencil-square"></i> Lançar Nota
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="perfil-grid">

                                <!-- Coluna esquerda: dados pessoais -->
                                <div class="card">
                                    <div class="card-header">
                                        <h3><i class="bi bi-person-vcard"></i>Dados Pessoais</h3>
                                    </div>
                                    <div class="card-body">
                                        <ul class="info-list">
                                            <li><span class="lbl">Email</span><span class="val info-email">${estudante.email}</span></li>
                                            <li><span class="lbl">Telefone(s)</span><span class="val">
                                                <c:choose>
                                                    <c:when test="${not empty estudante.telefones}">
                                                        <c:forEach var="tel" items="${estudante.telefones}" varStatus="st">${tel}${not st.last ? ', ' : ''}</c:forEach>
                                                    </c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </span></li>
                                            <li><span class="lbl">Curso</span><span class="val">${not empty estudante.nomeCurso ? estudante.nomeCurso : '—'}</span></li>
                                            <li><span class="lbl">Turma</span><span class="val">${not empty estudante.nomeTurma ? estudante.nomeTurma : '—'}</span></li>
                                            <li><span class="lbl">Sala</span><span class="val">${not empty estudante.sala ? estudante.sala : '—'}</span></li>
                                            <li><span class="lbl">Ano Lectivo</span><span class="val">${not empty estudante.nomePeriodo ? estudante.nomePeriodo : '—'}</span></li>
                                            <c:if test="${estudante.anoAcademico > 0}">
                                                <li><span class="lbl">Ano Académico</span><span class="val">${estudante.anoAcademico}º Ano</span></li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </div>

                                <!-- Coluna direita: notas + atendimentos -->
                                <div class="right-column">

                                    <!-- Notas -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h3><i class="bi bi-journal-check"></i>Notas</h3>
                                            <span class="tag">${not empty notas ? notas.size() : 0} registo(s)</span>
                                        </div>
                                        <div class="table-wrap">
                                            <table class="uni-table">
                                                <thead>
                                                    <tr>
                                                        <th>Disciplina</th>
                                                        <th>Período</th>
                                                        <th>Tipo</th>
                                                        <th class="text-center">Nota</th>
                                                        <th class="text-center">Resultado</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${empty notas}">
                                                            <tr><td colspan="5">
                                                                    <div class="empty-state compact">
                                                                        <i class="bi bi-journal-x"></i>
                                                                        <h3>Sem notas</h3>
                                                                    </div>
                                                                </td></tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="n" items="${notas}">
                                                                <tr>
                                                                    <td><strong>${n.nomeDisciplina}</strong></td>
                                                                    <td class="muted">${n.nomePeriodo}</td>
                                                                    <td><span class="badge badge-neutral">${n.tipo}</span></td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${n.valor >= 10}">
                                                                                <span class="grade-val grade-pass"><fmt:formatNumber value="${n.valor}" minFractionDigits="0" maxFractionDigits="1"/></span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="grade-val grade-fail"><fmt:formatNumber value="${n.valor}" minFractionDigits="0" maxFractionDigits="1"/></span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${n.valor >= 10}">
                                                                                <span class="badge badge-success">Aprovado</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge badge-danger">Reprovado</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Atendimentos -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h3><i class="bi bi-calendar2-check"></i>Atendimentos</h3>
                                            <span class="tag">${not empty atendimentos ? atendimentos.size() : 0} registo(s)</span>
                                        </div>
                                        <div class="table-wrap">
                                            <table class="uni-table">
                                                <thead>
                                                    <tr>
                                                        <th>Data</th>
                                                        <th>Hora</th>
                                                        <th>Descrição</th>
                                                        <th class="text-center">Estado</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${empty atendimentos}">
                                                            <tr><td colspan="4">
                                                                    <div class="empty-state compact">
                                                                        <i class="bi bi-calendar-x"></i>
                                                                        <h3>Sem atendimentos</h3>
                                                                    </div>
                                                                </td></tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="a" items="${atendimentos}">
                                                                <tr>
                                                                    <td><fmt:formatDate value="${a.dataAgendada}" pattern="dd/MM/yyyy"/></td>
                                                                    <td class="muted"><fmt:formatDate value="${a.dataAgendada}" pattern="HH:mm"/></td>
                                                                    <td class="text-truncate"
                                                                        title="${a.descricao}">${a.descricao}</td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${a.estado == 'CONFIRMADO'}">
                                                                                <span class="badge badge-success">Confirmado</span>
                                                                            </c:when>
                                                                            <c:when test="${a.estado == 'PENDENTE'}">
                                                                                <span class="badge badge-warning">Pendente</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge badge-danger">Rejeitado</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                </div><!-- /coluna direita -->
                            </div><!-- /grid -->

                        </c:otherwise>
                    </c:choose>

                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/unihelp.js"></script>
    </body>
</html>
