unit DataM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope,
  RESTRequest4D, Dataset.Serialize.Config,
  DataSet.Serialize.Adapter.RESTRequest4D, System.JSON;

type
  TDM = class(TDataModule)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    MemTable: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure EditarEnderecoIntegracao(pIdEndereco: integer;
      pDados: TFDMemTable);
    procedure AddCEP_Json(pDados: TFDMemTable; rJson : TJSONArray);
    procedure AddEndereco_Json(vIdEndereco :integer; pDados: TFDMemTable; rJson:TJSONArray);


    { Private declarations }
  public
    { Public declarations }
    procedure ListarPessoas(MemTable: TFDMemTable; filtro: string);
    procedure ListarPessoaId(MemTable: TFDMemTable; id_pessoa: integer);
    procedure InserirPessoa(pDados: TFDMemTable);
    function ExcluirPessoa(pIdPessoa: integer):TJSONValue;
    function ExcluirPessoaDropAll:TJSONValue;
    procedure ListarEnderecoPessoa(MemTable: TFDMemTable; id_pessoa: integer);
    procedure EditarCEP(pIdPessoa, pIdEndereco: integer; pCEP: string);
    procedure EditarEndereco(pIdEndereco: integer; pDados: TFDMemTable; pAtualizarCEP : boolean);
    procedure EditarPessoa(pIdPessoa : integer; pDados: TFDMemTable);
    function ExcluirEndereco(pIdPessoa, pIdEndereco: integer): TJSONValue;
    procedure InserirEndereco(pDados: TFDMemTable);
  end;

var
  DM: TDM;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDM.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDM.AddCEP_Json(pDados: TFDMemTable; rJson:TJSONArray);
var
  vJsonObj : TJsonObject;
begin
  try
    pDados.First;
    while not pDados.Eof do
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('idpessoa', pDados.FieldByName('idpessoa').AsInteger);
      vJsonObj.AddPair('dscep'   , pDados.FieldByName('dscep'   ).AsString);
      rJson.Add(vJsonObj);

      pDados.Next;
    end;
  finally
//    freeAndNil(vJsonObj);
  end;
end;

procedure TDM.AddEndereco_Json(vIdEndereco :integer; pDados: TFDMemTable; rJson:TJSONArray);
var
  vJsonObj : TJsonObject;
begin
  try
    pDados.First;
    while not pDados.Eof do
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('idpessoa'     , pDados.FieldByName('idpessoa'     ).AsInteger);
      vJsonObj.AddPair('idendereco'   , vIdEndereco);
      vJsonObj.AddPair('dsuf'         , pDados.FieldByName('dsuf'         ).AsString);
      vJsonObj.AddPair('nmcidade'     , pDados.FieldByName('nmcidade'     ).AsString);
      vJsonObj.AddPair('nmbairro'     , pDados.FieldByName('nmbairro'     ).AsString);
      vJsonObj.AddPair('nmlogradouro' , pDados.FieldByName('nmlogradouro' ).AsString);
      vJsonObj.AddPair('dscomplemento', pDados.FieldByName('dscomplemento').AsString);
      rJson.Add(vJsonObj);

      pDados.Next;
    end;
  finally
//    freeAndNil(vJsonObj);
  end;
end;

procedure TDM.InserirEndereco(pDados: TFDMemTable);
var
  resp: IResponse;
  vJsonObj : TJsonObject;
  vJsonArr : TJSONArray;
//  vJsonRet : TJSONArray;
  vIdEndereco : Integer;
begin

  vIdEndereco := 0;
  try
    vJsonArr := TJSONArray.Create;
    AddCEP_Json(pDados, vJsonArr);

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/endereco')
                    .AddBody(vJsonArr.ToJSON)
                    .Accept('application/json')
                    .Post;

    vJsonObj := TJsonObject.Create;
    try
      vJsonObj    := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(resp.Content),0) as  TJsonObject;
      vIdEndereco := vJsonObj.GetValue<integer>('idendereco', 0);
      vJsonObj.DisposeOf;
    except
//      ShowMessage('Memo n�o � um complexType!');
      vJsonObj.DisposeOf;
    end;

    vJsonArr.DisposeOf;
    if vIdEndereco > 0 then
    begin
      vJsonArr := TJSONArray.Create;
      AddEndereco_Json(vIdEndereco, pDados, vJsonArr);

      resp := TRequest.New.BaseURL('http://localhost:8080')
                      .Resource('/endereco/integracao')
                      .AddBody(vJsonArr.ToJSON)
                      .Accept('application/json')
                      .Post;

      vJsonArr.DisposeOf;
      if resp.StatusCode <> 200 then
      begin
          raise Exception.Create(resp.Content);
      end;

    end;
  finally
