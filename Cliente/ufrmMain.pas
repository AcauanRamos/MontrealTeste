unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, JSON, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  TfrmMain = class(TForm)
    edtUrl: TLabeledEdit;
    btnGetAllTasks: TBitBtn;
    cdsTasks: TClientDataSet;
    cdsTasksId: TIntegerField;
    cdsTasksTitulo: TStringField;
    cdsTasksDescricao: TStringField;
    cdsTasksPrioridade: TIntegerField;
    cdsTasksStatus: TStringField;
    cdsTasksDataCriacao: TDateTimeField;
    cdsTasksDataConclusao: TDateTimeField;
    gridTasks: TDBGrid;
    dsTasks: TDataSource;
    btnNewTask: TBitBtn;
    lblTasksTotal: TLabel;
    cdsTasksAlterar: TStringField;
    cdsTasksExcluir: TStringField;
    gbTasksInfo: TGroupBox;
    edtTasksTotal: TLabeledEdit;
    edtPendingTasksPriorityAvg: TLabeledEdit;
    edtFinishedTasks7Days: TLabeledEdit;
    btnDasboard: TBitBtn;
    edtApiKey: TLabeledEdit;
    procedure btnGetAllTasksClick(Sender: TObject);
    procedure btnNewTaskClick(Sender: TObject);
    procedure gridTasksMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure gridTasksDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gridTasksCellClick(Column: TColumn);
    procedure cdsTasksCalcFields(DataSet: TDataSet);
    procedure btnDasboardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

    procedure GetAllTasks;
    procedure GetDashboardTasks;
    procedure LoadCdsTasksFromJSON(oJSONArr: TJSONArray);

    procedure AddNewTask;
    procedure ModifyTask;
    procedure DeleteTask;
    procedure ModifyTaskStatus;


  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.Generics.Collections, System.Math, System.UITypes, System.SysUtils,
  RESTRequest4D, uTask, ufrmTask, uConstants, uExceptionHelper;

{$R *.dfm}

{ TForm1 }

procedure TfrmMain.AddNewTask;
var
  FTask: TfrmTask;
  oTask: TTask;
  LResponse: IResponse;
begin
  FTask := TfrmTask.Create(nil);
  FTask.edtDataCriacao.Text := DateTimeToStr(Now);
  try
  if (FTask.ShowModal = mrOk) then
  begin
    oTask := TTask.Create;
    oTask.Titulo := FTask.edtTitulo.Text;
    oTask.Descricao := FTask.memDescricao.Lines.Text;
    oTask.Prioridade := FTask.edtPrioridade.ValueInt;
    oTask.Status := FTask.edtStatus.Text;
    oTask.DataCriacao := IfThen(FTask.edtDataCriacao.Text = '', 0, StrToDateTimeDef(FTask.edtDataCriacao.Text, Now));
    oTask.DataConclusao := IfThen(FTask.edtDataConclusao.Text = '', 0, StrToDateTimeDef(FTask.edtDataConclusao.Text, 0));

    try
    LResponse := TRequest.New.BaseURL(edtUrl.Text + API_ROUTE_TASKS)
      .AddHeader(API_HEADER_APIKEY, edtApiKey.Text)
      .Accept(API_CONTENTTYPE_JSON)
      .AddBody(oTask.ToJSON.ToString)
      .Post;

    if LResponse.StatusCode = 201 then
      ShowMessage(MSG_TASK_CREATED)
    else
      ShowMessage(GetErrorMessage(LResponse.Content));
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;

  finally
    FreeAndNil(FTask);
    FreeAndNil(oTask);
  end;
end;

procedure TfrmMain.ModifyTask;
var
  FTask: TfrmTask;
  oTask: TTask;
  LResponse: IResponse;
  sRoute: string;
