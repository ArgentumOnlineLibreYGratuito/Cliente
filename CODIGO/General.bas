Attribute VB_Name = "Mod_General"
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

Public bLluvia() As Byte 'TODO Is this comment still valid? =>  Array para determinar si
'TODO Is this comment still valid? => debemos mostrar la animacion de la lluvia

Private Type tFont
    red As Byte
    green As Byte
    blue As Byte
    bold As Boolean
    italic As Boolean
End Type

Public Enum FontTypeNames
    FONTTYPE_TALK
    FONTTYPE_FIGHT
    FONTTYPE_WARNING
    FONTTYPE_INFO
    FONTTYPE_INFOBOLD
    FONTTYPE_EJECUCION
    FONTTYPE_PARTY
    FONTTYPE_VENENO
    FONTTYPE_GUILD
    FONTTYPE_SERVER
    FONTTYPE_GUILDMSG
    FONTTYPE_CONSEJO
    FONTTYPE_CONSEJOCAOS
    FONTTYPE_CONSEJOVesA
    FONTTYPE_CONSEJOCAOSVesA
    FONTTYPE_GMMSG
    FONTTYPE_GM
    FONTTYPE_CITIZEN
End Enum

Public FontTypes(18) As tFont

''
' Initializes the fonts array

Public Sub InitFonts()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 05/17/06
'
'***************************************************
    With FontTypes(FontTypeNames.FONTTYPE_TALK)
        .red = 255
        .green = 255
        .blue = 255
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_FIGHT)
        .red = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_WARNING)
        .red = 32
        .green = 51
        .blue = 223
        .bold = 1
        .italic = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_INFO)
        .red = 65
        .green = 190
        .blue = 156
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_INFOBOLD)
        .red = 65
        .green = 190
        .blue = 156
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_EJECUCION)
        .red = 130
        .green = 130
        .blue = 130
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_PARTY)
        .red = 255
        .green = 180
        .blue = 250
    End With
    
    FontTypes(FontTypeNames.FONTTYPE_VENENO).green = 255
    
    With FontTypes(FontTypeNames.FONTTYPE_GUILD)
        .red = 255
        .green = 255
        .blue = 255
        .bold = 1
    End With
    
    FontTypes(FontTypeNames.FONTTYPE_SERVER).green = 185
    
    With FontTypes(FontTypeNames.FONTTYPE_GUILDMSG)
        .red = 228
        .green = 199
        .blue = 27
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJO)
        .red = 130
        .green = 130
        .blue = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJOCAOS)
        .red = 255
        .green = 60
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJOVesA)
        .green = 200
        .blue = 255
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CONSEJOCAOSVesA)
        .red = 255
        .green = 50
        .bold = 1
    End With

    
    With FontTypes(FontTypeNames.FONTTYPE_GMMSG)
        .red = 255
        .green = 255
        .blue = 255
        .italic = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_GM)
        .green = 185
        .bold = 1
    End With
    
    With FontTypes(FontTypeNames.FONTTYPE_CITIZEN)
        .blue = 200
        .bold = 1
    End With
End Sub


Public Function DirGraficos() As String
    DirGraficos = App.path & "\GRAFICOS\"
End Function

Public Function DirMapas() As String
    DirMapas = App.path & "\MAPAS\"
End Function

Public Function RandomNumber(ByVal LowerBound As Long, ByVal UpperBound As Long) As Long
    'Initialize randomizer
    Randomize Timer
    
    'Generate random number
    RandomNumber = (UpperBound - LowerBound) * Rnd + LowerBound
End Function

Sub CargarAnimArmas()
On Error Resume Next

    Dim loopc As Long
    Dim arch As String
    
    arch = App.path & "\init\" & "armas.dat"
    
    NumWeaponAnims = Val(GetVar(arch, "INIT", "NumArmas"))
    
    ReDim WeaponAnimData(1 To NumWeaponAnims) As WeaponAnimData
    
    For loopc = 1 To NumWeaponAnims
        InitGrh WeaponAnimData(loopc).WeaponWalk(1), Val(GetVar(arch, "ARMA" & loopc, "Dir1")), 0
        InitGrh WeaponAnimData(loopc).WeaponWalk(2), Val(GetVar(arch, "ARMA" & loopc, "Dir2")), 0
        InitGrh WeaponAnimData(loopc).WeaponWalk(3), Val(GetVar(arch, "ARMA" & loopc, "Dir3")), 0
        InitGrh WeaponAnimData(loopc).WeaponWalk(4), Val(GetVar(arch, "ARMA" & loopc, "Dir4")), 0
    Next loopc
