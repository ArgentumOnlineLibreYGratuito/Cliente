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

Public Type Texture
    Width As Long
    Height As Long
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
Public Type char
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
    
    Emitter As Audio_Emitter
    Node As Partitioner_Item
End Type

'Info de un objeto
Public Type Obj
    OBJIndex As Integer
    Amount As Integer
    
    Node As Partitioner_Item
End Type

'Tipo de las celdas del mapa
Public Type MapBlock
    Graphic(1 To 4) As Grh
    Nodes(1 To 4)   As Partitioner_Item
    CharIndex As Integer
    ObjGrh As Grh

    NPCIndex As Integer
    OBJInfo As Obj
    TileExit As WorldPos
    Blocked As Byte
    
    Trigger As Integer
End Type

Public Type EffectData
    Animacion As Integer
    OffsetX As Integer
    OffsetY As Integer
End Type

'TODO Is this comment still valid? => Bordes del mapa
Public MinXBorder As Byte
Public MaxXBorder As Byte
Public MinYBorder As Byte
Public MaxYBorder As Byte

'TODO Is this comment still valid? => Status del user
Public UserMoving As Byte
Public UserPos As Position 'Posicion
Public AddtoUserPos As Position 'Si se mueve
Public UserCharIndex As Integer

Public FPS As Integer
Private FramesPerSecCounter As Integer
Private timerElapsedTime As Single
Private timerTicksPerFrame As Double
Public engineBaseSpeed As Single
Private lFrameTimer As Long
Private ScrollPixelsPerFrameX As Byte
Private ScrollPixelsPerFrameY As Byte
Private TileBufferSize As Integer

Private WindowTileWidth As Integer
Private WindowTileHeight As Integer

Private HalfWindowTileWidth As Integer
Private HalfWindowTileHeight As Integer


'TODO Is this comment still valid? => Tamaño de los tiles en pixels
Public TilePixelHeight As Integer
Public TilePixelWidth As Integer

'TODO Is this comment still valid? => Number of pixels the engine scrolls per frame. MUST divide evenly into pixels per tile
Public NumChars As Integer
Public LastChar As Integer
'TODO Is this comment still valid? => ¿?¿?¿?¿?¿?¿?¿?¿?¿?¿Graficos¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?
Public GrhData() As GrhData 'Guarda todos los grh
Public BodyData() As BodyData
Public HeadData() As HeadData
Public FxData() As EffectData
Public WeaponAnimData() As WeaponAnimData
Public ShieldAnimData() As ShieldAnimData
Public CascoAnimData() As HeadData
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿Mapa?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?
Public MapData() As MapBlock ' Mapa
'¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?

Public bRain        As Boolean 'está raineando?
Public bTecho       As Boolean 'TODO Is this comment still valid? => hay techo?
Public charlist(1 To 10000) As char

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

Public Technique_1_ As Graphic_Pipeline
Public Technique_2_ As Graphic_Pipeline
Private Font_ As Graphic_Font
Public Partitioner_ As Partitioner


'Very percise counter 64bit system counter
Private Declare Function QueryPerformanceFrequency Lib "kernel32" (lpFrequency As Currency) As Long
Private Declare Function QueryPerformanceCounter Lib "kernel32" (lpPerformanceCount As Currency) As Long

Sub ConvertCPtoTP(ByVal viewPortX As Integer, ByVal viewPortY As Integer, ByRef tX As Byte, ByRef tY As Byte)
'******************************************
'Converts where the mouse is in the main window to a tile position. MUST be called eveytime the mouse moves.
'******************************************
    tX = UserPos.x + viewPortX \ 32 - frmMain.renderer.ScaleWidth \ 64
    tY = UserPos.y + viewPortY \ 32 - frmMain.renderer.ScaleHeight \ 64
End Sub

Sub ResetCharInfo(ByVal CharIndex As Integer)
    With charlist(CharIndex)
        .active = 0
        .Criminal = 0
        .FxIndex = 0
        .invisible = False
        
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
                
        ' Create virtual sound source
        Set .Emitter = modEngine_Audio.CreateEmitter(X, Y)
        
        ' Quad-tree
        Call UpdateSceneCharacter(CharIndex)
        Call Partitioner_.Insert(.Node)
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
    
    Call Partitioner_.Remove(charlist(CharIndex).Node)
    
    MapData(charlist(CharIndex).Pos.x, charlist(CharIndex).Pos.y).CharIndex = 0
    
    'Remove char's dialog
    Call Dialogos.RemoveDialog(CharIndex)
    
    Call ResetCharInfo(CharIndex)
                
    ' Destroy virtual sound source
    Call modEngine_Audio.DeleteEmitter(charlist(CharIndex).Emitter, False)
        
    'Update NumChars
    NumChars = NumChars - 1
End Sub

Public Sub InitGrh(ByRef Grh As Grh, ByVal grhindex As Integer, Optional ByVal Started As Byte = 2)
'*****************************************************************
'Sets up a grh. MUST be done before rendering
'*****************************************************************
    If (grhindex = 0) Then Exit Sub
    
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

Private Function EstaPCarea(ByVal CharIndex As Integer) As Boolean
    With charlist(CharIndex).Pos
        EstaPCarea = .x > UserPos.x - MinXBorder And .x < UserPos.x + MinXBorder And .y > UserPos.y - MinYBorder And .y < UserPos.y + MinYBorder
    End With
