object frmCadastroAutomatizado: TfrmCadastroAutomatizado
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro Automatizado'
  ClientHeight = 585
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 270
    Top = 300
    Width = 96
    Height = 22
    Alignment = taCenter
    Caption = '00:00:00'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
  end
  object btInserirBanco: TButton
    Left = 16
    Top = 302
    Width = 145
    Height = 25
    Caption = 'Inserir no Banco'
    Enabled = False
    TabOrder = 5
    OnClick = btInserirBancoClick
  end
  object DBGridBanco: TDBGrid
    Left = 16
    Top = 331
    Width = 604
    Height = 218
    DataSource = dtsBanco
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'idPessoa'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'flNatureza'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dtRegistro'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nmprimeiro'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nmsegundo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dsdocumento'
        Visible = True
      end>
  end
  object edDoc: TEdit
    Left = 16
    Top = 16
    Width = 121
    Height = 23
    TabOrder = 0
    Text = '1'
  end
  object edNome: TEdit
    Left = 143
    Top = 16
    Width = 121
    Height = 23
    TabOrder = 1
    Text = 'Nome'
  end
  object edSobrenome: TEdit
    Left = 270
    Top = 16
    Width = 121
    Height = 23
    TabOrder = 2
    Text = 'Sobrenome'
  end
  object DBGridLocal: TDBGrid
    Left = 16
    Top = 82
    Width = 604
    Height = 214
    DataSource = dtsGrid
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'dsdocumento'
        Title.Caption = 'Documento'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nmprimeiro'
        Title.Caption = 'Nome'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nmsegundo'
        Title.Caption = 'Sobrenome'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'flNatureza'
        Title.Caption = 'Natureza'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dtregistro'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'idpessoa'
        Visible = True
      end>
  end
  object btInserirGrid: TButton
    Left = 16
    Top = 51
    Width = 145
    Height = 25
    Caption = 'Inserir no Grid'
    TabOrder = 4
    OnClick = btInserirGridClick
  end
  object edQtd: TEdit
    Left = 568
    Top = 16
    Width = 52
    Height = 23
    NumbersOnly = True
    TabOrder = 3
    Text = '5'
  end
  object btSair: TButton
    Left = 545
    Top = 552
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 8
    OnClick = btSairClick
  end
  object btAtualizar: TButton
    Left = 16
    Top = 554
    Width = 161
    Height = 25
    Caption = 'Atualizar Grid Banco'
    TabOrder = 9
    OnClick = btAtualizarClick
  end
  object btExcluir: TButton
    Left = 545
    Top = 300
    Width = 75
    Height = 25
    Caption = 'Excluir All'
    TabOrder = 10
    OnClick = btExcluirClick
  end
  object dtsBanco: TDataSource
    DataSet = FDMT_Banco
    Left = 504
    Top = 336
  end
  object dtsGrid: TDataSource
    DataSet = FDMemTable
    Left = 488
    Top = 136
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 416
    Top = 136
    object FDMemTableflNatureza: TIntegerField
      FieldName = 'flNatureza'
    end
    object FDMemTabledsdocumento: TStringField
      FieldName = 'dsdocumento'
    end
    object FDMemTablenmprimeiro: TStringField
      FieldName = 'nmprimeiro'
    end
    object FDMemTablenmsegundo: TStringField
      FieldName = 'nmsegundo'
    end
    object FDMemTabledtregistro: TDateField
      FieldName = 'dtregistro'
    end
    object FDMemTableidpessoa: TIntegerField
      FieldName = 'idpessoa'
    end
  end
  object FDMT_Banco: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 432
    Top = 336
    object IntegerField1: TIntegerField
      FieldName = 'idPessoa'
    end
    object IntegerField2: TIntegerField
      FieldName = 'flNatureza'
    end
    object DateField1: TDateField
      FieldName = 'dtRegistro'
    end
    object FDMT_Banconmprimeiro: TStringField
      FieldName = 'nmprimeiro'
    end
    object FDMT_Banconmsegundo: TStringField
      FieldName = 'nmsegundo'
    end
    object FDMT_Bancodsdocumento: TStringField
      FieldName = 'dsdocumento'
    end
  end
end
