# MontrealTeste
Teste Montreal Delphi 12 CE

Serviço (Windows service)
Cliente (VCL Aplication)
MSSQL   (acesso no serviço, via ADO)

# Parte técnica:
Conforme indicação, usei Horse e RestRequest4delphi.
Fiz o tratamento de exceções no serviço e cliente (encapsulando as mensagens de erro em um json padronizado).
Fiz o tratamento de literais com o uso de constantes compartilhadas entre Serviço e Cliente.
Não pude usar o FireDAC, pois minha versão CE Community Edition não estava possuia componentes TFDPhysMSSQLDriverLink ou ainda o TFDPhysODBCDriverLink (outros exemplos/provas que participei acabei usando Postgres).

# Parte do banco:
Criei a estrutura simples (podia ser criada uma tabela de status).
Campos: Id, Titulo, Descricao, Prioridade, Status, DataCriacao, DataConclusao.
Índices em: Status, e DataConclusao (para as consultas já definidas).
Os parâmetros de conexão estão no arquivo DB.ini (junto ao serviço).

# Parte de negócio:
O campo Status ficou aberto, pois não tínhamos um domínio específico. Logo, para cálculos foram consideradas as literais "PENDENTE" e "CONCLUIDA".
Fiz apenas umas validações de negócio simples na camada service com exceções de negócio personalizadas (data de criação e existência do Id para operações de atualização e exclusão).
Criei também a edição completa de uma tarefa.

# Melhorias possíveis:
Definição do domínio de Status (cadastro e uso controlado na atualização e cadastro).
Visualização gráfica das estatísticas (cores, destaque, imagem).
Edição direta no grid.
Atualização de registros em tela após atualizações.
Carregamento parcial dos registros (paginação).
Autenticação mais segura.
Métodos para configurações do banco, neste caso deixei em no BD.ini junto ao serviço.

Instruções para uso
- Instalar o serviço TaskService.exe /install
- Ajustar o BD.ini com os dados para conexão
- Executar o cliente TarefasMontreal.exe