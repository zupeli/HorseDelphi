unit uPrincipal;

// https://www.youtube.com/watch?v=57wGK5iwt3g&t=172s
// https://codedelphi.com/arrays-json-em-delphi/

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type

  TfrmPrincipal = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    btCadastroPessoa: TButton;
    GroupBox2: TGroupBox;
    GridPessoa: TDBGrid;
    cdsPessoa: TFDMemTable;
    dtsPessoa: TDataSource;
    btPesquisar: TButton;
    Label1: TLabel;
    edID: TEdit;
    Label2: TLabel;
    edNome: TEdit;
    btEditarExcluir: TButton;
    btCadEndereco: TButton;
    cdsPessoaflnatureza: TIntegerField;
    cdsPessoaidpessoa: TIntegerField;
    cdsPessoadsdocumento: TStringField;
    cdsPessoanmprimeiro: TStringField;
    cdsPessoanmsegundo: TStringField;
    cdsPessoadtregistro: TDateField;
    btAutomatizado: TButton;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure btPesquisarClick(Sender: TObject);
    procedure edIDChange(Sender: TObject);
    procedure edIDKeyPress(Sender: TObject; var Key: Char);
    procedure edNomeChange(Sender: TObject);
    procedure edNomeKeyPress(Sender: TObject; var Key: Char);
    procedure btCadastroPessoaClick(Sender: TObject);
    procedure GridPessoaCellClick(Column: TColumn);
    procedure GridPessoaExit(Sender: TObject);
    procedure btEditarExcluirClick(Sender: TObject);
    procedure btCadEnderecoClick(Sender: TObject);
    procedure GridPessoaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cdsPessoaAfterOpen(DataSet: TDataSet);
    procedure cdsPessoaflnaturezaGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure btAutomatizadoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure RefreshPessoas;
    procedure TerminateBusca(Sender: TObject);
    procedure IdentarGrid;
    function VersaoExe: String;
    function GetVersion: string;

    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses DataM, uThread, uPessoaCad, uEditarExcluir, uEnderecoCad, uCadastroAutomatizado;

procedure TfrmPrincipal.btCadastroPessoaClick(Sender: TObject);
var
 vObjCadastro : TFrmPessoaCad;
begin
   vObjCadastro := TFrmPessoaCad.create(nil);
   try
     vObjCadastro.idPessoa := 0;
     vObjCadastro.ShowModal;

   finally
     FreeAndNil(vObjCadastro)
   end;
end;

procedure TfrmPrincipal.btCadEnderecoClick(Sender: TObject);
var
 vObjForm : TfrmEnderecoCad;
begin
   vObjForm := TfrmEnderecoCad.create(nil);
   try
     vObjForm.idEndereco := 0;
     vObjForm.idPessoa   := cdsPessoa.FieldByName('idpessoa'  ).AsInteger;
     vObjForm.dsPessoa   := cdsPessoa.FieldByName('idpessoa'  ).Asstring + ' - ' +
                            cdsPessoa.FieldByName('nmprimeiro').AsString;
     vObjForm.ShowModal;

     if Assigned(vObjForm.OnClose) then
     begin
      RefreshPessoas;
     end;

   finally
     FreeAndNil(vObjForm)
   end;

end;

procedure TfrmPrincipal.btEditarExcluirClick(Sender: TObject);
var
 vObjForm : TfrmEditarExcluir;
begin
   vObjForm := TfrmEditarExcluir.create(nil);
   try
     vObjForm.idPessoa             := cdsPessoa.FieldByName('idpessoa'   ).AsInteger;
     vObjForm.edDocumento.Text     := cdsPessoa.FieldByName('dsdocumento').AsString;
     vObjForm.edNome.Text          := cdsPessoa.FieldByName('nmprimeiro' ).AsString;
     vObjForm.edSobrenome.Text     := cdsPessoa.FieldByName('nmsegundo'  ).AsString;
     vObjForm.rgNatureza.ItemIndex := cdsPessoa.FieldByName('flnatureza' ).AsInteger;
     vObjForm.ShowModal;

     if Assigned(vObjForm.OnClose) then
     begin
       RefreshPessoas;
     end;

   finally
     FreeAndNil(vObjForm)
   end;

end;

procedure TfrmPrincipal.btPesquisarClick(Sender: TObject);
begin
  RefreshPessoas;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btAutomatizadoClick(Sender: TObject);
var
 vObjCad : TfrmCadastroAutomatizado;
begin
  vObjCad := TfrmCadastroAutomatizado.Create(nil);
  try
    vObjCad.ShowModal;
  finally
    FreeAndNil(vObjCad);
  end;
end;

procedure TfrmPrincipal.cdsPessoaAfterOpen(DataSet: TDataSet);
begin
//   tabEndereconmcidadeGetText(Sender: TField;
//  cdsPessoa.on
end;

