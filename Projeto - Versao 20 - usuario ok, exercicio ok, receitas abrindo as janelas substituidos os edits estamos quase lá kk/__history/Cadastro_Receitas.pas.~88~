unit Cadastro_Receitas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Refeicao_Cadastro, Data.Win.ADODB, Vcl.Mask, Dia_Semana, CadastroAlimentos;

type
  TCadastro_Receita = class(TForm)
    NomePessoa: TLabel;
    Cardapio: TLabel;
    lista_alimento: TDBGrid;
    Salvar: TButton;
    Excluir: TButton;
    Proximo: TButton;
    Anterior: TButton;
    Refeicao: TLabel;
    DiadaSemana: TLabel;
    btn1: TSpeedButton;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Alimentos: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Nome: TEdit;
    DBEdit2: TEdit;
    DBEdit3: TEdit;
    DBEdit4: TEdit;
    DBEdit1: TEdit;
    procedure btn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    procedure GridDblClick(Sender: TObject);
  public
  end;

var
  Cadastro_Receita: TCadastro_Receita;

implementation

{$R *.dfm}

uses Conexao;

{===========================}
{== Seleção de Usuário ====}
{===========================}
procedure TCadastro_Receita.btn1Click(Sender: TObject);
var
  FormGrid: TForm;
  Grid: TDBGrid;
  DSGrid: TDataSource;
  QryGrid: TFDQuery;
begin
  FormGrid := TForm.Create(Self);
  try
    FormGrid.Caption := 'Usuários Cadastrados';
    FormGrid.Width := 500;
    FormGrid.Height := 300;
    FormGrid.Position := poScreenCenter;
    FormGrid.BorderStyle := bsDialog;
    FormGrid.Color := clBtnFace;

    // Cria a Query
    QryGrid := TFDQuery.Create(FormGrid);
    QryGrid.Connection := DataModule1.FDConnection1;
    QryGrid.SQL.Text :=
      'SELECT CAST(NOME AS VARCHAR(100)) AS NOME, ' +
      'CAST(CPF AS VARCHAR(20)) AS CPF ' +
      'FROM USUARIOS ' +
      'ORDER BY NOME;';
    QryGrid.Open;

    // Cria o DataSource
    DSGrid := TDataSource.Create(FormGrid);
    DSGrid.DataSet := QryGrid;

    // Cria o Grid
    Grid := TDBGrid.Create(FormGrid);
    Grid.Parent := FormGrid;
    Grid.Align := alClient;
    Grid.DataSource := DSGrid;
    Grid.ReadOnly := True;
    Grid.Options := [dgTitles, dgRowSelect, dgColLines, dgRowLines];
    Grid.TitleFont.Style := [fsBold];
    Grid.Font.Size := 10;

    // Define títulos e tamanhos das colunas
    Grid.Columns[0].Title.Caption := 'Nome';
    Grid.Columns[1].Title.Caption := 'CPF';
    Grid.Columns[0].Width := 300;
    Grid.Columns[1].Width := 150;

    // Define evento e referência da query
    Grid.Tag := NativeInt(QryGrid);
    Grid.OnDblClick := GridDblClick;

    FormGrid.ShowModal;
  finally
    FormGrid.Free;
  end;
end;

{=================================}
{== Seleção de Refeição ========}
{=================================}
procedure TCadastro_Receita.SpeedButton1Click(Sender: TObject);
begin
  try
    Refecicao_Cadastro := TRefecicao_Cadastro.Create(Self);
    try
      if Refecicao_Cadastro.ShowModal = mrOk then
      begin
        if not Refecicao_Cadastro.QryRefeicao.IsEmpty then
          DBEdit2.Text := Refecicao_Cadastro.QryRefeicao.FieldByName('NOME_REFEICAO').AsString;
      end;
    finally
      Refecicao_Cadastro.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao abrir cadastro de refeições: ' + E.Message);
  end;
end;

