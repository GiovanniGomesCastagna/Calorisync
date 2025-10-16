unit Cadastro_User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TCadastro_Usuario = class(TForm)
    Nome_Razao_social: TLabel;
    Inserir_nome: TEdit;
    Inserir_CPF_CNPJ: TEdit;
    Digite_CRN: TEdit;
    Digite_Senha: TEdit;
    CNPJ: TRadioButton;
    CPF: TRadioButton;
    Nao: TRadioButton;
    Sim: TRadioButton;
    Senha: TLabel;
    CRN_SIM_NAO: TLabel;
    Cadastrar: TButton;
    Editar: TButton;
    Excluir: TButton;
    Painel_Cad: TPanel;
    Sexo: TLabel;
    Masculino: TRadioButton;
    Feminino: TRadioButton;
    Documentos: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Cadastro_Usuario: TCadastro_Usuario;

implementation

{$R *.dfm}

procedure TCadastro_Usuario.FormCreate(Sender: TObject);
begin
  Position := poScreenCenter;
  // Centraliza o painel ao abrir
  Painel_cad.Left := (ClientWidth - Painel_cad.Width) div 2;
  Painel_cad.Top := (ClientHeight - Painel_cad.Height) div 2;
end;

procedure TCadastro_Usuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;            // Libera o form da memória ao fechar
  Cadastro_Usuario := nil;     // Evita ponteiro inválido
end;

procedure TCadastro_Usuario.FormResize(Sender: TObject);
begin
  // Centraliza o painel ao redimensionar/maximizar
  Painel_cad.Left := (ClientWidth - Painel_cad.Width) div 2;
  Painel_cad.Top := (ClientHeight - Painel_cad.Height) div 2;
end;

end.

