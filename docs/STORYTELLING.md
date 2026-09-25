# 📜 Storytelling: A Sprint da Virada no App SENAI

**Contexto:** Refinamento técnico e alinhamento de sprint via Slack / Google Meet entre a equipe de produto e engenharia móvel.  
**Participantes:**
- **Ana (Product Owner / Agilista)**
- **Clayton (Desenvolvedor Flutter Sênior)**

---

### [09:15] Daily & Alinhamento de Demandas

**Ana (Product Owner):**  
Bom dia, Clayton! Tudo bem por aí? Conseguiu dar uma olhada nos cards prioritários da nossa sprint? O pessoal de suporte e testes subiu duas demandas bem urgentes vindas direto do feedback dos usuários do piloto.

**Clayton (Desenvolvedor Flutter):**  
Bom dia, Ana! Tudo ótimo. Sim, estava olhando o board agora de manhã. Vi que tem uma bronca no fluxo de autenticação e uma entrega pendente na vitrine, certo?

**Ana (Product Owner):**  
Exatamente. Vou te contextualizar:
1. **Bug Crítico no Login:** Os alunos relataram que, quando erram a senha ou digitam um e-mail fora do padrão institucional, o app entra em um "loop infinito". Aquele botão de entrar fica com a rodinha de loading girando eternamente e a tela não destrava! O usuário é obrigado a fechar o aplicativo e abrir de novo.
2. **Nova Feature na Home:** A nossa tela inicial (`HomeView`) hoje é praticamente um esqueleto em branco, só tem um `Container` vazio lá dentro. A camada de dados de produtos à venda já foi construída pelo time anterior (com datasource simulando a API via Maps, models e repositories com padrão Result), mas ninguém construiu a ViewModel/Controller do GetX para ligar essa vitrine à tela. Precisamos que a Home passe a listar os produtos disponíveis de forma dinâmica e reativa!

**Clayton (Desenvolvedor Flutter):**  
Putz, Ana... Dei uma puxada no código do projeto ontem à noite para entender o que herdamos daquela consultoria que tocou o MVP às pressas. Olha, vou ser bem sincero com você: o bug do login e a ligação da Home com a repository de produtos são tarefas tranquilas de implementar, mas o estado desse código me deu calafrios. Está cheirando muito mal em termos de Clean Code e arquitetura.

**Ana (Product Owner):**  
Sério, Clayton? Tão ruim assim? O que você encontrou por lá? Me dá uma dimensão técnica, porque se precisar justificar tempo de refatoração para os stakeholders, eu preciso entender o impacto.

---

### [09:22] A Negociação do Refactoring e as Pistas Técnicas

**Clayton (Desenvolvedor Flutter):**  
O problema é que se a gente só empurrar mais código em cima dessa base, o projeto vai virar uma bomba-relógio para os alunos e para o suporte. Quero te pedir para quebrarmos a tarefa em duas partes: **(1)** corrigir o bug do login e criar a ViewModel da Home, e **(2)** abrir um card de **Débito Técnico / Refatoração Clean Code** para limpar a casa.

**Ana (Product Owner):**  
Faz todo sentido, Clayton! Qualidade de código é investimento para mantermos a velocidade nas próximas sprints. Mas me conta, quais foram as maiores bizarrices que você bateu o olho?

**Clayton (Desenvolvedor Flutter):**  
Vou te dar um resumo das "pérolas" que encontrei espalhadas:

1. **Variáveis com nomes indecifráveis:**  
   Em vários pontos do código, principalmente nos datasources, os caras usaram variáveis de uma única letra ou abreviações misteriosas tipo `u`, `d`, `r`, `pl`, `x`. Você olha pro código e parece álgebra do ensino médio; você tem que ficar mapeando mentalmente o que cada letra significa.
2. **Métodos com nomes genéricos e enganosos:**  
   Tem método lá chamado simplesmente `check` e outro chamado `proc`. O que diabos `proc` faz? Processa? Procura? Procedimento? O nome não revela a menor intenção do que o método devolve.
