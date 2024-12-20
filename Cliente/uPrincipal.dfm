object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Sistema Horse - Cadastro de Pessoa'
  ClientHeight = 424
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object Button1: TButton
    Left = 558
    Top = 393
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 325
    Width = 625
    Height = 61
    TabOrder = 1
    object btCadastroPessoa: TButton
      Left = 16
      Top = 17
      Width = 121
      Height = 25
      Caption = 'Cadastrar Pessoa'
      TabOrder = 0
      OnClick = btCadastroPessoaClick
    end
    object btEditarExcluir: TButton
      Left = 278
      Top = 17
      Width = 113
      Height = 25
      Caption = 'Alterar/Apagar'
      Enabled = False
      TabOrder = 2
      OnClick = btEditarExcluirClick
    end
    object btCadEndereco: TButton
      Left = 149
      Top = 17
      Width = 116
      Height = 25
      Caption = 'Cadastrar Endere'#231'o'
      Enabled = False
      TabOrder = 1
      OnClick = btCadEnderecoClick
    end
    object btAutomatizado: TButton
      Left = 566
      Top = 17
      Width = 46
      Height = 25
      Caption = 'Auto'
      TabOrder = 3
      OnClick = btAutomatizadoClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 625
    Height = 313
    Caption = 'Pessoas Cadastradas'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 282
      Width = 44
      Height = 15
      Caption = 'Filtrar ID'
    end
    object Label2: TLabel
      Left = 138
      Top = 282
      Width = 66
      Height = 15
      Caption = 'Filtrar Nome'
    end
    object GridPessoa: TDBGrid
      Left = 9
      Top = 25
      Width = 603
      Height = 248
      DataSource = dtsPessoa
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnCellClick = GridPessoaCellClick
      OnDrawColumnCell = GridPessoaDrawColumnCell
      OnExit = GridPessoaExit
    end
    object btPesquisar: TButton
      Left = 504
      Top = 279
      Width = 108
      Height = 25
      Caption = 'Pesquisar Pessoa'
      TabOrder = 1
      OnClick = btPesquisarClick
    end
    object edID: TEdit
      Left = 64
      Top = 279
      Width = 60
      Height = 23
      NumbersOnly = True
      TabOrder = 2
      OnChange = edIDChange
      OnKeyPress = edIDKeyPress
    end
    object edNome: TEdit
      Left = 210
      Top = 279
      Width = 144
      Height = 23
      TabOrder = 3
      OnChange = edNomeChange
      OnKeyPress = edNomeKeyPress
    end
  end
  object cdsPessoa: TFDMemTable
    AfterOpen = cdsPessoaAfterOpen
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 464
    Top = 176
    object cdsPessoaidpessoa: TIntegerField
      FieldName = 'idpessoa'
    end
    object cdsPessoadsdocumento: TStringField
      FieldName = 'dsdocumento'
    end
    object cdsPessoanmprimeiro: TStringField
      FieldName = 'nmprimeiro'
    end
    object cdsPessoanmsegundo: TStringField
      FieldName = 'nmsegundo'
    end
    object cdsPessoadtregistro: TDateField
      FieldName = 'dtregistro'
    end
    object cdsPessoaflnatureza: TIntegerField
      Alignment = taLeftJustify
      FieldName = 'flnatureza'
      OnGetText = cdsPessoaflnaturezaGetText
    end
  end
  object dtsPessoa: TDataSource
    DataSet = cdsPessoa
    Left = 555
    Top = 177
  end
end