End Sub

Sub CargarColores()
On Error Resume Next
    Dim archivoC As String
    
    archivoC = App.path & "\init\colores.dat"
    
    If Not FileExist(archivoC, vbArchive) Then
'TODO : Si hay que reinstalar, porque no cierra???
        Call MsgBox("ERROR: no se ha podido cargar los colores. Falta el archivo colores.dat, reinstale el juego", vbCritical + vbOKOnly)
        Exit Sub
    End If
    
    Dim i As Long
    
    For i = 0 To 48 '49 y 50 reservados para ciudadano y criminal
        ColoresPJ(i).r = CByte(GetVar(archivoC, CStr(i), "R"))
        ColoresPJ(i).g = CByte(GetVar(archivoC, CStr(i), "G"))
        ColoresPJ(i).b = CByte(GetVar(archivoC, CStr(i), "B"))
    Next i
    
    ColoresPJ(50).r = CByte(GetVar(archivoC, "CR", "R"))
    ColoresPJ(50).g = CByte(GetVar(archivoC, "CR", "G"))
    ColoresPJ(50).b = CByte(GetVar(archivoC, "CR", "B"))
    ColoresPJ(49).r = CByte(GetVar(archivoC, "CI", "R"))
    ColoresPJ(49).g = CByte(GetVar(archivoC, "CI", "G"))
    ColoresPJ(49).b = CByte(GetVar(archivoC, "CI", "B"))
End Sub

Sub CargarAnimEscudos()
On Error Resume Next

    Dim loopc As Long
    Dim arch As String
    
    arch = App.path & "\init\" & "escudos.dat"
    
    NumEscudosAnims = Val(GetVar(arch, "INIT", "NumEscudos"))
    
    ReDim ShieldAnimData(1 To NumEscudosAnims) As ShieldAnimData
    
    For loopc = 1 To NumEscudosAnims
        InitGrh ShieldAnimData(loopc).ShieldWalk(1), Val(GetVar(arch, "ESC" & loopc, "Dir1")), 0
        InitGrh ShieldAnimData(loopc).ShieldWalk(2), Val(GetVar(arch, "ESC" & loopc, "Dir2")), 0
        InitGrh ShieldAnimData(loopc).ShieldWalk(3), Val(GetVar(arch, "ESC" & loopc, "Dir3")), 0
        InitGrh ShieldAnimData(loopc).ShieldWalk(4), Val(GetVar(arch, "ESC" & loopc, "Dir4")), 0
    Next loopc
End Sub

Sub AddtoRichTextBox(ByRef RichTextBox As RichTextBox, ByVal Text As String, Optional ByVal red As Integer = -1, Optional ByVal green As Integer, Optional ByVal blue As Integer, Optional ByVal bold As Boolean = False, Optional ByVal italic As Boolean = False, Optional ByVal bCrLf As Boolean = False)
'******************************************
'Adds text to a Richtext box at the bottom.
'Automatically scrolls to new text.
'Text box MUST be multiline and have a 3D
'apperance!
'Pablo (ToxicWaste) 01/26/2007 : Now the list refeshes properly.
'Juan Martín Sotuyo Dodero (Maraxus) 03/29/2007 : Replaced ToxicWaste's code for extra performance.
'******************************************r
    With RichTextBox
        If Len(.Text) > 1000 Then
            'Get rid of first line
            .SelStart = InStr(1, .Text, vbCrLf) + 1
            .SelLength = Len(.Text) - .SelStart + 2
            .TextRTF = .SelRTF
        End If
        
        .SelStart = Len(RichTextBox.Text)
        .SelLength = 0
        .SelBold = bold
        .SelItalic = italic
        
        If Not red = -1 Then .SelColor = RGB(red, green, blue)
        
        .SelText = IIf(bCrLf, Text, Text & vbCrLf)
        
        RichTextBox.Refresh
    End With
End Sub