procedure TfrmPrincipal.cdsPessoaflnaturezaGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if DisplayText then begin
    case cdsPessoa.FieldByName('flnatureza').AsInteger of
      0: Text := 'Física';
      1: Text := 'Jurídica';
    else
      Text := 'Desconhecido';
    end;
  end else
    Text := cdsPessoa.FieldByName('flnatureza').AsString;
end;

procedure TfrmPrincipal.edIDChange(Sender: TObject);
begin
  edNome.Text := '';
end;

procedure TfrmPrincipal.edIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    RefreshPessoas;
end;

procedure TfrmPrincipal.edNomeChange(Sender: TObject);
begin
  edID.Text := '';
end;

procedure TfrmPrincipal.edNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    RefreshPessoas;
end;


procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  Caption := Caption + ' - ' +  VersaoExe;
//  Caption := Caption + ' - ' +  GetVersion;
end;

Function TfrmPrincipal.VersaoExe: String;
type
    PFFI = ^vs_FixedFileInfo;
var
    F : PFFI;
    Handle : Dword;
    Len : Longint;
    Data : Pchar;
    Buffer : Pointer;
    Tamanho : Dword;
    Parquivo: Pchar;
    Arquivo : String;
begin
    Arquivo := Application.ExeName;
    Parquivo := StrAlloc(Length(Arquivo) + 1);
    StrPcopy(Parquivo, Arquivo);
    Len := GetFileVersionInfoSize(Parquivo, Handle);
    Result := '';
        if Len > 0 then
        begin
            Data:=StrAlloc(Len+1);
            if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
            begin
                VerQueryValue(Data, '\',Buffer,Tamanho);
                F := PFFI(Buffer);
                Result := Format('%d.%d.%d.%d',[HiWord(F^.dwFileVersionMs),
                                                LoWord(F^.dwFileVersionMs),
                                                HiWord(F^.dwFileVersionLs),
                                                Loword(F^.dwFileVersionLs)]);
            end;
            StrDispose(Data);
        end;
        StrDispose(Parquivo);
end;

function TfrmPrincipal.GetVersion: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

procedure TfrmPrincipal.GridPessoaCellClick(Column: TColumn);
begin
  btEditarExcluir.Enabled := not cdsPessoa.IsEmpty;
  btCadEndereco.Enabled   := not cdsPessoa.IsEmpty;
end;

procedure TfrmPrincipal.GridPessoaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
//  if column.Field.FieldName = 'TP Pessoa' then
//  begin
//
//  end;

end;

procedure TfrmPrincipal.GridPessoaExit(Sender: TObject);
begin
//  btEditarExcluir.Enabled := False;
//  btCadEndereco.Enabled   := False;
end;

procedure TfrmPrincipal.RefreshPessoas;
begin
  TMyThread.ExecuteThread(procedure
  begin
    // Acessar o servidor...
    GridPessoa.DataSource := nil;
    if Trim(edID.Text) = '' then
    begin
      DM.ListarPessoas(cdsPessoa, Trim(edNome.Text));
    end
    else
    begin
      DM.ListarPessoaId(cdsPessoa, Trim(edID.Text).ToInteger);
    end;

    // Atualizar o DBGrid.
    Tthread.Synchronize(Tthread.CurrentThread, procedure
    begin
      GridPessoa.DataSource := dtsPessoa;
    end);
  end,
  TerminateBusca);

end;

procedure TfrmPrincipal.TerminateBusca(Sender: TObject);
begin
  IdentarGrid;
//  btExcluir.Enabled := False;
//  btEditar.Enabled  := False;

  if Sender is TThread then
    if Assigned(TThread(Sender).FatalException) then
    begin
      showmessage(Exception(TThread(sender).FatalException).Message);
      exit;
    end;
end;

procedure TfrmPrincipal.IdentarGrid;
begin
  GridPessoa.DataSource := dtsPessoa;
  if not cdsPessoa.IsEmpty then
  begin
    GridPessoa.Columns[0].Width          := 60;
    GridPessoa.Columns[0].Title.Caption  := 'ID';
    GridPessoa.Columns[0].Alignment      := taCenter;
    GridPessoa.Columns[1].Width          := 140;
    GridPessoa.Columns[1].Title.Caption  := 'Documento';
    GridPessoa.Columns[2].Width          := 200;
    GridPessoa.Columns[2].Title.Caption  := 'Nome';
    GridPessoa.Columns[3].Width          := 200;
    GridPessoa.Columns[3].Title.Caption  := 'Sobrenome';
    GridPessoa.Columns[4].Width          := 120;
    GridPessoa.Columns[4].Title.Caption  := 'Dt.Registro';
    GridPessoa.Columns[5].Width          := 100;
    GridPessoa.Columns[5].Title.Caption  := 'TP Pessoa';
    GridPessoa.Columns[5].Alignment      := taLeftJustify;
  end;
end;

end.
