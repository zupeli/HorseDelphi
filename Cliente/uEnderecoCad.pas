unit uEnderecoCad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls,
  Vcl.Samples.Gauges, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmEnderecoCad = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Gauge1: TGauge;
    edCEP: TMaskEdit;
    edUF: TEdit;
    edCidade: TEdit;
    edBairro: TEdit;
    edLogradouro: TEdit;
    edComplemento: TEdit;
    btSalvar: TButton;
    btSair: TButton;
    tabEndereco: TFDMemTable;
    tabEnderecoidpessoa: TIntegerField;
    tabEnderecoidendereco: TIntegerField;
    tabEnderecodscep: TStringField;
    tabEnderecodsuf: TStringField;
    tabEndereconmcidade: TStringField;
    tabEndereconmbairro: TStringField;
    tabEndereconmlogradouro: TStringField;
    tabEnderecodscomplemento: TStringField;
    procedure btSalvarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edCEPExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FidEndereco: Integer;
    FidPessoa: Integer;
    FdsCEP: String;
    FflAtualizarCEP: Boolean;
    FdsPessoa: String;
    function SomenteNumero(str: string): string;
    procedure SetDados;
    procedure TerminateSalvar(Sender: TObject);
    procedure ConsultarCEP(cep: string);
    { Private declarations }
  public
    { Public declarations }
    property idEndereco     : Integer  read FidEndereco      write FidEndereco;
    property idPessoa       : Integer  read FidPessoa        write FidPessoa;
    property dsCEP          : String   read FdsCEP           write FdsCEP;
    property dsPessoa       : String   read FdsPessoa        write FdsPessoa;
    property flAtualizarCEP : Boolean  read FflAtualizarCEP  write FflAtualizarCEP;
  end;

var
  frmEnderecoCad: TfrmEnderecoCad;

implementation

uses uThread, DataM;

{$R *.dfm}

procedure TfrmEnderecoCad.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEnderecoCad.btSalvarClick(Sender: TObject);
begin
  if SomenteNumero(edCEP.Text).Length <> 8 then
  begin
    ShowMessage('CEP inv�lido');
    exit;
  end;

  TMyThread.ExecuteThread(procedure
  begin
    SetDados;
    if FidEndereco = 0 then
    begin
      DM.InserirEndereco(tabEndereco);
    end
    else
    if FidEndereco > 0 then
    begin
      DM.EditarEndereco(FidEndereco, tabEndereco, FflAtualizarCEP);
    end;

  end, TerminateSalvar);
end;

procedure TfrmEnderecoCad.edCEPExit(Sender: TObject);
begin
  if (SomenteNumero(edCEP.Text) <> '') and
     (SomenteNumero(edCEP.Text) <> SomenteNumero(tabEndereco.FieldByName('dscep').AsString))  then
  begin
    ConsultarCEP(edCEP.Text);
  end;
end;

procedure TfrmEnderecoCad.ConsultarCEP(cep: string);
var
  vDM : TDM;
begin
  if SomenteNumero(edCEP.Text).Length <> 8 then
  begin
      ShowMessage('CEP inv�lido');
      exit;
  end;

  vDM := TDM.Create(self);
  try
    vDM.RESTRequest1.Resource := SomenteNumero(edCEP.Text) + '/json';
    try
      vDM.RESTRequest1.Execute;
    except
    end;

    if vDM.RESTRequest1.Response.StatusCode = 200 then
    begin
      if vDM.RESTRequest1.Response.Content.IndexOf('erro') > 0 then
          ShowMessage('CEP n�o encontrado')
      else
      begin
        try
          edUF.Text          := vDM.MemTable.FieldByName('uf'         ).AsString;
          edCidade.Text      := vDM.MemTable.FieldByName('localidade' ).AsString;
          edBairro.Text      := vDM.MemTable.FieldByName('bairro'     ).AsString;
          edLogradouro.Text  := vDM.MemTable.FieldByName('logradouro' ).AsString;
          edComplemento.Text := vDM.MemTable.FieldByName('complemento').AsString;
        except
          ShowMessage('Erro ao carregar informa��es!');
        end;
      end;
    end
    else
        ShowMessage('Erro ao consultar CEP');
  finally
    FreeAndNil(vDM);
  end;
end;

procedure TfrmEnderecoCad.TerminateSalvar(Sender: TObject);
begin

  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  ShowMessage('Endere�o salvo com sucesso!');
end;

procedure TfrmEnderecoCad.SetDados;
begin
  tabEndereco.EmptyDataSet;
  tabEndereco.insert;
  tabEnderecoidpessoa.AsInteger     := FidPessoa;
  tabEnderecoidendereco.AsInteger   := FidEndereco;
  tabEnderecodscep.AsString         := Trim(edCEP.Text);
  tabEnderecodsuf.AsString          := Trim(edUF.Text);
  tabEndereconmcidade.AsString      := Trim(edCidade.Text);
  tabEndereconmbairro.AsString      := Trim(edBairro.Text);
  tabEndereconmlogradouro.AsString  := Trim(edLogradouro.Text);
  tabEnderecodscomplemento.AsString := Trim(edComplemento.Text);
  tabEndereco.Post;

  if FidEndereco > 0 then // se � edi��o
  begin
    if fdsCEP <> SomenteNumero(edCEP.Text) then
    begin
      // atualiza a tabela endereco
      FflAtualizarCEP := True;
    end
    else
    begin
      FflAtualizarCEP := False;
    end;
  end;
end;

procedure TfrmEnderecoCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmEnderecoCad := nil;
end;

procedure TfrmEnderecoCad.FormCreate(Sender: TObject);
begin
  tabEndereco.CreateDataSet;
  dsCEP := '';
end;

procedure TfrmEnderecoCad.FormShow(Sender: TObject);
begin
  if FidEndereco = 0 then
  begin
    frmEnderecoCad.Caption := 'Inserir Endere�o';
  end
  else
  begin
    frmEnderecoCad.Caption := 'Editar Endere�o';
    dsCEP                  := SomenteNumero(edCEP.Text);
  end;

end;

function TfrmEnderecoCad.SomenteNumero(str : string) : string;
var
    x : integer;
begin
    Result := '';
    for x := 0 to Length(str) - 1 do
        if (str.Chars[x] In ['0'..'9']) then
            Result := Result + str.Chars[x];

  Result := Trim(StringReplace(Result, '-', '', [rfReplaceAll, rfIgnoreCase]));
end;



end.
