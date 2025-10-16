object Cadastro_Receita: TCadastro_Receita
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cardapio'
  ClientHeight = 411
  ClientWidth = 727
  Color = 14085375
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object NomePessoa: TLabel
    Left = 203
    Top = 32
    Width = 72
    Height = 15
    Caption = 'Nome Pessoa'
  end
  object Cardapio: TLabel
    Left = 227
    Top = 76
    Width = 48
    Height = 15
    Caption = 'Cardapio'
  end
  object Refeicao: TLabel
    Left = 230
    Top = 115
    Width = 45
    Height = 15
    Caption = 'Refeicao'
  end
  object DiadaSemana: TLabel
    Left = 203
    Top = 136
    Width = 72
    Height = 15
    Caption = 'DiadaSemana'
  end
  object btn1: TSpeedButton
    Left = 297
    Top = 29
    Width = 23
    Height = 22
  end
  object lista_alimento: TDBGrid
    Left = 0
    Top = 232
    Width = 729
    Height = 177
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dblklst1: TDBLookupListBox
    Left = 358
    Top = 32
    Width = 35
    Height = 19
    TabOrder = 1
  end
  object Salvar: TButton
    Left = 32
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
  end
  object Excluir: TButton
    Left = 152
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
  end
  object Proximo: TButton
    Left = 270
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Proximo'
    TabOrder = 4
  end
  object Anterior: TButton
    Left = 376
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Anterior'
    TabOrder = 5
  end
  object IDcardapio: TDBLookupListBox
    Left = 358
    Top = 72
    Width = 121
    Height = 19
    TabOrder = 6
  end
  object dblklst2: TDBLookupListBox
    Left = 358
    Top = 97
    Width = 121
    Height = 19
    TabOrder = 7
  end
  object dblklst3: TDBLookupListBox
    Left = 358
    Top = 122
    Width = 121
    Height = 19
    TabOrder = 8
  end
end
