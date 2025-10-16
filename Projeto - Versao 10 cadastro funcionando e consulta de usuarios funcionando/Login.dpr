program Login;

uses
  Vcl.Forms,
  System.UITypes,
  Login_user in 'Login_user.pas' {Form2},
  Conexao in 'Conexao.pas' {DataModule1: TDataModule},
  MenusSistema in 'MenusSistema.pas' {Form1},
  Cadastro_User in 'Cadastro_User.pas' {FrmCadastro_Usuario},
  Consulta_User in 'Consulta_User.pas' {FrmConsulta_User},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  Application.Title := '';
  Application.CreateForm(TDataModule1, DataModule1);
  // cria conexão

  Form2 := TForm2.Create(nil); // cria login
  try
    if Form2.ShowModal = mrOk then
    begin
      Application.CreateForm(TForm1, Form1); // cria menu
      Application.Run;
    end
    else
      Application.Terminate;
  finally
    Form2.Free;
  end;
end.

