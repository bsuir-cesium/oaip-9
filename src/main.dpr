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
          BinSearch := middleIndex;
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
          BinSearch := middleIndex;
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
  BlockSearch := -1;
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
            BlockSearch := i;
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
            BlockSearch := i;
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
  indexBin, indexBlock, counterBin, counterBlock, searchValue, i, len, min, max: integer;
  searchString: String;
  searchFlag, founded: boolean;

begin
  GetRandomArr(arr);
  PrintArray(arr);
  Sort(arr, True);
  PrintArray(arr);

  write('Enter search string: ');
  readln(searchString);

  counterBin := 0;
  indexBin := BinSearch(arr, searchString, 1, len_array, counterBin, True);

  counterBlock := 0;
  indexBlock := BlockSearch(arr, searchString, 1, len_array, counterBlock, True);


  writeln('_________________________________________________________________________');
  writeln('|             |            |            |               |               |');
  writeln('|             |   ������   |  ��������  |      ���      |   ���������   |');
  writeln('|_____________|____________|____________|_______________|_______________|');
  writeln('|             |            |            |               |               |');
  if (indexBin = -1) then
    writeln('|   ��������  |      -     |      -     |        -      |        -      |')
  else
  begin
    writeln('|   ��������  |    ', indexBin:4, '    |    ', arr[indexBin].value:3, '     |   ', arr[indexBin].name:10, '  |     ', counterBin:5, '     |');
  end;
  writeln('|_____________|____________|____________|_______________|_______________|');
  writeln('|             |            |            |               |               |');
  if (indexBlock = -1) then
    writeln('|   �������   |      -     |      -     |        -      |        -      |')
  else
  begin
    writeln('|   �������   |    ', indexBlock:4, '    |    ', arr[indexBlock].value:3, '     |   ', arr[indexBlock].name:10, '  |     ', counterBlock:5, '     |');
  end;
  writeln('|_____________|____________|____________|_______________|_______________|');
  writeln('Press Enter...');
  readln;

  Sort(arr, False);
  PrintArray(arr);

  write('Enter search value: ');
  readln(searchValue);

  counterBin := 0;
  indexBin := BinSearch(arr, searchValue, 1, len_array, counterBin, False);
  writeln('_________________________________________________________________________');
  writeln('|             |            |            |               |               |');
  writeln('|             |   ������   |  ��������  |      ���      |   ���������   |');
  writeln('|_____________|____________|____________|_______________|_______________|');
  if (indexBin = -1) then
  begin
    writeln('|             |            |            |               |               |');
    writeln('|   ��������  |      -     |      -     |        -      |        -      |');
  end
  else
  begin
    GetNearIndexes(arr, indexBin, searchValue, searchValue, indexes, len, counterBin);

    for i := 0 to len - 1 do
    begin
      writeln('|             |            |            |               |               |');
      if i = 0 then
        writeln('|   ��������  |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |     ', counterBin:5, '     |')
      else
        writeln('|             |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |               |');
    end;
  end;
  writeln('|_____________|____________|____________|_______________|_______________|');

  counterBlock := 0;
  indexBlock := BlockSearch(arr, searchValue, 1, len_array, counterBlock, False);
  if (indexBlock = -1) then
  begin
    writeln('|             |            |            |               |               |');
    writeln('|   �������   |      -     |      -     |        -      |        -      |');
  end
  else
  begin
    GetNearIndexes(arr, indexBlock, searchValue, searchValue, indexes, len, counterBlock);

    for i := 0 to len - 1 do
    begin
      writeln('|             |            |            |               |               |');
      if i = 0 then
        writeln('|   �������   |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |     ', counterBlock:5, '     |')
      else
        writeln('|             |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |               |');
    end;
  end;
  writeln('|_____________|____________|____________|_______________|_______________|');

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
      writeln('_________________________________________________________________________');
      writeln('|             |            |            |               |               |');
      writeln('|             |   ������   |  ��������  |      ���      |   ���������   |');
      writeln('|_____________|____________|____________|_______________|_______________|');
      founded := False;
      i := min;
      while (not founded) and (i <= max) do
      begin
        counterBin := 0;
        indexBin := BinSearch(arr, i, 1, len_array, counterBin, False);
        if indexBin = -1 then
          Inc(i)
        else
          founded := True;
      end;

      if founded then
      begin
        GetNearIndexes(arr, indexBin, min, max, indexes, len, counterBin);

        for i := 0 to len - 1 do
        begin
          writeln('|             |            |            |               |               |');
          if i = 0 then
            writeln('|   ��������  |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |     ', counterBin:5, '     |')
          else
            writeln('|             |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |               |');
        end;
      end
      else
      begin
        writeln('|             |            |            |               |               |');
        writeln('|   ��������  |      -     |      -     |        -      |        -      |');
      end;
      writeln('|_____________|____________|____________|_______________|_______________|');

      founded := False;
      i := min;
      while (not founded) and (i <= max) do
      begin
        counterBlock := 0;
        indexBlock := BlockSearch(arr, i, 1, len_array, counterBlock, False);
        if indexBlock = -1 then
          Inc(i)
        else
          founded := True;
      end;

      if founded then
      begin
        GetNearIndexes(arr, indexBlock, min, max, indexes, len, counterBlock);

        for i := 0 to len - 1 do
        begin
          writeln('|             |            |            |               |               |');
          if i = 0 then
            writeln('|   �������   |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |     ', counterBlock:5, '     |')
          else
            writeln('|             |    ', indexes[i]:4, '    |    ', arr[indexes[i]].value:3, '     |   ', arr[indexes[i]].name:10, '  |               |');
        end;
      end
      else
      begin
        writeln('|             |            |            |               |               |');
        writeln('|   �������   |      -     |      -     |        -      |        -      |');
      end;
      writeln('|_____________|____________|____________|_______________|_______________|');

      searchFlag := False;
    end;
  end;

  writeln('Press Enter to exit...');
  readln;

end.
