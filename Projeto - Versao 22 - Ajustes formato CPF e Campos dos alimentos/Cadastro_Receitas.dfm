object Cadastro_Receita: TCadastro_Receita
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cardapio'
  ClientHeight = 393
  ClientWidth = 788
  Color = 14085375
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object NomePessoa: TLabel
    Left = 219
    Top = 32
    Width = 72
    Height = 15
    Caption = 'Nome Pessoa'
  end
  object Refeicao: TLabel
    Left = 246
    Top = 67
    Width = 45
    Height = 15
    Caption = 'Refei'#231#227'o'
  end
  object DiadaSemana: TLabel
    Left = 213
    Top = 96
    Width = 78
    Height = 15
    Caption = 'Dia da Semana'
  end
  object btn1: TSpeedButton
    Left = 297
    Top = 29
    Width = 23
    Height = 22
    Caption = '[...]'
    OnClick = btn1Click
  end
  object SpeedButton1: TSpeedButton
    Left = 297
    Top = 65
    Width = 23
    Height = 22
    Caption = '[...]'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 297
    Top = 93
    Width = 23
    Height = 22
    Caption = '[...]'
    OnClick = SpeedButton2Click
  end
  object Alimentos: TLabel
    Left = 237
    Top = 128
    Width = 54
    Height = 15
    Caption = 'Alimentos'
  end
  object SpeedButton4: TSpeedButton
    Left = 297
    Top = 121
    Width = 23
    Height = 22
    Caption = '[...]'
    OnClick = SpeedButton4Click
  end
  object lista_alimento: TDBGrid
    Left = 0
    Top = 215
    Width = 785
    Height = 177
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Salvar: TButton
    Left = 272
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 1
    OnClick = SalvarClick
  end
  object Excluir: TButton
    Left = 448
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 2
    OnClick = ExcluirClick
  end
  object Nome: TEdit
    Left = 336
    Top = 29
    Width = 121
    Height = 23
    TabOrder = 3
  end
  object DBEdit2: TEdit
    Left = 336
    Top = 64
    Width = 121
    Height = 23
    TabOrder = 4
  end
  object DBEdit3: TEdit
    Left = 336
    Top = 93
    Width = 121
    Height = 23
    TabOrder = 5
  end
  object DBEdit4: TEdit
    Left = 336
    Top = 125
    Width = 121
    Height = 23
    TabOrder = 6
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 600
    Top = 144
  end
  object FDQuery1: TFDQuery
    Connection = DataModule1.FDConnection1
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtWideMemo
        TargetDataType = dtWideString
      end>
    SQL.Strings = (
      '')
    Left = 600
    Top = 48
  end
end
