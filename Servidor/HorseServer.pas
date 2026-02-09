unit HorseServer;

interface

procedure StartServer;
procedure StopServer;

implementation

uses
  System.SysUtils, System.Classes, Horse, uTask.Api.Routes, uApi.Auth, uApi.MiddlewareError;

var
  othHorseThread: TThread;

procedure StartServer;
begin
  if Assigned(othHorseThread) then
    Exit;

  othHorseThread :=
    TThread.CreateAnonymousThread(
      procedure
      begin
        try
        THorse.Use(AuthMiddleware);
        THorse.Use(ErrorMiddleware);
        RegisterTaskRoutes;
        THorse.Listen(9000);
        except
          on E: Exception do
          begin
          end;
        end;
      end
    );

  othHorseThread.FreeOnTerminate := False;
  othHorseThread.Start;
end;

procedure StopServer;
begin
  if Assigned(othHorseThread) then
  begin
    THorse.StopListen;
    othHorseThread.Terminate;
    othHorseThread.WaitFor;
    FreeAndNil(othHorseThread);
  end;
end;

end.
