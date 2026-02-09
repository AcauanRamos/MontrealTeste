unit uTask.Api.Routes;

interface

  procedure RegisterTaskRoutes;

implementation

uses
  Horse,
  uTask.Controller, uConstants, System.SysUtils;

procedure RegisterTaskRoutes;
begin
  { POST /tasks }
  THorse.Post(API_ROUTE_TASKS, TTaskController.Create);
  { PUT /tasks/:id }
  THorse.Put( Format('%s/:id', [API_ROUTE_TASKS]), TTaskController.Update);
  { PUT /tasks/:id/status/:status }
  THorse.Put( Format('%s/:id%s/:status', [API_ROUTE_TASKS, API_ROUTE_STATUS]), TTaskController.UpdateStatus);
  { DELETE /tasks/:id }
  THorse.Delete( Format('%s/:id', [API_ROUTE_TASKS]), TTaskController.Delete);
  { GET /tasks }
  THorse.Get(API_ROUTE_TASKS, TTaskController.GetAll);
  { GET /tasks/:id }
  THorse.Get( Format('%s/:id',[API_ROUTE_TASKS]), TTaskController.Get);
  { GET /tasks/dashboard }
  THorse.Get( Format('%s%s', [API_ROUTE_TASKS, API_ROUTE_DASHBOARD]), TTaskController.Dashboard);
end;

end.