'TODO : Never was sure this is really necessary....
'TODO : 08/03/2006 - (AlejoLp) Esto hay que volarlo...
Public Sub RefreshAllChars()
'*****************************************************************
'Goes through the charlist and replots all the characters on the map
'Used to make sure everyone is visible
'*****************************************************************
    Dim loopc As Long
    
    For loopc = 1 To LastChar
        If charlist(loopc).active = 1 Then
            MapData(charlist(loopc).Pos.x, charlist(loopc).Pos.y).CharIndex = loopc
        End If
    Next loopc
End Sub

Function AsciiValidos(ByVal cad As String) As Boolean
    Dim car As Byte
    Dim i As Long
    
    cad = LCase$(cad)
    
    For i = 1 To Len(cad)
        car = Asc(mid$(cad, i, 1))
        
        If ((car < 97 Or car > 122) Or car = Asc("º")) And (car <> 255) And (car <> 32) Then
            Exit Function
        End If
    Next i
    
    AsciiValidos = True
End Function

Function CheckUserData(ByVal checkemail As Boolean) As Boolean
    'Validamos los datos del user
    Dim loopc As Long
    Dim CharAscii As Integer
    
    If checkemail And UserEmail = "" Then
        MsgBox ("Dirección de email invalida")
        Exit Function
    End If
    
    If UserPassword = "" Then
        MsgBox ("Ingrese un password.")
        Exit Function
    End If
    
    For loopc = 1 To Len(UserPassword)
        CharAscii = Asc(mid$(UserPassword, loopc, 1))
        If Not LegalCharacter(CharAscii) Then
            MsgBox ("Password inválido. El caractér " & Chr$(CharAscii) & " no está permitido.")
            Exit Function
        End If
    Next loopc
    
    If UserName = "" Then
        MsgBox ("Ingrese un nombre de personaje.")
        Exit Function
    End If
    
    If Len(UserName) > 30 Then
        MsgBox ("El nombre debe tener menos de 30 letras.")
        Exit Function
    End If
    
    For loopc = 1 To Len(UserName)
        CharAscii = Asc(mid$(UserName, loopc, 1))
        If Not LegalCharacter(CharAscii) Then
            MsgBox ("Nombre inválido. El caractér " & Chr$(CharAscii) & " no está permitido.")
            Exit Function
        End If
    Next loopc
    
    CheckUserData = True
End Function

Sub UnloadAllForms()
On Error Resume Next

    Dim mifrm As Form
    
    For Each mifrm In Forms
        Unload mifrm
    Next
End Sub

Function LegalCharacter(ByVal KeyAscii As Integer) As Boolean
'*****************************************************************
'Only allow characters that are Win 95 filename compatible
'*****************************************************************
    'if backspace allow
    If KeyAscii = 8 Then
        LegalCharacter = True
        Exit Function
    End If
    
    'Only allow space, numbers, letters and special characters
    If KeyAscii < 32 Or KeyAscii = 44 Then
        Exit Function
    End If
    
    If KeyAscii > 126 Then
        Exit Function
    End If
    
    'Check for bad special characters in between
    If KeyAscii = 34 Or KeyAscii = 42 Or KeyAscii = 47 Or KeyAscii = 58 Or KeyAscii = 60 Or KeyAscii = 62 Or KeyAscii = 63 Or KeyAscii = 92 Or KeyAscii = 124 Then
        Exit Function
    End If
    
    'else everything is cool
    LegalCharacter = True
End Function

Sub SetConnected()
'*****************************************************************
'Sets the client to "Connect" mode
'*****************************************************************
    'Set Connected
    Connected = True

    'Unload the connect form
    Unload frmConnect
    Unload frmPasswd
    Unload frmCrearPersonaje
    
    frmMain.Label8.Caption = UserName
    'Load main form
    frmMain.Visible = True

End Sub

