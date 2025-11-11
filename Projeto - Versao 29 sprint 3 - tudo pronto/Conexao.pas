unit Conexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, System.IniFiles,
  Vcl.Dialogs;

type
  TDataModule1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    function BuscarCaminho(): string;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TDataModule1.BuscarCaminho: string;
var
  LIniFile: TIniFile;
  LCaminho: string;
begin
  LCaminho := ExtractFilePath(ParamStr(0));
  if not FileExists(LCaminho + 'config.ini') then
  begin
    ShowMessage('Arquivo ' + LCaminho + 'config.ini não encontrado!' +
      sLineBreak + 'Verifique.');
    Abort;
  end;

  LIniFile := TIniFile.Create(LCaminho + 'config.ini');
  try
    Result := LIniFile.ReadString('configuracao', 'caminhobanco', '');
    if Result = '' then
    begin
      ShowMessage('Caminho do banco não configurado no config.ini.');
      Abort;
    end;
  finally
    LIniFile.Free;
  end;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  try
    FDConnection1.Close;
    FDConnection1.Params.Clear;
    FDConnection1.Params.Add('DriverID=SQLite');
    FDConnection1.Params.Add('Database=' + BuscarCaminho);
    FDConnection1.Connected := True;
  except
    on E: Exception do
      ShowMessage('Não foi possível conectar ao banco: ' + sLineBreak +
        E.Message);
  end;
end;

procedure TDataModule1.FDConnection1AfterConnect(Sender: TObject);
begin
  try
    // 🔹 Aumenta tempo de espera para evitar "database is locked"
    FDConnection1.ExecSQL('PRAGMA busy_timeout = 5000;');

    // 🔹 Ativa integridade referencial
    FDConnection1.ExecSQL('PRAGMA foreign_keys = ON;');

    // 🔹 Modo de journal "Write Ahead Logging" (permite leitura e escrita simultânea)
    FDConnection1.ExecSQL('PRAGMA journal_mode = WAL;');

    // 🔹 Sincronização balanceada (performance + segurança)
    FDConnection1.ExecSQL('PRAGMA synchronous = NORMAL;');

    // 🔹 Otimiza acesso a disco e cache
    FDConnection1.ExecSQL('PRAGMA temp_store = MEMORY;');
    FDConnection1.ExecSQL('PRAGMA cache_size = 10000;');

  except
    on E: Exception do
      ShowMessage('Erro ao aplicar configurações SQLite: ' + E.Message);
  end;
end;

end.

