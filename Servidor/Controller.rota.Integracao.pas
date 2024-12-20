unit Controller.rota.Integracao;

interface

uses Horse, System.JSON, System.SysUtils, uIntegracao, uEndereco;

  procedure RegistarRotaIntegracao;
  procedure listarEndereco(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
//  procedure Listar_CEP(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure listarEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure InserirEnderecoCEP(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure InserirEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure ExcluirEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure ExcluirEndereco(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure EditarEnderecoCEP(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
  procedure EditarEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
implementation


procedure RegistarRotaIntegracao;
begin

  Thorse.Get('/endereco/integracao/:id_endereco'     , listarEnderecoIntegracao);
  Thorse.Get('/endereco/:id_pessoa'                  , listarEndereco);
//  Thorse.Get('/endereco/:cep'                      , Listar_CEP);
  Thorse.post('/endereco/integracao'                 , InserirEnderecoIntegracao);
  Thorse.post('/endereco'                            , InserirEnderecoCEP);
  Thorse.Delete('/endereco/integracao/:id_endereco'  , ExcluirEnderecoIntegracao);
  Thorse.Delete('/endereco/:id_endereco'             , ExcluirEndereco);
  Thorse.put('/endereco/:id_pessoa'                  , EditarEnderecoCEP);
  Thorse.put('/endereco/integracao'                  , EditarEnderecoIntegracao);

end;


procedure listarEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbIntegracao : TIntegracao;

begin
  try
    vOjbIntegracao := TIntegracao.Create;
    try
      vOjbIntegracao.idEndereco := Req.Params['id_endereco'].ToInteger;
    except
      vOjbIntegracao.idEndereco := 0;
    end;

    try
      Res.Send<TJsonArray>(vOjbIntegracao.Listar);

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(vOjbIntegracao);
  end;

end;

procedure listarEndereco(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbEndereco : TEndereco;
  vIdPessoa : integer;
begin
  try
    vOjbEndereco := TEndereco.Create;
    try
      vIdPessoa := Req.Params['id_pessoa'].ToInteger;
    except
      vIdPessoa := 0;
    end;

    try
      vOjbEndereco.dsCEP := Req.Query['filtro'];
      Res.Send<TJsonArray>(vOjbEndereco.ListarEndereco(vIdPessoa));

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(vOjbEndereco);
  end;

end;

procedure EditarEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vBody : TJSONArray;
  vOjbIntegracao : TIntegracao;
  vCont          : integer;
begin
  try
    vOjbIntegracao := TIntegracao.Create;
    try

      try
        vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as  TJSONArray;
      except
        vBody.DisposeOf;
        Exit;
      end;

      for vCont := 0 to vBody.Count -1 do
      begin
        vOjbIntegracao.idEndereco  := vBody[vCont].GetValue<integer>('idendereco'  ,  0);
        vOjbIntegracao.UF          := vBody[vCont].GetValue<string>('dsuf'         , '');
        vOjbIntegracao.Cidade      := vBody[vCont].GetValue<string>('nmcidade'     , '');
        vOjbIntegracao.Bairro      := vBody[vCont].GetValue<string>('nmbairro'     , '');
        vOjbIntegracao.Logradouro  := vBody[vCont].GetValue<string>('nmlogradouro' , '');
        vOjbIntegracao.Complemento := vBody[vCont].GetValue<string>('dscomplemento', '');

        Res.Send<TJsonObject>(vOjbIntegracao.Editar).Status(201);
      end;

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(vOjbIntegracao);
  end;
end;


procedure EditarEnderecoCEP(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vBody : TJSONObject;
  vOjbEndereco : TEndereco;
  vIdPessoa : integer;
begin
  try
    vOjbEndereco := TEndereco.Create;
    try

      try
        vIdPessoa := Req.Params['id_pessoa'].ToInteger;
      except
        vIdPessoa := 0;
      end;

      vBody := Req.Body<TJSONObject>;
      vOjbEndereco.dsCEP      := vBody.GetValue<string>('dscep'      , '');
      vOjbEndereco.idEndereco := vBody.GetValue<integer>('idendereco', 0);

      Res.Send<TJsonObject>(vOjbEndereco.EditarEnderecoCEP(vIdPessoa)).Status(201);
    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(vOjbEndereco);
  end;
end;

procedure ExcluirEndereco(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vObjEndereco : TEndereco;
  vIdPessoa    : Integer;
begin
  vObjEndereco := TEndereco.Create;
  try
    try
      try
        vObjEndereco.idEndereco := Req.Params['id_endereco'].ToInteger;
      except
        vObjEndereco.idEndereco := 0;
      end;

      vIdPessoa := Req.Query['idpessoa'].ToInteger;

      if (vObjEndereco.idEndereco > 0) and (vIdPessoa > 0) then
      begin
        Res.Send<TJsonObject>(vObjEndereco.ExcluirEndereco(vIdPessoa)).Status(200);
      end
      else
      begin
        Res.Send('Erro ao excluir endere�o CEP! ').Status(500);
      end;

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;
  finally
    FreeAndNil(vObjEndereco);
  end;
end;

procedure ExcluirEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vObjIntegracao : TIntegracao;
begin
  try
    vObjIntegracao := TIntegracao.Create;
    try

      try
        vObjIntegracao.idEndereco := Req.Params['id_endereco'].ToInteger;
      except
        vObjIntegracao.idEndereco := 0;
      end;

      if vObjIntegracao.idEndereco > 0 then
      begin
        Res.Send<TJsonObject>(vObjIntegracao.Excluir).Status(200);
      end
      else
      begin
        Res.Send('Erro ao excluir endere�o! ').Status(500);
      end;

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;
  finally
    FreeAndNil(vObjIntegracao);
  end;
end;

procedure InserirEnderecoCEP(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbEndereco : TEndereco;
  vIdPessoa    : Integer;
  vBody        : TJSONArray;
  vCont        : integer;
begin
  vOjbEndereco := TEndereco.Create;
  try
    try
      vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as  TJSONArray;
    except
      vBody.DisposeOf;
      Exit;
    end;

    for vCont := 0 to vBody.Count -1 do
    begin
      vIdPessoa          := vBody[vCont].GetValue<integer>('idpessoa',  0);
      vOjbEndereco.dsCEP := vBody[vCont].GetValue<string>('dscep'    , '');

      Res.Send<TJsonObject>(vOjbEndereco.InserirCEP(vIdPessoa)).Status(200);
    end;

  finally
    FreeAndNil(vOjbEndereco);
    vBody.DisposeOf;
  end;
end;

procedure InserirEnderecoIntegracao(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vObjIntegracao : TIntegracao;
  vBody          : TJSONArray;
  vCont          : Integer;
begin
  vObjIntegracao := TIntegracao.Create;
  try

    try
      vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as  TJSONArray;
    except
      vBody.DisposeOf;
      Exit;
    end;

    for vCont := 0 to vBody.Count -1 do
    begin
      vObjIntegracao.idEndereco  := vBody[vCont].GetValue<integer>('idendereco'   ,  0);
      vObjIntegracao.UF          := vBody[vCont].GetValue<string>('dsuf'          , '');
      vObjIntegracao.Cidade      := vBody[vCont].GetValue<string>('nmcidade'      , '');
      vObjIntegracao.Bairro      := vBody[vCont].GetValue<string>('nmbairro'      , '');
      vObjIntegracao.Logradouro  := vBody[vCont].GetValue<string>('nmlogradouro'  , '');
      vObjIntegracao.Complemento := vBody[vCont].GetValue<string>('dscomplemento' , '');

      if vObjIntegracao.idEndereco > 0 then
      begin
        Res.Send<TJsonObject>(vObjIntegracao.Inserir).Status(200);
      end
      else
      begin
        Res.Send('Erro ao inserir a endere�o Integra��o! ').Status(500);
      end;
    end;

  finally
    FreeAndNil(vObjIntegracao);
    vBody.DisposeOf;
  end;
end;

end.