begin
  FTask := TfrmTask.Create(nil);

  FTask.edtTitulo.Text := cdsTasksTitulo.AsString;
  FTask.memDescricao.Lines.Text := cdsTasksDescricao.AsString;
  FTask.edtPrioridade.ValueInt := cdsTasksPrioridade.AsInteger;
  FTask.edtStatus.Text := cdsTasksStatus.AsString;
  FTask.edtDataCriacao.Text := cdsTasksDataCriacao.AsString;
  FTask.edtDataConclusao.Text := cdsTasksDataConclusao.AsString;

  try
  if (FTask.ShowModal = mrOk) then
  begin
    oTask := TTask.Create;
    oTask.Titulo := FTask.edtTitulo.Text;
    oTask.Descricao := FTask.memDescricao.Lines.Text;
    oTask.Prioridade := FTask.edtPrioridade.ValueInt;
    oTask.Status := FTask.edtStatus.Text;
    oTask.DataCriacao := IfThen(FTask.edtDataCriacao.Text = '', 0, StrToDateTimeDef(FTask.edtDataCriacao.Text, Now));
    oTask.DataConclusao := IfThen(FTask.edtDataConclusao.Text = '', 0, StrToDateTimeDef(FTask.edtDataConclusao.Text, 0));

    sRoute := Format(edtUrl.Text + '%s/%s',[API_ROUTE_TASKS, cdsTasksId.AsString]);
    LResponse := TRequest.New.BaseURL(sRoute)
      .AddHeader(API_HEADER_APIKEY, edtApiKey.Text)
      .Accept(API_CONTENTTYPE_JSON)
      .AddBody(oTask.ToJSON.ToString)
      .Put;
    if LResponse.StatusCode = 200 then
      ShowMessage(MSG_TASK_UPDATED)
    else
      ShowMessage(GetErrorMessage(LResponse.Content));
  end;

  finally
    FreeAndNil(FTask);
    FreeAndNil(oTask);
  end;
end;

procedure TfrmMain.ModifyTaskStatus;
var
  LResponse: IResponse;
  sRoute, sNewStatus: string;
begin
  sNewStatus := InputBox(MSG_TASK_ASK_STATUS_CAPTION, CAPTION_Status, '');
  if (sNewStatus = '') then
    Exit;

  sRoute := Format(edtUrl.Text + '%s/%s%s/%s',[API_ROUTE_TASKS, cdsTasksId.AsString, API_ROUTE_STATUS, sNewStatus]);
  LResponse := TRequest.New.BaseURL(sRoute)
    .AddHeader(API_HEADER_APIKEY, edtApiKey.Text)
    .Accept(API_CONTENTTYPE_JSON)
    .Put;
  if LResponse.StatusCode = 200 then
    ShowMessage(MSG_TASK_STATUS_UPDATED)
  else
    ShowMessage(GetErrorMessage(LResponse.Content));
end;

procedure TfrmMain.DeleteTask;
var
  oTask: TTask;
  LResponse: IResponse;
  sRoute: string;
begin
  if MessageDlg(MSG_TASK_ASK_DELETE, mtConfirmation, [mbNo, mbYes], 0, mbNo) <> mrYes then
    Exit;

  try
  sRoute := Format(edtUrl.Text + '%s/%s',[API_ROUTE_TASKS, cdsTasksId.AsString]);
  LResponse := TRequest.New.BaseURL(sRoute)
    .AddHeader(API_HEADER_APIKEY, edtApiKey.Text)
    .Accept(API_CONTENTTYPE_JSON)
    .Delete;
  if LResponse.StatusCode = 204 then
    ShowMessage(MSG_TASK_DELETED)
  else
    ShowMessage(GetErrorMessage(LResponse.Content));

  finally
    FreeAndNil(oTask);
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  edtApiKey.Text := API_APIKEY_TESTS;
end;

procedure TfrmMain.btnDasboardClick(Sender: TObject);
begin
  GetDashboardTasks;
end;

procedure TfrmMain.btnGetAllTasksClick(Sender: TObject);
begin
  GetAllTasks;
end;

procedure TfrmMain.btnNewTaskClick(Sender: TObject);
begin
  AddNewTask;
end;

procedure TfrmMain.cdsTasksCalcFields(DataSet: TDataSet);
begin
  cdsTasksAlterar.AsString := CAPTION_Alterar;
  cdsTasksExcluir.AsString := CAPTION_Excluir;
end;

procedure TfrmMain.GetAllTasks;
var
  LResponse: IResponse;
  oJSONArr: TJSONArray;
begin
  LResponse := TRequest.New.BaseURL(edtUrl.Text + API_ROUTE_TASKS)
    .AddHeader(API_HEADER_APIKEY, edtApiKey.Text)
    .Accept(API_CONTENTTYPE_JSON)
    .Get;
  if LResponse.StatusCode = 200 then
  begin
    try
    oJSONArr := TJSONArray.ParseJSONValue(LResponse.Content) as TJSONArray;
    if Assigned(oJSONArr) then
      LoadCdsTasksFromJSON(oJSONArr);

    if (not Assigned(oJSONArr)) or oJSONArr.IsEmpty then
      ShowMessage(MSG_TASKS_NOTFOUND);

    finally
      FreeAndNil(oJSONArr);
    end;
  end
  else
    ShowMessage(GetErrorMessage(LResponse.Content));
