unit uTask.Repository.SQL;

interface

uses
  System.Generics.Collections, Data.DB, Data.Win.ADODB, JSON,
  uTask, uTask.Repository.Intf, uDBConnection;

type
  TTaskRepositorySQL = class(TInterfacedObject, ITaskRepository)

  private
    FoQuery: TADOQuery;
    FoConnection: TADOConnection;

    procedure Insert(oTask: TTask);
    procedure Update(iId: Integer; oTask: TTask);
    procedure UpdateStatus(iId: Integer; sStatus: string);
    procedure Delete(iId: Integer);
    function GetAll: TList<TTask>;
    function Get(iId: Integer): TTask;

    function AvgPriorityPending: Double;
    function DoneLast7Days: Integer;
    function TotalTasks: Integer;

    procedure CreateQueryAndConnection;
    procedure FreeQueryAndConnection;
  end;

implementation

uses
  System.SysUtils, Winapi.ActiveX, System.Variants;

procedure TTaskRepositorySQL.CreateQueryAndConnection;
begin
  CoInitialize(nil);

  FoConnection := TADOConnection.Create(nil);
  FoQuery := TADOQuery.Create(nil);
  FoQuery.Connection := GetConnection;
end;

procedure TTaskRepositorySQL.FreeQueryAndConnection;
begin
  FoQuery.Close;
  FoConnection.Connected := False;
  FreeAndNil(FoQuery);
  FreeAndNil(FoConnection);

  CoUninitialize;
end;

procedure TTaskRepositorySQL.Insert(oTask: TTask);
begin
  CreateQueryAndConnection;
  try
    FoQuery.SQL.Text :=
      'INSERT INTO Tarefas (Titulo, Descricao, Prioridade, Status, DataCriacao, DataConclusao) ' +
      'VALUES (:Titulo, :Descricao, :Prioridade, :Status, :DataCriacao, :DataConclusao)';

    FoQuery.Parameters.ParamByName('Titulo').Value := oTask.Titulo;
    FoQuery.Parameters.ParamByName('Descricao').Value := oTask.Descricao;
    FoQuery.Parameters.ParamByName('Status').Value := oTask.Status;
    FoQuery.Parameters.ParamByName('Prioridade').Value := oTask.Prioridade;
    FoQuery.Parameters.ParamByName('DataCriacao').Value := oTask.DataCriacao;
    if oTask.DataConclusao > 0 then
      FoQuery.Parameters.ParamByName('DataConclusao').Value := oTask.DataConclusao
    else
      FoQuery.Parameters.ParamByName('DataConclusao').Value := Null;

    FoQuery.ExecSQL;
  finally
    FreeQueryAndConnection;
  end;
end;

procedure TTaskRepositorySQL.Update(iId: Integer; oTask: TTask);
begin
  CreateQueryAndConnection;
  try
  FoQuery.SQL.Text :=
    'UPDATE Tarefas set '+
    '  Titulo = :Titulo'+
    ' ,Descricao = :Descricao'+
    ' ,Prioridade = :Prioridade'+
    ' ,Status = :Status'+
    ' ,DataConclusao = :DataConclusao'+
    ' WHERE Id = :Id';

  FoQuery.Parameters.ParamByName('Titulo').Value := oTask.Titulo;
  FoQuery.Parameters.ParamByName('Descricao').Value := oTask.Descricao;
  FoQuery.Parameters.ParamByName('Status').Value := oTask.Status;
  FoQuery.Parameters.ParamByName('Prioridade').Value := oTask.Prioridade;
  if oTask.DataConclusao > 0 then
    FoQuery.Parameters.ParamByName('DataConclusao').Value := oTask.DataConclusao
  else
    FoQuery.Parameters.ParamByName('DataConclusao').Value := Null;
  FoQuery.Parameters.ParamByName('Id').Value := iId;

  FoQuery.ExecSQL;
  finally
    FreeQueryAndConnection;
  end;
end;

procedure TTaskRepositorySQL.UpdateStatus(iId: Integer; sStatus: string);
begin
  CreateQueryAndConnection;
  try
  FoQuery.SQL.Text :=
    'UPDATE Tarefas set '+
    '  Status = :Status'+
    ' ,DataConclusao = :DataConclusao'+
    ' WHERE Id = :Id';

  FoQuery.Parameters.ParamByName('Status').Value := sStatus;
  if sStatus = 'CONCLUIDA' then
    FoQuery.Parameters.ParamByName('DataConclusao').Value := Now
  else
    FoQuery.Parameters.ParamByName('DataConclusao').Value := Null;
  FoQuery.Parameters.ParamByName('Id').Value := iId;

  FoQuery.ExecSQL;
  finally
    FreeQueryAndConnection;
  end;
