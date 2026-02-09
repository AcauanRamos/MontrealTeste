unit ServiceMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TSVCMontrealTeste = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  SVCMontrealTeste: TSVCMontrealTeste;

implementation

uses
  HorseServer;

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SVCMontrealTeste.Controller(CtrlCode);
end;

function TSVCMontrealTeste.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TSVCMontrealTeste.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Started := True;

  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        StartServer;
      except
        on E: Exception do
        begin
          // depois podemos logar
        end;
      end;
    end
  ).Start;
end;

procedure TSVCMontrealTeste.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  StopServer;
  Stopped := True;
end;

end.
