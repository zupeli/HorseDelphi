object DM_Pessoa: TDM_Pessoa
  OnCreate = DataModuleCreate
  Height = 361
  Width = 555
  PixelsPerInch = 144
  object RESTClient1: TRESTClient
    BaseURL = 'http://viacep.com.br/ws'
    Params = <>
    SynchronizedEvents = False
    Left = 48
    Top = 128
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Resource = '01001000/json/'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 152
    Top = 128
  end
  object RESTResponse1: TRESTResponse
    Left = 256
    Top = 128
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = MemTable
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 152
    Top = 192
  end
  object MemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 336
    Top = 208
  end
end
