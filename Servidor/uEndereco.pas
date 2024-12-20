unit uEndereco;

interface

uses Horse, uDataModulo, System.JSON,
     Dataset.Serialize.Config, Dataset.Serialize;

type
  TEndereco = class

  private
    FidEndereco: Integer;
    FdsCEP     : String;


  public
    function ListarEndereco(pIdPessoa : integer): TJsonArray;
    function ExcluirEndereco(pIdPessoa : integer) : TJsonObject;
    function InserirCEP(pIdPessoa : integer) : TjsonObject;
    function EditarEnderecoCEP(pIdPessoa : integer) : TjsonObject;

    property  idEndereco   : Integer  read FidEndereco   write FidEndereco;
    property  dsCEP        : String   read FdsCEP        write FdsCEP;

  end;


implementation

uses
  System.SysUtils, FireDAC.Comp.Client;


{ TEndereco }

function TEndereco.EditarEnderecoCEP(pIdPessoa: integer): TjsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.SQL.Text := 'update endereco set            ' +
                      ' dscep = :dscep                ' +
                      ' where idpessoa   = :idpessoa  ' +
                      '   and idendereco = :idendereco';

    vQry.ParamByName('idpessoa'  ).Value := pIdPessoa;
    vQry.ParamByName('idendereco').Value := FidEndereco;
    vQry.ParamByName('dscep'     ).Value := FdsCEP;
    vQry.ExecSQL;

  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;

function TEndereco.ExcluirEndereco(pIdPessoa : integer):TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    try
      vQry.SQL.Text := 'delete from endereco            ' +
                       ' where idendereco = :idendereco ' +
                       '   and idpessoa   = :idpessoa';
      vQry.ParamByName('idendereco').Value := FidEndereco;
      vQry.ParamByName('idpessoa'  ).Value := pIdPessoa;
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

Function TEndereco.ListarEndereco(pIdPessoa : integer):TJsonArray;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.SQL.Text := 'Select endereco.idendereco, dscep, idpessoa, dsuf,          ' +
                     '       nmcidade, nmbairro, nmlogradouro, dscomplemento      ' +
                     '  from endereco                                             ' +
                     '  left join endereco_integracao on                          ' +
                     '       endereco.idendereco = endereco_integracao.idendereco ' +
                     ' where idpessoa = :idpessoa';

    if FdsCEP <> '' then
    begin
      vQry.SQL.Add(' and dscep like :filtro');
      vQry.ParamByName('filtro').Value := '%' + FdsCEP + '%';
    end;

    vQry.SQL.Add('order by dsuf, nmcidade, dsuf');
    vQry.SQL.Add('limit 100');
    vQry.ParamByName('idpessoa').Value := pIdPessoa;
    vQry.open;

    Result := vQry.ToJSONArray;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;



function TEndereco.InserirCEP(pIdPessoa : integer): TjsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.sql.Text := 'select idendereco ' +
                     '  from endereco   ' +
                     ' order by idendereco desc limit 1';
    vQry.open;
    idEndereco := StrToIntDef(vQry.FieldByName('idendereco').Asstring,0);
    inc(FidEndereco);
    vQry.close;

    vQry.SQL.Text := 'insert into endereco(idendereco, idpessoa, dscep) ' +
                    ' values(:idendereco, :idpessoa, :dscep)';
    vQry.ParamByName('idpessoa'  ).Value := pIdPessoa;
    vQry.ParamByName('idendereco').Value := FidEndereco;
    vQry.ParamByName('dscep'     ).Value := FdsCEP;
    vQry.ExecSQL;
//    vQry.SQL.Text := 'select last_insert_rowid() as idendereco';
//    vQry.Open;
//    Result := vQry.ToJSONObject;
//    Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('{"idendereco":'+FidEndereco.ToString+'}'),0) as  TJsonObject;
    Result := TJSONObject.ParseJSONValue('{"idendereco":'+FidEndereco.ToString+'}') as  TJsonObject;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;

end;


end.
