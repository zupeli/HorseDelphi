unit uEditarExcluir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmEditarExcluir = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edDocumento: TEdit;
    edNome: TEdit;
    Label2: TLabel;
    edSobrenome: TEdit;
    Label3: TLabel;
    rgNatureza: TRadioGroup;
    GridEndereco: TDBGrid;
    cdsEndereco: TFDMemTable;
    dtsEndereco: TDataSource;
    btSair: TButton;
    btExcluirPessoa: TButton;
    btEditarPessoa: TButton;
    btEditarEndereco: TButton;
    btExcluirEndereco: TButton;
    btInserirEndereco: TButton;
    procedure btSairClick(Sender: TObject);
    procedure btExcluirPessoaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridEnderecoCellClick(Column: TColumn);
    procedure btEditarPessoaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btEditarEnderecoClick(Sender: TObject);
    procedure btExcluirEnderecoClick(Sender: TObject);
    procedure btInserirEnderecoClick(Sender: TObject);
  private
    FidPessoa: Integer;
    fAcao    : Boolean;
    procedure TerminateExcluir(Sender: TObject);
    procedure GetEndereco;
    procedure IdentarGrid;
    procedure TerminateBusca(Sender: TObject);
    procedure TerminateEditar(Sender: TObject);
    procedure TerminateExcluirEndereco(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    property idPessoa  : Integer  read FidPessoa   write FidPessoa;
  end;

var
  frmEditarExcluir: TfrmEditarExcluir;

implementation

{$R *.dfm}

uses DataM, uThread, uEnderecoCad;

procedure TfrmEditarExcluir.btEditarEnderecoClick(Sender: TObject);
var
  vObjEndereco : TfrmEnderecoCad;
begin
  vObjEndereco := TfrmEnderecoCad.Create(nil);
  try
    vObjEndereco.edCEP.Text         := cdsEndereco.FieldByName('dscep'        ).AsString;
    vObjEndereco.edUF.Text          := cdsEndereco.FieldByName('dsuf'         ).AsString;
    vObjEndereco.edCidade.Text      := cdsEndereco.FieldByName('nmcidade'     ).AsString;
    vObjEndereco.edBairro.Text      := cdsEndereco.FieldByName('nmbairro'     ).AsString;
    vObjEndereco.edLogradouro.Text  := cdsEndereco.FieldByName('nmlogradouro' ).AsString;
    vObjEndereco.edComplemento.Text := cdsEndereco.FieldByName('dscomplemento').AsString;
    vObjEndereco.idEndereco         := cdsEndereco.FieldByName('idendereco'   ).AsInteger;
    vObjEndereco.idPessoa           := cdsEndereco.FieldByName('idpessoa'     ).AsInteger;
    if not cdsEndereco.IsEmpty then
    begin
//      vObjEndereco.tabEndereco := cdsEndereco;
      vObjEndereco.tabEndereco.insert;
      vObjEndereco.tabEnderecoidpessoa.AsInteger     := vObjEndereco.idPessoa;
      vObjEndereco.tabEnderecoidendereco.AsInteger   := vObjEndereco.idEndereco;
      vObjEndereco.tabEnderecodscep.AsString         := cdsEndereco.FieldByName('dscep'        ).AsString;;
      vObjEndereco.tabEnderecodsuf.AsString          := cdsEndereco.FieldByName('dsuf'         ).AsString;
      vObjEndereco.tabEndereconmcidade.AsString      := cdsEndereco.FieldByName('nmcidade'     ).AsString;
      vObjEndereco.tabEndereconmbairro.AsString      := cdsEndereco.FieldByName('nmbairro'     ).AsString;
      vObjEndereco.tabEndereconmlogradouro.AsString  := cdsEndereco.FieldByName('nmlogradouro' ).AsString;
      vObjEndereco.tabEnderecodscomplemento.AsString := cdsEndereco.FieldByName('dscomplemento').AsString;
      vObjEndereco.tabEndereco.Post;
    end;
    vObjEndereco.ShowModal;

    if Assigned(vObjEndereco.OnClose) then
    begin
      GetEndereco;
    end;
  finally
    FreeAndNil(vObjEndereco);
    fAcao := True;
  end;
end;

procedure TfrmEditarExcluir.btEditarPessoaClick(Sender: TObject);
var
  vDadosPessoa: TFDMemTable;
begin
  vDadosPessoa := TFDMemTable.Create(nil);
  vDadosPessoa.Close;
  vDadosPessoa.FieldDefs.Clear;
  vDadosPessoa.FieldDefs.Add('dsdocumento', ftString, 150, false);
  vDadosPessoa.FieldDefs.Add('nmprimeiro' , ftString, 200, false);
  vDadosPessoa.FieldDefs.Add('nmsegundo'  , ftString, 200, false);
  vDadosPessoa.FieldDefs.Add('flnatureza' , ftInteger,  0, false);
  vDadosPessoa.CreateDataSet;

  vDadosPessoa.Append;
  vDadosPessoa.FieldValues['dsdocumento'] := Trim(edDocumento.Text);
  vDadosPessoa.FieldValues['nmprimeiro' ] := Trim(edNome.Text);
  vDadosPessoa.FieldValues['nmsegundo'  ] := Trim(edSobrenome.Text);
  vDadosPessoa.FieldValues['flnatureza' ] := Trim(rgNatureza.ItemIndex.ToString);
  vDadosPessoa.Post;

  TMyThread.ExecuteThread(procedure
  begin
    if FidPessoa > 0 then
    begin
      DM.EditarPessoa(FidPessoa, vDadosPessoa);
    end;

  end, TerminateEditar);
end;

procedure TfrmEditarExcluir.TerminateEditar(Sender: TObject);
begin
  fAcao := True;

  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  ShowMessage('Dados editados com sucesso!');
end;

procedure TfrmEditarExcluir.btExcluirEnderecoClick(Sender: TObject);
begin
  TMyThread.ExecuteThread(procedure
  begin
    DM.ExcluirEndereco(FidPessoa, cdsEndereco.FieldByName('idendereco').AsInteger);

  end, TerminateExcluirEndereco);
end;

procedure TfrmEditarExcluir.TerminateExcluirEndereco(Sender: TObject);
begin
  fAcao := True;
  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  GetEndereco;
  ShowMessage('Endere�o excluido!');
  btExcluirEndereco.Enabled := False;
  btEditarEndereco.Enabled  := False;
end;

procedure TfrmEditarExcluir.btExcluirPessoaClick(Sender: TObject);
begin
  if not cdsEndereco.IsEmpty then
  begin
     ShowMessage('Existe endere�o associado a Pessoa. Exclua o endere�o antes!');
     Exit;
  end;


  TMyThread.ExecuteThread(procedure
  begin
    DM.ExcluirPessoa(FidPessoa);

  end, TerminateExcluir); //
end;

procedure TfrmEditarExcluir.btInserirEnderecoClick(Sender: TObject);
var
  vObjEndereco : TfrmEnderecoCad;
begin
  vObjEndereco := TfrmEnderecoCad.Create(nil);
  try
    vObjEndereco.idEndereco := 0;
    vObjEndereco.idPessoa   := FidPessoa;
    vObjEndereco.dsPessoa   := FidPessoa.ToString + ' - ' +
                               edNome.Text;
    vObjEndereco.ShowModal;

    if Assigned(vObjEndereco.OnClose) then
    begin
      GetEndereco;
    end;
  finally
    FreeAndNil(vObjEndereco);
    fAcao := True;
  end;
end;

procedure TfrmEditarExcluir.TerminateExcluir(Sender: TObject);
begin
  fAcao := True;
  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  idPessoa := 0;
  edDocumento.Text := '';
  edNome.Text := '';
  edSobrenome.Text := '';
  ShowMessage('Pessoa excluida!');
  btExcluirPessoa.Enabled := False;
  btEditarPessoa.Enabled  := False;
end;

procedure TfrmEditarExcluir.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditarExcluir.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if fAcao then
  begin
    Action := TCloseAction.caFree;
    frmEditarExcluir := nil;
  end;
end;

procedure TfrmEditarExcluir.FormShow(Sender: TObject);
begin
  fAcao := False;
  GetEndereco;
end;

procedure TfrmEditarExcluir.GetEndereco;
begin
  TMyThread.ExecuteThread(procedure
  begin
    // Acessar o servidor...
    GridEndereco.DataSource := nil;
    if FidPessoa <> 0 then
    begin
      DM.ListarEnderecoPessoa(cdsEndereco, FidPessoa);
    end;

    // Atualizar o DBGrid.
    Tthread.Synchronize(Tthread.CurrentThread, procedure
    begin
      GridEndereco.DataSource := dtsEndereco;
    end);
  end,
  TerminateBusca);

end;

procedure TfrmEditarExcluir.GridEnderecoCellClick(Column: TColumn);
begin
  btEditarEndereco.Enabled  := not cdsEndereco.IsEmpty;
  btExcluirEndereco.Enabled := not cdsEndereco.IsEmpty;
end;

procedure TfrmEditarExcluir.TerminateBusca(Sender: TObject);
begin
  IdentarGrid;
  btEditarEndereco.Enabled  := False;
  btExcluirEndereco.Enabled := False;

  if Sender is TThread then
    if Assigned(TThread(Sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;
end;

procedure TfrmEditarExcluir.IdentarGrid;
begin
  GridEndereco.DataSource := dtsEndereco;
  if not cdsEndereco.IsEmpty then
  begin
    GridEndereco.Columns[0].Width          := 60;   // id_endereco
    GridEndereco.Columns[0].Title.Caption  := 'ID';
    GridEndereco.Columns[1].Width          := 110;
    GridEndereco.Columns[1].Title.Caption  := 'CEP';
//    GridEndereco.Columns[2].Width          := 150;
    GridEndereco.Columns[2].Visible        := False; // id_pessoa
    GridEndereco.Columns[3].Width          := 50;
    GridEndereco.Columns[3].Title.Caption  := 'UF';
    GridEndereco.Columns[4].Width          := 120;
    GridEndereco.Columns[4].Title.Caption  := 'Cidade';
    GridEndereco.Columns[5].Width          := 150;
    GridEndereco.Columns[5].Title.Caption  := 'Bairro';
    GridEndereco.Columns[6].Width          := 150;
    GridEndereco.Columns[6].Title.Caption  := 'Logradouro';
    GridEndereco.Columns[7].Width          := 250;
    GridEndereco.Columns[7].Title.Caption  := 'Complemento';
  end;
end;

end.
