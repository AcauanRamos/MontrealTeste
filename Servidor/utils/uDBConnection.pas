unit uDBConnection;

interface

uses
  System.SysUtils, Data.Win.ADODB;

  function GetConnection: TADOconnection;

implementation

uses
  IniFiles;

function GetConnection: TADOconnection;
var
  ini: TIniFile;
begin
  Result := TADOConnection.Create(nil);
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'BD.ini');
  try

  Result.LoginPrompt := False;

  Result.ConnectionString := Format(
    'Provider=MSOLEDBSQL;' +
    'Server=%s;' +
    'Database=%s;' +
    'User ID=%s;' +
    'Password=%s;' +
    'Persist Security Info=True;',
    [ini.ReadString('BD','Server',''),
     ini.ReadString('BD','Database',''),
     ini.ReadString('BD','User ID','sa'),
     ini.ReadString('BD','Password','')]);

  Result.Connected := True;
  Result := Result;

  finally
    FreeAndNil(ini);
  end;
end;

end.
