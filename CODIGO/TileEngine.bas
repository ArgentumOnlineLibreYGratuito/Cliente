Attribute VB_Name = "Mod_TileEngine"
'Argentum Online 0.12.1 MENDUZ DX8 VERSION www.noicoder.com
'
'Copyright (C) 2002 Márquez Pablo Ignacio
'Copyright (C) 2002 Otto Perez
'Copyright (C) 2002 Aaron Perkins
'Copyright (C) 2002 Matías Fernando Pequeño
'
'This program is free software; you can redistribute it and/or modify
'it under the terms of the Affero General Public License;
'either version 1 of the License, or any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the Affero General Public License
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'
'
'You can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'Calle 3 número 983 piso 7 dto A
'La Plata - Pcia, Buenos Aires - Republica Argentina
'Código Postal 1900
'Pablo Ignacio Márquez



Option Explicit

'Map sizes in tiles
Public Const XMaxMapSize As Byte = 100
Public Const XMinMapSize As Byte = 1
Public Const YMaxMapSize As Byte = 100
Public Const YMinMapSize As Byte = 1

Private Const GrhFogata As Integer = 1521

''
'Sets a Grh animation to loop indefinitely.
Private Const INFINITE_LOOPS As Integer = -1


'Encabezado bmp
Type BITMAPFILEHEADER
    bfType As Integer
    bfSize As Long
    bfReserved1 As Integer
    bfReserved2 As Integer
    bfOffBits As Long
End Type

'Info del encabezado del bmp
Type BITMAPINFOHEADER
    biSize As Long
    biWidth As Long
    biHeight As Long
    biPlanes As Integer
    biBitCount As Integer
    biCompression As Long
    biSizeImage As Long
    biXPelsPerMeter As Long
    biYPelsPerMeter As Long
    biClrUsed As Long
    biClrImportant As Long
End Type

'Posicion en un mapa
Public Type Position
    x As Long
    y As Long
End Type

'Posicion en el Mundo
Public Type WorldPos
    map As Integer
    x As Integer
    y As Integer
End Type

'Contiene info acerca de donde se puede encontrar un grh tamaño y animacion
Public Type GrhData
    sX As Integer
    sY As Integer
    
    FileNum As Long
    
    pixelWidth As Integer
    pixelHeight As Integer
    
    TileWidth As Single
    TileHeight As Single
    
    NumFrames As Integer
    Frames() As Long
    
    Speed As Single
End Type

'apunta a una estructura grhdata y mantiene la animacion
Public Type Grh
    grhindex As Integer
    FrameCounter As Single
    Speed As Single
    Started As Byte
    Loops As Integer
End Type

'Lista de cuerpos
Public Type BodyData
    Walk(E_Heading.NORTH To E_Heading.WEST) As Grh
    HeadOffset As Position
End Type

'Lista de cabezas
Public Type HeadData
    Head(E_Heading.NORTH To E_Heading.WEST) As Grh
End Type

'Lista de las animaciones de las armas
Type WeaponAnimData
    WeaponWalk(E_Heading.NORTH To E_Heading.WEST) As Grh
End Type

'Lista de las animaciones de los escudos
Type ShieldAnimData
    ShieldWalk(E_Heading.NORTH To E_Heading.WEST) As Grh
End Type


'Apariencia del personaje
Public Type Char
    active As Byte
    Heading As E_Heading
    Pos As Position
    
    iHead As Integer
    iBody As Integer
    Body As BodyData
    Head As HeadData
    Casco As HeadData
    Arma As WeaponAnimData
    Escudo As ShieldAnimData
    UsandoArma As Boolean
    
    fX As Grh
    FxIndex As Integer
    
    Criminal As Byte
    
    Nombre As String
    
    scrollDirectionX As Integer
    scrollDirectionY As Integer
    
    Moving As Byte
    MoveOffsetX As Single
    MoveOffsetY As Single
    
    pie As Boolean
    muerto As Boolean
    invisible As Boolean
    priv As Byte
End Type

'Info de un objeto
Public Type Obj
    OBJIndex As Integer
    Amount As Integer
End Type

'Tipo de las celdas del mapa
Public Type MapBlock
    Graphic(1 To 4) As Grh
    CharIndex As Integer
    ObjGrh As Grh
    
    light_value(3) As Long
    
    luz As Integer
    color(3) As Long
    
    particle_group As Integer

    
    NPCIndex As Integer
    OBJInfo As Obj
    TileExit As WorldPos
    Blocked As Byte
    
    Trigger As Integer
