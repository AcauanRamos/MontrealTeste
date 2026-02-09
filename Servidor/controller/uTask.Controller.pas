unit uTask.Controller;

interface

uses
  Horse;

type
  TTaskController = class
  public
    class procedure Create(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
    class procedure Update(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
    class procedure UpdateStatus(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
    class procedure Delete(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
    class procedure Get(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
    class procedure GetAll(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);

    class procedure Dashboard(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
  end;

implementation

uses
  System.SysUtils, System.JSON, uTask.Service, uTask, uConstants, uExceptionHelper,
  uApi.ErrorResponse;

{ TTaskController }

{ POST /tasks }
class procedure TTaskController.Create(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  oService: TTaskService;
  oTask: TTask;
  oJSONObj: TJSONObject;
begin
  oJSONObj := TJSONObject.ParseJSONValue(oReq.Body) as TJSONObject;
  if not Assigned(oJSONObj) then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_INVALID_BODY).ToString)
         .Status(400);
    Exit;
  end;

  oTask := TTask.FromJSON(oJSONObj);
  oService := TTaskService.Create;
  try
    try
    oService.Insert(oTask);
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Status(201);
    except
      on E: Exception do
        oResp.ContentType(API_CONTENTTYPE_JSON)
             .Send(BuildError(E.Message).ToString)
             .Status(400);
    end;
  finally
    FreeAndNil(oTask);
    FreeAndNil(oService);
    FreeAndNil(oJSONObj);
  end;
end;

{ PUT /tasks/:id }
class procedure TTaskController.Update(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  oService: TTaskService;
  oTask: TTask;
  oJSONObj: TJSONObject;
  iId: Integer;
begin
  if not TryStrToInt(oReq.Params['id'], iId) then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_INVALID_ID).ToString)
         .Status(400);
    Exit;
  end;

  oJSONObj := TJSONObject.ParseJSONValue(oReq.Body) as TJSONObject;
  if not Assigned(oJSONObj) then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_INVALID_BODY).ToString)
         .Status(400);
    Exit;
  end;

  oTask := TTask.FromJSON(oJSONObj);
  oService := TTaskService.Create;
  try
    try
    oService.Update(iId, oTask);
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(oTask.ToJson.ToString)
         .Status(200);
    except
      on E: Exception do
        oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(E.Message).ToString)
         .Status(400);
    end;

  finally
    FreeAndNil(oTask);
    FreeAndNil(oService);
    FreeAndNil(oJSONObj);
  end;
end;

{ PUT /tasks/:id/status/:status }
class procedure TTaskController.UpdateStatus(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  oService: TTaskService;
  iId: Integer;
  sStatus: string;
begin
  if not TryStrToInt(oReq.Params['id'], iId) then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_INVALID_ID).ToString)
         .Status(400);
    Exit;
  end;

  sStatus := oReq.Params['status'].Trim;
  if sStatus.IsEmpty then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_STATUS_NOT_PROVIDED).ToString)
         .Status(400);
    Exit;
  end;

  oService := TTaskService.Create;
  try
    try
    oService.UpdateStatus(iId, sStatus);
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send('')
         .Status(200);
    except
      on E: Exception do
        oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(E.Message).ToString)
         .Status(400);
    end;
  finally
    FreeAndNil(oService);
  end;
end;

{ DELETE /tasks/:id }
class procedure TTaskController.Delete(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  oService: TTaskService;
  iId: Integer;
begin
  if not TryStrToInt(oReq.Params['id'], iId) then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_INVALID_ID).ToString)
         .Status(400);
    Exit;
  end;

  oService := TTaskService.Create;
  try
    try
    oService.Delete(iId);
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send('')
         .Status(204);
    except
    on E: Exception do
      oResp.ContentType(API_CONTENTTYPE_JSON)
           .Send(BuildError(E.Message).ToString)
           .Status(400);
    end;

  finally
    FreeAndNil(oService);
  end;
end;

{ GET /tasks/:id }
class procedure TTaskController.Get(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  oService: TTaskService;
  iId: Integer;
  oTask: TTask;
begin
  if not TryStrToInt(oReq.Params['id'], iId) then
  begin
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(ERROR_INVALID_ID).ToString)
         .Status(400);
    Exit;
  end;

  oService := TTaskService.Create;
  try
    try
    oTask := oService.Get(iId);
    if not Assigned(oTask) then
      oResp.ContentType(API_CONTENTTYPE_JSON)
           .Status(204)
    else
      oResp.ContentType(API_CONTENTTYPE_JSON)
           .Send(oTask.ToJSON.ToString)
           .Status(200);
    except
      on E: Exception do
        oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(E.Message).ToString)
         .Status(400);
    end;
  finally
    FreeAndNil(oService);
  end;
end;

{ GET /tasks }
class procedure TTaskController.GetAll(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  oService: TTaskService;
begin
  oService := TTaskService.Create;
  try
    try
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(oService.GetAll.ToString)
         .Status(200);
    except
      on E: Exception do
        oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(E.Message).ToString)
         .Status(400);
    end;
  finally
    FreeAndNil(oService);
  end;
end;

{ GET /tasks/dashboard }
class procedure TTaskController.Dashboard(oReq: THorseRequest;
  oResp: THorseResponse; Next: TProc);
var
  Service: TTaskService;
  Dashboard: TJSONObject;
begin
  Service := TTaskService.Create;
  try
    try
    Dashboard := Service.GetDashboard;
    oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(Dashboard.ToString)
         .Status(200);
    except
      on E: Exception do
        oResp.ContentType(API_CONTENTTYPE_JSON)
         .Send(BuildError(E.Message).ToString)
         .Status(400);
    end;
  finally
    FreeAndNil(Service);
    FreeAndNil(Dashboard);
  end;
end;


end.
