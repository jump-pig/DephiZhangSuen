unit Unit1;

interface

uses
  uZhangSuen,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;



type
  TForm1 = class(TForm)
    btn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ZhangSuen: TZhangSien;
    m: TBitmap;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  x, y: integer;
begin
  ZhangSuen.LoadBitmap( m);
  ZhangSuen.Handle;

  for y := 0 to ZhangSuen.Height - 1 do
    for x := 0 to ZhangSuen.Width - 1 do
    begin

      if ZhangSuen.Pixel[x, y] > 0 then
        m.Canvas.Pixels[x, y] := clRed;
    end;

  canvas.Draw(0, 0, m);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ZhangSuen := TZhangSien.Create;


   //use 24bit bitmap£¬ black is empty, another is color range

  m := Tbitmap.Create();

  m.PixelFormat := pf24bit;
  m.SetSize(400, 200);

  m.Canvas.Font.Size := 72;
  m.Canvas.Brush.Color := clBlack;
  m.Canvas.FillRect(rect( 0, 0, 400, 200));
  m.Canvas.Font.Color := clWhite;
  m.Canvas.TextOut(20, 20, 'ABCDEF');

end;


end.