Sub MoveTo(ByVal Direccion As E_Heading)
'***************************************************
'Author: Alejandro Santos (AlejoLp)
'Last Modify Date: 06/28/2008
'Last Modified By: Lucas Tavolaro Ortiz (Tavo)
' 06/03/2006: AlejoLp - Elimine las funciones Move[NSWE] y las converti a esta
' 12/08/2007: Tavo    - Si el usuario esta paralizado no se puede mover.
' 06/28/2008: NicoNZ - Saqué lo que impedía que si el usuario estaba paralizado se ejecute el sub.
'***************************************************
    Dim LegalOk As Boolean

    Select Case Direccion
        Case E_Heading.NORTH
            LegalOk = LegalPos(UserPos.x, UserPos.y - 1)
        Case E_Heading.EAST
            LegalOk = LegalPos(UserPos.x + 1, UserPos.y)
        Case E_Heading.SOUTH
            LegalOk = LegalPos(UserPos.x, UserPos.y + 1)
        Case E_Heading.WEST
            LegalOk = LegalPos(UserPos.x - 1, UserPos.y)
    End Select
    
    If LegalOk And Not UserParalizado Then
        If Not UserDescansar And Not UserMeditar Then
            Call WriteWalk(Direccion) 'We only walk if we are not meditating or resting
            engine.Char_Move_by_Head UserCharIndex, Direccion
            MoveScreen Direccion
        Else
            If Not UserAvisado Then
                If UserDescansar Then
                    WriteRest 'Stop resting (we do NOT have the 1 step enforcing anymore) sono como un tema de los guns.
                ElseIf UserMeditar Then
                    WriteMeditate 'Stop meditation
                End If
                UserAvisado = True
            End If
        End If
    Else
        If charlist(UserCharIndex).Heading <> Direccion Then
            Call WriteChangeHeading(Direccion)
        End If
    End If
    
    If frmMain.macrotrabajo.Enabled Then frmMain.DesactivarMacroTrabajo

End Sub

Sub RandomMove()
'***************************************************
'Author: Alejandro Santos (AlejoLp)
'Last Modify Date: 06/03/2006
' 06/03/2006: AlejoLp - Ahora utiliza la funcion MoveTo
'***************************************************
    Call MoveTo(RandomNumber(NORTH, WEST))
End Sub

Sub CheckKeys()
'*****************************************************************
'Checks keys and respond
'*****************************************************************
On Error Resume Next
    
    'TODO Is this comment still valid? => No input allowed while Argentum is not the active window
    If Not Application.IsAppActive() Then Exit Sub
    
    'No walking when in commerce or banking.
    If Comerciando Then Exit Sub

    'If game is paused, abort movement.
    If pausa Then Exit Sub
    
    'Don't allow any these keys during movement..
    If UserMoving = 0 Then
        If Not UserEstupido Then
            'Move Up
            If GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyUp)) < 0 Then
                If frmMain.TrainingMacro.Enabled Then frmMain.DesactivarMacroHechizos
                Call MoveTo(NORTH)
                frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
                Exit Sub
            End If
            
            'Move Right
            If GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyRight)) < 0 Then
                If frmMain.TrainingMacro.Enabled Then frmMain.DesactivarMacroHechizos
                Call MoveTo(EAST)
                frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
                Exit Sub
            End If
        
            'Move down
            If GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyDown)) < 0 Then
                If frmMain.TrainingMacro.Enabled Then frmMain.DesactivarMacroHechizos
                Call MoveTo(SOUTH)
                frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
                Exit Sub
            End If
        
            'Move left
            If GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyLeft)) < 0 Then
                If frmMain.TrainingMacro.Enabled Then frmMain.DesactivarMacroHechizos
                Call MoveTo(WEST)
                frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
                Exit Sub
            End If
            
        Else
            Dim kp As Boolean
            kp = (GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyUp)) < 0) Or _
                GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyRight)) < 0 Or _
                GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyDown)) < 0 Or _
                GetKeyState(CustomKeys.BindedKey(eKeyType.mKeyLeft)) < 0
            
            If kp Then
                Call RandomMove
            End If
            
            If frmMain.TrainingMacro.Enabled Then frmMain.DesactivarMacroHechizos
            frmMain.Coord.Caption = "(" & UserPos.x & "," & UserPos.y & ")"
        End If
    End If
End Sub

'TODO : Si bien nunca estuvo allí, el mapa es algo independiente o a lo sumo dependiente del engine, no va acá!!!

