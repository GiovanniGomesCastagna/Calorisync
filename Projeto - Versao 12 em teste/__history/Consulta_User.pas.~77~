unit Consulta_User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Conexao, System.StrUtils;

type
  TConsulta_User = class(TForm)
    Nome_Razao_social: TLabel;
    Documentos: TLabel;
    Inserir_nome: TEdit;
    CNPJ: TRadioButton;
    CPF: TRadioButton;
    Inserir_CPF_CNPJ: TMaskEdit;
    Senha: TLabel;
    Digite_Senha: TEdit;
    CRN_Panel: TPanel;
    CRN_SIM_NAO: TLabel;
    Nao_CRN: TRadioButton;
    Sim_CRN: TRadioButton;
    Digite_CRN: TMaskEdit;
    Sxo_Panel: TPanel;
    Sexo: TLabel;
    Masculino: TRadioButton;
    Feminino: TRadioButton;
    FDQuery1: TFDQuery;
    DBGrid1: TDBGrid;
    Salvar: TButton;
    DataSource1: TDataSource;
    FDQuery1NOME: TWideStringField;
    FDQuery1CPF: TWideStringField;
    FDQuery1CNPJ: TWideStringField;
    FDQuery1TIPO_CONTA: TWideStringField;
    FDQuery1CNR: TWideStringField;
    FDQuery1SEXO: TWideStringField;
    Excluir: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ExcluirClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure CNPJClick(Sender: TObject);
    procedure CPFClick(Sender: TObject);
    procedure SalvarClick(Sender: TObject);
    procedure Sim_CRNClick(Sender: TObject);
    procedure Nao_CRNClick(Sender: TObject);
    procedure AutoAjustarColunas(Grid: TDBGrid);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
  public
  end;

var
  FrmConsulta_User: TConsulta_User;

implementation

{$R *.dfm}

procedure TConsulta_User.FormCreate(Sender: TObject);
begin
  FDQuery1.Connection := DataModule1.FDConnection1;
end;

procedure TConsulta_User.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TConsulta_User.FormShow(Sender: TObject);
begin
  FDQuery1.Close;
  FDQuery1.SQL.Text :=
    'SELECT NOME, CPF, CNPJ, TIPO_CONTA, CNR, SEXO, SENHA FROM Usuarios';
  FDQuery1.Open;

  // Máscaras corretas
  FDQuery1CPF.EditMask := '000.000.000-00;0'; // 11 dígitos
  FDQuery1CNPJ.EditMask := '00.000.000/0000-00;0'; // 14 dígitos

  DBGrid1.Columns[3].Title.Caption := 'Tipo Conta';
  AutoAjustarColunas(DBGrid1);
end;


procedure TConsulta_User.Nao_CRNClick(Sender: TObject);
begin
  Digite_CRN.Visible := False;
  Digite_CRN.Clear; // opcional, limpa o campo quando oculto
end;

procedure TConsulta_User.SalvarClick(Sender: TObject);
var
  CPF_CNPJ: string;
begin
  if FDQuery1.IsEmpty then
  begin
    ShowMessage('Nenhum registro selecionado para atualizar!');
    Exit;
  end;

  // Determina o CPF ou CNPJ atual
  if FDQuery1.FieldByName('CPF').AsString <> '' then
    CPF_CNPJ := FDQuery1.FieldByName('CPF').AsString
  else
    CPF_CNPJ := FDQuery1.FieldByName('CNPJ').AsString;

  // Executa o UPDATE no banco
  FDQuery1.Connection.ExecSQL(
    'UPDATE Usuarios SET ' +
    'NOME = :NOME, ' +
    'CPF = :CPF, ' +
    'CNPJ = :CNPJ, ' +
    'SEXO = :SEXO, ' +
    'CNR = :CNR, ' +
    'SENHA = :SENHA ' +
    'WHERE CPF = :OLDCPF OR CNPJ = :OLDCNPJ',
    [
      Inserir_nome.Text,
      IfThen(CPF.Checked, Inserir_CPF_CNPJ.Text, ''),
      IfThen(CNPJ.Checked, Inserir_CPF_CNPJ.Text, ''),
      IfThen(Masculino.Checked, 'M', IfThen(Feminino.Checked, 'F', '')),
      IfThen(Sim_CRN.Checked, Digite_CRN.Text, ''),
      Digite_Senha.Text,
      CPF_CNPJ,
      CPF_CNPJ
    ]
  );

  // Atualiza a query para mostrar as alterações
  FDQuery1.Close;
  FDQuery1.Open;

  // Limpa todos os campos do formulário
  Inserir_nome.Clear;
  CPF.Checked := False;
  CNPJ.Checked := False;
  Inserir_CPF_CNPJ.Clear;
  Masculino.Checked := False;
  Feminino.Checked := False;
  Sim_CRN.Checked := False;
  Nao_CRN.Checked := False;
  Digite_CRN.Clear;
  Digite_Senha.Clear;

  ShowMessage('Registro atualizado com sucesso!');
end;



