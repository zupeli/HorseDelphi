object frmEditarExcluir: TfrmEditarExcluir
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Pessoa/Endere'#231'o'
  ClientHeight = 464
  ClientWidth = 588
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 584
    Height = 101
    Caption = 'Pessoa'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 63
      Height = 15
      Caption = 'Documento'
    end
    object Label2: TLabel
      Left = 133
      Top = 17
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object Label3: TLabel
      Left = 262
      Top = 17
      Width = 61
      Height = 15
      Caption = 'Sobrenome'
    end
    object edDocumento: TEdit
      Left = 8
      Top = 34
      Width = 118
      Height = 23
      NumbersOnly = True
      TabOrder = 0
    end
    object edNome: TEdit
      Left = 133
      Top = 34
      Width = 121
      Height = 23
      TabOrder = 1
    end
    object edSobrenome: TEdit
      Left = 262
      Top = 34
      Width = 179
      Height = 23
      TabOrder = 2
    end
    object rgNatureza: TRadioGroup
      Left = 447
      Top = 9
      Width = 129
      Height = 48
      Caption = 'Tipo de Pessoa'
      Columns = 2
      Items.Strings = (
        'F'#237'sica'
        'Jur'#237'dica')
      TabOrder = 3
    end
    object btExcluirPessoa: TButton
      Left = 464
      Top = 66
      Width = 112
      Height = 25
      Caption = 'Excluir Pessoa'
      TabOrder = 5
      OnClick = btExcluirPessoaClick
    end
    object btEditarPessoa: TButton
      Left = 365
      Top = 66
      Width = 93
      Height = 25
      Caption = 'Editar Pessoa'
      TabOrder = 4
      OnClick = btEditarPessoaClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 102
    Width = 584
    Height = 320
    Caption = 'Endere'#231'o'
    TabOrder = 1
    object GridEndereco: TDBGrid
      Left = 8
      Top = 18
      Width = 568
      Height = 263
      DataSource = dtsEndereco
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnCellClick = GridEnderecoCellClick
    end
    object btEditarEndereco: TButton
      Left = 359
      Top = 287
      Width = 93
      Height = 25
      Caption = 'Editar Endere'#231'o'
      TabOrder = 1
      OnClick = btEditarEnderecoClick
    end
    object btExcluirEndereco: TButton
      Left = 464
      Top = 287
      Width = 112
      Height = 25
      Caption = 'Excluir Endere'#231'o'
      TabOrder = 2
      OnClick = btExcluirEnderecoClick
    end
    object btInserirEndereco: TButton
      Left = 252
      Top = 287
      Width = 93
      Height = 25
      Caption = 'Inserir Endere'#231'o'
      TabOrder = 3
      OnClick = btInserirEnderecoClick
    end
  end
  object btSair: TButton
    Left = 509
    Top = 430
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = btSairClick
  end
  object cdsEndereco: TFDMemTable
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
    Left = 424
    Top = 184
  end
  object dtsEndereco: TDataSource
    DataSet = cdsEndereco
    Left = 515
    Top = 185
  end
end
