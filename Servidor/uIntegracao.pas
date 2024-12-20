unit uIntegracao;

interface

uses FireDAC.Comp.Client, System.JSON,
     Dataset.Serialize.Config, Dataset.Serialize;

type
  TIntegracao = class

  private
    FLogradouro  : String;
    FComplemento : String;
    F_UF         : String;
    FidEndereco  : Integer;
    FCidade      : String;
    FBairro      : String;


  public
      function Inserir: TJsonObject;
      function Excluir: TJsonObject;
      function Editar: TJsonObject;
      function Listar: TJsonArray;

      property idEndereco  : Integer  read FidEndereco   write FidEndereco;
      property UF          : String   read F_UF          write F_UF;
      property Cidade      : String   read FCidade       write FCidade;
      property Bairro      : String   read FBairro       write FBairro;
      property Logradouro  : String   read FLogradouro   write FLogradouro;
      property Complemento : String   read FComplemento  write FComplemento;
  end;

implementation

uses uDataModulo, System.SysUtils;

Function TIntegracao.Listar:TJsonArray;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.SQL.Text := 'Select idendereco, dsuf, nmcidade, nmbairro, ' +
                     '       nmlogradouro, dscomplemento           ' +
                     '  from endereco_integracao                   ' +
                     ' where idendereco = :idendereco';

    vQry.SQL.Add('order by dsuf, nmcidade, dsuf');
    vQry.SQL.Add('limit 100');
    vQry.ParamByName('idendereco').Value := FidEndereco;
    vQry.open;

    Result := vQry.ToJSONArray;
    vQry.Close;
  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;


end;

function TIntegracao.Editar: TjsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.SQL.Text := 'update endereco_integracao set                         ' +
                      ' nmcidade      = :nmcidade,     nmbairro = :nmbairro, ' +
                      ' nmlogradouro  = :nmlogradouro, dsuf     = :dsuf,     ' +
                      ' dscomplemento = :dscomplemento                       ' +
                      ' where idendereco   = :idendereco';

    vQry.ParamByName('idendereco'   ).Value := FidEndereco;
    vQry.ParamByName('dsuf'         ).Value := F_UF;
    vQry.ParamByName('nmcidade'     ).Value := FCidade;
    vQry.ParamByName('nmbairro'     ).Value := FBairro;
    vQry.ParamByName('nmlogradouro' ).Value := FLogradouro;
    vQry.ParamByName('dscomplemento').Value := FComplemento;
    vQry.ExecSQL;

  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;
end;

function TIntegracao.Inserir: TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    vQry.SQL.Text := 'insert into endereco_integracao(idendereco, dsuf, ' +
                     ' nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
                     ' values(:idendereco, :dsuf, :nmcidade, :nmbairro, ' +
                     ' :nmlogradouro, :dscomplemento)';
    vQry.ParamByName('idendereco'   ).Value := FidEndereco;
    vQry.ParamByName('dsuf'         ).Value := f_UF;
    vQry.ParamByName('nmcidade'     ).Value := FCidade;
    vQry.ParamByName('nmbairro'     ).Value := FBairro;
    vQry.ParamByName('nmlogradouro' ).Value := FLogradouro;
    vQry.ParamByName('dscomplemento').Value := FComplemento;
    vQry.ExecSQL;

    Result := vQry.ToJsonObject;

  finally
    FreeAndNil(vQry);
    FreeAndNil(DM);
  end;

end;

function TIntegracao.Excluir:TJsonObject;
var
  vQry : TFDQuery;
  DM   : TDM;
begin
  try
    vQry := TFDQuery.Create(nil);
    DM   := TDM.Create(nil);
    vQry.Connection := DM.FDConn_base;

    try
      vQry.SQL.Text := 'delete from endereco_integracao ' +
                       ' where idendereco = :idendereco';
      vQry.ParamByName('idendereco').Value := FidEndereco;
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

end.
