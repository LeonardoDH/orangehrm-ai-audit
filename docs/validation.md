# Evidências da execução — 29/10/2026

Execução realizada com Codex autenticado localmente, Chromium/Playwright e demo público do OrangeHRM. O objetivo é comprovar a cadeia de evidências, não maximizar o número de issues.

| Resultado | Evidência |
|---|---|
| 7 testes unitários passaram | [CI](https://github.com/LeonardoDH/orangehrm-ai-audit/actions/runs/40943696468) |
| Controle com defeito falha; controle corrigido passa | `npm run demo` no CI e `npm run demo -- --codex` executado localmente |
| 8 smoke tests contra o demo passaram no Linux | [Live smoke](https://github.com/LeonardoDH/orangehrm-ai-audit/actions/runs/40943074473) |
| Skill validada | `quick_validate.py`: `Skill is valid!` |
| HTML sem idioma declarado | [Issue #1](https://github.com/LeonardoDH/orangehrm-ai-audit/issues/1), [teste e revisão na PR #4](https://github.com/LeonardoDH/orangehrm-ai-audit/pull/4) |
| Quatro links sociais sem nome acessível | [Issue #2](https://github.com/LeonardoDH/orangehrm-ai-audit/issues/2), [teste e revisão na PR #3](https://github.com/LeonardoDH/orangehrm-ai-audit/pull/3) |

Os dois testes gerados foram executados contra o demo e falharam na asserção `expected: 0 / actual: 1`, respectivamente pelas regras axe-core `html-has-lang` e `link-name`. Essa falha é o resultado esperado de uma regressão que reproduz um defeito ainda presente no produto externo. Não foi usado `test.fail`, `skip` ou inversão da asserção para produzir um resultado verde.

O revisor Codex publicou parecer **approve** nas duas PRs depois de verificar o arquivo canônico e reproduzir o comportamento em outro contexto do navegador. O parecer é um comentário técnico associado ao SHA, não uma aprovação formal da própria PR, e não houve merge.

A regra `color-contrast` apresentou resultado incompleto na auditoria e não foi publicada como issue. Nove contratos de login e navegação passaram na primeira exploração. A auditoria estendida contém doze casos; a quantidade de achados pode mudar quando o demo for atualizado.

## Roteiro para demonstração

1. Mostre a issue, os passos e as duas observações independentes.
2. Abra a PR correspondente: teste curto, lógica reutilizável no POM e asserção do comportamento correto.
3. Mostre o comentário do revisor com o SHA e a observação independente.
4. Mostre o CI verde e explique a diferença entre integridade do pipeline e defeitos ainda presentes no site auditado.
5. Execute `pwsh -File scripts/run-local.ps1` para repetir o pipeline com Codex e deduplicação.

No GitHub Actions, IA com Codex exige `CODEX_API_KEY`. A sessão local do ChatGPT não foi exportada. O modo `rules` é uma alternativa determinística para validar a infraestrutura sem chave; não deve ser apresentado como execução de IA.
