unit uPessoaCad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls,
  Vcl.Samples.Gauges, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFrmPessoaCad = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edDocumento: TEdit;
    edNome: TEdit;
    edSobrenome: TEdit;
    rgNatureza: TRadioGroup;
    btSalvar: TButton;
    btSair: TButton;
    TabPessoaCad: TFDMemTable;
    TabPessoaCaddsdocumento: TIntegerField;
    TabPessoaCadnmprimeiro: TStringField;
    TabPessoaCadnmsegundo: TStringField;
    TabPessoaCadflnatureza: TIntegerField;
    procedure btSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btSairClick(Sender: TObject);
  private
    FidPessoa: Integer;
    procedure TerminateSalvar(Sender: TObject);
    procedure SetDados;
    { Private declarations }
  public
    { Public declarations }

    property idPessoa  : Integer  read FidPessoa   write FidPessoa;
  end;

var
  FrmPessoaCad: TFrmPessoaCad;

implementation

uses  DataM, uThread;

{$R *.dfm}

procedure TFrmPessoaCad.FormCreate(Sender: TObject);
begin
  TabPessoaCad.CreateDataSet;
end;

procedure TFrmPessoaCad.SetDados;
begin
  TabPessoaCad.EmptyDataSet;
  TabPessoaCad.Insert;
  TabPessoaCaddsdocumento.AsInteger := StrToIntDef(edDocumento.Text,0);
  TabPessoaCadnmprimeiro.AsString   := Trim(edNome.Text);
  TabPessoaCadnmsegundo.AsString    := Trim(edSobrenome.Text);
  TabPessoaCadflnatureza.AsInteger  := rgNatureza.ItemIndex;
  TabPessoaCad.Post;

end;

procedure TFrmPessoaCad.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPessoaCad.btSalvarClick(Sender: TObject);
begin
  TMyThread.ExecuteThread(procedure
  begin
    if FidPessoa = 0 then
    begin
      SetDados;
      DM.InserirPessoa(TabPessoaCad);
    end
    else
    begin
      DM.EditarPessoa(FidPessoa, TabPessoaCad);
    end;

  end, TerminateSalvar);
end;

procedure TFrmPessoaCad.TerminateSalvar(Sender: TObject);
begin

  if Sender is TThread then
    if Assigned(TThread(sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;

  if FidPessoa = 0 then
  begin
    ShowMessage('Dados Inseridos.')
  end
  else
  begin
    ShowMessage('Dados Alterados.')
  end;

end;


end.
