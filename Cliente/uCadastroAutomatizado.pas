unit uCadastroAutomatizado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, uThread, Vcl.ExtCtrls,
  DataM, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmCadastroAutomatizado = class(TForm)
    btInserirBanco: TButton;
    DBGridBanco: TDBGrid;
    dtsBanco: TDataSource;
    edDoc: TEdit;
    edNome: TEdit;
    edSobrenome: TEdit;
    DBGridLocal: TDBGrid;
    btInserirGrid: TButton;
    dtsGrid: TDataSource;
    edQtd: TEdit;
    btSair: TButton;
    Label1: TLabel;
    FDMemTable: TFDMemTable;
    FDMemTableflNatureza: TIntegerField;
    FDMT_Banco: TFDMemTable;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    DateField1: TDateField;
    btAtualizar: TButton;
    btExcluir: TButton;
    FDMemTabledsdocumento: TStringField;
    FDMemTablenmprimeiro: TStringField;
    FDMemTablenmsegundo: TStringField;
    FDMemTabledtregistro: TDateField;
    FDMemTableidpessoa: TIntegerField;
    FDMT_Banconmprimeiro: TStringField;
    FDMT_Banconmsegundo: TStringField;
    FDMT_Bancodsdocumento: TStringField;
    procedure btSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btInserirGridClick(Sender: TObject);
    procedure btInserirBancoClick(Sender: TObject);
    procedure btAtualizarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
  private
    FStart : TDateTime;
    procedure TerminateInserirGrid(Sender: TObject);
    procedure Loop;
    procedure TerminateInserirBanco(Sender: TObject);
    procedure RefreshBanco;
    procedure TerminateBusca(Sender: TObject);
    procedure TerminateExcluir(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroAutomatizado: TfrmCadastroAutomatizado;

implementation

{$R *.dfm}

procedure TfrmCadastroAutomatizado.btAtualizarClick(Sender: TObject);
begin
  RefreshBanco;
end;

procedure TfrmCadastroAutomatizado.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroAutomatizado.btExcluirClick(Sender: TObject);
begin
  FStart := Now;
  TMyThread.ExecuteThread(procedure
  begin
    btExcluir.Enabled := False;
    Label1.Caption := '';
    DM.ExcluirPessoaDropAll;

  end, TerminateExcluir); //
end;

procedure TfrmCadastroAutomatizado.TerminateExcluir(Sender: TObject);
begin
  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  btExcluir.Enabled := True;
  Label1.Caption := FormatDateTime('HH:nn:ss:zzz', Now-FStart);
//  ShowMessage('Registros da tabela pessoa excluido!');
//  RefreshBanco;
end;

procedure TfrmCadastroAutomatizado.FormCreate(Sender: TObject);
begin
//  cdsGrid.CreateDataSet;
  FDMemTable.CreateDataSet;
  FDMT_Banco.CreateDataSet;
end;

procedure TfrmCadastroAutomatizado.Loop;
var
  I, vQtd: Int64;
begin
  vQtd := StrToInt64Def(edQtd.Text,1);
  I := 1;
  for I := 1 to vQtd do
  begin
    FDMemTable.Insert;
    FDMemTabledsdocumento.Value := I.ToString;
    FDMemTableflNatureza.Value  := 0;
    FDMemTablenmprimeiro.Value  := edNome.Text      + ' ' + I.ToString;
    FDMemTablenmsegundo.Value   := edSobrenome.Text + ' ' + I.ToString;
    FDMemTabledtRegistro.Value  := Now;
    FDMemTableidpessoa.Value    := I;

    FDMemTable.Post;
    {
    cdsGrid.Insert;
    cdsGrididPessoa.Value    := I;
    cdsGridflNatureza.Value  := 0;
    cdsGriddsNome.Value      := edNome.Text      + ' ' + I.ToString;
    cdsGriddsSobrenome.Value := edSobrenome.Text + ' ' + I.ToString;
    cdsGriddtRegistro.Value  := Now;

    cdsGrid.Post;
    }
  end;
end;

procedure TfrmCadastroAutomatizado.btInserirBancoClick(Sender: TObject);
begin
  FStart := Now;
  TMyThread.ExecuteThread(procedure
  begin
    Label1.Caption := '';
    FDMemTable.DisableControls;
    BtInserirBanco.Enabled := False;
    DM.InserirPessoa(FDMemTable);
  end, TerminateInserirBanco);
end;

procedure TfrmCadastroAutomatizado.TerminateInserirBanco(Sender: TObject);
begin

  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;
  FDMemTable.EnableControls;
  Label1.Caption := FormatDateTime('HH:nn:ss:zzz', Now-FStart);
  btInserirBanco.Enabled := True;
//  ShowMessage('Dados Inseridos!')
end;

procedure TfrmCadastroAutomatizado.btInserirGridClick(Sender: TObject);
begin
  FStart := Now;
  FDMemTable.EmptyDataSet;
  TMyThread.ExecuteThread(procedure
  begin
    btInserirGrid.Enabled := False;
    Label1.Caption := '';
//    cdsGrid.EmptyDataSet;
//    cdsGrid.DisableControls;
    FDMemTable.DisableControls;
    Loop;
  end, TerminateInserirGrid);

end;

procedure TfrmCadastroAutomatizado.TerminateInserirGrid(Sender: TObject);
begin
//  cdsGrid.EnableControls;
  FDMemTable.EnableControls;
  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  Label1.Caption := FormatDateTime('HH:nn:ss:zzz', Now-FStart);
  btInserirGrid.Enabled := True;
  btInserirBanco.Enabled := True;
//  ShowMessage('Dados Inseridos.');
end;

procedure TfrmCadastroAutomatizado.RefreshBanco;
begin
  FStart := Now;
  DBGridBanco.DataSource := nil;
  TMyThread.ExecuteThread(procedure
  begin
    btAtualizar.Enabled := False;
    Label1.Caption := '';

    // Acessar o servidor...
    DM.ListarPessoas(FDMT_Banco, '');

    // Atualizar o DBGrid.
    Tthread.Synchronize(Tthread.CurrentThread, procedure
    begin
      DBGridBanco.DataSource := dtsBanco;
    end);
  end,
  TerminateBusca);

end;

procedure TfrmCadastroAutomatizado.TerminateBusca(Sender: TObject);
begin
//  IdentarGrid;

  if Sender is TThread then
    if Assigned(TThread(Sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  Label1.Caption := FormatDateTime('HH:nn:ss:zzz', Now-FStart);
  btAtualizar.Enabled := True;
end;

end.
