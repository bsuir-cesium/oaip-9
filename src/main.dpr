program main;

// {$mode DELPHI}
{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  len_array = 1000;
  len_name = 20;
  random_range = 326;

type
  TRecord = Record
    value: integer;
    name: string[len_name];
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
  while firstIndex < lastIndex do
  begin
    for i := firstIndex to lastIndex - 1 do
      if ((arr[i].name > arr[i + 1].name) and byName) or
        ((arr[i].value > arr[i + 1].value) and not byName) then
      begin
        tempValue := arr[i];
        arr[i] := arr[i + 1];
        arr[i + 1] := tempValue;
      end;
    for i := lastIndex downto firstIndex + 1 do
      if ((arr[i].name < arr[i - 1].name) and byName) or
        ((arr[i].value < arr[i - 1].value) and not byName) then
      begin
        tempValue := arr[i];
        arr[i] := arr[i - 1];
        arr[i - 1] := tempValue;
      end;
    firstIndex := firstIndex + 1;
    lastIndex := lastIndex - 1;
  end;
end;

function BinSearch(const arr: TArr; const key: Variant;
  leftIndex, rightIndex: integer; var counter: integer;
  const byName: boolean): integer;
var
  middleIndex: integer;
  search: boolean;
begin
  search := True;
  while search do
  begin
    counter := counter + 1;
    if byName then
    begin
      if (leftIndex = rightIndex) and (arr[leftIndex].name <> key) then
      begin
        BinSearch := -1;
        search := False;
      end
      else
      begin
        middleIndex := (leftIndex + rightIndex) div 2;
        if arr[middleIndex].name = key then
        begin
          BinSearch := middleIndex;
          search := False;
        end
        else if arr[middleIndex].name < key then
          leftIndex := middleIndex + 1
        else
          rightIndex := middleIndex;
      end;
    end
    else
    begin
      if (leftIndex = rightIndex) and (arr[leftIndex].value <> key) then
      begin
        BinSearch := -1;
        search := False;
      end
      else
      begin
        middleIndex := (leftIndex + rightIndex) div 2;
        if arr[middleIndex].value = key then
        begin
          BinSearch := middleIndex;
          search := False;
        end
        else if arr[middleIndex].value < key then
          leftIndex := middleIndex + 1
        else
          rightIndex := middleIndex;
      end;
    end;
  end;
end;

var
  arr: TArr;
  indexes: TIndexes;
  index, counter, searchValue, i, len: integer;
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
    index := BinSearch(arr, searchString, 1, len_array, counter, True);
    if (index = -1) then
      writeln('Not found, try again')
    else
    begin
      writeln('(index: ', index, ', value: ', arr[index].value, ', name: ',
        arr[index].name, ', counter: ', counter, ')');
      writeln('Press Enter...');
      readln;
      searchFlag := False;
    end;
  end;

  Sort(arr, False);
  PrintArray(arr);

  searchFlag := True;
  while searchFlag do
  begin
    write('Enter search value: ');
    readln(searchValue);
    index := BinSearch(arr, searchValue, 1, len_array, counter, False);

    if (index = -1) then
    begin
      writeln('Not found, try again')
    end
    else
    begin
      setLength(indexes, 1);
      indexes[0] := index;

      i := index + 1;
      len := 2;
      while (searchFlag) and (i <= len_array) do
        if arr[i].value = searchValue then
        begin
          setLength(indexes, len);
          indexes[len - 1] := i;
          Inc(i);
          Inc(counter);
          Inc(len);
        end
        else
          searchFlag := False;

      searchFlag := True;
      i := index - 1;
      while (searchFlag) and (i >= 1) do
        if arr[i].value = searchValue then
        begin
          setLength(indexes, i);
          indexes[len - 1] := i;
          Dec(i);
          Inc(counter);
          Inc(len);
        end
        else
          searchFlag := False;

      searchFlag := False;
    end;
  end;

  for i := 0 to len - 2 do
  begin
    writeln('(index: ', indexes[i], ', value: ', arr[indexes[i]].value,
      ', name: ', arr[indexes[i]].name, ', counter: ', counter, ')');
  end;
  readln;

end.
