unit Cadastro_User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Mask,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Conexao,
  Pesquisa_Usuario,
  Vcl.Imaging.pngimage;

type
  TCadastro_Usuario = class(TForm)
    Nome_Razao_social: TLabel;
    Inserir_nome: TEdit;
    Digite_CRN: TMaskEdit;
    Digite_Senha: TEdit;
    CNPJ: TRadioButton;
    CPF: TRadioButton;
    Nao_CRN: TRadioButton;
    Sim_CRN: TRadioButton;
    Senha: TLabel;
    CRN_SIM_NAO: TLabel;
    Cadastrar: TButton;
    Painel_Cad: TPanel;
    Sexo: TLabel;
    Masculino: TRadioButton;
    Feminino: TRadioButton;
    Documentos: TLabel;
    Inserir_CPF_CNPJ: TMaskEdit;
    FDQuery1: TFDQuery;
    CRN_Panel: TPanel;
    Sxo_Panel: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CPFClick(Sender: TObject);
    procedure CNPJClick(Sender: TObject);
    procedure Sim_CRNClick(Sender: TObject);
    procedure Nao_CRNClick(Sender: TObject);
    procedure CadastrarClick(Sender: TObject);
    procedure LimparCampos;
    procedure BtnPesquisarUsuarioClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Inserir_CPF_CNPJChange(Sender: TObject);
  private
    FEditando: Boolean;
    procedure CentralizarPainel;
    function RetirarMascara(const Valor: string): string;
    function SexoSelecionado: string;
    procedure CarregarUsuarioPorDocumento(const Documento: string; IsCPF: Boolean);
  public
  end;

var
  Cadastro_Usuario: TCadastro_Usuario;

implementation

{$R *.dfm}

procedure TCadastro_Usuario.BtnPesquisarUsuarioClick(Sender: TObject);
begin
  with TFormPesquisaUsuario.Create(Self) do
    try
      if ShowModal = mrOk then
      begin
        Inserir_nome.Text := NomeSelecionado;
        Digite_Senha.Text := SenhaSelecionada;
        Inserir_CPF_CNPJ.Text := DocumentoSelecionado;

        if Length(RetirarMascara(DocumentoSelecionado)) = 11 then
          CPF.Checked := True
        else
          CNPJ.Checked := True;

        FEditando := True;
        Cadastrar.Caption := 'Salvar';
      end;
    finally
      Free;
    end;
end;

procedure TCadastro_Usuario.CadastrarClick(Sender: TObject);
var
  vNome, vCPF, vCNPJ, vTipoConta, vCNR, vSenha, vSexo: string;
begin
  if Trim(Inserir_nome.Text) = '' then
  begin
    MessageDlg('O campo Nome/Razão Social é obrigatório.', mtWarning, [mbOK], 0);
    Inserir_nome.SetFocus;
    Exit;
  end;

  if Trim(Digite_Senha.Text) = '' then
  begin
    MessageDlg('O campo Senha é obrigatório.', mtWarning, [mbOK], 0);
    Digite_Senha.SetFocus;
    Exit;
  end;

  vNome := Trim(Inserir_nome.Text);
  vSenha := Digite_Senha.Text;
  vSexo := SexoSelecionado;
  vCNR := '';
  vCPF := '';
  vCNPJ := '';

  if CPF.Checked then
  begin
    vTipoConta := 'F';
    vCPF := RetirarMascara(Inserir_CPF_CNPJ.Text);
    if Length(vCPF) <> 11 then
    begin
      MessageDlg('O CPF informado é inválido.', mtWarning, [mbOK], 0);
      Inserir_CPF_CNPJ.SetFocus;
      Exit;
    end;
  end
  else if CNPJ.Checked then
  begin
    vTipoConta := 'J';
    vCNPJ := RetirarMascara(Inserir_CPF_CNPJ.Text);
    if Length(vCNPJ) <> 14 then
    begin
      MessageDlg('O CNPJ informado é inválido.', mtWarning, [mbOK], 0);
      Inserir_CPF_CNPJ.SetFocus;
      Exit;
    end;
    vSexo := '';
  end
  else
  begin
    MessageDlg('Selecione um tipo de documento (CPF ou CNPJ).', mtWarning, [mbOK], 0);
    Exit;
  end;

  if Sim_CRN.Checked then
  begin
    if Trim(Digite_CRN.Text) = '' then
    begin
      MessageDlg('O campo CRN é obrigatório.', mtWarning, [mbOK], 0);
      Digite_CRN.SetFocus;
      Exit;
    end;
    vCNR := Trim(Digite_CRN.Text);
  end;

  try
    if not FEditando then
    begin
      // 🚀 INSERT
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add
        ('INSERT INTO USUARIOS (NOME, CPF, CNPJ, TIPO_CONTA, CNR, SENHA, SEXO) ');
      FDQuery1.SQL.Add('VALUES (:NOME, :CPF, :CNPJ, :TIPO_CONTA, :CNR, :SENHA, :SEXO)');
      FDQuery1.ParamByName('TIPO_CONTA').AsString := vTipoConta;
    end
    else
    begin
      // ✏️ UPDATE
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('UPDATE USUARIOS SET ');
      FDQuery1.SQL.Add('NOME = :NOME, SENHA = :SENHA, SEXO = :SEXO, CNR = :CNR ');
      FDQuery1.SQL.Add('WHERE (CPF = :CPF AND :CPF <> '''') OR (CNPJ = :CNPJ AND :CNPJ <> '''')');
    end;

    FDQuery1.ParamByName('NOME').AsString := vNome;
    FDQuery1.ParamByName('CPF').AsString := vCPF;
    FDQuery1.ParamByName('CNPJ').AsString := vCNPJ;
    FDQuery1.ParamByName('CNR').AsString := vCNR;
    FDQuery1.ParamByName('SENHA').AsString := vSenha;
    FDQuery1.ParamByName('SEXO').AsString := vSexo;

    FDQuery1.ExecSQL;

    if not FEditando then
      MessageDlg('Usuário cadastrado com sucesso!', mtConfirmation, [mbOK], 0)
    else
      MessageDlg('Usuário atualizado com sucesso!', mtConfirmation, [mbOK], 0);

    LimparCampos;
    FEditando := False;
    Cadastrar.Caption := 'Cadastrar';

  except
    on E: Exception do
      MessageDlg('Erro ao salvar usuário: ' + E.Message, mtWarning, [mbOK], 0);
  end;
