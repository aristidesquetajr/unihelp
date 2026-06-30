package ao.unic.ojj.controller;

import ao.unic.ojj.dao.DisciplinaDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.NotaDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.EstudanteDetalheDTO;
import ao.unic.ojj.model.Disciplina;
import ao.unic.ojj.model.Nota;
import ao.unic.ojj.model.PeriodoLetivo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * GET /funcionario/nota → Formulário de lançamento de nota. POST
 * /funcionario/nota → Guarda ou actualiza a nota.
 */
@WebServlet("/funcionario/lancar-nota")
public class LancarNotaServlet extends HttpServlet {

    private final NotaDAO notaDAO = new NotaDAO();
    private final DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final PeriodoLetivoDAO periodoLetivoDAO = new PeriodoLetivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Disciplina> disciplinas = disciplinaDAO.listar();
        List<EstudanteDetalheDTO> estudantes = estudanteDAO.listarEstudantesDetalhes();
        List<PeriodoLetivo> periodos = periodoLetivoDAO.listar();

        req.setAttribute("disciplinas", disciplinas);
        req.setAttribute("estudantes", estudantes);
        req.setAttribute("periodos", periodos);
        req.setAttribute("tipos", Nota.Tipo.values());

        // Se vier idNota, é edição
        String idNotaParam = req.getParameter("id");
        if (idNotaParam != null) {
            Nota nota = notaDAO.buscarPorId(Integer.parseInt(idNotaParam));
            req.setAttribute("nota", nota);
        }

        req.getRequestDispatcher("/WEB-INF/views/funcionario/lancar-nota.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idNotaParam = req.getParameter("idNota");
        int idEstudante = Integer.parseInt(req.getParameter("estudanteId"));
        int idDisciplina = Integer.parseInt(req.getParameter("disciplinaId"));
        int idPeriodo = Integer.parseInt(req.getParameter("periodoId"));
        double valor = Double.parseDouble(req.getParameter("valor"));
        Nota.Tipo tipo = Nota.Tipo.valueOf(req.getParameter("tipo"));

        // Validação do valor
        if (valor < 0 || valor > 20) {
            req.setAttribute("erro", "O valor da nota deve estar entre 0 e 20.");
            doGet(req, res);
            return;
        }

        boolean sucesso;

        if (idNotaParam != null && !idNotaParam.isBlank()) {
            // Edição
            Nota nota = new Nota(Integer.parseInt(idNotaParam),
                    idEstudante, idDisciplina, idPeriodo, valor, tipo);
            sucesso = notaDAO.atualizar(nota);
        } else {
            // Nova nota
            Nota nota = new Nota(idEstudante, idDisciplina, idPeriodo, valor, tipo);
            sucesso = notaDAO.inserir(nota);
        }

        if (sucesso) {
            req.getSession().setAttribute("mensagem", "Nota guardada com sucesso!");
            res.sendRedirect(req.getContextPath() + "/funcionario/estudantes");
        } else {
            req.setAttribute("erro", "Erro ao guardar a nota.");
            doGet(req, res);
        }
    }
}