End Type

'Info de cada mapa
Public Type MapInfo
    Music As String
    Name As String
    StartPos As WorldPos
    MapVersion As Integer
End Type

'DX7 Objects
'Public DirectX As New DirectX7
'Public DirectDraw As DirectDraw7
'Private PrimarySurface As DirectDrawSurface7
'Private PrimaryClipper As DirectDrawClipper
'Private BackBufferSurface As DirectDrawSurface7

Public IniPath As String
Public MapPath As String


'Bordes del mapa
Public MinXBorder As Byte
Public MaxXBorder As Byte
Public MinYBorder As Byte
Public MaxYBorder As Byte

'Status del user
Public CurMap As Integer 'Mapa actual
Public UserIndex As Integer
Public UserMoving As Byte
Public UserBody As Integer
Public UserHead As Integer
Public UserPos As Position 'Posicion
Public AddtoUserPos As Position 'Si se mueve
Public UserCharIndex As Integer

Public EngineRun As Boolean

Public FPS As Long
Public FramesPerSecCounter As Long
Private fpsLastCheck As Long

'Tamaño del la vista en Tiles
Private WindowTileWidth As Integer
Private WindowTileHeight As Integer

Private HalfWindowTileWidth As Integer
Private HalfWindowTileHeight As Integer

'Offset del desde 0,0 del main view
Private MainViewTop As Integer
Private MainViewLeft As Integer

'Cuantos tiles el engine mete en el BUFFER cuando
'dibuja el mapa. Ojo un tamaño muy grande puede
'volver el engine muy lento
Public TileBufferSize As Integer

Private TileBufferPixelOffsetX As Integer
Private TileBufferPixelOffsetY As Integer

'Tamaño de los tiles en pixels
Public TilePixelHeight As Integer
Public TilePixelWidth As Integer

'Number of pixels the engine scrolls per frame. MUST divide evenly into pixels per tile
Public ScrollPixelsPerFrameX As Integer
Public ScrollPixelsPerFrameY As Integer

Dim timerElapsedTime As Single
Dim timerTicksPerFrame As Single
Dim engineBaseSpeed As Single


Public NumBodies As Integer
Public Numheads As Integer
Public NumFxs As Integer

Public NumChars As Integer
Public LastChar As Integer
Public NumWeaponAnims As Integer
Public NumShieldAnims As Integer


Private MainDestRect   As RECT
Private MainViewRect   As RECT
Private BackBufferRect As RECT

Private MainViewWidth As Integer
Private MainViewHeight As Integer

Private MouseTileX As Byte
Private MouseTileY As Byte




'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿Graficos¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?
Public GrhData() As GrhData 'Guarda todos los grh
Public BodyData() As BodyData
Public HeadData() As HeadData
Public FxData() As tIndiceFx
Public WeaponAnimData() As WeaponAnimData
Public ShieldAnimData() As ShieldAnimData
Public CascoAnimData() As HeadData
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿Mapa?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?
Public MapData() As MapBlock ' Mapa
Public MapInfo As MapInfo ' Info acerca del mapa en uso
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

Public bRain        As Boolean 'está raineando?
Public bTecho       As Boolean 'hay techo?
Public brstTick     As Long

Private RLluvia(7)  As RECT  'RECT de la lluvia
Private iFrameIndex As Byte  'Frame actual de la LL
Private llTick      As Long  'Contador
Private LTLluvia(4) As Integer

Public charlist(1 To 10000) As Char

#If SeguridadAlkon Then

Public MI(1 To 1233) As clsManagerInvisibles
Public CualMI As Integer

#End If

' Used by GetTextExtentPoint32
Private Type size
    cx As Long
    cy As Long
End Type

'[CODE 001]:MatuX
Public Enum PlayLoop
    plNone = 0
    plLluviain = 1
    plLluviaout = 2
End Enum
'[END]'
'
'       [END]
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

#If ConAlfaB Then

Private Declare Function BltAlphaFast Lib "vbabdx" (ByRef lpDDSDest As Any, ByRef lpDDSSource As Any, ByVal iWidth As Long, ByVal iHeight As Long, _
        ByVal pitchSrc As Long, ByVal pitchDst As Long, ByVal dwMode As Long) As Long