//    freeAndNil(vJsonObj);
//    freeAndNil(vJsonArr);
  end;
end;

procedure TDM.ListarPessoaId(MemTable: TFDMemTable;
                                    id_pessoa: integer);
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL('http://localhost:8080')
                  .Resource('/pessoa')
                  .ResourceSuffix(id_pessoa.ToString)
                  .Accept('application/json')
                  .Adapters(TDataSetSerializeAdapter.New(MemTable))
                  .Get;

  if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);
end;


procedure TDM.ListarEnderecoPessoa(MemTable: TFDMemTable;
                                   id_pessoa: integer);
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL('http://localhost:8080')
                  .Resource('/endereco')
                  .ResourceSuffix(id_pessoa.ToString)
                  .Accept('application/json')
                  .Adapters(TDataSetSerializeAdapter.New(MemTable))
                  .Get;

  if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);
end;

procedure TDM.InserirPessoa(pDados: TFDMemTable);
var
  resp: IResponse;
  vJsonObj : TJsonObject;
  vJsonArr : TJSONArray;
  vCont    : Int64;
begin
  vJsonArr := TJSONArray.Create;
  try
    pDados.First;
    vCont := 1;
    while not pDados.Eof do
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('dsdocumento' , pDados.FieldByName('dsdocumento').AsString);
      vJsonObj.AddPair('nmprimeiro'  , pDados.FieldByName('nmprimeiro' ).AsString);
      vJsonObj.AddPair('nmsegundo'   , pDados.FieldByName('nmsegundo'  ).AsString);
      vJsonObj.AddPair('flnatureza'  , pDados.FieldByName('flnatureza' ).AsString);

      vJsonArr.Add(vJsonObj);
      Inc(vCont);
      if vCont > 10000 then
      begin
        resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/InserirPessoa')
                    .AddBody(vJsonArr.ToJSON)
                    .Accept('application/json')
                    .Post;
        vJsonArr := TJSONArray.Create;
        vCont := 1;
      end;


      pDados.Next;
    end;

    if vJsonArr.Count >= 1 then
    begin
      resp := TRequest.New.BaseURL('http://localhost:8080')
                      .Resource('/InserirPessoa')
                      .AddBody(vJsonArr.ToJSON)
                      .Accept('application/json')
                      .Post;
    end;
    if resp.StatusCode <> 200 then
        raise Exception.Create(resp.Content);
  finally
    freeAndNil(vJsonObj);
  end;
end;

procedure TDM.EditarPessoa(pIdPessoa : integer; pDados: TFDMemTable);
var
  resp     : IResponse;
  vJsonObj : TJsonObject;
  vJsonArr : TJSONArray;
begin
  vJsonArr := TJSONArray.Create;
  try
    pDados.First;
    while not pDados.Eof do
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('dsdocumento', pDados.FieldByName('dsdocumento').AsString);
      vJsonObj.AddPair('nmprimeiro' , pDados.FieldByName('nmprimeiro' ).AsString);
      vJsonObj.AddPair('nmsegundo'  , pDados.FieldByName('nmsegundo'  ).AsString);
      vJsonObj.AddPair('flnatureza' , pDados.FieldByName('flnatureza' ).AsString);

      vJsonArr.Add(vJsonObj);
      pDados.Next;
    end;

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/pessoa')
                    .ResourceSuffix(pIdPessoa.ToString)
                    .AddBody(vJsonArr.ToJSON)
                    .Accept('application/json')
                    .Put;

    if resp.StatusCode <> 201 then
        raise Exception.Create(resp.Content);
  finally
    freeAndNil(vJsonObj);
  end;
end;

procedure TDM.EditarEndereco(pIdEndereco: integer; pDados: TFDMemTable; pAtualizarCEP : boolean);
begin
  if pAtualizarCEP then
  begin
    EditarCEP(pDados.FieldByName('idpessoa').AsInteger,
              pIdEndereco,
              pDados.FieldByName('dscep').AsString);
  end;
  EditarEnderecoIntegracao(pIdEndereco, pDados);
end;

