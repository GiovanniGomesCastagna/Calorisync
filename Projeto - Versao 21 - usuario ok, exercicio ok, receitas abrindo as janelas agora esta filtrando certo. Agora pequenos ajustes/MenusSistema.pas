unit MenusSistema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Cadastro_User, Consulta_User, System.ImageList, Vcl.ImgList, CadastroAlimentos, Cadastro_Receitas, Cadastro_Exercicio;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Cadastro2: TMenuItem;
    CadastroAlimentos1: TMenuItem;
    Consulta1: TMenuItem;
    reinos1: TMenuItem;
    Cardapio1: TMenuItem;
    Relatorio1: TMenuItem;
    Relatorio2: TMenuItem;
    CadastroExercicios1: TMenuItem;
    ImageList1: TImageList;
    procedure Cadastro2Click(Sender: TObject);
    procedure CadastroAlimentos1Click(Sender: TObject);
    procedure Cardapio1Click(Sender: TObject);
    procedure CadastroExercicios1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Cadastro2Click(Sender: TObject);
begin
  if not Assigned(FrmConsulta_User) then
    FrmConsulta_User := TConsulta_User.Create(Self);
  FrmConsulta_User.Show;
end;

procedure TForm1.CadastroAlimentos1Click(Sender: TObject);
begin
  if not Assigned(Cadastro_Alimentos) then
  Cadastro_Alimentos := TCadastro_Alimentos.Create(Self);
  Cadastro_Alimentos.Show;
end;

procedure TForm1.CadastroExercicios1Click(Sender: TObject);
begin
  if not Assigned(Cad_Exercicio) then
  Cad_Exercicio := TCad_Exercicio.Create(Self);
  Cad_Exercicio.Show;

end;

procedure TForm1.Cardapio1Click(Sender: TObject);
begin
  if not Assigned(Cadastro_Receita) then
  Cadastro_Receita := TCadastro_Receita.Create(Self);
  Cadastro_Receita.Show;

end;

end.
