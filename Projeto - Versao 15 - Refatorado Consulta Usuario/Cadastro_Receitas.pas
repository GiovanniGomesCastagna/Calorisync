unit Cadastro_Receitas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls;

type
  TCadastro_Receita = class(TForm)
    NomePessoa: TLabel;
    Cardapio: TLabel;
    lista_alimento: TDBGrid;
    dblklst1: TDBLookupListBox;
    Salvar: TButton;
    Excluir: TButton;
    Proximo: TButton;
    Anterior: TButton;
    IDcardapio: TDBLookupListBox;
    Refeicao: TLabel;
    DiadaSemana: TLabel;
    dblklst2: TDBLookupListBox;
    dblklst3: TDBLookupListBox;
    btn1: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Cadastro_Receita: TCadastro_Receita;

implementation

{$R *.dfm}

end.
