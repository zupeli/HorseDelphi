unit DataM_Pessoa;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope,
  RESTRequest4D, Dataset.Serialize.Config,
  DataSet.Serialize.Adapter.RESTRequest4D;

type
  TDM_Pessoa = class(TDataModule)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    MemTable: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private


    { Private declarations }
  public
    { Public declarations }
    procedure ListarPessoas(MemTable: TFDMemTable; filtro: string);
    procedure ListarPessoaId(MemTable: TFDMemTable; id_pessoa: integer);
  end;

var
  DM_Pessoa: TDM_Pessoa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TDM_Pessoa.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDM_Pessoa.ListarPessoaId(MemTable: TFDMemTable;
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

procedure TDM_Pessoa.ListarPessoas(MemTable: TFDMemTable;
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

end.
