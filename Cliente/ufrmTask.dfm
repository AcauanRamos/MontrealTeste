object frmTask: TfrmTask
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tarefa'
  ClientHeight = 211
  ClientWidth = 634
  Color = clBtnFace
  Constraints.MaxHeight = 500
  Constraints.MaxWidth = 900
  Constraints.MinHeight = 250
  Constraints.MinWidth = 650
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  DesignSize = (
    634
    211)
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 70
    Width = 54
    Height = 15
    Caption = 'Prioridade'
  end
  object Label2: TLabel
    Left = 304
    Top = 19
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object edtTitulo: TLabeledEdit
    Left = 8
    Top = 37
    Width = 276
    Height = 23
    EditLabel.Width = 31
    EditLabel.Height = 15
    EditLabel.Caption = 'T'#237'tulo'
    MaxLength = 200
    TabOrder = 0
    Text = ''
  end
  object edtStatus: TLabeledEdit
    Left = 104
    Top = 88
    Width = 180
    Height = 23
    EditLabel.Width = 32
    EditLabel.Height = 15
    EditLabel.Caption = 'Status'
    MaxLength = 20
    TabOrder = 3
    Text = ''
  end
  object edtDataCriacao: TLabeledEdit
    Left = 8
    Top = 139
    Width = 132
    Height = 23
    EditLabel.Width = 54
    EditLabel.Height = 15
    EditLabel.Caption = 'Criada em'
    TabOrder = 4
    Text = ''
  end
  object edtDataConclusao: TLabeledEdit
    Left = 152
    Top = 139
    Width = 132
    Height = 23
    EditLabel.Width = 74
    EditLabel.Height = 15
    EditLabel.Caption = 'Conclu'#237'da em'
    TabOrder = 5
    Text = ''
  end
  object edtPrioridade: TNumberBox
    Left = 8
    Top = 88
    Width = 72
    Height = 23
    MaxValue = 255.000000000000000000
    TabOrder = 2
    Value = 1.000000000000000000
  end
  object memDescricao: TMemo
    Left = 304
    Top = 37
    Width = 308
    Height = 125
    Anchors = [akLeft, akTop, akRight, akBottom]
    MaxLength = 1000
    ScrollBars = ssVertical
    TabOrder = 1
    ExplicitWidth = 300
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 174
    Width = 634
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    ExplicitTop = 149
    ExplicitWidth = 626
    DesignSize = (
      634
      37)
    object btnOK: TButton
      Left = 450
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 442
    end
    object btnCancel: TButton
      Left = 537
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 529
    end
  end
end