3. **Função "Monstro" com mil responsabilidades:**  
   Na camada de repositório de produtos, tem um método que faz tudo ao mesmo tempo: busca o dado bruto, calcula imposto, aplica desconto de promoção, formata texto e monta o modelo. Quebrou o Princípio da Responsabilidade Única (SRP) com gosto.
4. **Flag Arguments ligando e desligando lógica:**  
   Encontrei métodos recebendo parâmetros booleanos tipo `bool isVip` que alteram completamente o fluxo interno da função em dois blocos paralelos. Tio Bob sempre avisa: se você precisa passar um booleano de flag pra função decidir o que faz, ela faz mais de uma coisa e deveria ser dividida!
5. **Código Duplicado (Violação do DRY):**  
   Uma expressão regular inteira de validação de e-mail foi copiada e colada idêntica no Controller da tela e dentro da camada de dados. Se o SENAI mudar o padrão de validação amanhã, alguém vai alterar em um lugar e esquecer do outro.
6. **Números Mágicos e Strings Mágicas:**  
   Números como `2500`, `1800`, `0.85`, `0.15` e códigos de texto soltos como status `AUTH_OK_200` jogados diretamente no meio das contas, sem nenhuma constante nomeada ou enum para explicar a regra de negócio.
7. **A Pirâmide da Morte (Pyramid of Doom):**  
   No repositório de login, tem um ninho com quatro níveis de `if` aninhados um dentro do outro (`if (...) { if (...) { if (...) } }`). Parece uma seta apontando pra direita! Dá para resolver isso de forma elegante em poucas linhas usando cláusulas de guarda (*Early Return*).
8. **Acoplamento Forte e Desrespeito à Injeção de Dependências:**  
   O projeto tem GetX configurado para injeção de dependências nas bindings, mas adivinha? Dentro do próprio `LoginController`, o desenvolvedor simplesmente deu um `new` chamando a classe concreta do repositório diretamente no atributo! Isso mata a testabilidade do app; ninguém consegue criar um mock da API pra fazer teste unitário.
9. **Tratamento Genérico de Erros engolindo tudo:**  
   Nos blocos de tratamento, tem um `catch (e)` genérico que captura qualquer coisa, engole o tipo real da exceção (não sabe se foi erro de rede, de senha ou do banco) e sempre devolve a mesma mensagem genérica, sumindo com o stack trace.
10. **Nomes com Ruído e Inconsistência:**  
    No modelo de dados de produtos, adicionaram o tipo de dado dentro do nome dos campos, tipo `productIdString`, `productPriceDoubleAmount`, `isProductAvailableBooleanFlag`. Isso é ruído puro, além de poluir a semântica da entidade.

**Ana (Product Owner):**  
Nossa, Clayton... Agora eu entendi perfeitamente o tamanho da encrenca! E sobre o bug do login que trava o botão no loading, você já sacou o que é?

**Clayton (Desenvolvedor Flutter):**  
Já matei a charada! É um clássico erro bobo de reatividade no GetX. No controller, o desenvolvedor seta a variável reativa de loading para `true` logo no início da requisição. Se der sucesso, ele desativa o loading e navega. Mas quando a validação falha ou o repositório devolve uma falha no padrão Result, ele atualiza o texto de erro e **esquece de setar o loading para `false`**! Aí a view continua observando a variável reativa como `true`, e o botão fica girando o `CircularProgressIndicator` até o fim dos tempos.

**Ana (Product Owner):**  
Genial! Então fechamos assim:
- **Card 1 (Correção & Feature):** Corrigir o estado do GetX no login e criar a ViewModel/Controller da Home consumindo o repositório de produtos para exibir a vitrine.
- **Card 2 (Refatoração Clean Code):** Eliminar esses 10 problemas que você listou, deixando a arquitetura limpa, testável e sem gambiarras.

Vou priorizar essas tarefas agora mesmo no quadro! Mãos à obra, Clayton!

**Clayton (Desenvolvedor Flutter):**  
Show de bola, Ana! Vou puxar o card e começar agora mesmo. Esse app vai ficar um brinco!
