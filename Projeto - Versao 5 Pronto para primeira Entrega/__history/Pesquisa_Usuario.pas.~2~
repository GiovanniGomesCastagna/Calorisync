unit Pesquisa_Usuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client;

type
  TFormPesquisaUsuario = class(TForm)
    EditPesquisar: TEdit;
    BtnPesquisar: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDQueryPesquisa: TFDQuery;
    BtnOK: TButton;
    BtnCancelar: TButton;
    procedure BtnPesquisarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    FNomeSelecionado: string;
    FSenhaSelecionada: string;
    FDocumentoSelecionado: string;
  public
    property NomeSelecionado: string read FNomeSelecionado;
    property SenhaSelecionada: string read FSenhaSelecionada;
    property DocumentoSelecionado: string read FDocumentoSelecionado;
  end;

implementation

uses Conexao;

{$R *.dfm}

procedure TFormPesquisaUsuario.BtnPesquisarClick(Sender: TObject);
begin
  FDQueryPesquisa.Close;
  FDQueryPesquisa.SQL.Text :=
    'SELECT NOME, SENHA, CPF, CNPJ FROM USUARIOS ' +
    'WHERE NOME LIKE :PESQ ORDER BY NOME';
  FDQueryPesquisa.ParamByName('PESQ').AsString := '%' + EditPesquisar.Text + '%';
  FDQueryPesquisa.Open;
end;

procedure TFormPesquisaUsuario.DBGrid1DblClick(Sender: TObject);
begin
  if not FDQueryPesquisa.IsEmpty then
  begin
    FNomeSelecionado := FDQueryPesquisa.FieldByName('NOME').AsString;
    FSenhaSelecionada := FDQueryPesquisa.FieldByName('SENHA').AsString;
    if FDQueryPesquisa.FieldByName('CPF').AsString <> '' then
      FDocumentoSelecionado := FDQueryPesquisa.FieldByName('CPF').AsString
    else
      FDocumentoSelecionado := FDQueryPesquisa.FieldByName('CNPJ').AsString;
    ModalResult := mrOk;
  end;
end;

end.

