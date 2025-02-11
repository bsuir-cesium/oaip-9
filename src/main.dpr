program main;

{$mode DELPHI}

uses
    SysUtils;

const
    len_array = 1000;
    len_name = 20;
    random_range = 326;

type
    TRecord = Record
        value: integer;
        name: string;
    end;
    TArr = array [1..len_array] of TRecord;

procedure GetRandomArr(var arr: TArr);
var
    i: Integer;
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
    i: Integer;
begin
    for i := 1 to len_array do
        write('(value: ', arr[i].value, ', name: ', arr[i].name, ') ');
    writeln;
end;

procedure Sort(var arr: TArr; byName: boolean);
var
    i, firstIndex, lastIndex : integer;
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

function BinSearchByName(const arr: TArr; const name: string; leftIndex, rightIndex : Integer; var counter: Integer): Integer;
var
  middleIndex : Integer;
begin
    counter := counter + 1;
    if leftIndex > rightIndex then
        BinSearchByName := -1
    else
    begin
        middleIndex := (leftIndex + rightIndex) div 2;
        if arr[middleIndex].name = name then
            BinSearchByName := middleIndex
        else
            if arr[middleIndex].name > name then
                BinSearchByName := BinSearchByName(arr, name, leftIndex, middleIndex, counter)
            else
                BinSearchByName := BinSearchByName(arr, name, middleIndex + 1, rightIndex, counter);
    end;
end;

var
    arr: TArr;
    index, counter: Integer;
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
            writeln('(index: ', index, ', value: ', arr[index].value, ', name: ', arr[index].name, ', counter: ', counter, ')');
            searchFlag := False;
        end;
    end;
end.    