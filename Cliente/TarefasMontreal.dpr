program TarefasMontreal;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  uTask in '..\Comum\model\uTask.pas',
  ufrmTask in 'ufrmTask.pas' {frmTask},
  uConstants in '..\Comum\uConstants.pas',
  uExceptionHelper in '..\Comum\uExceptionHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTask, frmTask);
  Application.Run;
end.
