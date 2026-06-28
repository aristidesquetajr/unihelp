(function () {
    'use strict';

    var overlay = document.getElementById('modalFiltros');
    var btnAbrir = document.getElementById('btnAbrirFiltros');
    var btnFechar = document.getElementById('btnFecharFiltros');
    var btnCancelar = document.getElementById('btnCancelarFiltros');

    function abrir() {
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
})();