Private Declare Function BltEfectoNoche Lib "vbabdx" (ByRef lpDDSDest As Any, ByVal iWidth As Long, ByVal iHeight As Long, _
        ByVal pitchDst As Long, ByVal dwMode As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
#End If

Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long


'Added by Juan Martín Sotuyo Dodero
Private Declare Function StretchBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
Private Declare Function SetPixel Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Private Declare Function GetPixel Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long) As Long
'Added by Barrin


'Very percise counter 64bit system counter
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long

'Text width computation. Needed to center text.
Private Declare Function GetTextExtentPoint32 Lib "gdi32" Alias "GetTextExtentPoint32A" (ByVal hDC As Long, ByVal lpsz As String, ByVal cbString As Long, lpSize As size) As Long



Sub ConvertCPtoTP(ByVal viewPortX As Integer, ByVal viewPortY As Integer, ByRef tX As Byte, ByRef tY As Byte)
'******************************************
'Converts where the mouse is in the main window to a tile position. MUST be called eveytime the mouse moves.
'******************************************
    tX = UserPos.x + viewPortX \ 32 - frmMain.renderer.ScaleWidth \ 64
    tY = UserPos.y + viewPortY \ 32 - frmMain.renderer.ScaleHeight \ 64
    Debug.Print tX; tY
End Sub

Sub ResetCharInfo(ByVal CharIndex As Integer)
    With charlist(CharIndex)
        .active = 0
        .Criminal = 0
        .FxIndex = 0
        .invisible = False
        
#If SeguridadAlkon Then
        Call MI(CualMI).ResetInvisible(CharIndex)
#End If
        
        .Moving = 0
        .muerto = False
        .Nombre = ""
        .pie = False
        .Pos.x = 0
        .Pos.y = 0
        .UsandoArma = False
    End With
End Sub
Sub MakeChar(ByVal CharIndex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As Byte, ByVal x As Integer, ByVal y As Integer, ByVal Arma As Integer, ByVal Escudo As Integer, ByVal Casco As Integer)
On Error Resume Next
    'Apuntamos al ultimo Char
    If CharIndex > LastChar Then LastChar = CharIndex
    
    With charlist(CharIndex)
        'If the char wasn't allready active (we are rewritting it) don't increase char count
        If .active = 0 Then _
            NumChars = NumChars + 1
        
        If Arma = 0 Then Arma = 2
        If Escudo = 0 Then Escudo = 2
        If Casco = 0 Then Casco = 2
        
        .iHead = Head
        .iBody = Body
        .Head = HeadData(Head)
        .Body = BodyData(Body)
        .Arma = WeaponAnimData(Arma)
        
        .Escudo = ShieldAnimData(Escudo)
        .Casco = CascoAnimData(Casco)
        
        .Heading = Heading
        
        'Reset moving stats
        .Moving = 0
        .MoveOffsetX = 0
        .MoveOffsetY = 0
        
        'Update position
        .Pos.x = x
        .Pos.y = y
        
        'Make active
        .active = 1
    End With
    
    'Plot on map
    MapData(x, y).CharIndex = CharIndex
End Sub
Sub EraseChar(ByVal CharIndex As Integer)
'*****************************************************************
'Erases a character from CharList and map
'*****************************************************************
On Error Resume Next
    charlist(CharIndex).active = 0
    
    'Update lastchar
    If CharIndex = LastChar Then
        Do Until charlist(LastChar).active = 1
            LastChar = LastChar - 1
            If LastChar = 0 Then Exit Do
        Loop
    End If
    
    MapData(charlist(CharIndex).Pos.x, charlist(CharIndex).Pos.y).CharIndex = 0
    
    'Remove char's dialog
    Call Dialogos.RemoveDialog(CharIndex)
    
    Call ResetCharInfo(CharIndex)
    
    'Update NumChars
    NumChars = NumChars - 1
End Sub

Public Sub InitGrh(ByRef Grh As Grh, ByVal grhindex As Integer, Optional ByVal Started As Byte = 2)
'*****************************************************************
'Sets up a grh. MUST be done before rendering
'*****************************************************************
    Grh.grhindex = grhindex
    
    If Started = 2 Then
        If GrhData(Grh.grhindex).NumFrames > 1 Then
            Grh.Started = 1
        Else
            Grh.Started = 0
        End If
    Else
        'Make sure the graphic can be started
        If GrhData(Grh.grhindex).NumFrames = 1 Then Started = 0
        Grh.Started = Started
    End If
    
    
    If Grh.Started Then
        Grh.Loops = INFINITE_LOOPS
    Else
        Grh.Loops = 0
    End If
    
    Grh.FrameCounter = 1
    Grh.Speed = GrhData(Grh.grhindex).Speed
