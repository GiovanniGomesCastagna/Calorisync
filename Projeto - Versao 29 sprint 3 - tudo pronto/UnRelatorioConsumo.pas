unit UnRelatorioConsumo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.DateUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.DApt,
  Conexao, Printers, Vcl.ComCtrls,
  System.UITypes, System.IOUtils, System.Types, System.Math;



type
  TRelatorio_Consumo = class(TForm)
    lblPessoa: TLabel;
    btnPessoa: TSpeedButton;
    edtNomePessoa: TEdit;
    DataInicio: TDateTimePicker;
    Datfim: TDateTimePicker;
    btnGerar: TButton;
    lblPeriodo: TLabel;
    PanelGrafico: TPanel;
    PaintBox1: TPaintBox;
    btnGeraPDF: TButton;
    procedure btnPessoaClick(Sender: TObject);
    procedure GridPessoaDblClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure btnGeraPDFClick(Sender: TObject);
  private
    procedure DesenharGrafico;
    procedure ExecutarConsulta;
  public
  end;

var
  Relatorio_Consumo: TRelatorio_Consumo;
  IDUsuarioSelecionado: Integer = 0;
  Dados: TFDQuery;

implementation

{$R *.dfm}

{ --------------------------------------------------------------------------- }
{ Seleção de Pessoa }
{ --------------------------------------------------------------------------- }

procedure TRelatorio_Consumo.btnPessoaClick(Sender: TObject);
var
  Frm: TForm;
  Grid: TDBGrid;
  DS: TDataSource;
  Q: TFDQuery;
begin
  Frm := TForm.Create(Self);
  try
    Frm.Caption := 'Usuários';
    Frm.Width := 520;
    Frm.Height := 360;
    Frm.Position := poScreenCenter;
    Frm.BorderStyle := bsDialog;

    Q := TFDQuery.Create(Frm);
    Q.Connection := DataModule1.FDConnection1;
    Q.SQL.Text := 'SELECT ID_USUARIO, CAST(NOME AS VARCHAR(100)) AS NOME FROM USUARIOS ORDER BY NOME';
    Q.Open;

    DS := TDataSource.Create(Frm);
    DS.DataSet := Q;

    Grid := TDBGrid.Create(Frm);
    Grid.Parent := Frm;
    Grid.Align := alClient;
    Grid.DataSource := DS;
    Grid.Options := Grid.Options + [dgTitles, dgRowSelect];
    Grid.TitleFont.Style := [fsBold];
    Grid.Tag := NativeInt(Q);
    Grid.OnDblClick := GridPessoaDblClick;

    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TRelatorio_Consumo.GridPessoaDblClick(Sender: TObject);
var
  Grid: TDBGrid;
  Q: TFDQuery;
begin
  Grid := Sender as TDBGrid;
  Q := TFDQuery(Pointer(Grid.Tag));
  if not Q.IsEmpty then
  begin
    edtNomePessoa.Text := Q.FieldByName('NOME').AsString;
    IDUsuarioSelecionado := Q.FieldByName('ID_USUARIO').AsInteger;
    if Grid.Parent is TForm then
      TForm(Grid.Parent).Close;
  end;
end;

{ --------------------------------------------------------------------------- }
{ Botão Gerar Relatório }
{ --------------------------------------------------------------------------- }

procedure TRelatorio_Consumo.btnGeraPDFClick(Sender: TObject);
var
  Q: TFDQuery;
  Canvas: TCanvas;
  cons, gast, saldo, TotalCons, TotalGast: Double;
  Dia: string;
  LinhaAltura, y, PagLargura, PagAltura, Centro: Integer;
  SavedPrinter: string;
  MargemEsq, MargemSup, ColDia, ColCons, ColGast, ColRes, LarguraMax: Integer;