End Function

Sub DoPasosFx(ByVal CharIndex As Integer)
    With charlist(CharIndex)
        If Not UserNavegando Then
            If Not .muerto And EstaPCarea(CharIndex) And (.priv = 0 Or .priv > 5) Then
                .pie = Not .pie
                    
                If .pie Then
                    Call modEngine_Audio.PlayEffect(SND_PASOS1, .Emitter)
                Else
                    Call modEngine_Audio.PlayEffect(SND_PASOS2, .Emitter)
                End If
            End If
        Else
    ' TODO : Actually we would have to check if the CharIndex char is in the water or not....
            Call modEngine_Audio.PlayEffect(SND_NAVEGANDO, .Emitter)
        End If
    End With
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
        
        
        Call modEngine_Audio.UpdateEmitter(.Emitter, nX, nY)
        Call UpdateSceneCharacter(CharIndex)
        Call Partitioner_.Update(.Node)

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

Public Sub Engine_MoveScreen(ByVal nHeading As E_Heading)
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

Public Sub Char_Move_by_Head(ByVal CharIndex As Integer, ByVal nHeading As E_Heading)
'*****************************************************************
'Starts the movement of a character in nHeading direction
'*****************************************************************
    Dim addx As Integer
    Dim addy As Integer
    Dim x As Integer
    Dim y As Integer
    Dim nX As Integer
    Dim nY As Integer
    
    With charlist(CharIndex)
        x = .Pos.x
        y = .Pos.y
        
        'Figure out which way to move
        Select Case nHeading
            Case E_Heading.NORTH
                addy = -1
        
            Case E_Heading.EAST
                addx = 1
        
            Case E_Heading.SOUTH
                addy = 1
            
            Case E_Heading.WEST
                addx = -1
        End Select
        
        nX = x + addx
        nY = y + addy
        
        MapData(nX, nY).CharIndex = CharIndex
        .Pos.x = nX
        .Pos.y = nY
        MapData(x, y).CharIndex = 0
                
        Call modEngine_Audio.UpdateEmitter(.Emitter, nX, nY)
        Call UpdateSceneCharacter(CharIndex)
        Call Partitioner_.Update(.Node)

        .MoveOffsetX = -1 * (32 * addx)
        .MoveOffsetY = -1 * (32 * addy)
        
        .Moving = 1
        .Heading = nHeading
        
        .scrollDirectionX = addx
        .scrollDirectionY = addy
    End With
    
    If UserEstado <> 1 Then Call DoPasosFx(CharIndex)
    
    'areas viejos
    If (nY < MinLimiteY) Or (nY > MaxLimiteY) Or (nX < MinLimiteX) Or (nX > MaxLimiteX) Then
        Call EraseChar(CharIndex)
    End If
End Sub

Public Sub Char_Move_by_Pos(ByVal CharIndex As Integer, ByVal nX As Integer, ByVal nY As Integer)
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
        
         Call modEngine_Audio.UpdateEmitter(.Emitter, nX, nY)
         Call UpdateSceneCharacter(CharIndex)
         Call Partitioner_.Update(.Node)

        .MoveOffsetX = -1 * (32 * addx)
        .MoveOffsetY = -1 * (32 * addy)
        
        .Moving = 1
        .Heading = nHeading
        
        .scrollDirectionX = Sgn(addx)
        .scrollDirectionY = Sgn(addy)
        
        'parche para que no medite cuando camina
        If .FxIndex = FxMeditar.CHICO Or .FxIndex = FxMeditar.GRANDE Or .FxIndex = FxMeditar.MEDIANO Or .FxIndex = FxMeditar.XGRANDE Or .FxIndex = FxMeditar.XXGRANDE Then
            .FxIndex = 0
        End If
    End With

End Sub

Public Sub Initialize()
                                          
    WindowTileWidth = frmMain.renderer.ScaleWidth / 32
    WindowTileHeight = frmMain.renderer.ScaleHeight / 32
    HalfWindowTileWidth = WindowTileWidth \ 2
    HalfWindowTileHeight = WindowTileHeight \ 2
    
    TileBufferSize = 9

    TilePixelWidth = 32
    TilePixelHeight = 32
    
    engineBaseSpeed = 0.017
    
    ReDim MapData(XMinMapSize To XMaxMapSize, YMinMapSize To YMaxMapSize) As MapBlock
    
    'Set FPS value to 60 for startup
    FPS = 60
    FramesPerSecCounter = 60
    
    ScrollPixelsPerFrameX = 8
    ScrollPixelsPerFrameY = 8
    
    UserPos.x = 50
    UserPos.y = 50
    
    MinXBorder = XMinMapSize + HalfWindowTileWidth
    MaxXBorder = XMaxMapSize - HalfWindowTileWidth
    MinYBorder = YMinMapSize + HalfWindowTileWidth
    MaxYBorder = YMaxMapSize - HalfWindowTileWidth

    ' Initialize Techniques
    Set Technique_1_ = Aurora_Content.Load("Resources://Pipeline/Sprite.effect", eResourceTypePipeline)
    Set Technique_2_ = Aurora_Content.Load("Resources://Pipeline/Sprite_Alpha.effect", eResourceTypePipeline)
    Set Font_ = Aurora_Content.Load("Resources://Font/Primary.arfont", eResourceTypeFont)

End Sub


