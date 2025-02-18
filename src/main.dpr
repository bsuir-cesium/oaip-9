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
  TString = string[len_name];

  TRecord = Record
    value: integer;
    name: TString;
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

function BinSearch(const arr: TArr; const key; leftIndex, rightIndex: integer;
  var counter: integer; const byName: boolean): integer;
var
  middleIndex: integer;
  search: boolean;
begin
  BinSearch := -1;
  search := True;
  while search do
  begin
    counter := counter + 1;
    if byName then
    begin
      if (leftIndex = rightIndex) and (arr[leftIndex].name <> String(key)) then
        search := False
      else
      begin
        middleIndex := (leftIndex + rightIndex) div 2;
        if arr[middleIndex].name = String(key) then
        begin
          Result := middleIndex;
          search := False;
        end
        else if arr[middleIndex].name < String(key) then
          leftIndex := middleIndex + 1
        else
          rightIndex := middleIndex;
      end;
    end
    else
    begin
      if (leftIndex = rightIndex) and (arr[leftIndex].value <> integer(key))
      then
        search := False
      else
      begin
        middleIndex := (leftIndex + rightIndex) div 2;
        if arr[middleIndex].value = integer(key) then
        begin
          Result := middleIndex;
          search := False;
        end
        else if arr[middleIndex].value < integer(key) then
          leftIndex := middleIndex + 1
        else
          rightIndex := middleIndex;
      end;
    end;
  end;
end;

function BlockSearch(const arr: TArr; const key; leftIndex, rightIndex: integer;
  var counter: integer; const byName: boolean): integer;
var
  blockSize, blockStart, blockEnd, i: integer;
  found, blockSearchFinished, linearSearchFinished: boolean;
begin
  Result := -1;
  counter := 0;
  found := False;
  blockSearchFinished := False;
  linearSearchFinished := False;

  blockSize := Trunc(Sqrt(rightIndex - leftIndex + 1));

  blockStart := leftIndex;
  while (blockStart <= rightIndex) and not blockSearchFinished do
  begin
    blockEnd := blockStart + blockSize - 1;
    if blockEnd > rightIndex then
      blockEnd := rightIndex;

    Inc(counter);

    if byName then
    begin
      if arr[blockEnd].name >= String(key) then
      begin
        i := blockStart;
        linearSearchFinished := False;
        while (i <= blockEnd) and not linearSearchFinished do
        begin
          Inc(counter);
          if arr[i].name = String(key) then
          begin
            Result := i;
            found := True;
            linearSearchFinished := True;
            blockSearchFinished := True;
          end
          else
            Inc(i);
        end;
        if not found then
          blockSearchFinished := True;
      end;
    end
    else
    begin
      if arr[blockEnd].value >= integer(key) then
      begin
        i := blockStart;
        linearSearchFinished := False;
        while (i <= blockEnd) and not linearSearchFinished do
        begin
          Inc(counter);
          if arr[i].value = integer(key) then
          begin
            Result := i;
            found := True;
            linearSearchFinished := True;
            blockSearchFinished := True;
          end
          else
            Inc(i);
        end;
        if not found then
          blockSearchFinished := True;
      end;
    end;

    if not blockSearchFinished then
    begin
      blockStart := blockEnd + 1;
    end;
  end;
end;

procedure GetNearIndexes(const arr: TArr; const index, min, max: integer;
  var indexes: TIndexes; var len, counter: integer);
var
  i: integer;
  searchFlag: boolean;
begin
  searchFlag := True;
  indexes := nil;
  len := 1;
  setLength(indexes, len);
  indexes[0] := index;

  i := index + 1;
  while (searchFlag) and (i <= len_array) do
    if (arr[i].value <= max) then
    begin
      Inc(len);
      setLength(indexes, len);
      indexes[len - 1] := i;
      Inc(i);
      Inc(counter);
    end
    else
      searchFlag := False;

  searchFlag := True;
  i := index - 1;
  while (searchFlag) and (i >= 1) do
    if (arr[i].value >= min) then
    begin
      Inc(len);
      setLength(indexes, len);
      indexes[len - 1] := i;
      Dec(i);
      Inc(counter);
    end
    else
      searchFlag := False;
