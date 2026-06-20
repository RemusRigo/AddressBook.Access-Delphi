unit wndProcessing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TfrmProcessing = class(TForm)
    pbProcessing: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProcessing: TfrmProcessing;

implementation

{$R *.dfm}

end.
