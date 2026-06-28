package ao.unic.ojj.controller;

import ao.unic.ojj.dao.CursoDAO;
import ao.unic.ojj.dao.EstudanteDAO;
import ao.unic.ojj.dao.InscricaoDAO;
import ao.unic.ojj.dao.PeriodoLetivoDAO;
import ao.unic.ojj.dao.TurmaDAO;
import ao.unic.ojj.dao.UtilizadorDAO;
import ao.unic.ojj.dto.EstudanteDetalheDTO;
import ao.unic.ojj.dto.InscricaoDetalheDTO;
import ao.unic.ojj.dto.TurmaDTO;
import ao.unic.ojj.model.Curso;
import ao.unic.ojj.model.Inscricao;
import ao.unic.ojj.model.PeriodoLetivo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/inscricoes")
public class GerirInscricoesServlet extends HttpServlet {

    private final TurmaDAO turmaDAO = new TurmaDAO();
    private final InscricaoDAO inscricaoDAO = new InscricaoDAO();
    private final UtilizadorDAO utilizadorDAO = new UtilizadorDAO();
    private final EstudanteDAO estudanteDAO = new EstudanteDAO(utilizadorDAO);
    private final PeriodoLetivoDAO periodoLetivoDAO = new PeriodoLetivoDAO();
    private final CursoDAO cursoDAO = new CursoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String periodoParam = req.getParameter("periodoId");
        String estado = req.getParameter("estado");
        String cursoParam = req.getParameter("cursoId");
        String nomeEstudante = req.getParameter("nomeEstudante");
        String numeroEstudante = req.getParameter("numeroEstudante");

        Integer periodoId = null;
        Integer cursoId = null;
        try { periodoId = Integer.valueOf(periodoParam); } catch (NumberFormatException ignored) {}
        try { cursoId = Integer.valueOf(cursoParam); } catch (NumberFormatException ignored) {}

        List<InscricaoDetalheDTO> inscricoes = inscricaoDAO.listarDetalhes(periodoId, estado, cursoId, nomeEstudante, numeroEstudante);

        List<TurmaDTO> turmas = turmaDAO.listar();
        List<EstudanteDetalheDTO> estudantes = estudanteDAO.listarEstudantesDetalhes();
        List<PeriodoLetivo> periodos = periodoLetivoDAO.listar();
        List<Curso> cursos = cursoDAO.listarAtivos();

        req.setAttribute("inscricoes", inscricoes);
        req.setAttribute("totalInscricoes", inscricoes.size());
        req.setAttribute("turmas", turmas);
        req.setAttribute("estudantes", estudantes);
        req.setAttribute("periodos", periodos);
        req.setAttribute("cursos", cursos);

        String mensagem = (String) req.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            req.setAttribute("mensagem", mensagem);
            req.getSession().removeAttribute("mensagem");
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/inscricoes.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");
        boolean sucesso = false;

        if ("inscrever".equals(acao)) {
            Inscricao i = new Inscricao(
                    Integer.parseInt(req.getParameter("estudanteId")),
                    Integer.parseInt(req.getParameter("turmaId")),
                    new Date(),
                    Inscricao.Estado.ACTIVO
            );
            sucesso = inscricaoDAO.inserir(i);
            req.getSession().setAttribute("mensagem",
                    sucesso ? "Estudante inscrito com sucesso." : "Erro ao inscrever estudante.");

        } else if ("alterar_estado".equals(acao)) {
            sucesso = inscricaoDAO.atualizarEstado(
                    Integer.parseInt(req.getParameter("id")),
                    Inscricao.Estado.valueOf(req.getParameter("novoEstado"))
            );
            req.getSession().setAttribute("mensagem",
                    sucesso ? "Estado actualizado com sucesso." : "Erro ao actualizar estado.");

        } else if ("eliminar".equals(acao)) {
            sucesso = inscricaoDAO.eliminar(Integer.parseInt(req.getParameter("id")));
            req.getSession().setAttribute("mensagem",
                    sucesso ? "Inscrição eliminada com sucesso." : "Erro ao eliminar inscrição.");
        }

        res.sendRedirect(req.getContextPath() + "/admin/inscricoes");
    }
}
