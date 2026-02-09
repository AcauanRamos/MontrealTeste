unit uConstants;

interface

const
  { API }
  API_HEADER_APIKEY = 'x-api-key';
  API_CONTENTTYPE_JSON = 'application/json; charset=utf-8';

  API_ROUTE_TASKS = '/tasks';
  API_ROUTE_DASHBOARD = '/dashboard';
  API_ROUTE_STATUS = '/status';

  API_APIKEY_TESTS = 'minha-chave-secreta';


  { Erros }
  ERROR = 'erro';
  ERROR_GET_DASHBOARD = 'Falha ao consultar estatísticas.';
  ERROR_INVALID_BODY = 'Body inválido';
  ERROR_INVALID_ID = 'ID inválido';
  ERROR_STATUS_NOT_PROVIDED = 'Status não informado';

  { Mensagens }
  SUCCESS = 'success';
  MESSAGE = 'message';
  MSG_APIKEY_NOT_PROVIDED = 'ApiKey não informada';
  MSG_APIKEY_INVALID = 'ApiKey inválida';

  MSG_TASK_CREATED = 'Tarefa criada com sucesso.';
  MSG_TASK_UPDATED = 'Tarefa alterada com sucesso.';
  MSG_TASK_DELETED = 'Tarefa excluída com sucesso.';
  MSG_TASK_ID_PROVIDED_NOTFOUND = 'Id informado não encontrado.';
  MSG_TASK_STATUS_UPDATED = 'Status da tarefa alterado com sucesso.';
  MSG_TASKS_NOTFOUND = 'Nenhuma tarefa encontrada.';
  MSG_TASK_ASK_STATUS_CAPTION = 'Informe o novo Status da tarefa';
  MSG_TASK_ASK_DELETE = 'Confirma excluir a tarefa selecionada?';

  CAPTION_Status = 'Status';
  CAPTION_Alterar = 'Alterar';
  CAPTION_Excluir = 'Excluir';

  { Mensagens formatadas }
  MSGF_TASKS_LISTED = 'Tarefas listadas: %d (atualizado até %s)';

  { Campos }
  FIELD_STATISTICS_total = 'total';
  FIELD_STATISTICS_mediaPrioridadePendentes = 'mediaPrioridadePendentes';
  FIELD_STATISTICS_concluidas7Dias = 'concluidas7Dias';

implementation

end.
