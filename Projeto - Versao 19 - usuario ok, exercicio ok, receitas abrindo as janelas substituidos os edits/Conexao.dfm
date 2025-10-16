object DataModule1: TDataModule1
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'StringFormat=Unicode'
      'Database=E:\Calorisync\Calorisync\bancoDados\CaloriBanco'
      'DriverID=SQLite')
    Left = 160
    Top = 48
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 312
    Top = 56
  end
end
