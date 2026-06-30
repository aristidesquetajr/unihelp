package ao.unic.ojj.controller;

import ao.unic.ojj.dao.AtendimentoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.NotaDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.EstudanteDetalheDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/funcionario/perfil-estudante")
public class PerfilEstudanteServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final NotaDAO notaDAO = new NotaDAO();
    private final AtendimentoDAO atendimentoDAO = new AtendimentoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/funcionario/estudantes");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/erro/400");
            return;
        }

        EstudanteDetalheDTO estudante = estudanteDAO.buscarDetalhesPorId(id);
        if (estudante == null) {
            res.sendRedirect(req.getContextPath() + "/erro/404");
            return;
        }

        req.setAttribute("estudante", estudante);

        try {
            req.setAttribute("notas", notaDAO.listarDetalhesPorEstudante(id));
        } catch (Exception e) {
            req.setAttribute("notas", null);
        }

        try {
            req.setAttribute("atendimentos", atendimentoDAO.listarPorEstudanteDTO(id));
        } catch (Exception e) {
            req.setAttribute("atendimentos", null);
        }

        req.getRequestDispatcher("/WEB-INF/views/funcionario/perfil-estudante.jsp")
                .forward(req, res);
    }
}