Public Sub Render()

    Dim Viewport As Math_Rectf
    Viewport.X1 = 0
    Viewport.X2 = frmMain.renderer.ScaleWidth
    Viewport.Y1 = 0
    Viewport.Y2 = frmMain.renderer.ScaleHeight
    
    Call Aurora_Graphic.Prepare(&H0, Viewport, eClearAll, -1, 1, 0)
    
    Call ShowNextFrame(&H0)
    
    Call Aurora_Graphic.Commit(&H0, False, False)
    
    Call Inventario.DrawInventory
    
End Sub


Public Sub Draw(ByRef Destination As Math_Rectf, ByRef Source As Math_Rectf, ByVal Depth As Single, ByVal angle As Single, ByVal color As Long, ByVal Graphic As Long, ByVal alpha As Boolean)
    
    Dim Material As Graphic_Material
    Set Material = Aurora_Content.Retrieve("Memory://Material://Base/" + CStr(Graphic), eResourceTypeMaterial, True)
    
    ' Create the Material on Demand
    If (Material.GetStatus = eResourceStatusNone) Then
        Dim Texture As Graphic_Texture
        Set Texture = Aurora_Content.Load("Resources://Texture/" + CStr(Graphic) + ".png", eResourceTypeTexture)
        
        If (Texture.GetStatus <> eResourceStatusLoaded) Then
            Debug.Print "Tile_Engine::Draw", "Failed to acquire texture"
            Exit Sub
        End If

        Call Material.SetTexture(0, Texture)
        
        Call Aurora_Content.Register(Material, False)
    End If

    If (alpha) Then
        Call Aurora_Renderer.DrawTexture(Destination, Source, Depth, angle, eRendererOrderNormal, color, Technique_2_, Material)
    Else
        Call Aurora_Renderer.DrawTexture(Destination, Source, Depth, angle, eRendererOrderOpaque, color, Technique_1_, Material)
    End If
    
End Sub

Public Sub DrawText(ByVal x As Long, ByVal y As Long, ByVal Z As Single, ByRef word As String, ByVal color As Long, ByVal Alignment As Renderer_Alignment, ByVal SIZE As Long, Optional ByVal Outline As Boolean = 0)
    Call Aurora_Renderer.DrawFont(Font_, word, x, y, Z, SIZE, color, Alignment)
End Sub


Public Function GetDepth(ByVal Layer As Single, Optional ByVal x As Single = 1, Optional ByVal y As Single = 1, Optional ByVal Z As Single = 1) As Single

    GetDepth = -1# + (Layer * 0.1) + ((y - 1) * 0.001) + ((x - 1) * 0.00001) + ((Z - 1) * 0.000001)
    
End Function

Public Function RGBA(ByVal red As Long, ByVal green As Long, ByVal blue As Long, ByVal alpha As Long) As Long
    If alpha > 127 Then
        RGBA = RGB(red, green, blue) Or (alpha - 128) * &H1000000 Or &H80000000
    Else
        RGBA = RGB(red, green, blue) Or alpha * &H1000000
    End If
End Function


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



Sub ShowNextFrame(ByVal time As Single)
    Static OffsetCounterX As Single
    Static OffsetCounterY As Single
        If UserMoving Then
            '****** Move screen Left and Right if needed ******
            If AddtoUserPos.x <> 0 Then
                OffsetCounterX = OffsetCounterX - ScrollPixelsPerFrameX * AddtoUserPos.x * timerTicksPerFrame
                If Abs(OffsetCounterX) >= Abs(32 * AddtoUserPos.x) Then
                    OffsetCounterX = 0
                    AddtoUserPos.x = 0
                    UserMoving = False
                End If
            End If
            
            '****** Move screen Up and Down if needed ******
            If AddtoUserPos.y <> 0 Then
                OffsetCounterY = OffsetCounterY - ScrollPixelsPerFrameY * AddtoUserPos.y * timerTicksPerFrame
                If Abs(OffsetCounterY) >= Abs(32 * AddtoUserPos.y) Then
                    OffsetCounterY = 0
                    AddtoUserPos.y = 0
                    UserMoving = False
                End If
            End If
        End If
        
                  
    Dim Camera As New Graphic_Camera
    Call Camera.SetOrthographic(0, frmMain.renderer.ScaleWidth, frmMain.renderer.ScaleHeight, 0, 1000, -1000)
    Call Camera.Compute ' TODO: Camera movement
            
    Call Aurora_Renderer.Begin(Camera, time)
    Call RenderScreen(UserPos.x - AddtoUserPos.x, UserPos.y - AddtoUserPos.y, OffsetCounterX, OffsetCounterY)
    Call Dialogos.Render

    FramesPerSecCounter = FramesPerSecCounter + 1
    timerElapsedTime = GetElapsedTime()
    timerTicksPerFrame = timerElapsedTime * engineBaseSpeed
    If GetTickCount - lFrameTimer > 1000 Then
        FPS = FramesPerSecCounter
        FramesPerSecCounter = 0
        lFrameTimer = GetTickCount
    End If
    
    DrawText 10, 10, 0, "FPS: " & FPS, RGBA(255, 0, 0, 255), eRendererAlignmentLeftMiddle, 24, False
    
    Call Aurora_Renderer.End
    
    
End Sub

