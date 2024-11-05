program ClienteHorse;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  DataM in 'DataM.pas' {DM: TDataModule},
  uPessoaCad in 'uPessoaCad.pas' {FrmPessoaCad},
  uEnderecoCad in 'uEnderecoCad.pas' {frmEnderecoCad},
  uThread in 'uThread.pas',
  uEditarExcluir in 'uEditarExcluir.pas' {frmEditarExcluir};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmEditarExcluir, frmEditarExcluir);
  Application.Run;
end.
