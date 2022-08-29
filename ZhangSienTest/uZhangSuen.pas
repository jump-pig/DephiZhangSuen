unit uZhangSuen;

interface

uses
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;


Type

  TZhangSien = class
  private
    FWidth: Integer;
    FHeight: integer;
    function GetPixel(const x, y: integer): byte;
    procedure SetPixel(const x, y: integer; const Value: byte);
  protected
    Map: Array of Byte;

    function GetObjectPixel(const x, y: integer): byte;
    function IsDelete( i, j: Integer; bSecond: Boolean = False): boolean;
  public
    property Width: Integer read FWidth;
    property Height: integer read FHeight;
    property Pixel[const x, y: integer]: byte read GetPixel write SetPixel;

    procedure SetSize( w, h: integer);
    procedure Fill( value: Byte);

    function InMap(const x, h: integer): boolean;

    procedure Handle;

    //use 24bit bitmap£¬ black is empty, another is color range
    procedure LoadBitmap( m: TBitmap);
  end;

implementation


{ TZhangSienImg }

procedure TZhangSien.Fill(value: Byte);
var
  len, i: integer;
begin
  len := Width * height;
  for I := 0 to len - 1 do
    map[ i] := value;
end;

function TZhangSien.GetObjectPixel(const x, y: integer): byte;
begin
  if not InMap(x, y) then
    result := 0
  else
  if Pixel[x, y] > 0 then
    result := 1
  else
    result := 0;
end;

function TZhangSien.GetPixel(const x, y: integer): byte;
begin
  result := Map[ x + y * Width];
end;

procedure TZhangSien.Handle;
var
  row, column: Integer;
  c: Integer;
  XYPosition: TList<Integer>;
  i, j, idx: integer;
begin
  row := width;
  column := Height;

  XYPosition := TList<integer>.Create;
  try

    while true do
    begin
      c := 0;
      // first

      for i := 0 to row - 1 do
      begin

        for j := 0 to column - 1 do
        begin

          if self.Pixel[i, j] > 128 then
          begin
            if IsDelete(i, j)  then
            begin
              XYPosition.Add( i);
              XYPosition.Add( j);
              Inc( c);
            end;
          end;
        end;
      end;

      if c <= 0 then
        Break

      else
      begin

        for Idx := 0 to c - 1 do
          self.SetPixel( XYPosition[idx * 2], XYPosition[idx * 2+ 1], 0);

        XYPosition.Clear;
        c := 0;
      end;

      // second

      for i := 0 to row - 1 do
      begin

        for j := 0 to column - 1 do
        begin

          if GetPixel( i, j) > 128 then
            if IsDelete( i, j, true) then
            begin
              XYPosition.add(i);
              XYPosition.add(j);
              inc( c);
            end;
        end;
      end;

      if c <= 0 then
        Break

      else
      begin

        for Idx := 0 to c - 1 do
          self.SetPixel( XYPosition[idx * 2], XYPosition[idx * 2 + 1], 0);

        XYPosition.Clear;
        c := 0;
      end

    end;

  finally

    XYPosition.Free;
  end;
end;

function TZhangSien.InMap( const x, h: integer): boolean;
begin
  result := (x >=0) and (x < width) and (h >= 0) and (h < Height);
end;

function TZhangSien.IsDelete(i, j: Integer; bSecond: Boolean): boolean;
var
  p2, p3, p4, p5, p6, p7, p8, p9: integer;
  ap, pb: integer;
begin

  result := false;

  ap := 0;
	p2 := GetObjectPixel(i - 1, j );
	p3 := GetObjectPixel(i - 1, j + 1);
	p4 := GetObjectPixel(i, j + 1);
	p5 := GetObjectPixel(i + 1, j + 1);
	p6 := GetObjectPixel(i + 1, j);
	p7 := GetObjectPixel(i + 1, j - 1);
	p8 := GetObjectPixel(i, j - 1);
	p9 := GetObjectPixel(i - 1, j - 1);

	// cacl AP

	if (1 = p3 - p2) then
		Inc( ap);

	if (1 = p4 - p3) then
		Inc( ap);

	if (1 = p5 - p4) then
		Inc( ap);

	if (1 = p6 - p5) then
		Inc( ap);

	if (1 = p7 - p6) then
		Inc( ap);

	if (1 = p8 - p7) THEN
    Inc( ap);

	if (1 = p9 - p8) then
    Inc( ap);

	if (1 = p2 - p9) then
    Inc( ap);

	if (ap <> 1) then
    exit;


	// cacl PB
	pb := p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9;
	if (pb < 2) or (pb > 6) then
    exit;

	if bSecond then
		result :=  (0 = p2 * p4 * p8) and (0 = p2 * p6 * p8)

	else
    result :=  (0 = p2 * p4 * p6) and (0 = p4 * p6 * p8);
end;

procedure TZhangSien.LoadBitmap(m: TBitmap);
var
  x, y: integer;
  p: pRGBTriple;
begin

  SetSize( m.Width, m.Height);
  Fill( 0);

  for y := 0 to m.Height - 1 do
  begin

    p := m.ScanLine[ y];
    for x := 0 to m.Width - 1 do
    begin

      if p^.rgbtRed > 100 then
        Pixel[x, y] := 255;

      inc( p);
    end;
  end;

end;

procedure TZhangSien.SetPixel(const x, y: integer; const Value: byte);
begin
  Map[ x + y * Width] := value;
end;

procedure TZhangSien.SetSize(w, h: integer);
begin
  if w < 0 then
    w := 0;
  if h < 0 then
    h := 0;

  if (w = 0) or ( h = 0) then
  begin
    w := 0;
    h := 0;
  end;

  if (w <> width) or (h <> height) then
  begin
    FWidth := w;
    FHeight := h;
    SetLength(Map, w * h);
  end;
end;


end.
