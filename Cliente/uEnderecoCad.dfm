object frmEnderecoCad: TfrmEnderecoCad
  Left = 0
  Top = 0
  Caption = 'Cadastro de Endere'#231'o'
  ClientHeight = 255
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 1
    Top = 8
    Width = 576
    Height = 205
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 7
      Width = 21
      Height = 15
      Caption = 'CEP'
    end
    object Label5: TLabel
      Left = 8
      Top = 67
      Width = 14
      Height = 15
      Caption = 'UF'
    end
    object Label6: TLabel
      Left = 50
      Top = 67
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object Label7: TLabel
      Left = 177
      Top = 67
      Width = 31
      Height = 15
      Caption = 'Bairro'
    end
    object Label8: TLabel
      Left = 343
      Top = 67
      Width = 62
      Height = 15
      Caption = 'Logradouro'
    end
    object Label9: TLabel
      Left = 8
      Top = 113
      Width = 77
      Height = 15
      Caption = 'Complemento'
    end
    object Gauge1: TGauge
      Left = 8
      Top = 178
      Width = 557
      Height = 21
      ForeColor = clTeal
      Progress = 0
      Visible = False
    end
    object edCEP: TMaskEdit
      Left = 8
      Top = 24
      Width = 70
      Height = 23
      EditMask = '00000\-999;1;_'
      MaxLength = 9
      TabOrder = 0
      Text = '     -   '
      OnExit = edCEPExit
    end
    object edUF: TEdit
      Left = 8
      Top = 84
      Width = 35
      Height = 23
      CharCase = ecUpperCase
      MaxLength = 2
      TabOrder = 1
    end
    object edCidade: TEdit
      Left = 50
      Top = 84
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object edBairro: TEdit
      Left = 177
      Top = 84
      Width = 160
      Height = 23
      TabOrder = 3
    end
    object edLogradouro: TEdit
      Left = 343
      Top = 84
      Width = 222
      Height = 23
      TabOrder = 4
    end
    object edComplemento: TEdit
      Left = 8
      Top = 130
      Width = 329
      Height = 23
      TabOrder = 5
    end
  end
  object btSalvar: TButton
    Left = 1
    Top = 222
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 1
    OnClick = btSalvarClick
  end
  object btSair: TButton
    Left = 502
    Top = 222
    Width = 75
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = btSairClick
  end
  object tabEndereco: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 473
    Top = 32
    object tabEnderecoidpessoa: TIntegerField
      FieldName = 'idpessoa'
    end
    object tabEnderecoidendereco: TIntegerField
      FieldName = 'idendereco'
    end
    object tabEnderecodscep: TStringField
      FieldName = 'dscep'
    end
    object tabEnderecodsuf: TStringField
      FieldName = 'dsuf'
    end
    object tabEndereconmcidade: TStringField
      FieldName = 'nmcidade'
    end
    object tabEndereconmbairro: TStringField
      FieldName = 'nmbairro'
    end
    object tabEndereconmlogradouro: TStringField
      FieldName = 'nmlogradouro'
    end
    object tabEnderecodscomplemento: TStringField
      FieldName = 'dscomplemento'
    end
  end
end
