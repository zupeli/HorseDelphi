object DM: TDM
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 460
  Width = 766
  PixelsPerInch = 144
  object FDConn_base: TFDConnection
    Params.Strings = (
      'Database=D:\Aulas\Delphi\Proj Horse\HorseDelphi\Banco\banco.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = FDConn_baseBeforeConnect
    Left = 112
    Top = 48
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 112
    Top = 144
  end
  object FDQueryVazia: TFDQuery
    Connection = FDConn_base
    Left = 288
    Top = 56
  end
end
