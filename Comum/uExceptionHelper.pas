unit uExceptionHelper;

interface

uses
  System.SysUtils, JSON;

  function GetErrorMessage(sContent: string): string;

type
  EBusinessException = class(Exception)
  public
    constructor Create(sMessage: string);
  end;

implementation

uses
  uConstants;

{ EBusinessException }

constructor EBusinessException.Create(sMessage: string);
begin
  inherited Create(sMessage);
end;

function GetErrorMessage(sContent: string): string;
var
  oJSONObj: TJSONObject;
begin
  Result := sContent;

  oJSONObj := TJSONObject.ParseJSONValue(sContent) as TJSONObject;
  if Assigned(oJSONObj) then
  begin
    if Assigned(oJSONObj.FindValue(SUCCESS)) and (not oJSONObj.GetValue<Boolean>(SUCCESS)) and
      Assigned(oJSONObj.FindValue(ERROR)) then
    begin
      Result := (oJSONObj.GetValue<TJSONObject>(ERROR) as TJSONObject).GetValue<string>(MESSAGE);
    end;
  end;
end;

end.