Function ReadField(ByVal Pos As Integer, ByRef Text As String, ByVal SepASCII As Byte) As String
'*****************************************************************
'Gets a field from a delimited string
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 11/15/2004
'*****************************************************************
    Dim i As Long
    Dim lastPos As Long
    Dim CurrentPos As Long
    Dim delimiter As String * 1
    
    delimiter = Chr$(SepASCII)
    
    For i = 1 To Pos
        lastPos = CurrentPos
        CurrentPos = InStr(lastPos + 1, Text, delimiter, vbBinaryCompare)
    Next i
    
    If CurrentPos = 0 Then
        ReadField = mid$(Text, lastPos + 1, Len(Text) - lastPos)
    Else
        ReadField = mid$(Text, lastPos + 1, CurrentPos - lastPos - 1)
    End If
End Function

Function FieldCount(ByRef Text As String, ByVal SepASCII As Byte) As Long
'*****************************************************************
'Gets the number of fields in a delimited string
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 07/29/2007
'*****************************************************************
    Dim Count As Long
    Dim curPos As Long
    Dim delimiter As String * 1
    
    If LenB(Text) = 0 Then Exit Function
    
    delimiter = Chr$(SepASCII)
    
    curPos = 0
    
    Do
        curPos = InStr(curPos + 1, Text, delimiter)
        Count = Count + 1
    Loop While curPos <> 0
    
    FieldCount = Count
End Function

Function FileExist(ByVal file As String, ByVal FileType As VbFileAttribute) As Boolean
    FileExist = (Dir$(file, FileType) <> "")
End Function

Sub Main()
    ' Initialize Aurora Engine
    Call modEngine.Initialize

    ' Load Game's properties
    Call modEngine_Properties.LoadProperties

    If (Not Application.IsAppDebug()) Then
        If (Application.IsAppRunning()) Then
            Call MsgBox("Argentum Online ya esta corriendo! No es posible correr otra instancia del juego. Haga click en Aceptar para salir.", vbApplicationModal + vbInformation + vbOKOnly, "Error al ejecutar")
            End
        End If
    End If

    'Set resolution BEFORE the loading form is displayed, therefore it will be centered.
    Call Resolution.SetResolution
    
    frmCargando.Show
    frmCargando.Refresh
    
    frmConnect.version = "v" & App.Major & "." & App.Minor & " Build: " & App.Revision

    AddtoRichTextBox frmCargando.status, "Iniciando constantes... ", 0, 0, 0, 0, 0, 1
    
    Call InicializarNombres

    ' Initialize FONTTYPES
    Call InitFonts
    
    frmOldPersonaje.NameTxt.Text = ""
    frmOldPersonaje.PasswordTxt.Text = ""
    
    AddtoRichTextBox frmCargando.status, "Hecho", , , , 1
    
    AddtoRichTextBox frmCargando.status, "Iniciando motor gráfico... ", 0, 0, 0, 0, 0, 1
    LoadGrhData
    CargarCabezas
    CargarCascos
    CargarCuerpos
    CargarArrayLluvia
    CargarFxs
    'If Not InitTileEngine(frmMain.hWnd, 160, 7, 32, 32, 13, 17, 9, 8, 8, 0.018) Then
    '    Call CloseClient
    'End If
    Call engine.Engine_Init
    Call engine.setup_ambient
    AddtoRichTextBox frmCargando.status, "Hecho", , , , 1
    
    Call AddtoRichTextBox(frmCargando.status, "Creando animaciones extra... ", , , , , , 1)