End Sub

Public Sub DoFogataFx()
    Dim location As Position
    
    If bFogata Then
        bFogata = HayFogata(location)
        If Not bFogata Then
            Call Audio.StopWave(FogataBufferIndex)
            FogataBufferIndex = 0
        End If
    Else
        bFogata = HayFogata(location)
        If bFogata And FogataBufferIndex = 0 Then FogataBufferIndex = Audio.PlayWave("fuego.wav", location.x, location.y, LoopStyle.Enabled)
    End If
End Sub

Private Function EstaPCarea(ByVal CharIndex As Integer) As Boolean
    With charlist(CharIndex).Pos
        EstaPCarea = .x > UserPos.x - MinXBorder And .x < UserPos.x + MinXBorder And .y > UserPos.y - MinYBorder And .y < UserPos.y + MinYBorder
    End With
End Function

Sub DoPasosFx(ByVal CharIndex As Integer)
    If Not UserNavegando Then
        With charlist(CharIndex)
            If Not .muerto And EstaPCarea(CharIndex) And (.priv = 0 Or .priv > 5) Then
                .pie = Not .pie
                
                If .pie Then
                    Call Audio.PlayWave(SND_PASOS1, .Pos.x, .Pos.y)
                Else
                    Call Audio.PlayWave(SND_PASOS2, .Pos.x, .Pos.y)
                End If
            End If
        End With
    Else
' TODO : Actually we would have to check if the CharIndex char is in the water or not....
        Call Audio.PlayWave(SND_NAVEGANDO, charlist(CharIndex).Pos.x, charlist(CharIndex).Pos.y)
    End If
End Sub

Sub MoveCharbyPos(ByVal CharIndex As Integer, ByVal nX As Integer, ByVal nY As Integer)
On Error Resume Next
    Dim x As Integer
    Dim y As Integer
    Dim addx As Integer
    Dim addy As Integer
    Dim nHeading As E_Heading
    
    With charlist(CharIndex)
        x = .Pos.x
        y = .Pos.y
        
        MapData(x, y).CharIndex = 0
        
        addx = nX - x
        addy = nY - y
        
        If Sgn(addx) = 1 Then
            nHeading = E_Heading.EAST
        End If
        
        If Sgn(addx) = -1 Then
            nHeading = E_Heading.WEST
        End If
        
        If Sgn(addy) = -1 Then
            nHeading = E_Heading.NORTH
        End If
        
        If Sgn(addy) = 1 Then
            nHeading = E_Heading.SOUTH
        End If
        
        MapData(nX, nY).CharIndex = CharIndex
        
        
        .Pos.x = nX
        .Pos.y = nY
        
        .MoveOffsetX = -1 * (TilePixelWidth * addx)
        .MoveOffsetY = -1 * (TilePixelHeight * addy)
        
        .Moving = 1
        .Heading = nHeading
        
        .scrollDirectionX = Sgn(addx)
        .scrollDirectionY = Sgn(addy)
        
        'parche para que no medite cuando camina
        If .FxIndex = FxMeditar.CHICO Or .FxIndex = FxMeditar.GRANDE Or .FxIndex = FxMeditar.MEDIANO Or .FxIndex = FxMeditar.XGRANDE Or .FxIndex = FxMeditar.XXGRANDE Then
            .FxIndex = 0
        End If
    End With
    
    If Not EstaPCarea(CharIndex) Then Call Dialogos.RemoveDialog(CharIndex)
    
    If (nY < MinLimiteY) Or (nY > MaxLimiteY) Or (nX < MinLimiteX) Or (nX > MaxLimiteX) Then
        Call EraseChar(CharIndex)
    End If
End Sub

