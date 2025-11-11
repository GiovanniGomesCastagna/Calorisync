unit MenusSistema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,ShellAPI, Cadastro_Treino,
  Cadastro_User, Consulta_User, System.ImageList, Vcl.ImgList, CadastroAlimentos, Cadastro_Receitas,UnRelatorioConsumo,
  Cadastro_Exercicio;

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
    Ajuda1: TMenuItem;
    Manual1: TMenuItem;
    Suporte1: TMenuItem;
    procedure Cadastro2Click(Sender: TObject);
    procedure CadastroAlimentos1Click(Sender: TObject);
    procedure Cardapio1Click(Sender: TObject);
    procedure CadastroExercicios1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Manual1Click(Sender: TObject);
    procedure Suporte1Click(Sender: TObject);
    procedure reinos1Click(Sender: TObject);
    procedure Relatorio2Click(Sender: TObject);
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

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
    Close;
end;

procedure TForm1.Manual1Click(Sender: TObject);
begin
  ShellExecute(0, 'open',
    'https://docs.google.com/document/d/1998JFe_jNydmSZH2781lmlRJRdkr23vJ/edit#heading=h.5ams723lvqmt',
    nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.reinos1Click(Sender: TObject);
begin
  if not Assigned(DMCadastro_Treino) then
    DMCadastro_Treino := TDMCadastro_Treino.Create(Self);
  DMCadastro_Treino.Show;
end;


procedure TForm1.Relatorio2Click(Sender: TObject);
begin
  if not Assigned(Relatorio_Consumo) then
    Relatorio_Consumo := TRelatorio_Consumo.Create(Self);
  Relatorio_Consumo.Show;
end;

procedure TForm1.Suporte1Click(Sender: TObject);
begin
  ShellExecute(0, 'open',
  'https://wa.me/5549988749516?text=Olá,+preciso+de+suporte!',
  nil, nil, SW_SHOWNORMAL);

end;

end.