{=================================}
{== Seleção de Dia da Semana ====}
{=================================}
procedure TCadastro_Receita.SpeedButton2Click(Sender: TObject);
begin
  try
    Dias_Semana := TDias_Semana.Create(Self);
    try
      if Dias_Semana.ShowModal = mrOk then
      begin
        if not Dias_Semana.QryDiaSemana.IsEmpty then
          DBEdit3.Text := Dias_Semana.QryDiaSemana.FieldByName('NOME_DIA').AsString;
      end;
    finally
      Dias_Semana.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao abrir cadastro de dia de semana: ' + E.Message);
  end;
end;

{=================================}
{== Seleção de Alimento =========}
{=================================}
procedure TCadastro_Receita.SpeedButton4Click(Sender: TObject);
var
  FormGrid: TForm;
  Grid: TDBGrid;
  DSGrid: TDataSource;
  QryGrid: TFDQuery;
begin
  FormGrid := TForm.Create(Self);
  try
    FormGrid.Caption := 'Selecione um alimento';
    FormGrid.Width := 600;
    FormGrid.Height := 400;
    FormGrid.Position := poScreenCenter;
    FormGrid.BorderStyle := bsDialog;
    FormGrid.Color := clBtnFace;

   // Cria a Query
   QryGrid := TFDQuery.Create(FormGrid);
   QryGrid.Connection := DataModule1.FDConnection1;
   QryGrid.SQL.Text :=
  'SELECT ID_ALIMENTO, ' +
  'CAST(NOME_ALIMENTO AS VARCHAR(100)) AS NOME_ALIMENTO, ' +
  'CAST(CALORIA_ALIMENTO AS VARCHAR(20)) AS CALORIA_ALIMENTO, ' +
  'CAST(PESO_ALIMENTO_G AS VARCHAR(20)) AS PESO_ALIMENTO_G ' +
  'FROM CADASTRO_ALIMENTOS ' +
  'ORDER BY NOME_ALIMENTO;';
   QryGrid.Open;


    // Cria o DataSource
    DSGrid := TDataSource.Create(FormGrid);
    DSGrid.DataSet := QryGrid;

    // Cria o Grid
    Grid := TDBGrid.Create(FormGrid);
    Grid.Parent := FormGrid;
    Grid.Align := alClient;
    Grid.DataSource := DSGrid;
    Grid.ReadOnly := True;
    Grid.Options := Grid.Options + [dgRowSelect, dgTitles];
    Grid.TitleFont.Style := [fsBold];

    // Define evento e referência da query
    Grid.Tag := NativeInt(QryGrid);
    Grid.OnDblClick := GridDblClick;

    FormGrid.ShowModal;
  finally
    FormGrid.Free;
  end;
end;

{=================================}
{== Evento de Duplo Clique ======}
{=================================}
procedure TCadastro_Receita.GridDblClick(Sender: TObject);
var
  Grid: TDBGrid;
  QryGrid: TFDQuery;
begin
  Grid := Sender as TDBGrid;
  QryGrid := TFDQuery(Pointer(Grid.Tag));

  if (QryGrid <> nil) and (not QryGrid.IsEmpty) then
  begin
    // Se for grid de alimentos
    if QryGrid.FindField('NOME_ALIMENTO') <> nil then
    begin
      DBEdit4.Text := QryGrid.FieldByName('NOME_ALIMENTO').AsString;

      // (Opcional) carregar também calorias e peso:
      // DBEdit1.Text := QryGrid.FieldByName('CALORIA_ALIMENTO').AsString;
      // DBEdit2.Text := QryGrid.FieldByName('PESO_ALIMENTO_G').AsString;
    end
    // Se for grid de usuários
    else if QryGrid.FindField('NOME') <> nil then
    begin
      Nome.Text := QryGrid.FieldByName('NOME').AsString;
    end;
  end;

  // Fecha o form que contém o grid
  if (Grid.Parent is TForm) then
    (Grid.Parent as TForm).Close;
end;

end.