end;

procedure TTaskRepositorySQL.Delete(iId: Integer);
begin
  CreateQueryAndConnection;
  try
  FoQuery.SQL.Text := 'DELETE FROM Tarefas WHERE Id = :Id';

  FoQuery.Parameters.ParamByName('Id').Value := iId;

  FoQuery.ExecSQL;
  finally
    FreeQueryAndConnection;
  end;
end;

function TTaskRepositorySQL.Get(iId: Integer): TTask;
begin
  CreateQueryAndConnection;
  Result := nil;
  try
  FoQuery.SQL.Text := ' SELECT * FROM Tarefas WHERE Id = :Id';
  FoQuery.Parameters.ParamByName('Id').Value := iId;

  FoQuery.Open;
  if not FoQuery.IsEmpty then
  begin
    Result := TTask.Create;
    Result.Id := FoQuery.FieldByName('Id').AsInteger;
    Result.Titulo := FoQuery.FieldByName('Titulo').AsString;
    Result.Descricao := FoQuery.FieldByName('Descricao').AsString;
    Result.Prioridade := FoQuery.FieldByName('Prioridade').AsInteger;
    Result.Status := FoQuery.FieldByName('Status').AsString;
    Result.DataCriacao := FoQuery.FieldByName('DataCriacao').AsDateTime;
    Result.DataConclusao := FoQuery.FieldByName('DataConclusao').AsDateTime;
  end;

  finally
    FreeQueryAndConnection;
  end;
end;

function TTaskRepositorySQL.GetAll: TList<TTask>;
var
  aTask: TTask;
begin
  CreateQueryAndConnection;
  Result := TList<TTask>.Create;
  try

  FoQuery.SQL.Text := ' SELECT * FROM Tarefas ORDER BY Id';
  FoQuery.Open;
  FoQuery.First;
  while not FoQuery.Eof do
  begin
    aTask := TTask.Create;
    aTask.Id := FoQuery.FieldByName('Id').AsInteger;
    aTask.Titulo := FoQuery.FieldByName('Titulo').AsString;
    aTask.Descricao := FoQuery.FieldByName('Descricao').AsString;
    aTask.Prioridade := FoQuery.FieldByName('Prioridade').AsInteger;
    aTask.Status := FoQuery.FieldByName('Status').AsString;
    aTask.DataCriacao := FoQuery.FieldByName('DataCriacao').AsDateTime;
    aTask.DataConclusao := FoQuery.FieldByName('DataConclusao').AsDateTime;

    Result.Add(aTask);
    FoQuery.Next;
  end;

  finally
    FreeQueryAndConnection;
  end;
end;

function TTaskRepositorySQL.AvgPriorityPending: Double;
begin
  CreateQueryAndConnection;
  try
  FoQuery.SQL.Text :=
    'SELECT CAST(AVG(CAST(Prioridade AS NUMERIC(12,2))) AS NUMERIC(12,2)) AS MEDIA'+
    '  FROM Tarefas '+
    ' WHERE Status = :Status';

  FoQuery.Parameters.ParamByName('Status').Value := 'PENDENTE';

  FoQuery.Open;
  Result := FoQuery.FieldByName('MEDIA').AsFloat;
  finally
    FreeQueryAndConnection;
  end;
end;

function TTaskRepositorySQL.DoneLast7Days: Integer;
begin
  CreateQueryAndConnection;
  try
  FoQuery.SQL.Text :=
    'SELECT COUNT(1) AS TOT_REGISTROS '+
    '  FROM Tarefas ' +
    ' WHERE Status = :Status ' +
    '   AND DataConclusao >= CAST(DATEADD(DAY, -7, GETDATE()) AS DATE)';

  FoQuery.Parameters.ParamByName('Status').Value := 'CONCLUIDA';

  FoQuery.Open;
  Result := FoQuery.FieldByName('TOT_REGISTROS').AsInteger;
  finally
    FreeQueryAndConnection;
  end;
end;

function TTaskRepositorySQL.TotalTasks: Integer;
begin
  CreateQueryAndConnection;
  try
  FoQuery.SQL.Text := 'SELECT COUNT(1) AS TOT_REGISTROS FROM Tarefas';
  FoQuery.Open;
  Result := FoQuery.FieldByName('TOT_REGISTROS').AsInteger;
  finally
    FreeQueryAndConnection;
  end;
end;

end.
