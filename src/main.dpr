program main;

// {$mode DELPHI}
{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  len_array = 100;
  len_name = 20;
  random_range = 326;

type
  TRecord = Record
    value: integer;
    name: string;
  end;

  TArr = array [1 .. len_array] of TRecord;
  TIndexes = array of integer;

procedure GetRandomArr(var arr: TArr);
var
  i: integer;
begin
  randomize;
  for i := 1 to len_array do
  begin
    arr[i].value := Random(random_range);
    arr[i].name := 'sensor_' + IntToStr(i);
  end;
end;

procedure PrintArray(const arr: TArr);
var
  i: integer;
begin
  writeln('------====== Array start ======------');
  for i := 1 to len_array do
    write('(value: ', arr[i].value, ', name: ', arr[i].name, ') ');
  writeln;
  writeln('------====== Array end ======------');
  writeln;
end;

procedure Sort(var arr: TArr; byName: boolean);
var
  i, firstIndex, lastIndex: integer;
  tempValue: TRecord;
begin
  firstIndex := 1;
  lastIndex := len_array;
  if byName then
    while firstIndex < lastIndex do
    begin
      for i := firstIndex to lastIndex - 1 do
        if arr[i].name > arr[i + 1].name then
        begin
          tempValue := arr[i];
          arr[i] := arr[i + 1];
          arr[i + 1] := tempValue;
        end;

      for i := lastIndex downto firstIndex + 1 do
        if arr[i].name < arr[i - 1].name then
        begin
          tempValue := arr[i];
          arr[i] := arr[i - 1];
          arr[i - 1] := tempValue;
        end;

      firstIndex := firstIndex + 1;
      lastIndex := lastIndex - 1;
    end
  else
    while firstIndex < lastIndex do
    begin
      for i := firstIndex to lastIndex - 1 do
        if arr[i].value > arr[i + 1].value then
        begin
          tempValue := arr[i];
          arr[i] := arr[i + 1];
          arr[i + 1] := tempValue;
        end;

      for i := lastIndex downto firstIndex + 1 do
        if arr[i].value < arr[i - 1].value then
        begin
          tempValue := arr[i];
          arr[i] := arr[i - 1];
          arr[i - 1] := tempValue;
        end;

      firstIndex := firstIndex + 1;
      lastIndex := lastIndex - 1;
    end;
end;

function BinSearchByName(const arr: TArr; const name: string;
  leftIndex, rightIndex: integer; var counter: integer): integer;
var
  middleIndex: integer;
  search: boolean;
begin
  search := True;
  while search do
  begin
    counter := counter + 1;
    if (leftIndex = rightIndex) and (arr[leftIndex].name <> name) then
    begin
      BinSearchByName := -1;
      search := False;
    end
    else
    begin
      middleIndex := (leftIndex + rightIndex) div 2;
      if arr[middleIndex].name = name then
      begin
        BinSearchByName := middleIndex;
        search := False;
      end
      else if arr[middleIndex].name < name then
        leftIndex := middleIndex + 1
      else
        rightIndex := middleIndex;
    end;
  end;
end;

function BinSearchByValue(const arr: TArr; const value: integer;
  leftIndex, rightIndex: integer; var counter: integer): TIndexes;
var
  middleIndex, i, j, min, max: integer;
  search: boolean;
  resultArray: TIndexes;
begin
  min := leftIndex;
  max := rightIndex;
  search := True;
  while search do
  begin
    counter := counter + 1;
    if (leftIndex = rightIndex) and (arr[leftIndex].value <> value) then
    begin
      setLength(resultArray, 1);
      resultArray[0] := -1;
      search := False;
    end
    else
    begin
      middleIndex := (leftIndex + rightIndex) div 2;
      if arr[middleIndex].value = value then
      begin
        setLength(resultArray, 1);
        resultArray[0] := middleIndex;
        i := middleIndex + 1;
        j := 2;
        while (search) and (i <= max) do
          if arr[i].value = value then
          begin
            setLength(resultArray, j);
            resultArray[j - 1] := i;
            Inc(i);
            Inc(j);
          end
          else
            search := False;
        search := True;
        i := middleIndex - 1;
        while (search) and (i >= min) do
          if arr[i].value = value then
          begin
            setLength(resultArray, i);
            resultArray[j - 1] := i;
            Dec(i);
            Inc(j);
          end
          else
            search := False;
      end
      else if arr[middleIndex].value < value then
        leftIndex := middleIndex + 1
      else
        rightIndex := middleIndex;
    end;
  end;
  BinSearchByValue := resultArray;
end;

var
  arr: TArr;
  indexes: TIndexes;
  index, counter, searchValue, i: integer;
  searchString: string;
  searchFlag: boolean;

begin
  GetRandomArr(arr);
  PrintArray(arr);
  Sort(arr, True);
  PrintArray(arr);

  searchFlag := True;
  while searchFlag do
  begin
    write('Enter search string: ');
    readln(searchString);
    counter := 0;
    index := BinSearchByName(arr, searchString, 1, len_array, counter);
    if (index = -1) then
      writeln('Not found, try again')
    else
    begin
      writeln('(index: ', index, ', value: ', arr[index].value, ', name: ',
        arr[index].name, ', counter: ', counter, ')');
      writeln;
      searchFlag := False;
    end;
  end;

  Sort(arr, False);
  PrintArray(arr);

  searchFlag := True;
  while searchFlag do
  begin
    write('Enter search string: ');
    readln(searchValue);
    counter := 0;
    indexes := BinSearchByValue(arr, searchValue, 1, len_array, counter);
    if (indexes[0] = -1) then
      writeln('Not found, try again')
    else
    begin
      for i := low(indexes) to high(indexes) do
        writeln('(value: ', arr[indexes[i]].value, ', name: ',
          arr[indexes[i]].name, ')');
      writeln;
      searchFlag := False;
    end;
  end;

  readln;

end.
