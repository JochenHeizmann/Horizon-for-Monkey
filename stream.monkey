Import mojo

#if TARGET="ios"
	Import "native/stream.${TARGET}.${LANG}"

	Extern
    	Function LoadBinaryString$(file$)="LoadBinaryString"
	Public
#else
    Function LoadBinaryString$(file$)
    	Local ret := LoadString(file)
        Return ret
   	End
#end

Class Stream
    Global floatChars := ["","0","1","2","3","4","5","6","7","8","9","-",".","e"] '4-bit

    Field littleEndian:Bool
    Field stream$
    Field serializedStream$
    Field pos%

    Method New()
        littleEndian = True
    End

    Method New(file$)
        littleEndian = True
        Open(file)
    End

    Method Open(file$)
        pos = 0
        stream = LoadBinaryString(file)
    End

    Method ReadInt%()
        Local result$ = stream[pos..pos+4]
        pos += 4

        If (littleEndian)
            Return StringToLittleEndianInt(result)
        Else
            Return StringToInt(result)
        End
    End

    ' WARNING! Only Works with STRING FLOAT Representation
    Method ReadFloat#()
        Local result#
        Local len% = ReadInt()
        Local val := ReadString(len)
        Return Float(val)
    End   
     

    Method ReadBool?()
        Local result:Bool
        result = Bool(stream[pos])
        pos+=1
        Return result
    End

    Method Eof?()
        Return (pos >= stream.Length)
    End

    Method ReadLine$()
        Local result$ = ""

        For Local p% = pos To stream.Length-1
            If stream[p] = 13 or stream[p] = 10
                result = stream[pos..p+1]
                pos = p+1
                Return result
            End
        Next

        pos += 1
        Return result
    End

    Method Close:Void()
        stream = ""
        pos = 0
    End

    Method Save:Void()
        'SaveState(stream)
    End

    Method ReadString:String(strLen%)
        Local result:String
        If strLen > 0
            result = stream[pos..pos+strLen]
            pos+=strLen
        End
        Return result
    End

    Method WriteString(s$)
        stream += s
        serializedStream += "S:" + s + ";"
    End

    Method WriteBool:String(b?)
        stream += String.FromChar(b)
        serializedStream += "B:" + Int(b) + ";"
    End

    Method WriteInt:String(i%)
        If (littleEndian)
            stream += LittleEndianIntToString(i)
        Else
            stream += IntToString(i)
        End
        serializedStream += "I:" + i + ";"
    End

    Method Seek:Void(p%)
        pos = p 
    End

    Method Pos:Int()
        Return pos
    End

    Method LittleEndianIntToString:String(val:Int)
        Local result:String
        result = String.FromChar((val) & $FF)
        result+= String.FromChar((val Shr 8) & $FF)
        result+= String.FromChar((val Shr 16) & $FF)
        result+= String.FromChar((val Shr 24) & $FF)
        Return result
    End

    Method StringToLittleEndianInt:Int(val:String)
        Local result:Int

        result = (val[0])
        result|= (val[1] Shl 8)
        result|= (val[2] Shl 16)
        result|= (val[3] Shl 24)

        Return result
    End 
    
    Method IntToString:String(val:Int)
        Local result:String
        result = String.FromChar((val Shr 24) & $FF)
        result+= String.FromChar((val Shr 16) & $FF)
        result+= String.FromChar((val Shr 8) & $FF)
        result+= String.FromChar(val & $FF)
        Return result
    End
              
    Method StringToInt:Int(val:String)
        Local result:Int
        result = (val[0] Shl 24)
        result|= (val[1] Shl 16)
        result|= (val[2] Shl 8)
        result|= val[3]
        Return result
    End
End