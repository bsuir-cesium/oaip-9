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
  TIndexes = array [1 .. 2] of integer;

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
    // if byName then
    // begin
      if (leftIndex = rightIndex) and (((arr[leftIndex].name <> String(key)) and byName) or ((arr[leftIndex].value <> integer(key)) and not byName)) then
        search := False
      else
      begin
        middleIndex := (leftIndex + rightIndex) div 2;
        if ((arr[middleIndex].value = integer(key)) and not byName) or ((arr[middleIndex].name = String(key)) and byName) then
        begin
          BinSearch := middleIndex;
          search := False;
        end
        else if ((arr[middleIndex].value < integer(key)) and not byName) or ((arr[middleIndex].name < String(key)) and byName) then
          leftIndex := middleIndex + 1
        else
          rightIndex := middleIndex;
      end;
    // end
    // else
    // begin
    //   if (leftIndex = rightIndex) and (arr[leftIndex].value <> integer(key))
    //   then
    //     search := False
    //   else
    //   begin
    //     middleIndex := (leftIndex + rightIndex) div 2;
    //     if arr[middleIndex].value = integer(key) then
    //     begin
    //       BinSearch := middleIndex;
    //       search := False;
    //     end
    //     else if arr[middleIndex].value < integer(key) then
    //       leftIndex := middleIndex + 1
    //     else
    //       rightIndex := middleIndex;
    //   end;
    // end;
  end;
end;

function BlockSearch(var arr: TArr; const key; leftIndex, rightIndex: integer;
  var counter: integer; const byName: boolean): integer;
var
  i, blockSize, j: integer;
  firstTime: boolean;
begin

  blockSize := trunc(sqrt(rightIndex));
  i := blockSize;

  if ((byName) and ((arr[leftIndex].name > string(key)) or
    (arr[rightIndex].name < string(key)))) or
    ((not byName) and ((arr[leftIndex].value > integer(key)) or
    (arr[rightIndex].value < integer(key)))) then
  begin
    BlockSearch := -1;
  end
  else
  begin
    while (blockSize <> 1) do
    begin
      Inc(counter);
      firstTime := True;
      while ((i <= rightIndex) and ((((byName) and (arr[i].name < string(key))))
        or (((not byName) and (arr[i].value < integer(key)))))) do
      begin
        if not firstTime then
          Inc(counter);
        firstTime := False;
        leftIndex := i + 1;
        i := i + blockSize;
        if i > rightIndex then
          i := rightIndex;
      end;
      rightIndex := i;
      blockSize := trunc(sqrt(rightIndex - leftIndex + 1));
      i := leftIndex + blockSize - 1;
    end;

    for j := leftIndex to rightIndex do
    begin
      Inc(counter);
      if (((byName) and (arr[j].name = string(key))) or
        ((not byName) and (arr[j].value = integer(key)))) then
      begin
        i := j;
      end;
    end;

    BlockSearch := i;
  end;

end;

procedure GetIndexes(const arr: TArr; const index, min, max: integer;
  var indexes: TIndexes; var counter: integer);
var
  i: integer;
  searchFlag: boolean;
begin
  searchFlag := True;
  indexes[1] := index;
  indexes[2] := index;
  i := index + 1;
  while (searchFlag) and (i <= len_array) do
    if (arr[i].value <= max) then
    begin
      indexes[2] := i;
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
      indexes[1] := i;
      Dec(i);
      Inc(counter);
    end
    else
      searchFlag := False;
end;

