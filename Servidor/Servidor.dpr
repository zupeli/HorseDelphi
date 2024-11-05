program Servidor;

uses
  Vcl.Forms,
  uServidor in 'uServidor.pas' {frmServidor},
  uPessoa in 'uPessoa.pas',
  uDataModulo in 'uDataModulo.pas' {DM: TDataModule},
  Controller.rota.pessoa in 'Controller.rota.pessoa.pas',
  uEndereco in 'uEndereco.pas',
  uIntegracao in 'uIntegracao.pas',
  Controller.rota.Integracao in 'Controller.rota.Integracao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServidor, frmServidor);
  Application.Run;
end.