Private Sub Char_Render(ByVal CharIndex As Long, ByVal PixelOffsetX As Integer, ByVal PixelOffsetY As Integer, ByVal x As Byte, ByVal y As Byte)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 12/03/04
'Draw char's to screen without offcentering them
'***************************************************
    Dim moved As Boolean
    Dim Pos As Integer
    Dim line As String
    Dim color As Long

    With charlist(CharIndex)
        If .Moving Then
            'If needed, move left and right
            If .scrollDirectionX <> 0 Then
                .MoveOffsetX = .MoveOffsetX + ScrollPixelsPerFrameX * Sgn(.scrollDirectionX) * timerTicksPerFrame
                
                'Start animations
'TODO : Este parche es para evita los uncornos exploten al moverse!! REVER!!!
                If .Body.Walk(.Heading).Speed > 0 Then _
                    .Body.Walk(.Heading).Started = 1
                .Arma.WeaponWalk(.Heading).Started = 1
                .Escudo.ShieldWalk(.Heading).Started = 1
                
                'Char moved
                moved = True
                
                'Check if we already got there
                If (Sgn(.scrollDirectionX) = 1 And .MoveOffsetX >= 0) Or _
                        (Sgn(.scrollDirectionX) = -1 And .MoveOffsetX <= 0) Then
                    .MoveOffsetX = 0
                    .scrollDirectionX = 0
                End If
            End If
            
            'If needed, move up and down
            If .scrollDirectionY <> 0 Then
                .MoveOffsetY = .MoveOffsetY + ScrollPixelsPerFrameY * Sgn(.scrollDirectionY) * timerTicksPerFrame
                
                'Start animations
'TODO : Este parche es para evita los uncornos exploten al moverse!! REVER!!!
                If .Body.Walk(.Heading).Speed > 0 Then _
                    .Body.Walk(.Heading).Started = 1
                .Arma.WeaponWalk(.Heading).Started = 1
                .Escudo.ShieldWalk(.Heading).Started = 1
                
                'Char moved
                moved = True
                
                'Check if we already got there
                If (Sgn(.scrollDirectionY) = 1 And .MoveOffsetY >= 0) Or _
                        (Sgn(.scrollDirectionY) = -1 And .MoveOffsetY <= 0) Then
                    .MoveOffsetY = 0
                    .scrollDirectionY = 0
                End If
            End If
        End If
        
        'If done moving stop animation
        If Not moved Then
            'Stop animations
            .Body.Walk(.Heading).Started = 0
            .Body.Walk(.Heading).FrameCounter = 1
            
            .Arma.WeaponWalk(.Heading).Started = 0
            .Arma.WeaponWalk(.Heading).FrameCounter = 1
            
            .Escudo.ShieldWalk(.Heading).Started = 0
            .Escudo.ShieldWalk(.Heading).FrameCounter = 1
            
            .Moving = False
        End If
        
        PixelOffsetX = PixelOffsetX + .MoveOffsetX
        PixelOffsetY = PixelOffsetY + .MoveOffsetY
        
        If .Head.Head(.Heading).grhindex Then
            If Not .invisible Then
                'Draw Body

                            If .Body.Walk(.Heading).grhindex Then _
                                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, GetDepth(3, .Pos.x, .Pos.y, 2), 1, 1, True)
         
                            If .Head.Head(.Heading).grhindex Then
                                Call Draw_Grh(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, GetDepth(3, .Pos.x, .Pos.y, 3), 1, 1, True)
                                                
                                If .Casco.Head(.Heading).grhindex Then _
                                    Call Draw_Grh(.Head.Head(.Heading), PixelOffsetX + .Body.HeadOffset.x, PixelOffsetY + .Body.HeadOffset.y, GetDepth(3, .Pos.x, .Pos.y, 4), 1, 1, True)
    
                                If .Escudo.ShieldWalk(.Heading).grhindex Then _
                                    Call Draw_Grh(.Escudo.ShieldWalk(.Heading), PixelOffsetX, PixelOffsetY, GetDepth(3, .Pos.x, .Pos.y, 5), 1, 1, True)
                                    
                                If .Arma.WeaponWalk(.Heading).grhindex Then _
                                    Call Draw_Grh(.Arma.WeaponWalk(.Heading), PixelOffsetX, PixelOffsetY, GetDepth(3, .Pos.x, .Pos.y, 6), 1, 1, True)
                                
                            End If
                            
                    'Draw name over head
                    If Nombres Then
                        If Len(.Nombre) > 0 Then
                            Pos = InStr(.Nombre, "<")
                            If Pos = 0 Then Pos = Len(.Nombre) + 2
                            
                            If .priv = 0 Then
                                If .Criminal Then
                                    color = RGBA(255, 0, 0, 255)
                                Else
                                    color = RGBA(0, 128, 255, 255)
                                End If
                            Else
                                'color = D3DColorXRGB(ColoresPJ(.priv).r, ColoresPJ(.priv).g, ColoresPJ(.priv).b)
                            End If
                            
                            'Nick
                            line = Left$(.Nombre, Pos - 2)
                            Call DrawText(PixelOffsetX + TilePixelWidth \ 2, PixelOffsetY + 35, GetDepth(3, x, y, 8), line, color, eRendererAlignmentCenterTop, 14, True)
    
                            'Clan
                            line = mid$(.Nombre, Pos)
                            Call DrawText(PixelOffsetX + TilePixelWidth \ 2, PixelOffsetY + 50, GetDepth(3, x, y, 8), line, color, eRendererAlignmentCenterTop, 14, True)
    
                        End If
                    End If
                End If
            'End If
        Else
            'Draw Body
            If .Body.Walk(.Heading).grhindex Then _
                Call Draw_Grh(.Body.Walk(.Heading), PixelOffsetX, PixelOffsetY, GetDepth(3, .Pos.x, .Pos.y, 2), 1, 1, True)
        End If

        ''Update dialogs
        Call Dialogos.UpdateDialogPos(PixelOffsetX, PixelOffsetY + .Body.HeadOffset.y, 0, CharIndex)
        
        'Draw FX
        If .FxIndex <> 0 Then
            'Call Draw_Grh(.fX, PixelOffsetX + FxData(.FxIndex).OffsetX, PixelOffsetY + FxData(.FxIndex).OffsetY, 1, 1, True)

            If .fX.Started = 0 Then .FxIndex = 0
        End If
    End With
