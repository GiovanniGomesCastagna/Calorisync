unit Login_user;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Conexao, MenusSistema;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Fundo_Panel: TImage;
    Usuáro: TLabel;
    User_Name: TEdit;
    Senha: TLabel;
    Senha_User: TEdit;
    Entrar: TButton;
    Imagem_Fundo: TImage;
    FDQuery1: TFDQuery;
    procedure EntrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure User_NameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Senha_UserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure User_NameChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  FDQuery1.Connection := DataModule1.FDConnection1;

end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then
    Close;
end;

procedure TForm2.User_NameChange(Sender: TObject);
var
  PosCursor: Integer;
begin
  PosCursor := User_Name.SelStart;
  User_Name.Text := UpperCase(User_Name.Text);
  User_Name.SelStart := PosCursor;
end;

procedure TForm2.User_NameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    Senha_User.SetFocus;
  end;
end;

procedure TForm2.Senha_UserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    EntrarClick(Sender);
  end;
end;

procedure TForm2.EntrarClick(Sender: TObject);
begin
  FDQuery1.Close;
  FDQuery1.SQL.Text :=
    'SELECT * FROM USUARIOS WHERE UPPER(NOME) = UPPER(:usuario) AND SENHA = :senha';

  FDQuery1.ParamByName('usuario').AsString := Trim(User_Name.Text);
  FDQuery1.ParamByName('senha').AsString := Trim(Senha_User.Text);

  FDQuery1.Open;

  if not FDQuery1.IsEmpty then
  begin
    ModalResult := mrOk;
  end
  else
    MessageDlg('Usuário ou senha inválidos.',TMsgDlgType.mtWarning,[mbOK],0);
end;

end.

