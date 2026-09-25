# Clean Code Challenge — SENAI

Projeto Flutter (GetX) desenvolvido a partir do storytelling em [docs/STORYTELLING.md](docs/STORYTELLING.md): correção de um bug crítico no login, implementação da vitrine de produtos na Home e refatoração Clean Code do código herdado.

## Como rodar

```bash
flutter pub get
flutter test
flutter run
```

---

## 1. Correção do bug de loading infinito no Login

**Problema:** ao errar a senha ou digitar um e-mail fora do padrão, o botão "Entrar" ficava girando (`CircularProgressIndicator`) para sempre, obrigando o usuário a fechar e reabrir o app.

**Causa raiz:** em [`LoginController.autenticar`](lib/ui/auth/controllers/login_controller.dart), a variável reativa `isLoading` era setada para `true` no início da requisição, mas só era desligada explicitamente no caminho de **sucesso**. Os caminhos de falha (e-mail inválido, senha incorreta, erro do repositório) saíam da função sem nunca voltar `isLoading` para `false`.

**Solução — `try / finally`:**

```dart
Future<void> autenticar(String email, String password) async {
  isLoading.value = true;
  errorMessage.value = '';

  try {
    if (!EmailValidator.isValid(email)) {
      errorMessage.value = 'Formato de email invalido';
      return;
    }

    final result = await _repository.login(email, password);

    result.fold<void>(
      (failure) => errorMessage.value = failure.message,
      (user) => Get.offNamed(AppPages.home),
    );
  } finally {
    isLoading.value = false;
  }
}
```

**Por que `finally` e não `isLoading.value = false` espalhado em cada `if`/`else`:**

- O método tem **múltiplos pontos de saída** (`return` da validação, sucesso, falha). O `finally` garante que o bloco execute **sempre**, não importa por qual caminho a função termine — inclusive se uma exceção não tratada for lançada.
- Elimina a necessidade de lembrar de repetir `isLoading.value = false` em cada novo caminho de saída que for adicionado no futuro — existe **um único lugar** responsável por isso, o que evita a reincidência exata deste bug.
- Não é um recurso do GetX: `try/finally` é da linguagem Dart. O único código de GetX ali é a variável reativa `isLoading` (`.obs`/`.value`).

---

## 2. Criação da Home (vitrine de produtos)

**Estado anterior:** [`HomeView`](lib/ui/home/views/home_view.dart) era um `Scaffold` com `body: Container()` — nenhuma lógica, nenhum dado.

**O que já existia:** toda a camada de dados de produtos (datasource simulando API, model, repositório com padrão `Result`), sem nenhuma ViewModel/Controller ligando isso à tela.

**O que foi criado:**

- [`HomeController`](lib/ui/home/controllers/home_controller.dart) — recebe `ProductRepository` por injeção de dependência, carrega os produtos em `onInit()` e expõe `isLoading`, `errorMessage` e `products` como variáveis reativas (`.obs`).
- [`HomeView`](lib/ui/home/views/home_view.dart) reescrita como `GetView<HomeController>`, com um único `Obx` cobrindo três estados: carregando, erro (com botão de tentar novamente) e lista de produtos (`ListView.builder`).
- Registro do `HomeController` em [`AppBinding`](lib/bindings/app_binding.dart) via `Get.lazyPut`.

O resultado: a Home passou a listar os produtos disponíveis de forma dinâmica e reativa, consumindo o repositório já existente.

---

## 3. Refatoração Clean Code

Os 10 problemas identificados no código herdado e a correção aplicada em cada um:

| # | Problema | Correção |
|---|---|---|
| 1 | Variáveis de uma letra (`u`, `d`, `r`, `pl`, `x`) | Renomeadas para nomes que revelam intenção (`_registeredUser`, `_products`, `email`, `password`, `product`) |
| 2 | Métodos genéricos (`check`, `proc`) | Renomeados para `authenticate()`, `fetchAllProducts()`, `fetchVipProducts()` |
| 3 | Método "monstro" (busca + imposto + desconto + formatação + model, tudo junto) | Quebrado em métodos pequenos e nomeados: `_loadProducts`, `_toPricedProducts`, `_withFinalPrice`, `_applyDiscount`, `_applyTax`, `_roundToCurrency` — cada um com uma responsabilidade |
| 4 | Flag argument `bool isVip` mudando o fluxo inteiro da função | Separado em dois métodos explícitos: `getProducts()` e `getVipProducts()` |
| 5 | Regex de validação de e-mail duplicada (Controller e datasource) | Centralizada em [`EmailValidator`](lib/core/validators/email_validator.dart), reutilizada nos dois pontos |
| 6 | Números e strings mágicas (`2500`, `1800`, `0.85`, `0.15`, `AUTH_OK_200`...) | Extraídos para constantes nomeadas: [`PricingRules`](lib/core/constants/business_rules.dart), [`AuthRules`](lib/core/constants/business_rules.dart), [`MockApiLatency`](lib/core/constants/mock_api.dart), [`ApiStatusCode`](lib/core/constants/mock_api.dart), [`ProductCategory`](lib/data/models/product_category.dart) (enum), e nomes de rota em [`AppPages`](lib/routes/app_pages.dart) |
| 7 | Pirâmide da morte (4 níveis de `if` aninhados no login) | Reescrito com cláusulas de guarda (*early return*) em `_validateCredentials` |
| 8 | `LoginController` instanciava o repositório concreto com `new`, ignorando a injeção de dependências do GetX | Repositório passa a ser injetado pelo construtor (`LoginController(this._repository)`), resolvido via `Get.find` no `AppBinding` — agora é mockável em testes |
| 9 | `catch (e)` genérico engolindo o tipo real da exceção e o stack trace | Tratamento específico por tipo: `on AuthException`, `on ServerException`, `on FormatException`, `on TypeError` — cada falha vira um `Failure` correspondente, sem esconder a causa |
| 10 | Ruído de tipo nos nomes (`productIdString`, `productPriceDoubleAmount`, `isProductAvailableBooleanFlag`) | Renomeados para `id`, `name`, `description`, `price`, `isAvailable`, `category` |

**Testes:** [`test/product_repository_test.dart`](test/product_repository_test.dart) cobre a listagem de produtos disponíveis e o desconto aplicado aos produtos VIP.

---

## Observações de escopo

- **Não foi criado um arquivo de bootstrap** separado (ex.: um `service_locator.dart`/`bootstrap.dart` isolado da inicialização do app). A injeção de dependências continua centralizada no [`AppBinding`](lib/bindings/app_binding.dart), que já cumpre esse papel no padrão GetX — criar uma camada adicional não fazia parte do que foi solicitado.
- **`lib/main.dart` e o widget `MainApp` permanecem exatamente como estavam** antes desta sprint. Nenhuma alteração foi feita ali porque não fazia parte dos requisitos (bug do login, Home e refatoração Clean Code).
