unit uTaskRepository.Factory;

interface

uses
  uTask.Repository.Intf, uTask.Repository.SQL;

type
  TRepositoryFactory = class
  public
    class function TaskRepository: ITaskRepository;
  end;

implementation

class function TRepositoryFactory.TaskRepository: ITaskRepository;
begin
  Result := TTaskRepositorySQL.Create;
end;

end.
