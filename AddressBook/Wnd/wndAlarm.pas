unit wndAlarm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Grids, DB, ADODB;

type
  TfrmAlarm = class(TForm)
    btnOk: TButton;
    pbProcessing: TProgressBar;
    pgCrtlAlarm: TPageControl;
    tsMonth: TTabSheet;
    pnlMonth: TPanel;
    pnlDay1: TPanel;
    lbDay1: TListBox;
    pnlDay2: TPanel;
    lbDay2: TListBox;
    pnlDay8: TPanel;
    lbDay8: TListBox;
    pnlDay9: TPanel;
    lbDay9: TListBox;
    pnlDay3: TPanel;
    lbDay3: TListBox;
    pnlDay4: TPanel;
    lbDay4: TListBox;
    pnlDay10: TPanel;
    lbDay10: TListBox;
    pnlDay11: TPanel;
    lbDay11: TListBox;
    pnlDay5: TPanel;
    lbDay5: TListBox;
    pnlDay6: TPanel;
    lbDay6: TListBox;
    pnlDay12: TPanel;
    lbDay12: TListBox;
    pnlDay13: TPanel;
    lbDay13: TListBox;
    pnlDay7: TPanel;
    lbDay7: TListBox;
    pnlDay14: TPanel;
    lbDay14: TListBox;
    pnlDay15: TPanel;
    lbDay15: TListBox;
    pnlDay16: TPanel;
    lbDay16: TListBox;
    pnlDay22: TPanel;
    lbDay22: TListBox;
    pnlDay23: TPanel;
    lbDay23: TListBox;
    pnlDay17: TPanel;
    lbDay17: TListBox;
    pnlDay18: TPanel;
    lbDay18: TListBox;
    pnlDay24: TPanel;
    lbDay24: TListBox;
    pnlDay25: TPanel;
    lbDay25: TListBox;
    pnlDay19: TPanel;
    lbDay19: TListBox;
    pnlDay20: TPanel;
    lbDay20: TListBox;
    pnlDay26: TPanel;
    lbDay26: TListBox;
    pnlDay27: TPanel;
    lbDay27: TListBox;
    pnlDay21: TPanel;
    lbDay21: TListBox;
    pnlDay28: TPanel;
    lbDay28: TListBox;
    pnlDay29: TPanel;
    lbDay29: TListBox;
    pnlDay30: TPanel;
    lbDay30: TListBox;
    pnlDay31: TPanel;
    lbDay31: TListBox;
    pnlDay32: TPanel;
    lbDay32: TListBox;
    pnlDay33: TPanel;
    lbDay33: TListBox;
    pnlDay34: TPanel;
    lbDay34: TListBox;
    pnlDay35: TPanel;
    lbDay35: TListBox;
    imgB: TImage;
    imgA: TImage;
    pnlDay36: TPanel;
    lbDay36: TListBox;
    pnlDay37: TPanel;
    lbDay37: TListBox;
    pnlDay38: TPanel;
    lbDay38: TListBox;
    pnlDay39: TPanel;
    lbDay39: TListBox;
    pnlDay40: TPanel;
    lbDay40: TListBox;
    pnlDay41: TPanel;
    lbDay41: TListBox;
    pnlDay42: TPanel;
    lbDay42: TListBox;
    DataSource: TDataSource;
    ADOConnection: TADOConnection;
    qryContacts: TADOQuery;
    qryAux: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure _ListBox_DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure _ListBox_MeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
  private
   public
      path : String;
      procedure PopulateItems(inDate : TDate);
  end;

var
  frmAlarm: TfrmAlarm;

implementation

uses
   DateUtils, IniFiles;

{$R *.dfm}

//-------------------------------------------------------------------------------------------------

function FirstDayOfMonth(Date: TDateTime): TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := EncodeDate(Year, Month, 1);
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAlarm.PopulateItems(inDate : TDate);
var
   i, j                : Integer;
   _month              : Integer;
   _daysInMonth        : Integer;
   _firstDayOfMonth    : Integer;
//   sr                  : TSearchRec;
//   ini                 : TIniFile;
   lbCount             : String;
   name                : String;
   _crtD, _crtM, _crtY : Word;
//   li                  : TListItem;
begin
   DecodeDate(Now, _crtY, _crtM, _crtD);
//   _crtDOW:=DayOfTheWeek(inDate);
   _month:=MonthOf(inDate);
   _daysInMonth:=DaysInMonth(inDate);
   _firstDayOfMonth:=DayOfTheWeek((FirstDayOfMonth(inDate)));

   j:=1;
   for i:=_firstDayOfMonth to _firstDayOfMonth+_daysInMonth-1 do
   begin
      TPanel(Self.FindComponent('pnlDay'+IntToStr(i))).Caption:=IntToStr(j);
      TListBox(Self.FindComponent('lbDay'+IntToStr(i))).Color:=clCream;
      TListBox(Self.FindComponent('lbDay'+IntToStr(_crtD+_firstDayOfMonth-1))).Color:=$00B9ECFF;
      j:=j+1;
   end;

   qryContacts.Close;
   qryContacts.SQL.Text:='select * from tblContacts order by FirstName asc';
   qryContacts.Active:=TRUE;
   qryContacts.Open;

   pbProcessing.Position:=0;
   pbProcessing.Max:=qryContacts.RecordCount;

   while not qryContacts.Eof do
   begin
