unit uTask.Repository.Intf;

interface

uses
  uTask, System.Generics.Collections;

type
  ITaskRepository = interface
    ['{C4B61588-7FA6-4B2B-B7E5-81D8BB276830}']
    procedure Insert(oTask: TTask);
    procedure Update(iId: Integer; oTask: TTask);
    procedure UpdateStatus(iId: Integer; sStatus: string);
    procedure Delete(iId: Integer);
    function GetAll: TList<TTask>;
    function Get(iId: Integer): TTask;

    function AvgPriorityPending: Double;
    function DoneLast7Days: Integer;
    function TotalTasks: Integer;
  end;

implementation

end.
