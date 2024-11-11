unit Controller.rota.pessoa;

interface

uses  System.JSON, System.SysUtils, Horse;

procedure RegistarRotas;
procedure Listar(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
procedure Listar_Id(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
procedure InserirPessoa(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
procedure ExcluirPessoa(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
procedure EditarPessoa(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);

implementation

uses
  uPessoa;

// rotas endpoint
procedure RegistarRotas;
begin
  Thorse.Get('/pessoa'              , listar);
  Thorse.Get('/pessoa/:id_pessoa'   , Listar_Id);
  Thorse.post('/InserirPessoa'      , InserirPessoa);
  Thorse.put('/pessoa/:id_pessoa'   , EditarPessoa);
  Thorse.Delete('/pessoa/:id_pessoa', ExcluirPessoa);
end;

procedure EditarPessoa(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vBody      : TJSONArray;
  vOjbPessoa : Tpessoa;
  vCont      : integer;
begin
  try
    vOjbPessoa := Tpessoa.Create;
    try

      try
        vOjbPessoa.idPessoa := Req.Params['id_pessoa'].ToInteger;
      except
        vOjbPessoa.idPessoa := 0;
      end;

//      vBody := Req.Body<TJSONArray>;
      try
        vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as  TJSONArray;
      except
        vBody.DisposeOf;
        Exit;
      end;

      for vCont := 0 to vBody.Count -1 do
      begin
        vOjbPessoa.Documento   := vBody[vCont].GetValue<integer>('dsdocumento', 0);
        vOjbPessoa.Nome        := vBody[vCont].GetValue<string>('nmprimeiro'  , '');
        vOjbPessoa.Sobrenome   := vBody[vCont].GetValue<string>('nmsegundo'   , '');
        vOjbPessoa.Natureza    := vBody[vCont].GetValue<integer>('flnatureza' ,  0);
      end;
      Res.Send<TJsonObject>(vOjbPessoa.EditarPessoa).Status(201);
    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(vOjbPessoa);
    vBody.DisposeOf;
  end;
end;

procedure InserirPessoa(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbPessoa : Tpessoa;
  vJsonArr   : TJSONArray;
  vCont      : integer;
begin
  vOjbPessoa := Tpessoa.Create;
  try
    try
      vJsonArr := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body),0) as  TJSONArray;
    except
//      ShowMessage('Memo não é um complexType!');
      vJsonArr.DisposeOf;
      Exit;
    end;

    for vCont := 0 to vJsonArr.Count -1 do
    begin
      //vOjbPessoa.Documento := vJsonArr.GetValue<string>('dsdocumento'  , '');
      vOjbPessoa.Documento := vJsonArr[vCont].GetValue<integer>('dsdocumento' , 0);
      vOjbPessoa.Nome      := vJsonArr[vCont].GetValue<string>('nmprimeiro'   , '');
      vOjbPessoa.Sobrenome := vJsonArr[vCont].GetValue<string>('nmsegundo'    , '');
      vOjbPessoa.Natureza  := vJsonArr[vCont].GetValue<integer>('flnatureza'  ,  0);

      Res.Send<TJsonObject>(vOjbPessoa.InserirPessoa).Status(200);
    end;

  finally
    FreeAndNil(vOjbPessoa);
    vJsonArr.DisposeOf;
  end;
end;

procedure ExcluirPessoa(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbPessoa : Tpessoa;
begin
  try
    vOjbPessoa := Tpessoa.Create;
    try

      try
        vOjbPessoa.idPessoa := Req.Params['id_pessoa'].ToInteger;
      except
        vOjbPessoa.idPessoa := 0;
      end;

      if vOjbPessoa.idPessoa > 0 then
      begin
        Res.Send<TJsonObject>(vOjbPessoa.ExcluirPessoa).Status(200);
      end
      else
      begin
        Res.Send('Erro ao excluir a pessoa! ').Status(500);
      end;

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;
  finally
    FreeAndNil(vOjbPessoa);
  end;
end;


procedure Listar(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbPessoa : Tpessoa;
begin
  try
    VOjbPessoa := Tpessoa.Create;
    try
      VOjbPessoa.Nome := Req.Query['filtro'];
      Res.Send<TJsonArray>(VOjbPessoa.ListarPessoa);

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(VOjbPessoa);
  end;

end;

procedure Listar_Id(Req: ThorseRequest; Res: THorseResponse; Next: Tproc);
var
  vOjbPessoa : Tpessoa;
begin
  try
    vOjbPessoa := Tpessoa.Create;
    try
      try
        vOjbPessoa.idPessoa := Req.Params['id_pessoa'].ToInteger;
      except
        vOjbPessoa.idPessoa := 0;
      end;

      if vOjbPessoa.idPessoa > 0 then
      begin
        Res.Send<TJsonObject>(vOjbPessoa.ListarPessoaId);
      end
      else
      begin
        Res.Send('Id da Pessoa está vazio! ').Status(500);
      end;

    except on ex:exception do
      Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
    end;

  finally
    FreeAndNil(vOjbPessoa);
  end;
end;


end.
