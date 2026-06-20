program AddressBook;

uses
  Forms,
  wndAgenda in 'Wnd\wndAgenda.pas' {frmAgenda},
  wndEdit in 'Wnd\wndEdit.pas' {frmEdit},
  wndAlarm in 'Wnd\wndAlarm.pas' {frmAlarm},
  wndContact in 'Wnd\wndContact.pas' {frmContact};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'AddressBook';
  Application.CreateForm(TfrmAgenda, frmAgenda);
  Application.Run;
end.
