(function () {
    'use strict';

    function initModal(overlayId, opts) {
        var overlay = document.getElementById(overlayId);
        if (!overlay) return;

        var abrir  = opts && opts.abrirId  ? document.getElementById(opts.abrirId)  : null;
        var fechar = opts && opts.fecharId ? document.getElementById(opts.fecharId) : null;
        var cancelar = opts && opts.cancelarId ? document.getElementById(opts.cancelarId) : null;

        function abrirModal() {
            fecharTodos();
            overlay.classList.add('open');
            document.body.style.overflow = 'hidden';
        }

        function fecharModal() {
            overlay.classList.remove('open');
            document.body.style.overflow = '';
        }

        function fecharTodos() {
            document.querySelectorAll('.modal-overlay.open').forEach(function (m) {
                m.classList.remove('open');
            });
        }

        if (abrir) abrir.addEventListener('click', abrirModal);
        if (fechar) fechar.addEventListener('click', fecharModal);
        if (cancelar) cancelar.addEventListener('click', fecharModal);

        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) fecharModal();
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && overlay.classList.contains('open')) fecharModal();
        });
    }

    if (document.getElementById('modalFiltros')) {
        initModal('modalFiltros', {
            abrirId: 'btnAbrirFiltros',
            fecharId: 'btnFecharFiltros',
            cancelarId: 'btnCancelarFiltros'
        });
    }

    window.initModal = initModal;
})();