Sub MoveScreen(ByVal nHeading As E_Heading)
'******************************************
'Starts the screen moving in a direction
'******************************************
    Dim x As Integer
    Dim y As Integer
    Dim tX As Integer
    Dim tY As Integer
    
    'Figure out which way to move
    Select Case nHeading
        Case E_Heading.NORTH
            y = -1
        
        Case E_Heading.EAST
            x = 1
        
        Case E_Heading.SOUTH
            y = 1
        
        Case E_Heading.WEST
            x = -1
    End Select
    
    'Fill temp pos
    tX = UserPos.x + x
    tY = UserPos.y + y
    
    'Check to see if its out of bounds
    If tX < MinXBorder Or tX > MaxXBorder Or tY < MinYBorder Or tY > MaxYBorder Then
        Exit Sub
    Else
        'Start moving... MainLoop does the rest
        AddtoUserPos.x = x
        UserPos.x = tX
        AddtoUserPos.y = y
        UserPos.y = tY
        UserMoving = 1
        
        bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
                MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
    End If
End Sub

Private Function HayFogata(ByRef location As Position) As Boolean
    Dim j As Long
    Dim k As Long
    
    For j = UserPos.x - 8 To UserPos.x + 8
        For k = UserPos.y - 6 To UserPos.y + 6
            If InMapBounds(j, k) Then
                If MapData(j, k).ObjGrh.grhindex = GrhFogata Then
                    location.x = j
                    location.y = k
                    
                    HayFogata = True
                    Exit Function
                End If
            End If
        Next k
    Next j
End Function

Function NextOpenChar() As Integer
'*****************************************************************
'Finds next open char slot in CharList
'*****************************************************************
    Dim loopc As Long
    Dim Dale As Boolean
    
    loopc = 1
    Do While charlist(loopc).active And Dale
        loopc = loopc + 1
        Dale = (loopc <= UBound(charlist))
    Loop
    
    NextOpenChar = loopc
End Function

''
' Loads grh data using the new file format.
'
' @return   True if the load was successfull, False otherwise.


Function LegalPos(ByVal x As Integer, ByVal y As Integer) As Boolean
'*****************************************************************
'Checks to see if a tile position is legal
'*****************************************************************
    'Limites del mapa
    If x < MinXBorder Or x > MaxXBorder Or y < MinYBorder Or y > MaxYBorder Then
        Exit Function
    End If
    
    'Tile Bloqueado?
    If MapData(x, y).Blocked = 1 Then
        Exit Function
    End If
    
    '¿Hay un personaje?
    If MapData(x, y).CharIndex > 0 Then
        Exit Function
    End If
   
    If UserNavegando <> HayAgua(x, y) Then
        Exit Function
    End If
    
    LegalPos = True
End Function

Function InMapBounds(ByVal x As Integer, ByVal y As Integer) As Boolean
'*****************************************************************
'Checks to see if a tile position is in the maps bounds
'*****************************************************************
    If x < XMinMapSize Or x > XMaxMapSize Or y < YMinMapSize Or y > YMaxMapSize Then
        Exit Function
    End If
    
    InMapBounds = True
End Function





Function GetBitmapDimensions(ByVal BmpFile As String, ByRef bmWidth As Long, ByRef bmHeight As Long)
'*****************************************************************
'Gets the dimensions of a bmp
'*****************************************************************
    Dim BMHeader As BITMAPFILEHEADER
    Dim BINFOHeader As BITMAPINFOHEADER
    
    Open BmpFile For Binary Access Read As #1
    
    Get #1, , BMHeader
    Get #1, , BINFOHeader
    
    Close #1
    
    bmWidth = BINFOHeader.biWidth
    bmHeight = BINFOHeader.biHeight
End Function

