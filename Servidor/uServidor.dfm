object frmServidor: TfrmServidor
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Servidor'
  ClientHeight = 122
  ClientWidth = 223
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 19
    Width = 25
    Height = 15
    Caption = 'Port:'
  end
  object lbPorta: TLabel
    Left = 8
    Top = 45
    Width = 129
    Height = 15
    Caption = 'Status >> Desconectado'
  end
  object btnStop: TBitBtn
    Left = 125
    Top = 89
    Width = 90
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 0
    OnClick = btnStopClick
  end
  object btnStart: TBitBtn
    Left = 8
    Top = 89
    Width = 90
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object edtPort: TEdit
    Left = 38
    Top = 16
    Width = 60
    Height = 23
    NumbersOnly = True
    TabOrder = 2
    Text = '8080'
  end
end
