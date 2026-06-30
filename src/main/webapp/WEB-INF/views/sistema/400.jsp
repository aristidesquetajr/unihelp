<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="pt-AO">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Requisição Inválida — UNIHELP</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles/error.css">
</head>
<body>
    <div class="error-page error-page-400">
        <div class="error-card">
            <div class="error-icon error-icon-400">
                <i class="bi bi-exclamation-circle"></i>
            </div>
            <div class="error-code">400</div>
            <div class="error-divider error-divider-400"></div>
            <div class="error-title">Requisição Inválida</div>
            <div class="error-desc">
                O pedido não pôde ser processado porque contém parâmetros inválidos.<br>
                Verifique o endereço e tente novamente.
            </div>
            <div class="error-actions">
                <a href="javascript:history.back()" class="btn btn-outline">
                    <i class="bi bi-arrow-left"></i> Voltar
                </a>
                <a href="${pageContext.request.contextPath}" class="btn btn-primary">
                    <i class="bi bi-house"></i> Página Inicial
                </a>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/scripts/error.js"></script>
</body>
</html>