end;

procedure TCadastro_Usuario.CentralizarPainel;
begin
  Painel_Cad.Left := (ClientWidth - Painel_Cad.Width) div 2;
  Painel_Cad.Top := (ClientHeight - Painel_Cad.Height) div 2;
end;

procedure TCadastro_Usuario.FormCreate(Sender: TObject);
begin
  Position := poScreenCenter;
  CentralizarPainel;

  FEditando := False;
  Cadastrar.Caption := 'Cadastrar';

  CPF.Checked := True;
  Inserir_CPF_CNPJ.EditMask := '000.000.000-00;0;_';
  Inserir_CPF_CNPJ.ReadOnly := False;
  Inserir_CPF_CNPJ.Enabled := True;
  Inserir_CPF_CNPJ.Text := '';

  Nao_CRN.Checked := True;
  Digite_CRN.Clear;
  Digite_CRN.Enabled := False;
  Digite_CRN.ReadOnly := True;
  Digite_CRN.Cursor := crDefault;
  Digite_CRN.Visible := False;
end;

procedure TCadastro_Usuario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TCadastro_Usuario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  Cadastro_Usuario := nil;
end;

procedure TCadastro_Usuario.FormResize(Sender: TObject);
begin
  CentralizarPainel;
end;


procedure TCadastro_Usuario.Inserir_CPF_CNPJChange(Sender: TObject);
var
  vDoc: string;
begin
  vDoc := RetirarMascara(Inserir_CPF_CNPJ.Text);

  if (CPF.Checked and (Length(vDoc) = 11)) then
    CarregarUsuarioPorDocumento(vDoc, True)
  else if (CNPJ.Checked and (Length(vDoc) = 14)) then
    CarregarUsuarioPorDocumento(vDoc, False);
end;

