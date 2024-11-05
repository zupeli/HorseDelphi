unit uServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmServidor = class(TForm)
    Label1: TLabel;
    lbPorta: TLabel;
    btnStop: TBitBtn;
    btnStart: TBitBtn;
    edtPort: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    procedure Status;
    procedure Start;
    procedure Stop;
  public
    { Public declarations }
  end;

var
  frmServidor: TfrmServidor;

implementation

uses
  Horse, System.JSON, System.StrUtils, Rest.JSON,
  Horse.Jhonson, Horse.CORS,  Controller.rota.pessoa, Controller.rota.Integracao;

{$R *.dfm}

{ TForm1 }

procedure TfrmServidor.btnStartClick(Sender: TObject);
begin
  Start;
  Status;
end;

procedure TfrmServidor.btnStopClick(Sender: TObject);
begin
  Stop;
  Status;
end;

procedure TfrmServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if THorse.IsRunning then
    Stop;
end;

procedure TfrmServidor.Start;
begin
  THorse.Use(Jhonson());
  THorse.Use(Cors);

  Controller.rota.pessoa.RegistarRotas;
  Controller.rota.Integracao.RegistarRotaIntegracao;

  THorse.Listen(StrToInt(edtPort.Text));
end;

procedure TfrmServidor.Status;
begin
  btnStop.Enabled  := THorse.IsRunning;
  btnStart.Enabled := not THorse.IsRunning;
  edtPort.Enabled  := not THorse.IsRunning;
  if THorse.IsRunning then
  begin
    lbPorta.Caption  := 'Status >> Conectado (porta:' + Thorse.Port.ToString + ')';
  end
  else
  begin
    lbPorta.Caption  := 'Status >> Desconectado';
  end;
end;

procedure TfrmServidor.Stop;
begin
  THorse.StopListen;

end;

end.
