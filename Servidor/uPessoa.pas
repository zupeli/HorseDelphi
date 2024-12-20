unit uPessoa;

interface

uses Horse, uDataModulo, System.JSON,
     Dataset.Serialize.Config, Dataset.Serialize;


type
  TPessoa = class

  private
    FidPessoa : Integer;
    FNome     : String;
    FSobrenome: String;
    FDocumento: Integer;
    Fnatureza: Integer;

//    procedure ListarPessoa_Id(Req: ThorseRequest; Res: THorseResponse;
//              Next: Tproc);
  public
    function ListarPessoa  : TJsonArray;
    function ListarPessoaId: TJsonObject;
    function ExcluirPessoa : TJsonObject;
    function InserirPessoa : TJsonObject;
    function EditarPessoa  : TJsonObject;
    function ExcluirPessoaDropAll: TJsonObject;

    property idPessoa  : Integer  read FidPessoa   write FidPessoa;
    property Natureza  : Integer  read Fnatureza   write Fnatureza;
    property Nome      : String   read FNome       write FNome;
    property Sobrenome : String   read FSobrenome  write FSobrenome;
    property Documento : Integer  read FDocumento  write FDocumento;

  end;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client;

function TPessoa.InserirPessoa: TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  DM   := TDM.Create(nil);
  vQry := TFDQuery.Create(nil);
  try

    vQry.Connection := DM.FDConn_base;

    vQry.sql.Text := 'select idpessoa from pessoa order by idpessoa desc limit 1';
    vQry.open;
    idPessoa := StrToIntDef(vQry.FieldByName('idpessoa').AsString,0);
    inc(FidPessoa);
    vQry.close;

    vQry.SQL.Text := 'insert into pessoa(idpessoa, flnatureza, dsdocumento, ' +
                     ' nmprimeiro, nmsegundo, dtregistro)                   ' +
                     ' values(:idpessoa, :flnatureza, :dsdocumento,         ' +
                     ' :nmprimeiro, :nmsegundo, :dtregistro)';

    vQry.ParamByName('idpessoa'   ).Value := FidPessoa;
    vQry.ParamByName('flnatureza' ).Value := Fnatureza;
    vQry.ParamByName('dsdocumento').Value := FDocumento;
    vQry.ParamByName('nmprimeiro' ).Value := FNome;
    vQry.ParamByName('nmsegundo'  ).Value := FSobrenome;
    vQry.ParamByName('dtregistro' ).Value := now;
    vQry.ExecSQL;

    vQry.SQL.Text := 'select last_insert_rowid() as idpessoa';
    vQry.Open;
    Result := vQry.ToJSONObject;
    vQry.Close;

  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;

function TPessoa.EditarPessoa: TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    try
      vQry.SQL.Text := 'update pessoa set               ' +
                       ' dsdocumento    = :dsdocumento, ' +
                       ' nmprimeiro     = :nmprimeiro,  ' +
                       ' nmsegundo      = :nmsegundo,   ' +
                       ' dtregistro     = :dtregistro,  ' +
                       ' flnatureza     = :flnatureza   ' +
                       ' where idpessoa = :idpessoa';
      vQry.ParamByName('idpessoa'   ).Value := FidPessoa;
      vQry.ParamByName('dsdocumento').Value := FDocumento;
      vQry.ParamByName('nmprimeiro' ).Value := FNome;
      vQry.ParamByName('nmsegundo'  ).Value := FSobrenome;
      vQry.ParamByName('flnatureza' ).Value := Fnatureza;
      vQry.ParamByName('dtregistro' ).Value := now;
      vQry.ExecSQL;
    except
    end;

    Result := vQry.ToJsonObject;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;

function TPessoa.ExcluirPessoa:TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    try
      vQry.SQL.Text := 'delete from pessoa         ' +
                       ' where idpessoa = :idpessoa';
      vQry.ParamByName('idpessoa').Value := FidPessoa;
      vQry.ExecSQL;
    except
    end;

    Result := vQry.ToJsonObject;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;

function TPessoa.ExcluirPessoaDropAll:TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    try
      vQry.SQL.Text := 'delete from pessoa';
      vQry.ExecSQL;
    except
    end;

    Result := vQry.ToJsonObject;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;

Function TPessoa.ListarPessoa:TJsonArray;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;
    {
    vQry.SQL.Text := 'Select pessoa.idpessoa, dsdocumento, nmprimeiro,   ' +
                     '       nmsegundo, dtregistro, idendereco,          ' +
                     '       flnatureza, dscep                           ' +
                     '  from pessoa                                      ' +
                     '  left join endereco on                            ' +
                     '       pessoa.idpessoa = endereco.idpessoa';
   }
    vQry.SQL.Text := 'Select idpessoa, dsdocumento, nmprimeiro, ' +
                     '       nmsegundo, dtregistro, flnatureza  ' +
                     '  from pessoa                             ';

    if Nome <> '' then
    begin
      vQry.SQL.Add('where nmprimeiro like :filtro');
      vQry.ParamByName('filtro').Value := '%' + Nome + '%';
    end;

//    vQry.SQL.Add('order by nmprimeiro, nmsegundo, dtregistro');
    vQry.SQL.Add('order by idpessoa desc');

    vQry.SQL.Add('limit 1000');
    vQry.open;

    Result := vQry.ToJSONArray;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;


function TPessoa.ListarPessoaId:TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.SQL.Text := 'Select idpessoa, dsdocumento, nmprimeiro, ' +
                     '       nmsegundo, dtregistro, flnatureza  ' +
                     '  from pessoa                             ' +
                     ' where idpessoa = :idPessoa';

    vQry.ParamByName('idPessoa').Value := FidPessoa;
    vQry.open;

    Result := vQry.ToJsonObject;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;


end.