End Sub

Sub RenderScreen(ByVal tilex As Integer, ByVal tiley As Integer, ByVal PixelOffsetX As Integer, ByVal PixelOffsetY As Integer)
    Dim ScreenMinY      As Long  'Start Y pos on current screen
    Dim ScreenMaxY      As Long  'End Y pos on current screen
    Dim ScreenMinX      As Long  'Start X pos on current screen
    Dim ScreenMaxX      As Long  'End X pos on current screen
    Dim MinY            As Long  'Start Y pos on current map
    Dim MaxY            As Long  'End Y pos on current map
    Dim MinX            As Long  'Start X pos on current map
    Dim MaxX            As Long  'End X pos on current map
    Dim X               As Long
    Dim Y               As Long
    Dim Drawable        As Long
    Dim DrawableX       As Long
    Dim DrawableY       As Long
    Dim DrawableType    As Long

    'Figure out Ends and Starts of screen
    screenminY = tiley - HalfWindowTileHeight
    screenmaxY = tiley + HalfWindowTileHeight
    screenminX = tilex - HalfWindowTileWidth
    screenmaxX = tilex + HalfWindowTileWidth
    
    'Figure out Ends and Starts of map
    MinY = ScreenMinY
    MaxY = ScreenMaxY
    MinX = ScreenMinX
    MaxX = ScreenMaxX

    If PixelOffsetY < 0 Then
        MaxY = MaxY + 1
    ElseIf PixelOffsetY > 0 Then
        MinY = MinY - 1
    End If
    If PixelOffsetX < 0 Then
        MaxX = MaxX + 1
    ElseIf PixelOffsetX > 0 Then
        MinX = MinX - 1
    End If
    
    If MinY < YMinMapSize Then MinY = YMinMapSize
    If maxY > YMaxMapSize Then maxY = YMaxMapSize
    If minX < XMinMapSize Then minX = XMinMapSize
    If maxX > XMaxMapSize Then maxX = XMaxMapSize

    For y = minY To maxY
        DrawableY = (Y - ScreenMinY) * TilePixelHeight + PixelOffsetY
        
        For x = minX To maxX
            DrawableX = (X - ScreenMinX) * TilePixelWidth + PixelOffsetX
        
            Call Draw_Grh(MapData(X, Y).Graphic(1), DrawableX, DrawableY, -1#, 0, 1)
        Next x
    Next y

 
    Dim Results() As Partitioner_Item
    
    ' Get the entities from the quadtree.
    Call Partitioner_.Query(MinX - 1, MinY - 1, MaxX + 1, MaxY + 1, Results)

    For Drawable = 0 To UBound(Results)
        With Results(Drawable)
            
            X = .X
            Y = .Y
            DrawableX = (.X - ScreenMinX) * TilePixelWidth + PixelOffsetX
            DrawableY = (.Y - ScreenMinY) * TilePixelHeight + PixelOffsetY
            DrawableType = .Type
            
            With MapData(.X, .Y)
                Select Case (DrawableType)
                    Case 2
                        Call Draw_Grh(.Graphic(2), DrawableX, DrawableY, GetDepth(2, X, Y), 1, 1)
                    Case 3
                        Call Draw_Grh(.Graphic(3), DrawableX, DrawableY, GetDepth(3, X, Y), 1, 1)
                    Case 4
                        If (Not bTecho) Then
                            Call Draw_Grh(.Graphic(4), DrawableX, DrawableY, GetDepth(4, X, Y), 1, 1, True)
                        End If
                    Case 5
                        Call Draw_Grh(.ObjGrh, DrawableX, DrawableY, GetDepth(3, X, Y, 2), 1, 1)
                    Case 6
                        Call Char_Render(.CharIndex, DrawableX, DrawableY, X, Y)
                End Select
            End With
        End With
   Next Drawable

End Sub


Private Sub Draw_Grh(ByRef Grh As Grh, ByVal x As Long, ByVal y As Long, ByVal Z As Single, ByVal center As Byte, ByVal Animate As Byte, Optional ByVal alpha As Boolean, Optional ByVal angle As Single)
    Dim CurrentGrhIndex As Integer
    If Grh.grhindex = 0 Then Exit Sub
    If Animate Then
        If Grh.Started = 1 Then
            Grh.FrameCounter = Grh.FrameCounter + (timerElapsedTime * GrhData(Grh.grhindex).NumFrames / Grh.Speed)
            If Grh.FrameCounter > GrhData(Grh.grhindex).NumFrames Then
                Grh.FrameCounter = (Grh.FrameCounter Mod GrhData(Grh.grhindex).NumFrames) + 1
                
                If Grh.Loops <> -1 Then
                    If Grh.Loops > 0 Then
                        Grh.Loops = Grh.Loops - 1
                    Else
                        Grh.Started = 0
                    End If
                End If
            End If
        End If
    End If
    
    'Figure out what frame to draw (always 1 if not animated)
    CurrentGrhIndex = GrhData(Grh.grhindex).Frames(Grh.FrameCounter)

    With GrhData(CurrentGrhIndex)
        'Center Grh over X,Y pos
        If center Then
            If .TileWidth <> 1 Then
                x = x - Int(.TileWidth * (32 \ 2)) + 32 \ 2
            End If
    
            If GrhData(Grh.grhindex).TileHeight <> 1 Then
                y = y - Int(.TileHeight * 32) + 32
            End If
        End If
        
        Dim Texture As Graphic_Texture
        Set Texture = Aurora_Content.Load("Resources://Texture/" + CStr(.FileNum) + ".png", eResourceTypeTexture)
        
        Dim Source As Math_Rectf, Destination As Math_Rectf
        Source.X1 = .sX / Texture.GetWidth()
        Source.Y1 = .sY / Texture.GetHeight
        Source.X2 = Source.X1 + .pixelWidth / Texture.GetWidth()
        Source.Y2 = Source.Y1 + .pixelHeight / Texture.GetHeight()
        Destination.X1 = x
        Destination.Y1 = y
        Destination.X2 = x + .pixelWidth
        Destination.Y2 = y + .pixelHeight
        
        Call Draw(Destination, Source, Z, angle, -1, .FileNum, alpha)
    End With
    
End Sub

Sub DrawGrhIndex(ByVal GrhIndex As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Z As Single, ByVal Center As Byte, Optional ByVal color As Long = -1, Optional ByVal Angle As Integer = 0)
    If (GrhIndex = 0) Then Exit Sub
    
    With GrhData(GrhIndex)
        'Center Grh over X,Y pos
        If Center Then
            If .TileWidth <> 1 Then
                X = X - Int(.TileWidth * TilePixelWidth / 2) + TilePixelWidth \ 2
            End If
            
            If .TileHeight <> 1 Then
                Y = Y - Int(.TileHeight * TilePixelHeight) + TilePixelHeight
            End If
        End If
                            
        Dim Texture As Graphic_Texture
        Set Texture = Aurora_Content.Load("Resources://Texture/" + CStr(.FileNum) + ".png", eResourceTypeTexture)
        
        Dim Source As Math_Rectf, destination As Math_Rectf
        Source.X1 = .sX / Texture.GetWidth()
        Source.Y1 = .sY / Texture.GetHeight
        Source.X2 = Source.X1 + .pixelWidth / Texture.GetWidth()
        Source.Y2 = Source.Y1 + .pixelHeight / Texture.GetHeight()
        destination.X1 = X
        destination.Y1 = Y
        destination.X2 = X + .pixelWidth
        destination.Y2 = Y + .pixelHeight
        
        Call Draw(destination, Source, Z, Angle, color, .FileNum, False)
    End With
  
End Sub

Public Function LoadWeapons(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then

        Dim Length As Long
        Length = Reader.ReadInt16()

        ReDim WeaponAnimData(0 To Length) As WeaponAnimData

        Dim I As Long
        For I = 1 To Length
            Call InitGrh(WeaponAnimData(I).WeaponWalk(1), Reader.ReadInt16(), 0)
            Call InitGrh(WeaponAnimData(I).WeaponWalk(2), Reader.ReadInt16(), 0)
            Call InitGrh(WeaponAnimData(I).WeaponWalk(3), Reader.ReadInt16(), 0)
            Call InitGrh(WeaponAnimData(I).WeaponWalk(4), Reader.ReadInt16(), 0)
        Next I

        LoadWeapons = True
    Else
        LoadWeapons = False
    End If
    
End Function

Public Function LoadShields(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then

        Dim Length As Long
        Length = Reader.ReadInt16()

        ReDim ShieldAnimData(0 To Length) As ShieldAnimData

        Dim I As Long
        For I = 1 To Length
            Call InitGrh(ShieldAnimData(I).ShieldWalk(1), Reader.ReadInt16(), 0)
            Call InitGrh(ShieldAnimData(I).ShieldWalk(2), Reader.ReadInt16(), 0)
            Call InitGrh(ShieldAnimData(I).ShieldWalk(3), Reader.ReadInt16(), 0)
            Call InitGrh(ShieldAnimData(I).ShieldWalk(4), Reader.ReadInt16(), 0)
        Next I

        LoadShields = True
    Else
        LoadShields = False
    End If
    
End Function

Public Function LoadHeads(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then
        ' TODO: Remove Header
        Call Reader.Skip(263)
        
        Dim Length As Long
        Length = Reader.ReadInt16()

        ReDim HeadData(0 To Length) As HeadData

        Dim I As Long
        For I = 1 To Length
            Call InitGrh(HeadData(I).Head(1), Reader.ReadInt16(), 0)
            Call InitGrh(HeadData(I).Head(2), Reader.ReadInt16(), 0)
            Call InitGrh(HeadData(I).Head(3), Reader.ReadInt16(), 0)
            Call InitGrh(HeadData(I).Head(4), Reader.ReadInt16(), 0)
        Next I

        LoadHeads = True
    Else
        LoadHeads = False
    End If
    
End Function

Public Function LoadHelmets(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then
        ' TODO: Remove Header
        Call Reader.Skip(263)
        
        Dim Length As Long
        Length = Reader.ReadInt16()

        ReDim CascoAnimData(0 To Length) As HeadData

        Dim I As Long
        For I = 1 To Length
            Call InitGrh(CascoAnimData(I).Head(1), Reader.ReadInt16(), 0)
            Call InitGrh(CascoAnimData(I).Head(2), Reader.ReadInt16(), 0)
            Call InitGrh(CascoAnimData(I).Head(3), Reader.ReadInt16(), 0)
            Call InitGrh(CascoAnimData(I).Head(4), Reader.ReadInt16(), 0)
        Next I
    
        LoadHelmets = True
    Else
        LoadHelmets = False
    End If
    
End Function

Public Function LoadBodies(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then
        ' TODO: Remove Header
        Call Reader.Skip(263)
        
        Dim Length As Long
        Length = Reader.ReadInt16()
    
        ReDim BodyData(0 To Length) As BodyData

        Dim I As Long
        For I = 1 To Length
            Call InitGrh(BodyData(I).Walk(1), Reader.ReadInt16(), 0)
            Call InitGrh(BodyData(I).Walk(2), Reader.ReadInt16(), 0)
            Call InitGrh(BodyData(I).Walk(3), Reader.ReadInt16(), 0)
            Call InitGrh(BodyData(I).Walk(4), Reader.ReadInt16(), 0)
                
            BodyData(I).HeadOffset.X = Reader.ReadInt16()
            BodyData(I).HeadOffset.Y = Reader.ReadInt16()
        Next I
    
        LoadBodies = True
    Else
        LoadBodies = False
    End If
    
End Function

Public Function LoadFXs(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then
        ' TODO: Remove Header
        Call Reader.Skip(263)
        
        Dim Length As Long
        Length = Reader.ReadInt16()
    
        ReDim FxData(0 To Length) As EffectData
        
        Dim I As Long
        For I = 1 To Length
            FxData(I).Animacion = Reader.ReadInt16()
            FxData(I).OffsetX = Reader.ReadInt16()
            FxData(I).OffsetY = Reader.ReadInt16()
        Next I
    
        LoadFXs = True
    Else
        LoadFXs = False
    End If
    
End Function

Public Function LoadGraphics(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()

    If (Reader.GetAvailable() > 0) Then
        ' TODO: Remove Header
        Call Reader.Skip(4)
        
        Dim Length As Long
        Length = Reader.ReadInt32()
    
        ReDim GrhData(1 To Length) As GrhData
        
        While (Reader.GetAvailable() > 0)
            Dim index As Long
            index = Reader.ReadInt32()
            
            With GrhData(index)
                .NumFrames = Reader.ReadInt16()
                      
                ReDim .Frames(0 To .NumFrames)
            
                If (.NumFrames > 1) Then
                    Dim Frame As Long
                    For Frame = 1 To .NumFrames
                        .Frames(Frame) = Reader.ReadInt32()
                    Next Frame
                    
                    .Speed = Reader.ReadReal32()
                    .pixelHeight = GrhData(.Frames(1)).pixelHeight
                    .pixelWidth = GrhData(.Frames(1)).pixelWidth
                    .TileWidth = GrhData(.Frames(1)).TileWidth
                    .TileHeight = GrhData(.Frames(1)).TileHeight
                Else
                    .FileNum = Reader.ReadInt32()
                    .sX = Reader.ReadInt16()
                    .sY = Reader.ReadInt16()
                    .pixelWidth = Reader.ReadInt16()
                    .pixelHeight = Reader.ReadInt16()

                    .TileWidth = .pixelWidth / 32
                    .TileHeight = .pixelHeight / 32
                
                    .Frames(1) = index
                End If
            End With
        Wend

        LoadGraphics = True
    Else
        LoadGraphics = False
    End If
    
End Function

Public Function LoadMap(ByVal Filename As String) As Boolean
    
    Dim File As Memory_Chunk
    Set File = Aurora_Content.Find(Filename)
    
    Dim Reader As BinaryReader
    Set Reader = File.GetReader()
    
    If (Reader.GetAvailable() > 0) Then
        Call Reader.Skip(2)
        Call Reader.Skip(263)
        Call Reader.Skip(8)
        
        Dim X As Long
        Dim Y As Long
        
        
        Set Partitioner_ = New Partitioner
        
        For Y = YMinMapSize To YMaxMapSize
            For X = XMinMapSize To XMaxMapSize
                Dim ByFlags As Long
                ByFlags = Reader.ReadInt8()
                    
                With MapData(X, Y)
                    .Blocked = (ByFlags And 1)
                    
                    'Layer 1
                    .Graphic(1).GrhIndex = Reader.ReadInt16()
                    Call InitGrh(.Graphic(1), .Graphic(1).GrhIndex)

                    'Layer 2 used?
                    If ByFlags And 2 Then
                        .Graphic(2).GrhIndex = Reader.ReadInt16()
                        Call InitGrh(.Graphic(2), .Graphic(2).GrhIndex)
                                            
                        With GrhData(.Graphic(2).GrhIndex)
                            Call UpdateSceneEntity(MapData(X, Y).Nodes(2), -1, X, Y, 2, .TileWidth, .TileHeight)
                        End With
                        Call Partitioner_.Insert(.Nodes(2))
                        
                    Else
                        .Graphic(2).GrhIndex = 0
                    End If
                        
                    'Layer 3 used?
                    If ByFlags And 4 Then
                        .Graphic(3).GrhIndex = Reader.ReadInt16()
                        Call InitGrh(.Graphic(3), .Graphic(3).GrhIndex)
                                                 
                        With GrhData(.Graphic(3).GrhIndex)
                            Call UpdateSceneEntity(MapData(X, Y).Nodes(3), -1, X, Y, 3, .TileWidth, .TileHeight)
                        End With
                        Call Partitioner_.Insert(.Nodes(3))
                        
                    Else
                        .Graphic(3).GrhIndex = 0
                    End If
                        
                    'Layer 4 used?
                    If ByFlags And 8 Then
                        .Graphic(4).GrhIndex = Reader.ReadInt16()
                        Call InitGrh(.Graphic(4), .Graphic(4).GrhIndex)
                                                                         
                        With GrhData(.Graphic(4).GrhIndex)
                            Call UpdateSceneEntity(MapData(X, Y).Nodes(4), -1, X, Y, 4, .TileWidth, .TileHeight)
                        End With
                        Call Partitioner_.Insert(.Nodes(4))
                        
                    Else
                        .Graphic(4).GrhIndex = 0
                    End If
                    
                    'Trigger used?
                    If ByFlags And 16 Then
                        .Trigger = Reader.ReadInt16()
                    Else
                        .Trigger = 0
                    End If
                    
                    'Erase NPCs
                    If .CharIndex > 0 Then
                        Call EraseChar(.CharIndex)
                    End If
                    
                    'Erase OBJs
                    .ObjGrh.GrhIndex = 0
                End With
            Next X
        Next Y
 
        LoadMap = True
    Else
        LoadMap = False
        
    End If
    
End Function


Public Sub UpdateSceneEntity(ByRef Node As Partitioner_Item, ByVal Id As Long, ByVal X As Long, ByVal Y As Long, ByVal Subtype As Long, ByVal Width As Long, ByVal Height As Long)
    
    Node.Id = Id
    Node.Type = Subtype
    Node.X = X
    Node.Y = Y
    Node.RectX1 = (X - Width / 2#)
    Node.RectY1 = (Y - Height)
    Node.RectX2 = Node.RectX1 + Width
    Node.RectY2 = Node.RectY1 + Height

End Sub

Public Sub UpdateSceneCharacter(ByVal CharIndex As Long)
    Dim Width As Single, Height As Single
    Call GetCharacterDimension(CharIndex, Width, Height)

    With charlist(CharIndex)
        .Node.Id = CharIndex
        .Node.Type = 6
        .Node.X = .Pos.X
        .Node.Y = .Pos.Y
        .Node.RectX1 = (.Pos.X - Width / 2#)
        .Node.RectY1 = (.Pos.Y + IIf(.Nombre <> vbNullString, 1, 0) - Height)
        .Node.RectX2 = .Node.RectX1 + Width
        .Node.RectY2 = .Node.RectY1 + Height
    End With
End Sub

Private Function GetCharacterDimension(ByVal CharIndex As Integer, ByRef RangeX As Single, ByRef RangeY As Single)
    Dim I As Long
    
    Dim BestX As Long
    Dim BestY As Long
            
    With charlist(CharIndex)
    
        ' Try to calculate the best width and height using all four direction of the entity's body
        If (.iBody <> 0) Then
            For I = 1 To 4
                If (GrhData(.Body.Walk(I).GrhIndex).TileWidth > RangeX) Then
                    RangeX = GrhData(.Body.Walk(I).GrhIndex).TileWidth
                End If
                If (GrhData(.Body.Walk(I).GrhIndex).TileHeight > RangeY) Then
                    RangeY = GrhData(.Body.Walk(I).GrhIndex).TileHeight
                End If
            Next I
        End If
                
        ' Try to calculate the best width and height using all four direction of the entity's body
        If (.iHead <> 0) Then

            For I = 1 To 4
                If (GrhData(.Head.Head(I).GrhIndex).TileWidth > RangeX) Then
                    RangeX = GrhData(.Head.Head(I).GrhIndex).TileWidth
                End If
                If (GrhData(.Head.Head(I).GrhIndex).TileHeight > BestY) Then
                    BestY = GrhData(.Head.Head(I).GrhIndex).TileHeight
                End If
            Next I

            RangeY = RangeY + BestY
        End If
            
        If (.Nombre <> vbNullString) Then
            RangeY = RangeY + 2
            
            BestX = Len(.Nombre) * 16 / 32
            If (BestX > RangeX) Then RangeX = BestX
        End If
        
            
        ' FX Too!
        BestX = 0
        BestY = 0
        
            If (.fX.GrhIndex <> 0) Then
                If (GrhData(.fX.GrhIndex).TileWidth > BestX) Then
                    BestX = GrhData(.fX.GrhIndex).TileWidth
                End If
                If (GrhData(.fX.GrhIndex).TileHeight > BestY) Then
                    BestY = GrhData(.fX.GrhIndex).TileHeight
                End If
            End If
            
        If (RangeX < BestX) Then RangeX = BestX
        If (RangeY < BestY) Then RangeY = BestY

    End With

End Function