UserMap = 1
    
    Call CargarArrayLluvia
    Call CargarAnimArmas
    Call CargarAnimEscudos
    Call CargarColores
    
    AddtoRichTextBox frmCargando.status, "Hecho", , , , 1
    
    AddtoRichTextBox frmCargando.status, "Iniciando DirectSound... ", 0, 0, 0, 0, 0, True
    
    'Inicializamos el sonido
    'Call Audio.Initialize(frmMain.hWnd, App.path & "\WAV\", App.path & "\MIDI\")
    
    'Enable / Disable audio
    modEngine_Audio.MusicEnabled = Configuration.Audio_MusicEnabled
    modEngine_Audio.MusicVolume = Configuration.Audio_MusicVolume
    modEngine_Audio.EffectEnabled = Configuration.Audio_EffectEnabled
    modEngine_Audio.EffectVolume = Configuration.Audio_EffectVolume
    modEngine_Audio.InterfaceEnabled = Configuration.Audio_InterfaceEnabled
    modEngine_Audio.InterfaceVolume = Configuration.Audio_InterfaceVolume
    
    'Inicializamos el inventario gráfico
    Call Inventario.Initialize(frmMain.picInv)
    
    Call modEngine_Audio.PlayMusic(MIdi_Inicio & ".mp3")
    
    AddtoRichTextBox frmCargando.status, "Hecho", , , , 1, , False
    AddtoRichTextBox frmCargando.status, "                    ¡Bienvenido a Argentum Online!", , , , 1

    Unload frmCargando

    frmConnect.Visible = True
    
    'Inicialización de variables globales
    prgRun = True
    pausa = False
    
    'Set the intervals of timers
    Call MainTimer.SetInterval(TimersIndex.Attack, INT_ATTACK)
    Call MainTimer.SetInterval(TimersIndex.Work, INT_WORK)
    Call MainTimer.SetInterval(TimersIndex.UseItemWithU, INT_USEITEMU)
    Call MainTimer.SetInterval(TimersIndex.UseItemWithDblClick, INT_USEITEMDCK)
    Call MainTimer.SetInterval(TimersIndex.SendRPU, INT_SENTRPU)
    Call MainTimer.SetInterval(TimersIndex.CastSpell, INT_CAST_SPELL)
    Call MainTimer.SetInterval(TimersIndex.Arrows, INT_ARROWS)
    Call MainTimer.SetInterval(TimersIndex.CastAttack, INT_CAST_ATTACK)
    
    frmMain.macrotrabajo.Interval = INT_MACRO_TRABAJO
    frmMain.macrotrabajo.Enabled = False
    
   'Init timers
    Call MainTimer.Start(TimersIndex.Attack)
    Call MainTimer.Start(TimersIndex.Work)
    Call MainTimer.Start(TimersIndex.UseItemWithU)
    Call MainTimer.Start(TimersIndex.UseItemWithDblClick)
    Call MainTimer.Start(TimersIndex.SendRPU)
    Call MainTimer.Start(TimersIndex.CastSpell)
    Call MainTimer.Start(TimersIndex.Arrows)
    Call MainTimer.Start(TimersIndex.CastAttack)
    
    'Set the dialog's font
    Dialogos.font = frmMain.font
    DialogosClanes.font = frmMain.font

    engine.Start
End Sub

Function GetVar(ByVal file As String, ByVal Main As String, ByVal var As String) As String
'*****************************************************************
'Gets a Var from a text file
'*****************************************************************
    Dim sSpaces As String ' This will hold the input that the program will retrieve
    
    sSpaces = Space$(100) ' This tells the computer how long the longest string can be. If you want, you can change the number 100 to any number you wish
    
    getprivateprofilestring Main, var, vbNullString, sSpaces, Len(sSpaces), file
    
    GetVar = RTrim$(sSpaces)
    GetVar = Left$(GetVar, Len(GetVar) - 1)
End Function

'[CODE 002]:MatuX
'
'  Función para chequear el email
'
'  Corregida por Maraxus para que reconozca como válidas casillas con puntos antes de la arroba y evitar un chequeo innecesario
Public Function CheckMailString(ByVal sString As String) As Boolean
On Error GoTo errHnd
    Dim lPos  As Long
    Dim lX    As Long
    Dim iAsc  As Integer
    
    '1er test: Busca un simbolo @
    lPos = InStr(sString, "@")
    If (lPos <> 0) Then
        '2do test: Busca un simbolo . después de @ + 1
        If Not (InStr(lPos, sString, ".", vbBinaryCompare) > lPos + 1) Then _
            Exit Function
        
        '3er test: Recorre todos los caracteres y los valída
        For lX = 0 To Len(sString) - 1
            If Not (lX = (lPos - 1)) Then   'No chequeamos la '@'
                iAsc = Asc(mid$(sString, (lX + 1), 1))
                If Not CMSValidateChar_(iAsc) Then _
                    Exit Function
            End If
        Next lX
        
        'Finale
        CheckMailString = True
    End If
errHnd:
End Function

