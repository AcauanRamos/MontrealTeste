unit uApi.Auth;

interface

uses
  Horse, StrUtils;

procedure AuthMiddleware(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils, uConstants;

procedure AuthMiddleware(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
var
  ApiKey: string;
begin
  ApiKey := oReq.Headers[API_HEADER_APIKEY];

  if ApiKey.Trim.IsEmpty then
  begin
    oResp.Status(401).Send(MSG_APIKEY_NOT_PROVIDED);
    raise EHorseCallbackInterrupted.Create;
  end;

  if not SameText(ApiKey, API_APIKEY_TESTS) then
  begin
    oResp.Status(403).Send(MSG_APIKEY_INVALID);
    raise EHorseCallbackInterrupted.Create;
  end;

  Next;
end;

end.
