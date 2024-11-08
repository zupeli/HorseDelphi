object FrmPessoaCad: TFrmPessoaCad
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Pessoa'
  ClientHeight = 181
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 456
    Height = 129
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
      Left = 8
      Top = 63
      Width = 185
      Height = 48
      Caption = 'Tipo de Pessoa'
      Columns = 2
      Items.Strings = (
        'F'#237'sica'
        'Jur'#237'dica')
      TabOrder = 3
    end
  end
  object btSalvar: TButton
    Left = 8
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 1
    OnClick = btSalvarClick
  end
  object btSair: TButton
    Left = 389
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = btSairClick
  end
  object TabPessoaCad: TFDMemTable
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
    Left = 385
    Top = 76
    object TabPessoaCaddsdocumento: TIntegerField
      FieldName = 'dsdocumento'
    end
    object TabPessoaCadnmprimeiro: TStringField
      FieldName = 'nmprimeiro'
    end
    object TabPessoaCadnmsegundo: TStringField
      FieldName = 'nmsegundo'
    end
    object TabPessoaCadflnatureza: TIntegerField
      FieldName = 'flnatureza'
    end
  end
end
