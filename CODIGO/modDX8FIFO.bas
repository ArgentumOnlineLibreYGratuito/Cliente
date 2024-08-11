Attribute VB_Name = "modDX8FIFO"
Option Explicit



Sub CargarCabezas()
    Dim N As Integer
    Dim i As Long
    Dim Numheads As Integer
    Dim Miscabezas() As tIndiceCabeza
    
    N = FreeFile()
    Open App.path & "\init\Cabezas.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , Numheads
    
    'Resize array
    ReDim HeadData(0 To Numheads) As HeadData
    ReDim Miscabezas(0 To Numheads) As tIndiceCabeza
    
    For i = 1 To Numheads
        Get #N, , Miscabezas(i)
        
        If Miscabezas(i).Head(1) Then
            Call InitGrh(HeadData(i).Head(1), Miscabezas(i).Head(1), 0)
            Call InitGrh(HeadData(i).Head(2), Miscabezas(i).Head(2), 0)
            Call InitGrh(HeadData(i).Head(3), Miscabezas(i).Head(3), 0)
            Call InitGrh(HeadData(i).Head(4), Miscabezas(i).Head(4), 0)
        End If
    Next i
    
    Close #N
End Sub

Sub CargarCascos()
    Dim N As Integer
    Dim i As Long
    Dim NumCascos As Integer

    Dim Miscabezas() As tIndiceCabeza
    
    N = FreeFile()
    Open App.path & "\init\Cascos.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , NumCascos
    
    'Resize array
    ReDim CascoAnimData(0 To NumCascos) As HeadData
    ReDim Miscabezas(0 To NumCascos) As tIndiceCabeza
    
    For i = 1 To NumCascos
        Get #N, , Miscabezas(i)
        
        If Miscabezas(i).Head(1) Then
            Call InitGrh(CascoAnimData(i).Head(1), Miscabezas(i).Head(1), 0)
            Call InitGrh(CascoAnimData(i).Head(2), Miscabezas(i).Head(2), 0)
            Call InitGrh(CascoAnimData(i).Head(3), Miscabezas(i).Head(3), 0)
            Call InitGrh(CascoAnimData(i).Head(4), Miscabezas(i).Head(4), 0)
        End If
    Next i
    
    Close #N
End Sub

Sub CargarCuerpos()
    Dim N As Integer
    Dim i As Long
    Dim NumCuerpos As Integer
    Dim MisCuerpos() As tIndiceCuerpo
    
    N = FreeFile()
    Open App.path & "\init\Personajes.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , NumCuerpos
    
    'Resize array
    ReDim BodyData(0 To NumCuerpos) As BodyData
    ReDim MisCuerpos(0 To NumCuerpos) As tIndiceCuerpo
    
    For i = 1 To NumCuerpos
        Get #N, , MisCuerpos(i)
        
        If MisCuerpos(i).Body(1) Then
            InitGrh BodyData(i).Walk(1), MisCuerpos(i).Body(1), 0
            InitGrh BodyData(i).Walk(2), MisCuerpos(i).Body(2), 0
            InitGrh BodyData(i).Walk(3), MisCuerpos(i).Body(3), 0
            InitGrh BodyData(i).Walk(4), MisCuerpos(i).Body(4), 0
            
            BodyData(i).HeadOffset.x = MisCuerpos(i).HeadOffsetX
            BodyData(i).HeadOffset.y = MisCuerpos(i).HeadOffsetY
        End If
    Next i
    
    Close #N
End Sub

Sub CargarFxs()
    Dim N As Integer
    Dim i As Long
    Dim NumFxs As Integer
    
    N = FreeFile()
    Open App.path & "\init\Fxs.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , NumFxs
    
    'Resize array
    ReDim FxData(1 To NumFxs) As tIndiceFx
    
    For i = 1 To NumFxs
        Get #N, , FxData(i)
    Next i
    
    Close #N
End Sub

Sub CargarArrayLluvia()
    Dim N As Integer
    Dim i As Long
    Dim Nu As Integer
    
    N = FreeFile()
    Open App.path & "\init\fk.ind" For Binary Access Read As #N
    
    'cabecera
    Get #N, , MiCabecera
    
    'num de cabezas
    Get #N, , Nu
    
    'Resize array
    ReDim bLluvia(1 To Nu) As Byte
    
    For i = 1 To Nu
        Get #N, , bLluvia(i)
    Next i
    
    Close #N
End Sub

Public Function LoadGrhData() As Boolean
On Error GoTo ErrorHandler
    Dim Grh As Long
    Dim Frame As Long
    Dim grhCount As Long
    Dim Handle As Integer
    Dim fileVersion As Long
    
    'Open files
    Handle = FreeFile()
    Open App.path & "\INIT\Graficos.ind" For Binary Access Read As Handle
    Seek #1, 1
    
    'Get file version
    Get Handle, , fileVersion
    
    'Get number of grhs
    Get Handle, , grhCount
    
    'Resize arrays
    ReDim GrhData(1 To grhCount) As GrhData
    
    While Not EOF(Handle)
        Get Handle, , Grh
        
        With GrhData(Grh)
            'Get number of frames
            Get Handle, , .NumFrames
            If .NumFrames <= 0 Then GoTo ErrorHandler
            
            ReDim .Frames(1 To GrhData(Grh).NumFrames)
            
            If .NumFrames > 1 Then
                'Read a animation GRH set
                For Frame = 1 To .NumFrames
                    Get Handle, , .Frames(Frame)
                    If .Frames(Frame) <= 0 Or .Frames(Frame) > grhCount Then
                        GoTo ErrorHandler
                    End If
                Next Frame
                
                Get Handle, , .Speed
                
                If .Speed <= 0 Then GoTo ErrorHandler
                
                'Compute width and height
                .pixelHeight = GrhData(.Frames(1)).pixelHeight
                If .pixelHeight <= 0 Then GoTo ErrorHandler
                
                .pixelWidth = GrhData(.Frames(1)).pixelWidth
                If .pixelWidth <= 0 Then GoTo ErrorHandler
                
                .TileWidth = GrhData(.Frames(1)).TileWidth
                If .TileWidth <= 0 Then GoTo ErrorHandler
                
                .TileHeight = GrhData(.Frames(1)).TileHeight
                If .TileHeight <= 0 Then GoTo ErrorHandler
            Else
                'Read in normal GRH data
                Get Handle, , .FileNum
                If .FileNum <= 0 Then GoTo ErrorHandler
                
                Get Handle, , GrhData(Grh).sX
                If .sX < 0 Then GoTo ErrorHandler
                
                Get Handle, , .sY
                If .sY < 0 Then GoTo ErrorHandler
                
                Get Handle, , .pixelWidth
                If .pixelWidth <= 0 Then GoTo ErrorHandler
                
                Get Handle, , .pixelHeight
                If .pixelHeight <= 0 Then GoTo ErrorHandler
                
                'Compute width and height
                .TileWidth = .pixelWidth / 32
                .TileHeight = .pixelHeight / 32
                
                .Frames(1) = Grh
            End If
        End With
    Wend
    
    Close Handle
    
    LoadGrhData = True
Exit Function

ErrorHandler:
    LoadGrhData = False
End Function