begin
  if IDUsuarioSelecionado = 0 then
  begin
    MessageDlg('Selecione uma pessoa antes de gerar o PDF.', mtWarning, [mbOK], 0);
    Exit;
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DataModule1.FDConnection1;
Q.SQL.Text :=
  'WITH DIAS AS ( ' +
  '  SELECT 1 AS ORD, ''Segunda'' AS DIA UNION ALL ' +
  '  SELECT 2, ''Terca''   UNION ALL ' +
  '  SELECT 3, ''Quarta''  UNION ALL ' +
  '  SELECT 4, ''Quinta''  UNION ALL ' +
  '  SELECT 5, ''Sexta''   UNION ALL ' +
  '  SELECT 6, ''Sabado''  UNION ALL ' +
  '  SELECT 7, ''Domingo'' ' +
  '), ' +

  //* -------------- CONSUMO (CORRIGIDO) ----------------
  //   - Soma J.CALORIA_TOTAL (fallback para CA.CALORIA_ALIMENTO se vier NULL)
  //   - Filtra por sobreposição de período tratando NULLs
  //   - Normaliza dia da semana incluindo acentos/variações
  //----------------------------------------------------- */
  'CONSUMO AS ( ' +
  '  SELECT ' +
  '    CASE ' +
  '      WHEN UPPER(TRIM(D.NOME_DIA)) IN (''SEGUNDA'', ''SEGUNDA-FEIRA'') THEN ''Segunda'' ' +
  '      WHEN UPPER(TRIM(D.NOME_DIA)) IN (''TERCA'', ''TERÇA'', ''TERÇA-FEIRA'', ''TERCA-FEIRA'') THEN ''Terca'' ' +
  '      WHEN UPPER(TRIM(D.NOME_DIA)) IN (''QUARTA'', ''QUARTA-FEIRA'') THEN ''Quarta'' ' +
  '      WHEN UPPER(TRIM(D.NOME_DIA)) IN (''QUINTA'', ''QUINTA-FEIRA'') THEN ''Quinta'' ' +
  '      WHEN UPPER(TRIM(D.NOME_DIA)) IN (''SEXTA'', ''SEXTA-FEIRA'') THEN ''Sexta'' ' +
  '      WHEN UPPER(TRIM(D.NOME_DIA)) IN (''SABADO'', ''SÁBADO'') THEN ''Sabado'' ' +
  '      ELSE ''Domingo'' ' +
  '    END AS DIA_SEMANA, ' +
  '    SUM( COALESCE(J.CALORIA_TOTAL, CA.CALORIA_ALIMENTO, 0) ) AS TOTAL_CONSUMO ' +
  '  FROM JUNCAO_ALIMENTO J ' +
  '  LEFT JOIN CADASTRO_ALIMENTOS CA ON CA.ID_ALIMENTO = J.ID_ALIMENTO ' +
  '  LEFT JOIN DIAS_SEMANA D ON D.ID_DIA = J.ID_DIA ' +
  '  WHERE J.ID_USUARIO = :U ' +
  '    AND DATE(COALESCE(J.DATA_INICIO, ''0001-01-01'')) <= DATE(:DF) ' +  // -- início <= fim do filtro
  '    AND DATE(COALESCE(J.DATA_FIM,    ''9999-12-31'')) >= DATE(:DI) ' +  // -- fim    >= início do filtro
  '  GROUP BY 1 ' +
  '), ' +

  //* ------------------ GASTO (mantido) ---------------- */
  'GASTO AS ( ' +
  '  SELECT ' +
  '    CASE STRFTIME(''%w'', DATA_TREINO) ' +
  '      WHEN ''0'' THEN ''Domingo'' ' +
  '      WHEN ''1'' THEN ''Segunda'' ' +
  '      WHEN ''2'' THEN ''Terca'' ' +
  '      WHEN ''3'' THEN ''Quarta'' ' +
  '      WHEN ''4'' THEN ''Quinta'' ' +
  '      WHEN ''5'' THEN ''Sexta'' ' +
  '      WHEN ''6'' THEN ''Sabado'' ' +
  '    END AS DIA_SEMANA, ' +
  '    SUM(COALESCE(CALORIAS_QUEIMADAS,0)) AS TOTAL_GASTO ' +
  '  FROM LISTA_TREINO ' +
  '  WHERE ID_USUARIO = :U ' +
  '    AND DATE(DATA_TREINO) BETWEEN DATE(:DI) AND DATE(:DF) ' +
  '  GROUP BY 1 ' +
  ') ' +

  'SELECT ' +
  '  DIAS.DIA AS DIA_SEMANA, ' +
  '  COALESCE(CONSUMO.TOTAL_CONSUMO,0) AS CONSUMO, ' +
  '  COALESCE(GASTO.TOTAL_GASTO,0)     AS GASTO ' +
  'FROM DIAS ' +
  'LEFT JOIN CONSUMO ON CONSUMO.DIA_SEMANA = DIAS.DIA ' +
  'LEFT JOIN GASTO   ON GASTO.DIA_SEMANA   = DIAS.DIA ' +
  'ORDER BY DIAS.ORD';


    Q.ParamByName('U').AsInteger := IDUsuarioSelecionado;
    Q.ParamByName('DI').AsDate := DataInicio.Date;
    Q.ParamByName('DF').AsDate := DatFim.Date;
    Q.Open;

    if Q.IsEmpty then
    begin
      MessageDlg('Nenhum dado encontrado para o período informado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    // === Impressão PDF ===
    SavedPrinter := Printer.Printers[Printer.PrinterIndex];
    try
      Printer.PrinterIndex := Printer.Printers.IndexOf('Microsoft Print to PDF');
      if Printer.PrinterIndex < 0 then
        raise Exception.Create('Impressora "Microsoft Print to PDF" não encontrada.');

      Printer.Title := 'Relatório de Consumo e Gasto Calórico';
      Printer.BeginDoc;
      Canvas := Printer.Canvas;

      // === Layout ===
      PagLargura := Printer.PageWidth;
      PagAltura  := Printer.PageHeight;
      MargemEsq  := Round(PagLargura * 0.1);
      MargemSup  := Round(PagAltura * 0.08);
      Centro     := PagLargura div 2;
      LinhaAltura := 160;
      y := MargemSup;

      ColDia  := MargemEsq;
      ColCons := MargemEsq + 1100;
      ColGast := MargemEsq + 2200;
      ColRes  := MargemEsq + 3400;
      LarguraMax := PagLargura - (MargemEsq * 2);

      // === Cabeçalho ===
      Canvas.Font.Size := 22;
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(Centro - Canvas.TextWidth('Relatório de Consumo e Gasto Calórico') div 2, y,
                     'Relatório de Consumo e Gasto Calórico');
      y := y + 300;

      Canvas.Font.Size := 11;
      Canvas.Font.Style := [];
      Canvas.TextOut(MargemEsq, y, 'Usuário: ' + edtNomePessoa.Text);
      y := y + 130;
      Canvas.TextOut(MargemEsq, y, 'Período: ' + DateToStr(DataInicio.Date) + ' até ' + DateToStr(DatFim.Date));
      y := y + 130;
      Canvas.TextOut(MargemEsq, y, 'Gerado em: ' + DateTimeToStr(Now));
      y := y + 250;

      // === Cabeçalho da tabela ===
      Canvas.Font.Size := 12;
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(ColDia,  y, 'Dia da Semana');
      Canvas.TextOut(ColCons, y, 'Consumido (kcal)');
      Canvas.TextOut(ColGast, y, 'Gasto (kcal)');
      Canvas.TextOut(ColRes,  y, 'Resultado');
      y := y + 120;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(MargemEsq, y);
      Canvas.LineTo(MargemEsq + LarguraMax, y);
      y := y + 120;

      // === Corpo ===
      TotalCons := 0;
      TotalGast := 0;
      Canvas.Font.Style := [];
      Canvas.Font.Size := 11;

      while not Q.Eof do
      begin
        Dia   := Q.FieldByName('DIA_SEMANA').AsString;
        cons  := Q.FieldByName('CONSUMO').AsFloat;
        gast  := Q.FieldByName('GASTO').AsFloat;
        saldo := cons - gast;

        if Odd(Q.RecNo) then
          Canvas.Brush.Color := RGB(245,245,245)
        else
          Canvas.Brush.Color := clWhite;

        Canvas.FillRect(Rect(MargemEsq, y - 10, MargemEsq + LarguraMax, y + LinhaAltura - 30));

        Canvas.Font.Color := clBlack;
        Canvas.TextOut(ColDia,  y, Dia);
        Canvas.TextOut(ColCons, y, FormatFloat('0.##', cons));
        Canvas.TextOut(ColGast, y, FormatFloat('0.##', gast));

        if saldo >= 0 then
        begin
          Canvas.Font.Color := clGreen;
          Canvas.TextOut(ColRes, y, 'Superávit ' + FormatFloat('0.##', saldo));
        end
        else
        begin
          Canvas.Font.Color := clRed;
          Canvas.TextOut(ColRes, y, 'Déficit ' + FormatFloat('0.##', Abs(saldo)));
        end;

        Inc(y, LinhaAltura);
        TotalCons := TotalCons + cons;
        TotalGast := TotalGast + gast;
        Q.Next;
      end;

      // === Totais ===
      y := y + 200;
      Canvas.Font.Size := 12;
      Canvas.Font.Color := clBlack;
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(ColDia,  y, 'Total consumido: ' + FormatFloat('0.##', TotalCons));
      Canvas.TextOut(ColGast, y, 'Total gasto: ' + FormatFloat('0.##', TotalGast));

      if (TotalCons - TotalGast) >= 0 then
      begin
        Canvas.Font.Color := clGreen;
        Canvas.TextOut(ColRes, y, 'Superávit total: ' + FormatFloat('0.##', TotalCons - TotalGast));
      end
      else
      begin
        Canvas.Font.Color := clRed;
        Canvas.TextOut(ColRes, y, 'Déficit total: ' + FormatFloat('0.##', Abs(TotalCons - TotalGast)));
      end;

      Printer.EndDoc;
      Sleep(1000); // 💡 Evita erro de PDF não carregado
      MessageDlg('PDF gerado com sucesso! Escolha o local de salvamento.', mtInformation, [mbOK], 0);
    finally
      Printer.PrinterIndex := Printer.Printers.IndexOf(SavedPrinter);
    end;

  finally
    Q.Free;
  end;
end;

procedure TRelatorio_Consumo.btnGerarClick(Sender: TObject);
begin
  if IDUsuarioSelecionado = 0 then
  begin
    MessageDlg('Selecione uma pessoa antes de gerar o relatório.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if DataInicio.Date > DatFim.Date then
  begin
    MessageDlg('A data inicial não pode ser maior que a final.', mtWarning, [mbOK], 0);
    Exit;
  end;

  ExecutarConsulta;
  PaintBox1.Repaint;
end;

{ --------------------------------------------------------------------------- }
{ Executar Consulta SQL }
{ --------------------------------------------------------------------------- }

procedure TRelatorio_Consumo.ExecutarConsulta;
begin
  if Assigned(Dados) then
    FreeAndNil(Dados);

  Dados := TFDQuery.Create(nil);
  Dados.Connection := DataModule1.FDConnection1;

  Dados.SQL.Text :=
    'WITH CONSUMO AS ( ' +
    '  SELECT ' +
    '    CASE D.NOME_DIA ' +
    '      WHEN ''Domingo'' THEN ''Domingo'' ' +
    '      WHEN ''Domingo-feira'' THEN ''Domingo'' ' +
    '      WHEN ''Segunda'' THEN ''Segunda'' ' +
    '      WHEN ''Segunda-feira'' THEN ''Segunda'' ' +
    '      WHEN ''Terça'' THEN ''Terca'' ' +
    '      WHEN ''Terça-feira'' THEN ''Terca'' ' +
    '      WHEN ''Quarta'' THEN ''Quarta'' ' +
    '      WHEN ''Quarta-feira'' THEN ''Quarta'' ' +
    '      WHEN ''Quinta'' THEN ''Quinta'' ' +
    '      WHEN ''Quinta-feira'' THEN ''Quinta'' ' +
    '      WHEN ''Sexta'' THEN ''Sexta'' ' +
    '      WHEN ''Sexta-feira'' THEN ''Sexta'' ' +
    '      WHEN ''Sábado'' THEN ''Sabado'' ' +
    '      WHEN ''Sábado-feira'' THEN ''Sabado'' ' +
    '    END AS DIA_SEMANA, ' +
    '    SUM(CA.CALORIA_ALIMENTO) AS TOTAL_CONSUMO ' +
    '  FROM JUNCAO_ALIMENTO J ' +
    '  JOIN CADASTRO_ALIMENTOS CA ON CA.ID_ALIMENTO = J.ID_ALIMENTO ' +
    '  JOIN DIAS_SEMANA D ON D.ID_DIA = J.ID_DIA ' +
    '  WHERE J.ID_USUARIO = :U ' +
    '  GROUP BY DIA_SEMANA ' +
    '), ' +
    'GASTO AS ( ' +
    '  SELECT ' +
    '    CASE STRFTIME(''%w'', DATA_TREINO) ' +
    '      WHEN ''0'' THEN ''Domingo'' ' +
    '      WHEN ''1'' THEN ''Segunda'' ' +
    '      WHEN ''2'' THEN ''Terca'' ' +
    '      WHEN ''3'' THEN ''Quarta'' ' +
    '      WHEN ''4'' THEN ''Quinta'' ' +
    '      WHEN ''5'' THEN ''Sexta'' ' +
    '      WHEN ''6'' THEN ''Sabado'' ' +
    '    END AS DIA_SEMANA, ' +
    '    SUM(CALORIAS_QUEIMADAS) AS TOTAL_GASTO ' +
    '  FROM LISTA_TREINO ' +
    '  WHERE ID_USUARIO = :U ' +
    '    AND DATA_TREINO BETWEEN :DI AND :DF ' +
    '  GROUP BY DIA_SEMANA ' +
    ') ' +
    'SELECT ' +
    '  G.DIA_SEMANA, ' +
    '  COALESCE(C.TOTAL_CONSUMO, 0) AS CAL_CONSUMO, ' +
    '  COALESCE(G.TOTAL_GASTO, 0) AS CAL_GASTO ' +
    'FROM GASTO G ' +
    'LEFT JOIN CONSUMO C ON C.DIA_SEMANA = G.DIA_SEMANA ' +
    'ORDER BY ' +
    '  CASE G.DIA_SEMANA ' +
    '    WHEN ''Segunda'' THEN 1 ' +
    '    WHEN ''Terca'' THEN 2 ' +
    '    WHEN ''Quarta'' THEN 3 ' +
    '    WHEN ''Quinta'' THEN 4 ' +
    '    WHEN ''Sexta'' THEN 5 ' +
    '    WHEN ''Sabado'' THEN 6 ' +
    '    WHEN ''Domingo'' THEN 7 ' +
    '  END ';

  Dados.ParamByName('U').AsInteger := IDUsuarioSelecionado;
  Dados.ParamByName('DI').AsDate := DataInicio.Date;
  Dados.ParamByName('DF').AsDate := DatFim.Date;
  Dados.Open;
end;

{ --------------------------------------------------------------------------- }
{ Desenhar Gráfico de Barras Horizontais }
{ --------------------------------------------------------------------------- }

procedure TRelatorio_Consumo.PaintBox1Paint(Sender: TObject);
begin
  DesenharGrafico;
end;

procedure TRelatorio_Consumo.DesenharGrafico;
var
  y, h, MaxVal: Integer;
  wConsumo, wGasto, wMeta, GraficoLargura: Integer;
  calCons, calGasto, TotalConsumo, TotalGasto: Double;
  DiaStr: string;
  MetaCal: Integer;
  MargemEsq, MargemSup: Integer;
begin
  MetaCal := 2000; // Meta padrão
  MargemEsq := 120;
  MargemSup := 70;

  with PaintBox1.Canvas do
  begin
    // 🔹 Fundo
    Brush.Color := RGB(245,245,245);
    FillRect(PaintBox1.ClientRect);

    Font.Size := 10;
    Font.Style := [fsBold];
    TextOut(MargemEsq, 20, 'Relatório Semanal de Consumo x Gasto Calórico');
    Font.Style := [];

    if (Dados = nil) or (Dados.IsEmpty) then
    begin
      TextOut(MargemEsq, 60, 'Nenhum dado encontrado para o período informado.');
      Exit;
    end;

    // 🔹 Cálculo da largura máxima do gráfico
    GraficoLargura := PaintBox1.Width - (MargemEsq + 200);

    // 🔹 Determinar o maior valor (para escala)
    MaxVal := MetaCal;
    Dados.First;
    while not Dados.Eof do
    begin
      MaxVal := Max(MaxVal, Round(Max(Dados.FieldByName('CAL_CONSUMO').AsFloat,
                                     Dados.FieldByName('CAL_GASTO').AsFloat)));
      Dados.Next;
    end;

    h := 35;  // altura das barras
    y := MargemSup;
    TotalConsumo := 0;
    TotalGasto := 0;
    Dados.First;

    while not Dados.Eof do
    begin
      calCons := Dados.FieldByName('CAL_CONSUMO').AsFloat;
      calGasto := Dados.FieldByName('CAL_GASTO').AsFloat;
      DiaStr := Dados.FieldByName('DIA_SEMANA').AsString;

      TotalConsumo := TotalConsumo + calCons;
      TotalGasto := TotalGasto + calGasto;

      if MaxVal = 0 then MaxVal := 1;

      wConsumo := Round(GraficoLargura * (calCons / MaxVal));
      wGasto   := Round(GraficoLargura * (calGasto / MaxVal));
      wMeta    := Round(GraficoLargura * (MetaCal / MaxVal));

      // 🔹 Nome do dia
      Font.Style := [fsBold];
      TextOut(20, y + 10, DiaStr);
      Font.Style := [];

      // 🔹 Linha de meta
      Pen.Color := RGB(160,160,160);
      Pen.Style := psDot;
      MoveTo(MargemEsq + wMeta, y - 5);
      LineTo(MargemEsq + wMeta, y + h + 5);
      Pen.Style := psSolid;

      // 🔹 Barra de consumo
      Brush.Color := RGB(255, 190, 80);
      FillRect(Rect(MargemEsq, y, MargemEsq + wConsumo, y + h - 5));

      // 🔹 Barra de gasto (acima da de consumo)
      Brush.Color := RGB(90, 160, 255);
      FillRect(Rect(MargemEsq, y + h, MargemEsq + wGasto, y + (h * 2) - 5));

      // 🔹 Texto de valores
      Font.Size := 8;
      Font.Color := clBlack;
      TextOut(MargemEsq + wGasto + 10, y + 5, Format('%.0f / %.0f kcal', [calCons, calGasto]));

      // Próxima linha
      Inc(y, (h * 2) + 20);
      Dados.Next;
    end;

    // 🔹 Legenda
    Brush.Color := RGB(255, 190, 80);
    FillRect(Rect(MargemEsq, y + 10, MargemEsq + 20, y + 25));
    TextOut(MargemEsq + 25, y + 10, 'Calorias Consumidas');

    Brush.Color := RGB(90, 160, 255);
    FillRect(Rect(MargemEsq + 180, y + 10, MargemEsq + 200, y + 25));
    TextOut(MargemEsq + 205, y + 10, 'Calorias Gastas');

    Pen.Color := RGB(160,160,160);
    Pen.Style := psDot;
    MoveTo(MargemEsq + 350, y + 18);
    LineTo(MargemEsq + 370, y + 18);
    Pen.Style := psSolid;
    TextOut(MargemEsq + 380, y + 10, Format('Meta: %d kcal', [MetaCal]));

    // 🔹 Totais finais
    y := y + 40;
    Font.Style := [fsBold];
    Font.Color := clBlack;
    TextOut(MargemEsq, y, Format('Total consumido: %.0f kcal', [TotalConsumo]));
    TextOut(MargemEsq + 200, y, Format('Total gasto: %.0f kcal', [TotalGasto]));
    if (TotalConsumo - TotalGasto) >= 0 then
      TextOut(MargemEsq + 400, y, Format('Superávit: %.0f kcal', [TotalConsumo - TotalGasto]))
    else
      TextOut(MargemEsq + 400, y, Format('Déficit: %.0f kcal', [TotalGasto - TotalConsumo]));
  end;
end;

end.

