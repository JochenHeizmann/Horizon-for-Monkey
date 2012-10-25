Import horizon.utilinisection
Import horizon.utilinikey
Import horizon.blitzmaxfunctions

Class UtilIniReader
    Field sections : List<UtilIniSection>

    Method New()
        Self.sections = New List<UtilIniSection>
    End Method

    Method GetValue:String(section:String, key:String)
        Local found:Int, section2:UtilIniSection, key2:UtilIniKey
        section2 = GetSection(section)

        If (section2)
            For key2 = EachIn section2.keys
                If key2.name.ToLower() = key.ToLower() Then Return key2.value
            Next
        End If

        Return ""
    End

    Method GetKey:UtilIniKey(section:String, key:String)
        Local found:Int, section2:UtilIniSection, key2:UtilIniKey
        section2 = GetSection(section)

        If (section2)
            For key2 = EachIn section2.keys
                If key2.name.ToLower() = key.ToLower() Then Return key2
            Next
        End If
        Local u := New UtilIniKey
        u.name = key
        u.value = section + "_" + key
        Return u
    End Method

    Method GetSection:UtilIniSection(section:String)
        Local found:Int, section2:UtilIniSection

        section = section.ToLower()
        For section2 = EachIn Self.sections
            If section2.name.ToLower() = section Then
                Return section2
            End If
        Next

        Return Null
    End Method

    Function Load:UtilIniReader(url:String)
        Local stream:TStream, reader:UtilIniReader, section:UtilIniSection
        Local key:UtilIniKey, line:String, position:Int, found:Int

        stream = ReadStream(url)
        If Not stream 
            Return Null
        End

        reader = New UtilIniReader
        While Not stream.Eof()
            line = stream.ReadLine()

            ' Check for white spaces at the beginning
            If line.Length > 0 And (line[0] = 9 Or line[0]) = 32 Then
                found = 0
                For position = 1 Until line.Length
                    If line[position] <> 9 And line[position] <> 32 Then
                        found = position
                        Exit
                    End If
                Next

                ' Trim white spaces
                line = line[found..]

                ' Only comments and keys can begin with white spaces
                If line[0] = 91 Then
                    stream.Close()
                    Error "Sections can't begin with white spaces."
                    Return Null
                End If
            End If

            ' Check for a comment
            found = line.Find(";")
            If found >= 0 Then
                If found > 0 And (Not (line[found - 1] = 9 Or
                                       line[found - 1] = 32)) Then
                    stream.Close()
                    Error "Expected spacing character before ';'."
                    Return Null
                End If

                line = line[..found]
            End If

            ' Check for empty line
            If line.Length = 0 Then Continue

            ' Check for a section
            If line[0] = 91 Then
                found = 0
                For position = 1 Until line.Length
                    If line[position] = 9 Or line[position] = 32 Then
                        stream.Close()
                        Error "Sectionnames can't contain white spaces."
                        Return Null
                    End If

                    If line[position] = 93 Then
                        found = position
                        Exit
                    End If
                Next

                If Not found Then
                    stream.Close()
                    Error "Expected ']'."
                    Return Null
                End If

                section = New UtilIniSection
                section.name = line[1..found]

                reader.sections.AddLast(section)
                Continue
            End If

            ' Check if a section exists
            If Not section
                stream.Close()
                Error "Expected '[Section]' before."
                Return Null
            End If

            ' Check for a key
            found = line.Find("=")
            If Not found Then
                stream.Close()
                Error "Expected '='."
                Return Null
            End If

            found = 0
            For position = 0 Until line.Length
                If found = 0 And (line[position] = 9 Or line[position] = 32) Then
                    found = position
                Else If found > 0 And line[position] <> 61 Then
                    stream.Close()
                    Error "Keynames can't contain white spaces."
                    Return Null
                Else If line[position] = 61 Then
                    found = position
                    Exit
                End If
            Next

            key = New UtilIniKey
            key.name  = line[..found].Replace(" ", "").Replace("    ", "")
            key.value = Trim(line[found + 1..])
            key.value = key.value.Replace("~~n", "~n")
            section.keys.AddLast(key)
        Wend

        stream.Close()
        Return reader
    End Function
End