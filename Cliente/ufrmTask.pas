unit ufrmTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.NumberBox;

type
  TfrmTask = class(TForm)
    edtTitulo: TLabeledEdit;
    edtStatus: TLabeledEdit;
    edtDataCriacao: TLabeledEdit;
    edtDataConclusao: TLabeledEdit;
    edtPrioridade: TNumberBox;
    Label1: TLabel;
    memDescricao: TMemo;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTask: TfrmTask;

implementation

{$R *.dfm}

end.
