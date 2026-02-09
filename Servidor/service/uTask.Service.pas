unit uTask.Service;

interface

uses
  uTask, uTask.Repository.Intf, uTaskRepository.Factory, JSON,
  System.Generics.Collections;

type
  TTaskService = class
  private
    FRepo: ITaskRepository;
  public
    constructor Create;

    procedure Insert(oTask: TTask);
    procedure Update(iId: Integer; oTask: TTask);
    procedure UpdateStatus(iId: Integer; sStatus: string);
    procedure Delete(iId: Integer);
    function GetAll: TJSONArray;
    function Get(iId: Integer): TTask;
    function GetDashboard: TJSONObject;
  end;

implementation

uses
  System.SysUtils, uConstants, uExceptionHelper;

{ TTaskService }

constructor TTaskService.Create;
begin
  FRepo := TRepositoryFactory.TaskRepository;
end;

procedure TTaskService.Insert(oTask: TTask);
begin
  if oTask.DataCriacao = 0 then
    oTask.DataCriacao := Now;
  FRepo.Insert(oTask);
end;

procedure TTaskService.Update(iId: Integer; oTask: TTask);
begin
  if not Assigned(FRepo.Get(iId)) then
    raise EBusinessException.Create(MSG_TASK_ID_PROVIDED_NOTFOUND);

  FRepo.Update(iId, oTask);
end;

procedure TTaskService.UpdateStatus(iId: Integer; sStatus: string);
begin
  if not Assigned(FRepo.Get(iId)) then
    raise EBusinessException.Create(MSG_TASK_ID_PROVIDED_NOTFOUND);

  FRepo.UpdateStatus(iId, sStatus);
end;

procedure TTaskService.Delete(iId: Integer);
begin
  if not Assigned(FRepo.Get(iId)) then
    raise EBusinessException.Create(MSG_TASK_ID_PROVIDED_NOTFOUND);

  FRepo.Delete(iId);
end;

function TTaskService.Get(iId: Integer): TTask;
begin
  if not Assigned(FRepo.Get(iId)) then
    raise EBusinessException.Create(MSG_TASK_ID_PROVIDED_NOTFOUND);

  Result := FRepo.Get(iId);
end;

function TTaskService.GetAll: TJSONArray;
var
  iTask: Integer;
  oTaskList: TList<TTask>;
begin
  Result := TJSONArray.Create;
  oTaskList := FRepo.GetAll;
  try
  for iTask := 0 to oTaskList.Count-1 do
    Result.AddElement(oTaskList[iTask].ToJSON);

  finally
    FreeAndNil(oTaskList);
  end;
end;

function TTaskService.GetDashboard: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair(FIELD_STATISTICS_total, TJSONNumber.Create(FRepo.TotalTasks));
  Result.AddPair(FIELD_STATISTICS_mediaPrioridadePendentes, TJSONNumber.Create(FRepo.AvgPriorityPending));
  Result.AddPair(FIELD_STATISTICS_concluidas7Dias, TJSONNumber.Create(FRepo.DoneLast7Days));
end;


end.
