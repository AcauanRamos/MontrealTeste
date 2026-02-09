program TaskService;

uses
  Vcl.SvcMgr,
  ServiceMain in 'ServiceMain.pas' {SVCMontrealTeste: TService},
  uTask in '..\Comum\model\uTask.pas',
  uTask.Repository.Intf in 'repository\uTask.Repository.Intf.pas',
  uTaskRepository.Factory in 'repository\uTaskRepository.Factory.pas',
  uTask.Repository.SQL in 'repository\uTask.Repository.SQL.pas',
  uTask.Service in 'service\uTask.Service.pas',
  uTask.Api.Routes in 'api\uTask.Api.Routes.pas',
  uTask.Controller in 'controller\uTask.Controller.pas',
  uApi.Auth in 'api\uApi.Auth.pas',
  uDBConnection in 'utils\uDBConnection.pas',
  uConstants in '..\Comum\uConstants.pas',
  HorseServer in 'HorseServer.pas',
  uApi.MiddlewareError in 'api\uApi.MiddlewareError.pas',
  uApi.ErrorResponse in 'api\uApi.ErrorResponse.pas',
  uExceptionHelper in '..\Comum\uExceptionHelper.pas';

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TSVCMontrealTeste, SVCMontrealTeste);
  Application.Run;
end.