procedure TCadastro_Usuario.CarregarUsuarioPorDocumento(const Documento: string; IsCPF: Boolean);
begin
  try
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    if IsCPF then
      FDQuery1.SQL.Add('SELECT NOME, SENHA, SEXO, CNR FROM USUARIOS WHERE CPF = :DOC')
    else
      FDQuery1.SQL.Add('SELECT NOME, SENHA, SEXO, CNR FROM USUARIOS WHERE CNPJ = :DOC');

    FDQuery1.ParamByName('DOC').AsString := Documento;
    FDQuery1.Open;

    if not FDQuery1.Eof then
    begin
      Inserir_nome.Text := FDQuery1.FieldByName('NOME').AsString;
      Digite_Senha.Text := FDQuery1.FieldByName('SENHA').AsString;

      if IsCPF then
      begin
        if FDQuery1.FieldByName('SEXO').AsString = 'M' then
          Masculino.Checked := True
        else if FDQuery1.FieldByName('SEXO').AsString = 'F' then
          Feminino.Checked := True
        else
        begin
          Masculino.Checked := False;
          Feminino.Checked := False;
        end;
      end
      else
      begin
        Masculino.Checked := False;
        Feminino.Checked := False;
      end;

      if FDQuery1.FieldByName('CNR').AsString <> '' then
      begin
        Sim_CRN.Checked := True;
        Digite_CRN.Enabled := True;
        Digite_CRN.ReadOnly := False;
        Digite_CRN.Text := FDQuery1.FieldByName('CNR').AsString;
        Digite_CRN.Visible := True;
      end
      else
      begin
        Nao_CRN.Checked := True;
        Digite_CRN.Clear;
        Digite_CRN.Enabled := False;
        Digite_CRN.ReadOnly := True;
        Digite_CRN.Visible := False;
      end;

      FEditando := True;
      Cadastrar.Caption := 'Salvar';
      MessageDlg('Documento já cadastrado. Dados carregados.', mtInformation, [mbOK], 0);
    end
    else
    begin
      FEditando := False;
      Cadastrar.Caption := 'Cadastrar';
    end;

  except
    on E: Exception do
      MessageDlg('Erro ao consultar documento: ' + E.Message, mtWarning, [mbOK], 0);
  end;
end;

procedure TCadastro_Usuario.CPFClick(Sender: TObject);
begin
  Inserir_CPF_CNPJ.EditMask := '000.000.000-00;0;_';
  Inserir_CPF_CNPJ.ReadOnly := False;
  Inserir_CPF_CNPJ.Enabled := True;
  Inserir_CPF_CNPJ.Text := '';
  Inserir_CPF_CNPJ.Visible := True;
  Inserir_CPF_CNPJ.SetFocus;
  Inserir_CPF_CNPJ.SelStart := 0;

  Masculino.Visible := True;
  Feminino.Visible := True;
  Sexo.Visible := True;
  Sxo_Panel.Visible := True;
end;

procedure TCadastro_Usuario.CNPJClick(Sender: TObject);
begin
  Inserir_CPF_CNPJ.EditMask := '00.000.000/0000-00;0;_';
  Inserir_CPF_CNPJ.ReadOnly := False;
  Inserir_CPF_CNPJ.Enabled := True;
  Inserir_CPF_CNPJ.Text := '';
  Inserir_CPF_CNPJ.Visible := True;
  Inserir_CPF_CNPJ.SetFocus;
  Inserir_CPF_CNPJ.SelStart := 0;

  Masculino.Visible := False;
  Feminino.Visible := False;
  Sexo.Visible := False;
  Sxo_Panel.Visible := False;
end;

procedure TCadastro_Usuario.Sim_CRNClick(Sender: TObject);
begin
  Digite_CRN.EditMask := '';
  Digite_CRN.ReadOnly := False;
  Digite_CRN.Enabled := True;
  Digite_CRN.Text := '';
  Digite_CRN.SelStart := Length(Digite_CRN.Text);
  Digite_CRN.Cursor := crIBeam;
  Digite_CRN.Visible := True;
end;

procedure TCadastro_Usuario.Nao_CRNClick(Sender: TObject);
begin
  Digite_CRN.Clear;
  Digite_CRN.ReadOnly := True;
  Digite_CRN.Enabled := False;
  Digite_CRN.Cursor := crDefault;
  Digite_CRN.Visible := False;
end;

function TCadastro_Usuario.RetirarMascara(const Valor: string): string;
var
  i: Integer;
  c: Char;
  Resultado: string;
begin
  Resultado := '';
  for i := 1 to Length(Valor) do
  begin
    c := Valor[i];
    if CharInSet(c, ['0' .. '9']) then
      Resultado := Resultado + c;
  end;
  Result := Resultado;
end;

function TCadastro_Usuario.SexoSelecionado: string;
begin
  if Masculino.Checked then
    Result := 'M'
  else if Feminino.Checked then
    Result := 'F'
  else
    Result := '';
end;

procedure TCadastro_Usuario.LimparCampos;
begin
  Inserir_nome.Clear;
  Digite_Senha.Clear;
  Inserir_CPF_CNPJ.Clear;
  Digite_CRN.Clear;

  CPF.Checked := True;
  Nao_CRN.Checked := True;
  Masculino.Checked := False;
  Feminino.Checked := False;

  Inserir_CPF_CNPJ.EditMask := '000.000.000-00;0;_';
  Inserir_CPF_CNPJ.Enabled := True;
  Inserir_CPF_CNPJ.ReadOnly := False;

  Digite_CRN.Enabled := False;
  Digite_CRN.ReadOnly := True;
  Digite_CRN.Cursor := crDefault;

  FEditando := False;
  Cadastrar.Caption := 'Cadastrar';

  Inserir_nome.SetFocus;
end;

end.