end;

procedure TfrmMain.GetDashboardTasks;
var
  LResponse: IResponse;
  oJSONObj: TJSONObject;
  sRoute: string;
begin
  sRoute := fORMAT(edtUrl.Text + '%s%s', [API_ROUTE_TASKS, API_ROUTE_DASHBOARD]);
  LResponse := TRequest.New.BaseURL(sRoute)
    .AddHeader(API_HEADER_APIKEY, edtApiKey.Text)
    .Accept(API_CONTENTTYPE_JSON)
    .Get;
  if LResponse.StatusCode = 200 then
  begin
    try
    oJSONObj := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
    if Assigned(oJSONObj) then
    begin
      if Assigned(oJSONObj.FindValue(FIELD_STATISTICS_total)) then
        edtTasksTotal.Text := oJSONObj.GetValue<Int64>(FIELD_STATISTICS_total).ToString;
      if Assigned(oJSONObj.FindValue(FIELD_STATISTICS_mediaPrioridadePendentes)) then
        edtPendingTasksPriorityAvg.Text := FormatFloat('#,##0.00',oJSONObj.GetValue<Extended>(FIELD_STATISTICS_mediaPrioridadePendentes));
      if Assigned(oJSONObj.FindValue(FIELD_STATISTICS_concluidas7Dias)) then
        edtFinishedTasks7Days.Text := oJSONObj.GetValue<Int64>(FIELD_STATISTICS_concluidas7Dias).ToString;
    end
    else
      ShowMessage(ERROR_GET_DASHBOARD);
    finally
      FreeAndNil(oJSONObj);
    end;
  end
  else
    ShowMessage(GetErrorMessage(LResponse.Content));
end;

procedure TfrmMain.gridTasksCellClick(Column: TColumn);
begin
  if cdsTasks.IsEmpty then
    Exit;

  { Alterar cadastro }
  if Column.Field = cdsTasksAlterar then
    ModifyTask
  { Excluir cadastro }
  else if Column.Field = cdsTasksExcluir then
    DeleteTask
  { Alterar apenas Status }
  else if Column.Field = cdsTasksStatus then
    ModifyTaskStatus;

  { muda de cell, permitindo clique novamente }
  gridTasks.SelectedField := cdsTasksTitulo;
end;

procedure TfrmMain.gridTasksDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (Column.Field = cdsTasksAlterar) or (Column.Field = cdsTasksexcluir) or (Column.Field = cdsTasksStatus) then
  begin
    gridTasks.Canvas.Font.Color := clNavy;
    gridTasks.Canvas.Font.Style := gridTasks.Canvas.Font.Style + [fsUnderline];
  end;
  gridTasks.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmMain.gridTasksMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Cell: TGridCoord;
begin
  Cell := TDBGrid(Sender).MouseCoord(X, Y);

  if dgIndicator in TDBGrid(Sender).Options then
    Dec(Cell.X);
  if dgTitles in TDBGrid(Sender).Options then
    Dec(Cell.Y);

  if (Cell.X >= 0) and (Cell.Y >= 0) and Assigned(TDBGrid(Sender).Columns[Cell.X].Field) and
    ((TDBGrid(Sender).Columns[Cell.X].Field = cdsTasksAlterar) or
     (TDBGrid(Sender).Columns[Cell.X].Field = cdsTasksExcluir)) then
    TDBGrid(Sender).Cursor := crHandPoint
  else
    TDBGrid(Sender).Cursor := crDefault;
end;

procedure TfrmMain.LoadCdsTasksFromJSON(oJSONArr: TJSONArray);
var
  iTask: Integer;
  oTask: TTask;

  { Pode entrar um units de utilidades }
  function DateTimeOrNUll(dt: TDateTime): variant;
  begin
    if dt = 0 then
      Result := null
    else
      Result := dt;
  end;

begin
  cdsTasks.EmptyDataSet;
  lblTasksTotal.Caption := Format(MSGF_TASKS_LISTED,
    [oJSONArr.Count, FormatDateTime('dd/mm/yy hh:mm:ss', Now)]);

  for iTask := 0 to oJSONArr.Count-1 do
  begin
    oTask := TTask.FromJSON(oJSONArr.Items[iTask] as TJSONObject);
    cdsTasks.AppendRecord(
      [oTask.Id,
       oTask.Titulo,
       oTask.Descricao,
       oTask.Prioridade,
       oTask.Status,
       oTask.DataCriacao,
       DateTimeOrNUll(oTask.DataConclusao)]);
  end;
end;

end.
