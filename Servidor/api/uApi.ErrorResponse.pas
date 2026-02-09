unit uApi.ErrorResponse;

interface

uses
  System.JSON;

function BuildError(const sMessage: string): TJSONObject;

implementation

uses
  uConstants;

function BuildError(const sMessage: string): TJSONObject;
begin
  Result :=
    TJSONObject.Create
      .AddPair(SUCCESS, TJSONBool.Create(False))
      .AddPair(ERROR,
        TJSONObject.Create
          .AddPair(MESSAGE, sMessage));
end;

end.