Public Sub Grh_Render_To_Hdc(ByVal desthDC As Long, grh_index As Long, ByVal screen_x As Integer, ByVal screen_y As Integer, Optional transparent As Boolean = False)
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 8/30/2004
'This method is SLOW... Don't use in a loop if you care about
'speed!
'Modified by Juan Martín Sotuyo Dodero
'*************************************************************
    
    On Error GoTo ErrorHandler
    
    Dim file_path As String
    Dim src_x As Integer
    Dim src_y As Integer
    Dim src_width As Integer
    Dim src_height As Integer
    Dim hdcsrc As Long
    Dim MaskDC As Long
    Dim PrevObj As Long
    Dim PrevObj2 As Long

    If grh_index <= 0 Then Exit Sub

    'If it's animated switch grh_index to first frame
    If GrhData(grh_index).NumFrames <> 1 Then
        grh_index = GrhData(grh_index).Frames(1)
    End If

        file_path = App.path & "\graficos\" & GrhData(grh_index).FileNum & ".bmp"
        
        src_x = GrhData(grh_index).sX
        src_y = GrhData(grh_index).sY
        src_width = GrhData(grh_index).pixelWidth
        src_height = GrhData(grh_index).pixelHeight
            
        hdcsrc = CreateCompatibleDC(desthDC)
        PrevObj = SelectObject(hdcsrc, LoadPicture(file_path))
        
        If transparent = False Then
            BitBlt desthDC, screen_x, screen_y, src_width, src_height, hdcsrc, src_x, src_y, vbSrcCopy
        Else
            MaskDC = CreateCompatibleDC(desthDC)
            
            PrevObj2 = SelectObject(MaskDC, LoadPicture(file_path))
            
            Grh_Create_Mask hdcsrc, MaskDC, src_x, src_y, src_width, src_height
            
            'Render tranparently
            BitBlt desthDC, screen_x, screen_y, src_width, src_height, MaskDC, src_x, src_y, vbSrcAnd
            BitBlt desthDC, screen_x, screen_y, src_width, src_height, hdcsrc, src_x, src_y, vbSrcPaint
            
            Call DeleteObject(SelectObject(MaskDC, PrevObj2))
            
            DeleteDC MaskDC
        End If
        
        Call DeleteObject(SelectObject(hdcsrc, PrevObj))
        DeleteDC hdcsrc
        
   
    
    
    Exit Sub
    
ErrorHandler:

    
End Sub



Public Function RenderSounds()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 3/30/2008
'Actualiza todos los sonidos del mapa.
'**************************************************************
    If bLluvia(UserMap) = 1 Then
        If bRain Then
            If bTecho Then
                If frmMain.IsPlaying <> PlayLoop.plLluviain Then
                    If RainBufferIndex Then _
                        Call Audio.StopWave(RainBufferIndex)
                    RainBufferIndex = Audio.PlayWave("lluviain.wav", 0, 0, LoopStyle.Enabled)
                    frmMain.IsPlaying = PlayLoop.plLluviain
                End If
            Else
                If frmMain.IsPlaying <> PlayLoop.plLluviaout Then
                    If RainBufferIndex Then _
                        Call Audio.StopWave(RainBufferIndex)
                    RainBufferIndex = Audio.PlayWave("lluviaout.wav", 0, 0, LoopStyle.Enabled)
                    frmMain.IsPlaying = PlayLoop.plLluviaout
                End If
            End If
        End If
    End If
    
    DoFogataFx
End Function

Function HayUserAbajo(ByVal x As Integer, ByVal y As Integer, ByVal grhindex As Integer) As Boolean
    If grhindex > 0 Then
        HayUserAbajo = _
            charlist(UserCharIndex).Pos.x >= x - (GrhData(grhindex).TileWidth \ 2) _
                And charlist(UserCharIndex).Pos.x <= x + (GrhData(grhindex).TileWidth \ 2) _
                And charlist(UserCharIndex).Pos.y >= y - (GrhData(grhindex).TileHeight - 1) _
                And charlist(UserCharIndex).Pos.y <= y
    End If
End Function

Sub LoadGraphics()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero - complete rewrite
'Last Modify Date: 11/03/2006
'Initializes the SurfaceDB and sets up the rain rects
'**************************************************************
    'New surface manager :D
    'Call SurfaceDB.Initialize(DirectDraw, ClientSetup.bUseVideo, DirGraficos, ClientSetup.byMemory)
    
    'Set up te rain rects
    RLluvia(0).Top = 0:      RLluvia(1).Top = 0:      RLluvia(2).Top = 0:      RLluvia(3).Top = 0
    RLluvia(0).Left = 0:     RLluvia(1).Left = 128:   RLluvia(2).Left = 256:   RLluvia(3).Left = 384
    RLluvia(0).Right = 128:  RLluvia(1).Right = 256:  RLluvia(2).Right = 384:  RLluvia(3).Right = 512
    RLluvia(0).bottom = 128: RLluvia(1).bottom = 128: RLluvia(2).bottom = 128: RLluvia(3).bottom = 128
    
    RLluvia(4).Top = 128:    RLluvia(5).Top = 128:    RLluvia(6).Top = 128:    RLluvia(7).Top = 128
    RLluvia(4).Left = 0:     RLluvia(5).Left = 128:   RLluvia(6).Left = 256:   RLluvia(7).Left = 384
    RLluvia(4).Right = 128:  RLluvia(5).Right = 256:  RLluvia(6).Right = 384:  RLluvia(7).Right = 512
    RLluvia(4).bottom = 256: RLluvia(5).bottom = 256: RLluvia(6).bottom = 256: RLluvia(7).bottom = 256
    
    'We are done!
    'Saco esto porque el texto del cargar queda horrible
    'AddtoRichTextBox frmCargando.status, "Hecho.", , , , 1, , False