'  Corregida por Maraxus para que reconozca como válidas casillas con puntos antes de la arroba
Private Function CMSValidateChar_(ByVal iAsc As Integer) As Boolean
    CMSValidateChar_ = (iAsc >= 48 And iAsc <= 57) Or _
                        (iAsc >= 65 And iAsc <= 90) Or _
                        (iAsc >= 97 And iAsc <= 122) Or _
                        (iAsc = 95) Or (iAsc = 45) Or (iAsc = 46)
End Function

'TODO : como todo lo relativo a mapas, no tiene nada que hacer acá....
Function HayAgua(ByVal x As Integer, ByVal y As Integer) As Boolean
    HayAgua = ((MapData(x, y).Graphic(1).grhindex >= 1505 And MapData(x, y).Graphic(1).grhindex <= 1520) Or _
            (MapData(x, y).Graphic(1).grhindex >= 5665 And MapData(x, y).Graphic(1).grhindex <= 5680) Or _
            (MapData(x, y).Graphic(1).grhindex >= 13547 And MapData(x, y).Graphic(1).grhindex <= 13562)) And _
                MapData(x, y).Graphic(2).grhindex = 0
                
End Function

Private Sub InicializarNombres()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 11/27/2005
'Inicializa los nombres de razas, ciudades, clases, skills, atributos, etc.
'**************************************************************
    Ciudades(eCiudad.cUllathorpe) = "Ullathorpe"
    Ciudades(eCiudad.cNix) = "Nix"
    Ciudades(eCiudad.cBanderbill) = "Banderbill"
    Ciudades(eCiudad.cLindos) = "Lindos"
    Ciudades(eCiudad.cArghal) = "Arghâl"
    
    ListaRazas(eRaza.Humano) = "Humano"
    ListaRazas(eRaza.Elfo) = "Elfo"
    ListaRazas(eRaza.ElfoOscuro) = "Elfo Oscuro"
    ListaRazas(eRaza.Gnomo) = "Gnomo"
    ListaRazas(eRaza.Enano) = "Enano"

    ListaClases(eClass.Mage) = "Mago"
    ListaClases(eClass.Cleric) = "Clerigo"
    ListaClases(eClass.Warrior) = "Guerrero"
    ListaClases(eClass.Assasin) = "Asesino"
    ListaClases(eClass.Thief) = "Ladron"
    ListaClases(eClass.Bard) = "Bardo"
    ListaClases(eClass.Druid) = "Druida"
    ListaClases(eClass.Bandit) = "Bandido"
    ListaClases(eClass.Paladin) = "Paladin"
    ListaClases(eClass.Hunter) = "Cazador"
    ListaClases(eClass.Fisher) = "Pescador"
    ListaClases(eClass.Blacksmith) = "Herrero"
    ListaClases(eClass.Lumberjack) = "Leñador"
    ListaClases(eClass.Miner) = "Minero"
    ListaClases(eClass.Carpenter) = "Carpintero"
    ListaClases(eClass.Pirat) = "Pirata"
    
    SkillsNames(eSkill.Suerte) = "Suerte"
    SkillsNames(eSkill.Magia) = "Magia"
    SkillsNames(eSkill.Robar) = "Robar"
    SkillsNames(eSkill.Tacticas) = "Tacticas de combate"
    SkillsNames(eSkill.Armas) = "Combate con armas"
    SkillsNames(eSkill.Meditar) = "Meditar"
    SkillsNames(eSkill.Apuñalar) = "Apuñalar"
    SkillsNames(eSkill.Ocultarse) = "Ocultarse"
    SkillsNames(eSkill.Supervivencia) = "Supervivencia"
    SkillsNames(eSkill.Talar) = "Talar árboles"
    SkillsNames(eSkill.Comerciar) = "Comercio"
    SkillsNames(eSkill.Defensa) = "Defensa con escudos"
    SkillsNames(eSkill.Pesca) = "Pesca"
    SkillsNames(eSkill.Mineria) = "Mineria"
    SkillsNames(eSkill.Carpinteria) = "Carpinteria"
    SkillsNames(eSkill.Herreria) = "Herreria"
    SkillsNames(eSkill.Liderazgo) = "Liderazgo"
    SkillsNames(eSkill.Domar) = "Domar animales"
    SkillsNames(eSkill.Proyectiles) = "Armas de proyectiles"
    SkillsNames(eSkill.Wrestling) = "Wrestling"
    SkillsNames(eSkill.Navegacion) = "Navegacion"

    AtributosNames(eAtributos.Fuerza) = "Fuerza"
    AtributosNames(eAtributos.Agilidad) = "Agilidad"
    AtributosNames(eAtributos.Inteligencia) = "Inteligencia"
    AtributosNames(eAtributos.Carisma) = "Carisma"
    AtributosNames(eAtributos.Constitucion) = "Constitucion"
