unit uDataModulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLiteWrapper.Stat, Data.DB, FireDAC.Comp.Client,

  Dataset.Serialize.Config, Dataset.Serialize, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    FDConn_base: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDQueryVazia: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDConn_baseBeforeConnect(Sender: TObject);
  private
    procedure CarregarConfigDB(Connection: TFDConnection);
    procedure conectar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  TDatasetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDatasetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
  conectar;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if FDConn_base.Connected then
  begin
    FDConn_base.Connected := False;
  end;
end;

procedure TDM.FDConn_baseBeforeConnect(Sender: TObject);
begin
  CarregarConfigDB(FDConn_base);
end;

procedure TDM.CarregarConfigDB(Connection: TFDConnection);
begin
  Connection.DriverName := 'SQLite';

  Connection.Params.Clear;
  Connection.Params.Add('DriverID=SQLite');
  Connection.Params.Add('Database=D:\Aulas\Delphi\Proj Horse\HorseDelphi\Banco\banco.db');
  Connection.Params.Add('User_Name=');
  Connection.Params.Add('Passord=');
  Connection.Params.Add('Port=');
  Connection.Params.Add('Server=');
  Connection.Params.Add('Protocol=');
  Connection.Params.Add('LockingMode=Normal');

end;

procedure TDM.conectar;
begin
  FDConn_base.Connected := True;
end;


end.
