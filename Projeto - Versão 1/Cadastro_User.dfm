object Cadastro_Usuario: TCadastro_Usuario
  Left = 0
  Top = 0
  Anchors = [akTop, akRight]
  BorderStyle = bsSingle
  Caption = 'Cadastro_Usuario'
  ClientHeight = 647
  ClientWidth = 940
  Color = 14085375
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poOwnerFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object Painel_Cad: TPanel
    Left = -10
    Top = 0
    Width = 942
    Height = 649
    BevelOuter = bvNone
    Color = 14085375
    ParentBackground = False
    TabOrder = 0
    OnResize = FormResize
    object Nome_Razao_social: TLabel
      Left = 409
      Top = 48
      Width = 103
      Height = 15
      Caption = 'Nome/Raz'#227'o Social'
    end
    object Senha: TLabel
      Left = 407
      Top = 206
      Width = 32
      Height = 15
      Caption = 'Senha'
    end
    object CRN_SIM_NAO: TLabel
      Left = 409
      Top = 261
      Width = 66
      Height = 15
      Caption = 'Possui CRN?'
    end
    object Sexo: TLabel
      Left = 409
      Top = 334
      Width = 25
      Height = 15
      Caption = 'Sexo'
    end
    object Documentos: TLabel
      Left = 408
      Top = 114
      Width = 68
      Height = 15
      Caption = 'Documentos'
    end
    object Sim: TRadioButton
      Left = 407
      Top = 282
      Width = 57
      Height = 17
      Caption = 'Sim'
      TabOrder = 0
    end
    object Inserir_nome: TEdit
      Left = 409
      Top = 77
      Width = 121
      Height = 23
      TabOrder = 1
    end
    object Inserir_CPF_CNPJ: TEdit
      Left = 409
      Top = 177
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object Nao: TRadioButton
      Left = 481
      Top = 282
      Width = 49
      Height = 17
      Caption = 'N'#227'o'
      TabOrder = 3
    end
    object Excluir: TButton
      Left = 552
      Top = 420
      Width = 75
      Height = 25
      Caption = 'Excluir'
      TabOrder = 4
    end
    object Editar: TButton
      Left = 437
      Top = 420
      Width = 75
      Height = 25
      Caption = 'Editar'
      TabOrder = 5
    end
    object Digite_Senha: TEdit
      Left = 407
      Top = 232
      Width = 121
      Height = 23
      TabOrder = 6
    end
    object Digite_CRN: TEdit
      Left = 407
      Top = 305
      Width = 121
      Height = 23
      TabOrder = 7
    end
    object CPF: TRadioButton
      Left = 479
      Top = 146
      Width = 49
      Height = 17
      Caption = 'CPF'
      TabOrder = 8
    end
    object CNPJ: TRadioButton
      Left = 407
      Top = 146
      Width = 50
      Height = 17
      Caption = 'CNPJ'
      TabOrder = 9
    end
    object Cadastrar: TButton
      Left = 320
      Top = 420
      Width = 75
      Height = 25
      Caption = 'Cadastrar'
      TabOrder = 10
    end
    object Masculino: TRadioButton
      Left = 407
      Top = 355
      Width = 81
      Height = 17
      Caption = 'Masculino'
      TabOrder = 11
    end
    object Feminino: TRadioButton
      Left = 407
      Top = 378
      Width = 80
      Height = 17
      Caption = 'Feminino'
      TabOrder = 12
    end
  end
end