procedure TDM.EditarEnderecoIntegracao(pIdEndereco: integer; pDados: TFDMemTable);
var
  resp  : IResponse;
  vJsonObj : TJsonObject;
  vJsonArr : TJSONArray;
begin
  vJsonArr := TJSONArray.Create;
  try
    pDados.First;
    while not pDados.Eof do
    begin
      vJsonObj := TJsonObject.Create;
      vJsonObj.AddPair('idendereco'   , pDados.FieldByName('idendereco'   ).AsString);
      vJsonObj.AddPair('dsuf'         , pDados.FieldByName('dsuf'         ).AsString);
      vJsonObj.AddPair('nmcidade'     , pDados.FieldByName('nmcidade'     ).AsString);
      vJsonObj.AddPair('nmbairro'     , pDados.FieldByName('nmbairro'     ).AsString);
      vJsonObj.AddPair('nmlogradouro' , pDados.FieldByName('nmlogradouro' ).AsString);
      vJsonObj.AddPair('dscomplemento', pDados.FieldByName('dscomplemento').AsString);

      vJsonArr.Add(vJsonObj);

      pDados.Next;
    end;

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/endereco/integracao')
//                    .AddParam('id_endereco', pIdEndereco.ToString)
                    .AddBody(vJsonArr.ToJSON)
                    .Accept('application/json')
                    .Put;

    if resp.StatusCode <> 201 then
        raise Exception.Create(resp.Content);
  finally
    vJsonObj.DisposeOf;
//    freeAndNil(vJsonArr);
  end;
end;

procedure TDM.EditarCEP(pIdPessoa, pIdEndereco : integer; pCEP : string);
var
  resp  : IResponse;
  vJson : TJsonObject;
begin
  try
    vJson := TJsonObject.Create;
    vJson.AddPair('dscep', pCEP);
    vJson.AddPair('idendereco', pIdEndereco);

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/endereco')
                    .ResourceSuffix(pIdPessoa.ToString)
//                    .AddParam('id_endereco', pIdEndereco.ToString)
                    .AddBody(vJson.ToJSON)
                    .Accept('application/json')
                    .Put;

    if resp.StatusCode <> 201 then
        raise Exception.Create(resp.Content);
  finally
    freeAndNil(vJson);
  end;
end;

procedure TDM.ListarPessoas(MemTable: TFDMemTable;
                                     filtro: string);
var
  resp: IResponse;
begin
  resp := TRequest.New.BaseURL('http://localhost:8080')
                  .Resource('/pessoa')
                  .AddParam('filtro', filtro)
                  .Accept('application/json')
                  .Adapters(TDataSetSerializeAdapter.New(MemTable))
                  .Get;

  if resp.StatusCode <> 200 then
      raise Exception.Create(resp.Content);
end;

function TDM.ExcluirPessoa(pIdPessoa : integer):TJSONValue;
var
  resp: IResponse;
begin
  try

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/pessoa')
                    .ResourceSuffix(pIdPessoa.ToString)
                    .Accept('application/json')
                    .Delete;


    if resp.StatusCode <> 200 then
        raise Exception.Create(resp.Content);

  finally
    Result := resp.JSONValue;
  end;
end;

function TDM.ExcluirPessoaDropAll:TJSONValue;
var
  resp: IResponse;
begin
  try
    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/pessoa/excluirAll')
                    .Accept('application/json')
                    .Delete;

    if resp.StatusCode <> 200 then
        raise Exception.Create(resp.Content);

  finally
    Result := resp.JSONValue;
  end;
end;

function TDM.ExcluirEndereco(pIdPessoa, pIdEndereco : integer):TJSONValue;
var
  resp: IResponse;
begin
  try

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/endereco/integracao')
                    .ResourceSuffix(pIdEndereco.ToString)
                    .Accept('application/json')
                    .Delete;

    if resp.StatusCode <> 200 then
        raise Exception.Create(resp.Content);

  finally
    Result := resp.JSONValue;
  end;

  try

    resp := TRequest.New.BaseURL('http://localhost:8080')
                    .Resource('/endereco')
                    .ResourceSuffix(pIdEndereco.ToString)
                    .AddParam('idpessoa', pIdPessoa.ToString)
                    .Accept('application/json')
                    .Delete;

    if resp.StatusCode <> 200 then
        raise Exception.Create(resp.Content);

  finally
    Result := resp.JSONValue;
  end;
end;

end.
