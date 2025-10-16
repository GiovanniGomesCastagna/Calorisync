unit MenusSistema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Data.DB, Cadastro_User,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

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
    procedure Cadastro2Click(Sender: TObject);
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
  if not Assigned(Cadastro_Usuario) then
    Cadastro_Usuario := TCadastro_Usuario.Create(Self);
end;

end.
