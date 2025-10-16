unit Consulta_User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Conexao;

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
  FDQuery1.SQL.Text := 'SELECT NOME, CPF, CNPJ, TIPO_CONTA, CNR, SEXO FROM Usuarios';
  FDQuery1.Open;

  // Máscaras corretas
  FDQuery1CPF.EditMask  := '000.000.000-00;0';      // 11 dígitos
  FDQuery1CNPJ.EditMask := '00.000.000/0000-00;0';  // 14 dígitos
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

  if MessageDlg('Deseja realmente excluir este registro?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  // Salva posição atual
  Bookmark := FDQuery1.GetBookmark;
  try
    if FDQuery1.FieldByName('CPF').AsString <> '' then
      CPF_CNPJ := FDQuery1.FieldByName('CPF').AsString
    else
      CPF_CNPJ := FDQuery1.FieldByName('CNPJ').AsString;

    FDQuery1.Connection.ExecSQL('DELETE FROM Usuarios WHERE CPF = :CPF OR CNPJ = :CNPJ',
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

