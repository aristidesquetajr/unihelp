package ao.unic.ojj.controller;

import ao.unic.ojj.dao.CursoDAO;
import ao.unic.ojj.dao.DisciplinaDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.EstudanteDetalheDTO;
import ao.unic.ojj.model.Curso;
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

@WebServlet("/funcionario/estudantes")
public class ListaEstudantesServlet extends HttpServlet {

    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final CursoDAO cursoDAO = new CursoDAO();
    private final DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
    private final PeriodoLetivoDAO periodoLetivoDAO = new PeriodoLetivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        List<Curso> cursos = cursoDAO.listarAtivos();
        req.setAttribute("cursos", cursos);

        String q = req.getParameter("q");
        String cursoParam = req.getParameter("cursoId");

        Integer cursoId = null;
        try {
            cursoId = Integer.valueOf(cursoParam);
        } catch (NumberFormatException ignored) {
        }

        List<EstudanteDetalheDTO> estudantes = estudanteDAO.pesquisarEstudantesDetalhes(q, cursoId);
        req.setAttribute("estudantes", estudantes);
        req.setAttribute("totalEstudantes", estudantes != null ? estudantes.size() : 0);
        req.setAttribute("disciplinas", disciplinaDAO.listar());
        req.setAttribute("periodos", periodoLetivoDAO.listar());
        req.setAttribute("tipos", Nota.Tipo.values());

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/funcionario/estudantes.jsp")
                .forward(req, res);
    }
}