End Sub




#If ConAlfaB Then

Public Sub EfectoNoche(ByRef Surface As DirectDrawSurface7)
    Dim dArray() As Byte
    Dim ddsdDest As DDSURFACEDESC2
    Dim Modo As Long
    Dim rRect As RECT
    
    Surface.GetSurfaceDesc ddsdDest
    
    With rRect
        .Left = 0
        .Top = 0
        .Right = ddsdDest.lWidth
        .bottom = ddsdDest.lHeight
    End With
    
    If ddsdDest.ddpfPixelFormat.lGBitMask = &H3E0 Then
        Modo = 0
    ElseIf ddsdDest.ddpfPixelFormat.lGBitMask = &H7E0 Then
        Modo = 1
    Else
        Modo = 2
    End If
    
    Dim DstLock As Boolean
    DstLock = False
    
    On Local Error GoTo HayErrorAlpha
    
    Surface.Lock rRect, ddsdDest, DDLOCK_WAIT, 0
    DstLock = True
    
    Surface.GetLockedArray dArray()
    Call BltEfectoNoche(ByVal VarPtr(dArray(0, 0)), _
        ddsdDest.lWidth, ddsdDest.lHeight, ddsdDest.lPitch, _
        Modo)
    
HayErrorAlpha:
    If DstLock = True Then
        Surface.Unlock rRect
        DstLock = False
    End If
End Sub

#End If

Private Function GetElapsedTime() As Single
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Gets the time that past since the last call
'**************************************************************
    Dim start_time As Currency
    Static end_time As Currency
    Static timer_freq As Currency

    'Get the timer frequency
    If timer_freq = 0 Then
        QueryPerformanceFrequency timer_freq
    End If
    
    'Get current time
    Call QueryPerformanceCounter(start_time)
    
    'Calculate elapsed time
    GetElapsedTime = (start_time - end_time) / timer_freq * 1000
    
    'Get next end time
    Call QueryPerformanceCounter(end_time)
End Function


Public Sub SetCharacterFx(ByVal CharIndex As Integer, ByVal fX As Integer, ByVal Loops As Integer)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 12/03/04
'Sets an FX to the character.
'***************************************************
    With charlist(CharIndex)
        .FxIndex = fX
        
        If .FxIndex > 0 Then
            Call InitGrh(.fX, FxData(fX).Animacion)
        
            .fX.Loops = Loops
        End If
    End With
End Sub

Private Sub CleanViewPort()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 12/03/04
'Fills the viewport with black.
'***************************************************

End Sub
Private Sub Grh_Create_Mask(ByRef hdcsrc As Long, ByRef MaskDC As Long, ByVal src_x As Integer, ByVal src_y As Integer, ByVal src_width As Integer, ByVal src_height As Integer)
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 8/30/2004
'Creates a Mask hDC, and sets the source hDC to work for trans bliting.
'**************************************************************
    Dim x As Integer
    Dim y As Integer
    Dim TransColor As Long
    Dim ColorKey As String
    
    'ColorKey = hex(COLOR_KEY)
    
    'Check if it has an alpha component
    'If Len(ColorKey) > 6 Then
         'get rid of alpha
    '    ColorKey = "&H" & Right$(ColorKey, 6)
    'End If
    'piluex prueba
    'TransColor = Val(ColorKey)
    ColorKey = "0"
    TransColor = &H0

    'Make it a mask (set background to black and foreground to white)
    'And set the sprite's background white
    For y = src_y To src_height + src_y
        For x = src_x To src_width + src_x
            If GetPixel(hdcsrc, x, y) = TransColor Then
                SetPixel MaskDC, x, y, vbWhite
                SetPixel hdcsrc, x, y, vbBlack
            Else
                SetPixel MaskDC, x, y, vbBlack
            End If
        Next x
    Next y
End Sub