End Sub

''
' Removes all text from the console and dialogs

Public Sub CleanDialogs()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 11/27/2005
'Removes all text from the console and dialogs
'**************************************************************
    'Clean console and dialogs
    frmMain.RecTxt.Text = vbNullString
    
    Call DialogosClanes.RemoveDialogs
    
    Call Dialogos.RemoveAllDialogs
End Sub

Public Sub CloseClient()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 8/14/2007
'Frees all used resources, cleans up and leaves
'**************************************************************

    frmCargando.Show
    AddtoRichTextBox frmCargando.status, "Liberando recursos...", 0, 0, 0, 0, 0, 1
    
    Call Resolution.ResetResolution
    
    'Stop tile engine
    
    
    'Destruimos los objetos públicos creados

    Set CustomKeys = Nothing
    Set SurfaceDB = Nothing
    Set Dialogos = Nothing
    Set DialogosClanes = Nothing
    Set Inventario = Nothing
    Set MainTimer = Nothing

    Call UnloadAllForms
    
    End
End Sub

Sub SwitchMap(ByVal map As Integer)
'**************************************************************
'Formato de mapas optimizado para reducir el espacio que ocupan.
'Diseñado y creado por Juan Martín Sotuyo Dodero (Maraxus) (juansotuyo@hotmail.com)
'**************************************************************
    Dim y As Long
    Dim x As Long
    Dim ByFlags As Byte
    Dim Handle As Integer
    Dim MICabecera As tCabecera
    Dim tempInt As Integer
    
    Handle = FreeFile()
    
    Open DirMapas & "Mapa" & map & ".map" For Binary As Handle
    Seek Handle, 1
            
    'map Header
    Get Handle, , MapInfo.MapVersion
    Get Handle, , MiCabecera
    Get Handle, , tempint
    Get Handle, , tempint
    Get Handle, , tempint
    Get Handle, , tempint
    
    'Load arrays
    For y = YMinMapSize To YMaxMapSize
        For x = XMinMapSize To XMaxMapSize
            Get Handle, , ByFlags
            MapData(x, y).luz = 0
            MapData(x, y).particle_group = 0
            MapData(x, y).Blocked = (ByFlags And 1)
            
            Get Handle, , MapData(x, y).Graphic(1).grhindex
            InitGrh MapData(x, y).Graphic(1), MapData(x, y).Graphic(1).grhindex
            
            'Layer 2 used?
            If ByFlags And 2 Then
                Get Handle, , MapData(x, y).Graphic(2).grhindex
                InitGrh MapData(x, y).Graphic(2), MapData(x, y).Graphic(2).grhindex
            Else
                MapData(x, y).Graphic(2).grhindex = 0
            End If
                
            'Layer 3 used?
            If ByFlags And 4 Then
                Get Handle, , MapData(x, y).Graphic(3).grhindex
                InitGrh MapData(x, y).Graphic(3), MapData(x, y).Graphic(3).grhindex
            Else
                MapData(x, y).Graphic(3).grhindex = 0
            End If
                
            'Layer 4 used?
            If ByFlags And 8 Then
                Get Handle, , MapData(x, y).Graphic(4).grhindex
                InitGrh MapData(x, y).Graphic(4), MapData(x, y).Graphic(4).grhindex
            Else
                MapData(x, y).Graphic(4).grhindex = 0
            End If
            
            'Trigger used?
            If ByFlags And 16 Then
                Get Handle, , MapData(x, y).Trigger
            Else
                MapData(x, y).Trigger = 0
            End If
            
            'Erase NPCs
            If MapData(x, y).CharIndex > 0 Then
                Call EraseChar(MapData(x, y).CharIndex)
            End If
            
            'Erase OBJs
            MapData(x, y).ObjGrh.grhindex = 0
        Next x
    Next y
    
    Close Handle
    
    MapInfo.Name = ""
    MapInfo.Music = ""
    
End Sub


