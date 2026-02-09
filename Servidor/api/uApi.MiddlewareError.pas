unit uApi.MiddlewareError;

interface

uses
  Horse;

procedure ErrorMiddleware(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils, System.JSON, uExceptionHelper, uConstants, uApi.ErrorResponse;

procedure ErrorMiddleware(oReq: THorseRequest; oResp: THorseResponse; Next: TProc);
begin
  try
    Next;
  except
    on E: EBusinessException do
    begin
      oResp
        .ContentType(API_CONTENTTYPE_JSON)
        .Send(BuildError(E.Message))
        .Status(409);
    end;

    on E: Exception do
    begin
      oResp
        .ContentType(API_CONTENTTYPE_JSON)
        .Send(BuildError(E.Message))
        .Status(500);
    end;
  end;
end;

end.