end;

var
  arr: TArr;
  indexes: TIndexes;
  index, counter, searchValue, i, len, min, max: integer;
  searchString: String;
  searchFlag, founded: boolean;

begin
  GetRandomArr(arr);
  PrintArray(arr);
  Sort(arr, True);
  PrintArray(arr);

  write('Enter search string: ');
  readln(searchString);

  counter := 0;
  index := BinSearch(arr, searchString, 1, len_array, counter, True);
  writeln('BinarySearch result:');
  if (index = -1) then
    writeln('Not found')
  else
  begin
    writeln('index: ', index, ', value: ', arr[index].value, ', name: ',
      arr[index].name, ', counter: ', counter, '');
  end;
  writeln;

  counter := 0;
  index := BlockSearch(arr, searchString, 1, len_array, counter, True);
  writeln('BlockSearch result:');
  if (index = -1) then
    writeln('Not found')
  else
  begin
    writeln('index: ', index, ', value: ', arr[index].value, ', name: ',
      arr[index].name, ', counter: ', counter, '');
  end;
  writeln;

  writeln('Press Enter...');
  readln;

  Sort(arr, False);
  PrintArray(arr);

  write('Enter search value: ');
  readln(searchValue);

  counter := 0;
  index := BinSearch(arr, searchValue, 1, len_array, counter, False);
  writeln('BinarySearch result:');
  if (index = -1) then
  begin
    writeln('Not found')
  end
  else
  begin
    GetNearIndexes(arr, index, searchValue, searchValue, indexes, len, counter);

    for i := 0 to len - 1 do
    begin
      writeln('index: ', indexes[i], ', value: ', arr[indexes[i]].value,
        ', name: ', arr[indexes[i]].name);
    end;
    writeln('counter: ', counter);
  end;
  writeln;

  counter := 0;
  index := BlockSearch(arr, searchValue, 1, len_array, counter, False);
  writeln('BlockSearch result:');
  if (index = -1) then
  begin
    writeln('Not found, try again')
  end
  else
  begin
    GetNearIndexes(arr, index, searchValue, searchValue, indexes, len, counter);

    for i := 0 to len - 1 do
    begin
      writeln('index: ', indexes[i], ', value: ', arr[indexes[i]].value,
        ', name: ', arr[indexes[i]].name);
    end;
    writeln('counter: ', counter);
  end;

  writeln('Press Enter...');
  readln;

  searchFlag := True;
  while searchFlag do
  begin
    write('Enter min board: ');
    readln(min);
    write('Enter max board: ');
    readln(max);
    if (min > max) or (min = max) or (min < 1) or (max < 1) or
      (min > random_range) or (max > random_range) then
      writeln('Enter valid values!')
    else
    begin
      founded := False;
      i := min;
      while (not founded) and (i <= max) do
      begin
        counter := 0;
        index := BinSearch(arr, i, 1, len_array, counter, False);
        if index = -1 then
          Inc(i)
        else
          founded := True;
      end;

      writeln('BinarySearch result:');
      if founded then
      begin
        GetNearIndexes(arr, index, min, max, indexes, len, counter);

        for i := 0 to len - 1 do
        begin
          writeln('index: ', indexes[i], ', value: ', arr[indexes[i]].value,
            ', name: ', arr[indexes[i]].name);
        end;
        writeln('counter: ', counter);
      end
      else
        writeln('Not found');

      writeln;

      founded := False;
      i := min;
      while (not founded) and (i <= max) do
      begin
        counter := 0;
        index := BlockSearch(arr, i, 1, len_array, counter, False);
        if index = -1 then
          Inc(i)
        else
          founded := True;
      end;

      writeln('BlockSearch result:');
      if founded then
      begin
        GetNearIndexes(arr, index, min, max, indexes, len, counter);

        for i := 0 to len - 1 do
        begin
          writeln('index: ', indexes[i], ', value: ', arr[indexes[i]].value,
            ', name: ', arr[indexes[i]].name);
        end;
        writeln('counter: ', counter);
      end
      else
        writeln('Not found');

      searchFlag := False;
    end;
  end;

  writeln('Press Enter to exit...');
  readln;

end.
