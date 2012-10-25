Class ArrayUtil2D<T>
    Function CreateArray:T[][](rows%, cols%)
        Local a:T[][] = New T[rows][]
        For Local i:Int = 0 Until rows
            a[i] = New T[cols]
        End

        Return a
    End
End

Class ArrayUtil3D<T>
    Function CreateArray:T[][][](x%, y%, z%)
        Local a:T[][][] = New T[x][][]
        For Local i:Int = 0 Until x
            a[i] = New T[y][]
            For Local j% = 0 Until z
                a[i][j] = New T[z]
            Next
        End

        Return a
    End
End