procedure TConsulta_User.Sim_CRNClick(Sender: TObject);
begin
  Digite_CRN.Visible := True;
end;

procedure TConsulta_User.AutoAjustarColunas(Grid: TDBGrid);
var
  i, j: Integer;
  MaxLargura, LarguraTitulo, LarguraCampo: Integer;
  Texto: string;
begin
  if not Assigned(Grid.DataSource) or not Assigned(Grid.DataSource.DataSet) then
    Exit;

  for i := 0 to Grid.Columns.Count - 1 do
  begin
    // largura mínima pelo título
    LarguraTitulo := Grid.Canvas.TextWidth(Grid.Columns[i].Title.Caption) + 10;
    MaxLargura := LarguraTitulo;

    // largura pelo conteúdo
    Grid.DataSource.DataSet.DisableControls; // evita refresh visual a cada leitura
    try
      Grid.DataSource.DataSet.First;
      while not Grid.DataSource.DataSet.Eof do
      begin
        Texto := Grid.Columns[i].Field.AsString;
        LarguraCampo := Grid.Canvas.TextWidth(Texto) + 35;
        if LarguraCampo > MaxLargura then
          MaxLargura := LarguraCampo;
        Grid.DataSource.DataSet.Next;
      end;
    finally
      Grid.DataSource.DataSet.EnableControls;
    end;

    // define a largura final da coluna
    Grid.Columns[i].Width := MaxLargura;
  end;
end;

procedure TConsulta_User.CNPJClick(Sender: TObject);
begin
  Inserir_CPF_CNPJ.EditMask := '00.000.000/0000-00;0'; // 14 dígitos
  Inserir_CPF_CNPJ.Clear;
  Sxo_Panel.Visible := False;
end;

procedure TConsulta_User.CPFClick(Sender: TObject);
begin
  Inserir_CPF_CNPJ.EditMask := '000.000.000-00;0'; // 11 dígitos
  Inserir_CPF_CNPJ.Clear;
  Sxo_Panel.Visible := True;
end;

procedure TConsulta_User.DBGrid1DblClick(Sender: TObject);
begin
  if FDQuery1.IsEmpty then
    Exit;

  // Preenche os campos de texto
  Inserir_nome.Text := FDQuery1.FieldByName('NOME').AsString;

  // Define se é CPF ou CNPJ
  if FDQuery1.FieldByName('CPF').AsString <> '' then
  begin
    CPF.Checked := True;
    Inserir_CPF_CNPJ.Text := FDQuery1.FieldByName('CPF').AsString;
  end
  else
  begin
    CNPJ.Checked := True;
    Inserir_CPF_CNPJ.Text := FDQuery1.FieldByName('CNPJ').AsString;
  end;

  // Sexo
  if FDQuery1.FieldByName('SEXO').AsString = 'M' then
    Masculino.Checked := True
  else if FDQuery1.FieldByName('SEXO').AsString = 'F' then
    Feminino.Checked := True
  else
  begin
    Masculino.Checked := False;
    Feminino.Checked := False;
  end;

  // CRN
  if FDQuery1.FieldByName('CNR').AsString <> '' then
  begin
    Sim_CRN.Checked := True;
    Digite_CRN.Text := FDQuery1.FieldByName('CNR').AsString;
  end
  else
  begin
    Nao_CRN.Checked := True;
    Digite_CRN.Clear;
  end;
  Digite_Senha.Text := FDQuery1.FieldByName('SENHA').AsString;
end;

procedure TConsulta_User.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Texto: string;
begin
  if Column.Field.FieldName = 'SENHA' then
  begin
    Texto := StringOfChar('*', Length(Column.Field.AsString));
    DBGrid1.Canvas.FillRect(Rect);
    DBGrid1.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Texto);
  end
  else
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;


procedure TConsulta_User.ExcluirClick(Sender: TObject);
var
  CPF_CNPJ: string;
  Bookmark: TBookmark;
begin
  if FDQuery1.IsEmpty then
  begin
    ShowMessage('Nenhum registro selecionado!');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir este registro?', mtConfirmation,
    [mbYes, mbNo], 0) = mrNo then
    Exit;

  // Salva posição atual
  Bookmark := FDQuery1.GetBookmark;
  try
    if FDQuery1.FieldByName('CPF').AsString <> '' then
      CPF_CNPJ := FDQuery1.FieldByName('CPF').AsString
    else
      CPF_CNPJ := FDQuery1.FieldByName('CNPJ').AsString;

    FDQuery1.Connection.ExecSQL
      ('DELETE FROM Usuarios WHERE CPF = :CPF OR CNPJ = :CNPJ',
      [CPF_CNPJ, CPF_CNPJ]);

    // Reabre a query e tenta manter a posição
    FDQuery1.Close;
    FDQuery1.Open;
  finally
    if FDQuery1.BookmarkValid(Bookmark) then
      FDQuery1.GotoBookmark(Bookmark);
    FDQuery1.FreeBookmark(Bookmark);
  end;
end;

procedure TConsulta_User.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FrmConsulta_User := nil;
end;

end.
