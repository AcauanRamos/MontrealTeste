object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Tarefas Montreal - Teste'
  ClientHeight = 411
  ClientWidth = 1044
  Color = clBtnFace
  Constraints.MaxWidth = 1060
  Constraints.MinHeight = 450
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    1044
    411)
  TextHeight = 15
  object lblTasksTotal: TLabel
    Left = 12
    Top = 131
    Width = 91
    Height = 15
    Caption = 'Tarefas listadas: 0'
  end
  object edtUrl: TLabeledEdit
    Left = 12
    Top = 32
    Width = 241
    Height = 23
    EditLabel.Width = 55
    EditLabel.Height = 15
    EditLabel.Caption = 'Url servi'#231'o'
    TabOrder = 0
    Text = 'http://localhost:9000'
  end
  object btnGetAllTasks: TBitBtn
    Left = 12
    Top = 80
    Width = 113
    Height = 25
    Caption = 'Listar tarefas'
    TabOrder = 1
    OnClick = btnGetAllTasksClick
  end
  object gridTasks: TDBGrid
    Left = 12
    Top = 152
    Width = 1034
    Height = 135
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsTasks
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = gridTasksCellClick
    OnDrawColumnCell = gridTasksDrawColumnCell
    OnMouseMove = gridTasksMouseMove
    Columns = <
      item
        Expanded = False
        FieldName = 'Titulo'
        Title.Caption = 'T'#237'tulo'
        Width = 145
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Prioridade'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Status'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DataCriacao'
        Title.Caption = 'Criada em'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DataConclusao'
        Title.Caption = 'Conclu'#237'da em'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Alterar'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Excluir'
        Width = 70
        Visible = True
      end>
  end
  object btnNewTask: TBitBtn
    Left = 148
    Top = 80
    Width = 113
    Height = 25
    Caption = 'Nova tarefa'
    TabOrder = 3
    OnClick = btnNewTaskClick
  end
  object gbTasksInfo: TGroupBox
    Left = 12
    Top = 298
    Width = 1034
    Height = 80
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' Estat'#237'ticas das tarefas '
    TabOrder = 4
    ExplicitTop = 273
    ExplicitWidth = 1026
    object edtTasksTotal: TLabeledEdit
      Left = 174
      Top = 41
      Width = 211
      Height = 23
      Alignment = taRightJustify
      EditLabel.Width = 102
      EditLabel.Height = 15
      EditLabel.Caption = 'Tarefas cadastradas'
      ReadOnly = True
      TabOrder = 0
      Text = ''
    end
    object edtPendingTasksPriorityAvg: TLabeledEdit
      Left = 406
      Top = 41
      Width = 211
      Height = 23
      Alignment = taRightJustify
      EditLabel.Width = 202
      EditLabel.Height = 15
      EditLabel.Caption = 'Prioridade m'#233'dia de tarefas pendentes'
      ReadOnly = True
      TabOrder = 1
      Text = ''
    end
    object edtFinishedTasks7Days: TLabeledEdit
      Left = 639
      Top = 41
      Width = 211
      Height = 23
      Alignment = taRightJustify
      EditLabel.Width = 195
      EditLabel.Height = 15
      EditLabel.Caption = 'Tarefas conclu'#237'das nos '#250'ltimos 7 dias'
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object btnDasboard: TBitBtn
      Left = 19
      Top = 39
      Width = 144
      Height = 25
      Caption = 'Carregar estat'#237'sticas'
      TabOrder = 3
      OnClick = btnDasboardClick
    end
  end
  object edtApiKey: TLabeledEdit
    Left = 300
    Top = 32
    Width = 241
    Height = 23
    EditLabel.Width = 40
    EditLabel.Height = 15
    EditLabel.Caption = 'Api Key'
    TabOrder = 5
    Text = #39'minha-chave-secreta'#39
  end
  object cdsTasks: TClientDataSet
    PersistDataPacket.Data = {
      B60000009619E0BD010000001800000007000000000003000000B60002496404
      0001000000000006546974756C6F010049000000010005574944544802000200
      C8000944657363726963616F020049000000010005574944544802000200E803
      0A5072696F726964616465040001000000000006537461747573010049000000
      01000557494454480200020014000B446174614372696163616F080008000000
      00000D44617461436F6E636C7573616F08000800000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'Titulo'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'Descricao'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'Prioridade'
        DataType = ftInteger
      end
      item
        Name = 'Status'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DataCriacao'
        DataType = ftDateTime
      end
      item
        Name = 'DataConclusao'
        DataType = ftDateTime
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    OnCalcFields = cdsTasksCalcFields
    Left = 68
    Top = 216
    object cdsTasksId: TIntegerField
      FieldName = 'Id'
    end
    object cdsTasksTitulo: TStringField
      FieldName = 'Titulo'
      Size = 200
    end
    object cdsTasksDescricao: TStringField
      FieldName = 'Descricao'
      Size = 1000
    end
    object cdsTasksPrioridade: TIntegerField
      FieldName = 'Prioridade'
    end
    object cdsTasksStatus: TStringField
      FieldName = 'Status'
    end
    object cdsTasksDataCriacao: TDateTimeField
      FieldName = 'DataCriacao'
    end
    object cdsTasksDataConclusao: TDateTimeField
      FieldName = 'DataConclusao'
    end
    object cdsTasksAlterar: TStringField
      FieldKind = fkCalculated
      FieldName = 'Alterar'
      Calculated = True
    end
    object cdsTasksExcluir: TStringField
      FieldKind = fkCalculated
      FieldName = 'Excluir'
      Calculated = True
    end
  end
  object dsTasks: TDataSource
    AutoEdit = False
    DataSet = cdsTasks
    Left = 100
    Top = 256
  end
end
