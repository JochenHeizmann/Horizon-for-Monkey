Import horizon.highscoreentry
Import horizon.stream

Class Highscore
    Field entries:List<HighscoreEntry>

    Method New()
        entries = New List<HighscoreEntry>
    End Method

    Method Serialize(s:Stream)
        s.WriteInt(entries.Count())
        For Local e:HighscoreEntry = EachIn entries
            s.WriteInt(e.score)
            s.WriteInt(e.name.Length)
            s.WriteString(e.name)
        Next
    End

    Method Deserialize(s:Stream)
        entries = New List<HighscoreEntry>
        Local c := s.ReadInt()
        For Local i := 0 To c-1
            Local score := s.ReadInt()
            Local name := s.ReadString(s.ReadInt())
            AddEntry(name, score)
        Next
    End
    
    Method AddEntry:HighscoreEntry(name:String, score:Int)
        Local e:HighscoreEntry = New HighscoreEntry
        e.score = score
        e.name = name
        entries.AddLast(e)
        Return e
    End Method

    Method Sort()
        Local arr := entries.ToArray()

        For Local n = arr.Length() To 2 Step -1
            For Local i=0 To arr.Length()-2
                If arr[i].score < arr[i+1].score
                    Local el1 := arr[i]
                    arr[i] = arr[i+1]
                    arr[i+1] = el1
                End
            Next
        Next

        entries.Clear()
        
        For Local i=0 To arr.Length()-1
            entries.AddLast(arr[i])
        Next


        Local id:Int = 1
        For Local e:HighscoreEntry = EachIn entries
            e.id = id
            id+=1
        Next
    End Method

    Method GetEntries:List<HighscoreEntry>(cap:Int = 0)
        If (cap > 0)
            If (entries.Count() > cap)
                Local el := entries.ToArray()
                Local tl := New List<HighscoreEntry>
                For Local i:Int = 0 To cap-1
                    tl.AddLast(el[i])
                Next
                entries = tl
            End
        End
        Return entries
    End Method
End
