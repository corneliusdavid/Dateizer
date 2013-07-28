program Dateizer;
{$APPTYPE Console}

uses
  SysUtils, StrUtils;

procedure ShowSyntax;
begin
  Writeln('Syntax: Dateizer {-f} {-t} <old_filename.ext>');
  Writeln('  Renames <old_filename.ext> to <old_filename>_YYYY-MM-DD.<ext>');
  Writeln('  -t parameter will append the time (hhmmss) as well');
  Writeln('  -f parameter will force the rename (delete existing file first)');
  Writeln('  Optional paramters must precede the filename');
  Writeln('  Example:  Dateizer -f -t ProjectSource.zip');
end;

var
  curr_param: string;
  param_num: Integer;
  oldname, newname: string;
  oldbase, oldext: string;
  force_rename: Boolean;
  append_time: Boolean;
begin
  if ParamCount = 0 then begin
    ShowSyntax;
    Exit;
  end else begin
    force_rename := False;
    append_time := False;

    param_num := 1;
    repeat
      curr_param := UpperCase(ParamStr(param_num));
      if (Pos('-', curr_param) = 1) and (Length(curr_param) = 2) then
        if curr_param = '-F' then
          force_rename := True
        else if curr_param = '-T' then
          append_time := True
        else begin
          Writeln('Unknown parameter: ' + curr_param);
          ShowSyntax;
          Exit;
        end;

      Inc(param_num);
    until param_num >= ParamCount;

    oldname := ParamStr(ParamCount);
    if not FileExists(oldname) then begin
      Writeln('The source filename, ' + oldname + ' does not exist.');
      Exit;
    end else begin
      oldext := ExtractFileExt(oldname);
      oldbase := LeftStr(oldname, Length(oldname) - Length(oldext));

      // append date and optionally time
      newname := oldbase + FormatDateTime('_YYYY-MM-DD', Date);
      if append_time then
        newname := newname + FormatDateTime('_hhnnss', Now);
      // complete new name
      newname := newname + oldext;

      // if force, check existing
      if FileExists(newname) then
        if force_rename then
          DeleteFile(newname)
        else begin
          Writeln('existing file (', newname, ') not overwritten');
          Exit;
        end;

      Writeln('renaming ' + oldname + ' to ' + newname);
      RenameFile(oldname, newname);
    end;
  end;
end.