//      li:=lvContacts.Items.Add;
//      li.ImageIndex:=-1;
//      li.Caption:=qryContacts.FieldByName('ID').AsString;
//      li.SubItems.Add(qryContacts.FieldByName('FirstName').AsString);
//      li.SubItems.Add(qryContacts.FieldByName('LastName').AsString);
//      li.SubItems.Add(qryContacts.FieldByName('BirthY').AsString+'.'+
//         qryContacts.FieldByName('BirthM').AsString+'.'+
//         qryContacts.FieldByName('BirthD').AsString);
      if qryContacts.FieldByName('BirthM').AsInteger=_Month then
      begin
         lbCount:='lbDay'+IntToStr(_firstDayOfMonth+qryContacts.FieldByName('BirthD').AsInteger-1);
         name:=qryContacts.FieldByName('FirstName').AsString+' '+qryContacts.FieldByName('LastName').AsString;
         TListBox(Self.FindComponent(lbCount)).Items.AddObject(name, imgB.Picture.Bitmap);
      end;

      qryContacts.Next;
      pbProcessing.Position:=pbProcessing.Position+1;
   end;

//   if FindFirst(path+'\Contacts\*.ini', faAnyFile-faDirectory, sr)=0 then
//   begin
//      repeat
//         ProgressBar.Position:=ProgressBar.Position+1;
//         ini:=TIniFile.Create(path+'Contacts\'+sr.Name);
//         if (ini.ValueExists('Main', 'BirthM')) and (ini.ValueExists('Main', 'BirthD')) then
//         begin
//            if ini.ReadInteger('Main', 'BirthM', 0)=_month then
//            begin
//               lbCount:='lbDay'+IntToStr(_firstDayOfMonth+ini.ReadInteger('Main', 'BirthD', 0)-1);
//               name:=ini.ReadString('Main', 'FirstName', '')+' '+ini.ReadString('Main', 'LastName', '');
//               TListBox(Self.FindComponent(lbCount)).Items.AddObject(name, imgB.Picture.Bitmap);
//            end;
//         end;
//         if (ini.ValueExists('Family', 'AnnivM')) and (ini.ValueExists('Family', 'AnnivD')) then
//         begin
//            if ini.ReadInteger('Family', 'AnnivM', 0)=_month then
//            begin
//               lbCount:='lbDay'+IntToStr(_firstDayOfMonth+ini.ReadInteger('Family', 'AnnivD', 0)-1);
//               name:=ini.ReadString('Main', 'FirstName', '')+' '+ini.ReadString('Main', 'LastName', '');
//               TListBox(Self.FindComponent(lbCount)).Items.AddObject(name, imgA.Picture.Bitmap);
//            end;
//         end;
//         ini.Free;
//      until FindNext(sr)<>0;
//      FindClose(sr);
//   end;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAlarm._ListBox_DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
   x, y : Integer;
   s    : String;
   bmp  : TBitmap;
begin
   bmp:=TBitmap.Create;
   TListBox(Self.FindComponent(Control.Name)).Canvas.FillRect(Rect);
   if TListBox(Self.FindComponent(Control.Name)).Items.Objects[Index] <> nil then
   begin
      bmp:=TListBox(Self.FindComponent(Control.Name)).Items.Objects[Index] as TBitmap;
      TListBox(Self.FindComponent(Control.Name)).Canvas.BrushCopy(Bounds(rect.Left+2, rect.Top+2,
         bmp.Width, bmp.Height), bmp, Bounds(0, 0, bmp.Width, bmp.Height),
         bmp.Canvas.Pixels[0, bmp.Height-1]);
   end;
   rect.Left:=rect.Left+bmp.Width+4;
   rect.Bottom:=rect.Top+bmp.Height+4;
   s:=TListBox(Self.FindComponent(Control.Name)).Items.Strings[Index];
   x:=Rect.Left;
   y:=(Rect.Bottom+Rect.Top-TListBox(Self.FindComponent(Control.Name)).Canvas.TextHeight(s)) div 2;
   TListBox(Self.FindComponent(Control.Name)).Canvas.TextOut(x, y, s);
   bmp.Free;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAlarm._ListBox_MeasureItem(Control: TWinControl; Index: Integer;
  var Height: Integer);
begin
   if Index=0 then
      Height:=imgB.Height+4;
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAlarm.FormShow(Sender: TObject);
begin
   PopulateItems(now);
end;

//-------------------------------------------------------------------------------------------------

procedure TfrmAlarm.FormCreate(Sender: TObject);
begin
   ADOConnection.Close;
   ADOConnection.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;'+
      'Data Source=Contacts.mdb;'+
      'Persist Security Info=False';
   ADOConnection.Provider:='Microsoft.Jet.OLEDB.4.0';
   ADOConnection.LoginPrompt:=FALSE;
   ADOConnection.Connected:=TRUE;
   ADOConnection.Open();
   qryContacts.Connection:=ADOConnection;
   DataSource.DataSet:=qryContacts;
end;

//-------------------------------------------------------------------------------------------------

end.
