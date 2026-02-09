unit uTask;

interface

uses
  JSON;

type
  TTask = class
  private
    FPrioridade: Integer;
    FTitulo: string;
    FDescricao: string;
    FId: Integer;
    FStatus: string;
    FDataConclusao: TDateTime;
    FDataCriacao: TDateTime;
    procedure SetDataConclusao(const Value: TDateTime);
    procedure SetDataCriacao(const Value: TDateTime);
    procedure SetDescricao(const Value: string);
    procedure SetId(const Value: Integer);
    procedure SetPrioridade(const Value: Integer);
    procedure SetStatus(const Value: string);
    procedure SetTitulo(const Value: string);
  public
    property Id: Integer read FId write SetId;
    property Titulo: string read FTitulo write SetTitulo;
    property Descricao: string read FDescricao write SetDescricao;
    property Prioridade: Integer read FPrioridade write SetPrioridade;
    property Status: string read FStatus write SetStatus;
    property DataCriacao: TDateTime read FDataCriacao write SetDataCriacao;
    property DataConclusao: TDateTime read FDataConclusao write SetDataConclusao;

    class function FromJSON(aJSON: TJSONObject): TTask;
    function ToJSON: TJSONObject;
  end;

implementation

uses
  DateUtils, System.SysUtils;

{ TTask }

procedure TTask.SetDataConclusao(const Value: TDateTime);
begin
  FDataConclusao := Value;
end;

procedure TTask.SetDataCriacao(const Value: TDateTime);
begin
  FDataCriacao := Value;
end;

procedure TTask.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TTask.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TTask.SetPrioridade(const Value: Integer);
begin
  FPrioridade := Value;
end;

procedure TTask.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

procedure TTask.SetTitulo(const Value: string);
begin
  FTitulo := Value;
end;

class function TTask.FromJSON(aJSON: TJSONObject): TTask;
begin
  Result := TTask.Create;

  if aJSON = nil then
    Exit;

  if Assigned(aJSON.FindValue('id')) then
    Result.Id := aJSON.GetValue<Integer>('id');
  if Assigned(aJSON.FindValue('prioridade')) then
    Result.Prioridade := aJSON.GetValue<Integer>('prioridade');
  if Assigned(aJSON.FindValue('titulo')) then
    Result.Titulo := aJSON.GetValue<string>('titulo');
  if Assigned(aJSON.FindValue('descricao')) then
    Result.Descricao := aJSON.GetValue<string>('descricao');
  if Assigned(aJSON.FindValue('status')) then
    Result.Status := aJSON.GetValue<string>('status');
  if Assigned(aJSON.FindValue('dataCriacao')) then
    Result.DataCriacao := ISO8601ToDate(aJSON.GetValue<string>('dataCriacao'), False);
  if Assigned(aJSON.FindValue('dataConclusao')) then
    Result.DataConclusao := ISO8601ToDate(aJSON.GetValue<string>('dataConclusao'), False);
end;

function TTask.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;

  Result.AddPair('id', TJSONNumber.Create(Id));
  Result.AddPair('titulo', TJSONString.Create(Titulo));
  Result.AddPair('descricao', TJSONString.Create(Descricao));
  Result.AddPair('prioridade', TJSONNumber.Create(Prioridade));
  Result.AddPair('status', TJSONString.Create(Status));
  if (DataCriacao > 0) then
    Result.AddPair(
      'dataCriacao', TJSONString.Create(DateToISO8601(DataCriacao, False)));
  if (DataConclusao > 0) then
    Result.AddPair(
      'dataConclusao', TJSONString.Create(DateToISO8601(DataConclusao, False)));
end;

end.
