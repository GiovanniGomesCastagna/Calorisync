object Refecicao_Cadastro: TRefecicao_Cadastro
  Left = 0
  Top = 0
  Caption = 'Refeci'#231#227'o Cadastro'
  ClientHeight = 619
  ClientWidth = 924
  Color = 14085375
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object Refeicao: TLabel
    Left = 104
    Top = 99
    Width = 45
    Height = 15
    Caption = 'Refei'#231#227'o'
  end
  object Nome_refeicao: TEdit
    Left = 176
    Top = 96
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 88
    Top = 240
    Width = 320
    Height = 120
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
  end
  object Salvar: TButton
    Left = 136
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = SalvarClick
  end
  object Excluir: TButton
    Left = 264
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
    OnClick = ExcluirClick
  end
  object QryRefeicao: TFDQuery
    Connection = DataModule1.FDConnection1
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtWideMemo
        TargetDataType = dtWideString
      end>
    SQL.Strings = (
      'select * from refeicoes')
    Left = 536
    Top = 104
  end
  object DataSource1: TDataSource
    DataSet = QryRefeicao
    Left = 632
    Top = 104
  end
end
