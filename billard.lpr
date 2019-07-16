program Billard;

uses
  Forms, Interfaces,
  Unit1 in 'UNIT1.PAS' {Form1},
  Balldlg in 'BALLDLG.PAS' {BallDialog},
  Drawings in 'DRAWINGS.PAS';

{$MODE Delphi}
{$R *.res}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TBallDialog, BallDialog);
  Application.Run;
end.