var
  arr: TArr;
  indexes: TIndexes;
  indexBin, indexBlock, counterBin, counterBlock, searchValue, i, min,
    max: integer;
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
  indexBlock := BlockSearch(arr, searchString, 1, len_array,
    counterBlock, True);

  writeln('_________________________________________________________________________');
  writeln('|             |            |            |               |               |');
  writeln('|             |   Индекс   |  Значение  |      Имя      |   Обращения   |');
  writeln('|_____________|____________|____________|_______________|_______________|');
  writeln('|             |            |            |               |               |');
  if (indexBin = -1) then
    writeln('|   Бинарный  |      -     |      -     |        -      |        -      |')
  else
  begin
    writeln('|   Бинарный  |    ', indexBin:4, '    |    ', arr[indexBin].value
      :3, '     |  ', arr[indexBin].name:11, '  |     ', counterBin:5,
      '     |');
  end;
  writeln('|_____________|____________|____________|_______________|_______________|');
  writeln('|             |            |            |               |               |');
  if (indexBlock = -1) then
    writeln('|   Блочный   |      -     |      -     |        -      |        -      |')
  else
  begin
    writeln('|   Блочный   |    ', indexBlock:4, '    |    ',
      arr[indexBlock].value:3, '     |  ', arr[indexBlock].name:11, '  |     ',
      counterBlock:5, '     |');
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
  writeln('|             |   Индекс   |  Значение  |      Имя      |   Обращения   |');
  writeln('|_____________|____________|____________|_______________|_______________|');
  if (indexBin = -1) then
  begin
    writeln('|             |            |            |               |               |');
    writeln('|   Бинарный  |      -     |      -     |        -      |        -      |');
  end
  else
  begin
    GetIndexes(arr, indexBin, searchValue, searchValue, indexes, counterBin);

    for i := indexes[1] to indexes[2] do
    begin
      writeln('|             |            |            |               |               |');
      if i = indexes[1] then
        writeln('|   Бинарный  |    ', i:4, '    |    ', arr[i].value:3,
          '     |  ', arr[i].name:11, '  |     ', counterBin:5, '     |')
      else
        writeln('|             |    ', i:4, '    |    ', arr[i].value:3,
          '     |  ', arr[i].name:11, '  |               |');
    end;
  end;
  writeln('|_____________|____________|____________|_______________|_______________|');

  counterBlock := 0;
  indexBlock := BlockSearch(arr, searchValue, 1, len_array,
    counterBlock, False);
  if (indexBlock = -1) then
  begin
    writeln('|             |            |            |               |               |');
    writeln('|   Блочный   |      -     |      -     |        -      |        -      |');
  end
  else
  begin
    GetIndexes(arr, indexBlock, searchValue, searchValue, indexes,
      counterBlock);

    for i := indexes[1] to indexes[2] do
    begin
      writeln('|             |            |            |               |               |');
      if i = indexes[1] then
        writeln('|   Блочный   |    ', i:4, '    |    ', arr[i].value:3,
          '     |  ', arr[i].name:11, '  |     ', counterBlock:5, '     |')
      else
        writeln('|             |    ', i:4, '    |    ', arr[i].value:3,
          '     |  ', arr[i].name:11, '  |               |');
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
    if (min > max) or (min = max) or (min < 0) or (max < 1) or
      (min >= random_range) or (max >= random_range) then
      writeln('Enter valid values!')
    else
    begin
      writeln('_________________________________________________________________________');
      writeln('|             |            |            |               |               |');
      writeln('|             |   Индекс   |  Значение  |      Имя      |   Обращения   |');
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
        GetIndexes(arr, indexBin, min, max, indexes, counterBin);

        for i := indexes[1] to indexes[2] do
        begin
          writeln('|             |            |            |               |               |');
          if i = indexes[1] then
            writeln('|   Бинарный  |    ', i:4, '    |    ', arr[i].value:3,
              '     |  ', arr[i].name:11, '  |     ', counterBin:5, '     |')
          else
            writeln('|             |    ', i:4, '    |    ', arr[i].value:3,
              '     |  ', arr[i].name:11, '  |               |');
        end;
      end
      else
      begin
        writeln('|             |            |            |               |               |');
        writeln('|   Бинарный  |      -     |      -     |        -      |        -      |');
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
        GetIndexes(arr, indexBlock, min, max, indexes, counterBlock);

        for i := indexes[1] to indexes[2] do
        begin
          writeln('|             |            |            |               |               |');
          if i = indexes[1] then
            writeln('|   Блочный   |    ', i:4, '    |    ', arr[i].value:3,
              '     |  ', arr[i].name:11, '  |     ', counterBlock:5, '     |')
          else
            writeln('|             |    ', i:4, '    |    ', arr[i].value:3,
              '     |  ', arr[i].name:11, '  |               |');
        end;
      end
      else
      begin
        writeln('|             |            |            |               |               |');
        writeln('|   Блочный   |      -     |      -     |        -      |        -      |');
      end;
      writeln('|_____________|____________|____________|_______________|_______________|');

      searchFlag := False;
    end;
  end;

  writeln('Press Enter to exit...');
  readln;

end.
