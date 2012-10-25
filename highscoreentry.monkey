
Class HighscoreEntry
    Field id:Int
    Field score:Int
    Field name:String
    Field obj:Object

    Function CompareEntries:Int(o1:Object, o2:Object)
        Return (HighscoreEntry(o1).score < HighscoreEntry(o2).score)
    End Function
End

