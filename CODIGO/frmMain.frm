VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.ocx"
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Argentum Online"
   ClientHeight    =   8625
   ClientLeft      =   4905
   ClientTop       =   2505
   ClientWidth     =   11910
   ClipControls    =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   Icon            =   "frmMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   575
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   794
   Visible         =   0   'False
   Begin VB.TextBox SendTxt 
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   315
      Left            =   45
      MaxLength       =   160
      MultiLine       =   -1  'True
      TabIndex        =   19
      TabStop         =   0   'False
      ToolTipText     =   "Chat"
      Top             =   1575
      Visible         =   0   'False
      Width           =   8160
   End
   Begin VB.Timer macrotrabajo 
      Enabled         =   0   'False
      Left            =   7080
      Top             =   2520
   End
   Begin VB.PictureBox Picture1 
      Height          =   135
      Left            =   11760
      ScaleHeight     =   75
      ScaleWidth      =   75
      TabIndex        =   18
      Top             =   8520
      Visible         =   0   'False
      Width           =   135
   End
   Begin VB.Timer TrainingMacro 
      Enabled         =   0   'False
      Interval        =   3121
      Left            =   6600
      Top             =   2520
   End
   Begin VB.TextBox SendCMSTXT 
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   315
      Left            =   45
      MaxLength       =   160
      MultiLine       =   -1  'True
      TabIndex        =   15
      TabStop         =   0   'False
      ToolTipText     =   "Chat"
      Top             =   8280
      Visible         =   0   'False
      Width           =   8160
   End
   Begin VB.Timer Macro 
      Interval        =   750
      Left            =   5760
      Top             =   2520
   End
   Begin VB.PictureBox PanelDer 
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   8145
      Left            =   8235
      ScaleHeight     =   543
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   239
      TabIndex        =   1
      Top             =   -60
      Width           =   3585
      Begin VB.CommandButton DespInv 
         Caption         =   "+"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   240
         Index           =   1
         Left            =   540
         MouseIcon       =   "frmMain.frx":030A
         MousePointer    =   99  'Custom
         TabIndex        =   9
         Top             =   4800
         Visible         =   0   'False
         Width           =   2430
      End
      Begin VB.CommandButton DespInv 
         Caption         =   "-"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   9
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   240
         Index           =   0
         Left            =   540
         MouseIcon       =   "frmMain.frx":045C
         MousePointer    =   99  'Custom
         TabIndex        =   8
         Top             =   2160
         Visible         =   0   'False
         Width           =   2430
      End
      Begin VB.PictureBox picInv 
         Appearance      =   0  'Flat
         AutoRedraw      =   -1  'True
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         CausesValidation=   0   'False
         ClipControls    =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000008&
         Height          =   2400
         Left            =   555
         ScaleHeight     =   160
         ScaleMode       =   3  'Pixel
         ScaleWidth      =   160
         TabIndex        =   7
         Top             =   2400
         Width           =   2400
      End
      Begin VB.ListBox hlst 
         BackColor       =   &H00000000&
         ForeColor       =   &H00FFFFFF&
         Height          =   2790
         Left            =   420
         TabIndex        =   14
         TabStop         =   0   'False
         Top             =   2040
         Visible         =   0   'False
         Width           =   2565
      End
      Begin VB.Label lblPorcLvl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "33.33%"
         ForeColor       =   &H00FFFF00&
         Height          =   195
         Left            =   1560
         TabIndex        =   17
         Top             =   450
         Width           =   660
      End
      Begin VB.Image cmdMoverHechi 
         Height          =   375
         Index           =   1
         Left            =   2940
         MouseIcon       =   "frmMain.frx":05AE
         MousePointer    =   99  'Custom
         Top             =   2100
         Visible         =   0   'False
         Width           =   315
      End
      Begin VB.Image cmdMoverHechi 
         Height          =   375
         Index           =   0
         Left            =   2940
         MouseIcon       =   "frmMain.frx":0700
         MousePointer    =   99  'Custom
         Top             =   2520
         Visible         =   0   'False
         Width           =   315
      End
      Begin VB.Image cmdInfo 
         Height          =   405
         Left            =   2310
         MouseIcon       =   "frmMain.frx":0852
         MousePointer    =   99  'Custom
         Top             =   4830
         Visible         =   0   'False
         Width           =   855
      End
      Begin VB.Image CmdLanzar 
         Height          =   405
         Left            =   450
         MouseIcon       =   "frmMain.frx":09A4
         MousePointer    =   99  'Custom
         Top             =   4830
         Visible         =   0   'False
         Width           =   1770
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "+"
         BeginProperty Font 
            Name            =   "MS Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   195
         Left            =   1185
         TabIndex        =   13
         Top             =   435
         Visible         =   0   'False
         Width           =   120
      End
      Begin VB.Label exp 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Exp:"
         ForeColor       =   &H00FFFFFF&
         Height          =   195
         Left            =   285
         TabIndex        =   12
         Top             =   675
         Width           =   345
      End
      Begin VB.Image Image3 
         Height          =   195
         Index           =   2
         Left            =   2070
         Top             =   6540
         Width           =   360
      End
      Begin VB.Image Image3 
         Height          =   195
         Index           =   1
         Left            =   2055
         Top             =   6255
         Width           =   360
      End
      Begin VB.Image Image3 
         Height          =   195
         Index           =   0
         Left            =   2085
         Top             =   5955
         Width           =   360
      End
      Begin VB.Label GldLbl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "1"
         BeginProperty Font 
            Name            =   "MS Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   195
         Left            =   2595
         TabIndex        =   11
         Top             =   5970
         Width           =   105
      End
      Begin VB.Image Image1 
         Height          =   300
         Index           =   2
         Left            =   1905
         MouseIcon       =   "frmMain.frx":0AF6
         MousePointer    =   99  'Custom
         Top             =   7575
         Width           =   1410
      End
      Begin VB.Image Image1 
         Height          =   300
         Index           =   1
         Left            =   1905
         MouseIcon       =   "frmMain.frx":0C48
         MousePointer    =   99  'Custom
         Top             =   7200
         Width           =   1410
      End
      Begin VB.Image Image1 
         Height          =   300
         Index           =   0
         Left            =   1920
         MouseIcon       =   "frmMain.frx":0D9A
         MousePointer    =   99  'Custom
         Top             =   6840
         Width           =   1410
      End
      Begin VB.Shape AGUAsp 
         BackColor       =   &H00C00000&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         FillColor       =   &H0000FFFF&
         Height          =   75
         Left            =   315
         Top             =   7575
         Width           =   1290
      End
      Begin VB.Shape COMIDAsp 
         BackColor       =   &H0000C000&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         FillColor       =   &H0000FFFF&
         Height          =   75
         Left            =   315
         Top             =   7245
         Width           =   1290
      End
      Begin VB.Shape MANShp 
         BackColor       =   &H00FFFF00&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         Height          =   75
         Left            =   315
         Top             =   6585
         Width           =   1290
      End
      Begin VB.Shape STAShp 
         BackColor       =   &H0000FFFF&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         FillColor       =   &H0000FFFF&
         Height          =   75
         Left            =   315
         Top             =   6240
         Width           =   1290
      End
      Begin VB.Shape Hpshp 
         BorderColor     =   &H8000000D&
         BorderStyle     =   0  'Transparent
         FillColor       =   &H000000FF&
         FillStyle       =   0  'Solid
         Height          =   75
         Left            =   330
         Top             =   6900
         Width           =   1290
      End
      Begin VB.Label Label8 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   195
         Left            =   420
         TabIndex        =   10
         Top             =   180
         Width           =   2625
      End
      Begin VB.Label Label7 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   450
         Left            =   1800
         MouseIcon       =   "frmMain.frx":0EEC
         MousePointer    =   99  'Custom
         TabIndex        =   6
         Top             =   1290
         Width           =   1605
      End
      Begin VB.Label Label4 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   435
         Left            =   150
         MouseIcon       =   "frmMain.frx":103E
         MousePointer    =   99  'Custom
         TabIndex        =   5
         Top             =   1305
         Width           =   1605
      End
      Begin VB.Image InvEqu 
         Height          =   4395
         Left            =   120
         Top             =   1320
         Width           =   3240
      End
      Begin VB.Label lbCRIATURA 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   5.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   120
         Left            =   555
         TabIndex        =   4
         Top             =   1965
         Width           =   30
      End
      Begin VB.Label LvlLbl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "1"
         ForeColor       =   &H00FFFFFF&
         Height          =   195
         Left            =   765
         TabIndex        =   3
         Top             =   450
         Width           =   105
      End
      Begin VB.Label Label6 
         BackStyle       =   0  'Transparent
         Caption         =   "Nivel"
         ForeColor       =   &H00FFFFFF&
         Height          =   225
         Left            =   285
         TabIndex        =   2
         Top             =   450
         Width           =   465
      End
   End
   Begin RichTextLib.RichTextBox RecTxt 
      Height          =   1500
      Left            =   45
      TabIndex        =   0
      TabStop         =   0   'False
      ToolTipText     =   "Mensajes del servidor"
      Top             =   45
      Width           =   8175
      _ExtentX        =   14420
      _ExtentY        =   2646
      _Version        =   393217
      BackColor       =   0
      Enabled         =   -1  'True
      ReadOnly        =   -1  'True
      ScrollBars      =   2
      DisableNoScroll =   -1  'True
      TextRTF         =   $"frmMain.frx":1190
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.PictureBox renderer 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   6240
      Left            =   120
      ScaleHeight     =   416
      ScaleMode       =   0  'User
      ScaleWidth      =   544
      TabIndex        =   20
      Top             =   1980
      Width           =   8055
   End
   Begin VB.Image PicResu 
      BorderStyle     =   1  'Fixed Single
      Height          =   510
      Left            =   9810
      Picture         =   "frmMain.frx":120D
      Stretch         =   -1  'True
      Top             =   8100
      Visible         =   0   'False
      Width           =   510
   End
   Begin VB.Image PicMH 
      BorderStyle     =   1  'Fixed Single
      Height          =   510
      Left            =   8790
      Picture         =   "frmMain.frx":250F
      Stretch         =   -1  'True
      Top             =   8100
      Visible         =   0   'False
      Width           =   510
   End
   Begin VB.Label Coord 
      AutoSize        =   -1  'True
      BackColor       =   &H00000000&
      BackStyle       =   0  'Transparent
      BorderStyle     =   1  'Fixed Single
      Caption         =   "(000,00,00)"
      ForeColor       =   &H0000FFFF&
      Height          =   255
      Left            =   10680
      TabIndex        =   16
      Top             =   8250
      Width           =   1035
   End
   Begin VB.Image PicSeg 
      BorderStyle     =   1  'Fixed Single
      Height          =   510
      Left            =   8280
      Picture         =   "frmMain.frx":3321
      Stretch         =   -1  'True
      Top             =   8100
      Width           =   510
   End
   Begin VB.Menu mnuObj 
      Caption         =   "Objeto"
      Visible         =   0   'False
      Begin VB.Menu mnuTirar 
         Caption         =   "Tirar"
      End
      Begin VB.Menu mnuUsar 
         Caption         =   "Usar"
      End
      Begin VB.Menu mnuEquipar 
         Caption         =   "Equipar"
      End
   End
   Begin VB.Menu mnuNpc 
      Caption         =   "NPC"
      Visible         =   0   'False
      Begin VB.Menu mnuNpcDesc 
         Caption         =   "Descripcion"
      End
      Begin VB.Menu mnuNpcComerciar 
         Caption         =   "Comerciar"
         Visible         =   0   'False
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
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

Public tX As Byte
Public tY As Byte
Public MouseX As Long
Public MouseY As Long
Public MouseBoton As Long
Public MouseShift As Long

Public IsPlaying As Byte

Dim PuedeMacrear As Boolean

Private Sub cmdMoverHechi_Click(index As Integer)
    If hlst.ListIndex = -1 Then Exit Sub
    Dim sTemp As String

    Select Case index
        Case 1 'subir
            If hlst.ListIndex = 0 Then Exit Sub
        Case 0 'bajar
            If hlst.ListIndex = hlst.ListCount - 1 Then Exit Sub
    End Select

    Call WriteMoveSpell(index, hlst.ListIndex + 1)
    
    Select Case index
        Case 1 'subir
            sTemp = hlst.List(hlst.ListIndex - 1)
            hlst.List(hlst.ListIndex - 1) = hlst.List(hlst.ListIndex)
            hlst.List(hlst.ListIndex) = sTemp
            hlst.ListIndex = hlst.ListIndex - 1
        Case 0 'bajar
            sTemp = hlst.List(hlst.ListIndex + 1)
            hlst.List(hlst.ListIndex + 1) = hlst.List(hlst.ListIndex)
            hlst.List(hlst.ListIndex) = sTemp
            hlst.ListIndex = hlst.ListIndex + 1
    End Select
End Sub

Public Sub ActivarMacroHechizos()
    If Not hlst.Visible Then
        Call AddtoRichTextBox(frmMain.RecTxt, "Debes tener seleccionado el hechizo para activar el auto-lanzar", 0, 200, 200, False, True, False)
        Exit Sub
    End If
    TrainingMacro.Interval = INT_MACRO_HECHIS
    TrainingMacro.Enabled = True
    Call AddtoRichTextBox(frmMain.RecTxt, "Auto lanzar hechizos activado", 0, 200, 200, False, True, False)
    PicMH.Visible = True
End Sub

Public Sub DesactivarMacroHechizos()
        PicMH.Visible = False
        TrainingMacro.Enabled = False
        Call AddtoRichTextBox(frmMain.RecTxt, "Auto lanzar hechizos desactivado", 0, 150, 150, False, True, False)
End Sub

Public Sub ControlSeguroResu(ByVal Mostrar As Boolean)
If Mostrar Then
    If Not PicResu.Visible Then
        PicResu.Visible = True
    End If
Else
    If PicResu.Visible Then
        PicResu.Visible = False
    End If
End If
End Sub

Public Sub DibujarMH()
PicMH.Visible = True
End Sub

Public Sub DesDibujarMH()
PicMH.Visible = False
End Sub

Public Sub DibujarSeguro()
PicSeg.Visible = True
End Sub

Public Sub DesDibujarSeguro()
PicSeg.Visible = False
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
    
    If (Not SendTxt.Visible) And (Not SendCMSTXT.Visible) Then
        
        'Checks if the key is valid
        If LenB(CustomKeys.ReadableName(KeyCode)) > 0 Then
            Select Case KeyCode
                Case CustomKeys.BindedKey(eKeyType.mKeyToggleMusic)
                    modEngine_Audio.MasterEnabled = Not modEngine_Audio.MasterEnabled
                
                Case CustomKeys.BindedKey(eKeyType.mKeyGetObject)
                    Call AgarrarItem
                
                Case CustomKeys.BindedKey(eKeyType.mKeyToggleCombatMode)
                    UserCombate = Not UserCombate
                
                Case CustomKeys.BindedKey(eKeyType.mKeyEquipObject)
                    Call EquiparItem
                
                Case CustomKeys.BindedKey(eKeyType.mKeyToggleNames)
                    Nombres = Not Nombres
                
                Case CustomKeys.BindedKey(eKeyType.mKeyTamAnimal)
                    Call WriteWork(eSkill.Domar)
                
                Case CustomKeys.BindedKey(eKeyType.mKeySteal)
                    Call WriteWork(eSkill.Robar)
                            
                Case CustomKeys.BindedKey(eKeyType.mKeyHide)
                    Call WriteWork(eSkill.Ocultarse)
                
                Case CustomKeys.BindedKey(eKeyType.mKeyDropObject)
                    Call TirarItem
                
                Case CustomKeys.BindedKey(eKeyType.mKeyUseObject)
                    If macrotrabajo.Enabled Then DesactivarMacroTrabajo
                        
                    If MainTimer.Check(TimersIndex.UseItemWithU) Then
                        Call UsarItem
                    End If
                
                Case CustomKeys.BindedKey(eKeyType.mKeyRequestRefresh)
                    If MainTimer.Check(TimersIndex.SendRPU) Then
                        Call WriteRequestPositionUpdate
                        Beep
                    End If
                Case CustomKeys.BindedKey(eKeyType.mKeyToggleSafeMode)
                    If frmMain.PicSeg.Visible Then
                        AddtoRichTextBox frmMain.RecTxt, "Escribe /SEG para quitar el seguro", 255, 255, 255, False, False, False
                    Else
                        Call WriteSafeToggle
                    End If
            End Select
        End If
    End If
    
    Select Case KeyCode
        Case CustomKeys.BindedKey(eKeyType.mKeyTalkWithGuild)
            If SendTxt.Visible Then Exit Sub
            
            If (Not frmComerciar.Visible) And (Not frmComerciarUsu.Visible) And _
              (Not frmBancoObj.Visible) And (Not frmSkills3.Visible) And _
              (Not frmMSG.Visible) And _
              (Not frmEstadisticas.Visible) And (Not frmCantidad.Visible) Then
                SendCMSTXT.Visible = True
                SendCMSTXT.SetFocus
            End If

        Case CustomKeys.BindedKey(eKeyType.mKeyShowOptions)
            Call frmOpciones.Show(vbModeless, frmMain)
        
        Case CustomKeys.BindedKey(eKeyType.mKeyMeditate)
            If UserMinMAN = UserMaxMAN Then Exit Sub
            
            If Not PuedeMacrear Then
                AddtoRichTextBox frmMain.RecTxt, "No tan rápido..!", 255, 255, 255, False, False, False
            Else
                Call WriteMeditate
                PuedeMacrear = False
            End If
        
        Case CustomKeys.BindedKey(eKeyType.mKeyCastSpellMacro)
            If TrainingMacro.Enabled Then
                DesactivarMacroHechizos
            Else
                ActivarMacroHechizos
            End If
        
        Case CustomKeys.BindedKey(eKeyType.mKeyWorkMacro)
            If macrotrabajo.Enabled Then
                DesactivarMacroTrabajo
            Else
                ActivarMacroTrabajo
            End If
        
        Case CustomKeys.BindedKey(eKeyType.mKeyExitGame)
            Call WriteQuit
            
        Case CustomKeys.BindedKey(eKeyType.mKeyAttack)
            'If not in combat mode, can't attack
            If Not UserCombate Then
                Call ShowConsoleMsg("No estás en modo de combate, presiona la tecla ""C"" para pasar al modo combate.", FontTypeNames.FONTTYPE_INFO)
                Exit Sub
            End If
        
            If Shift <> 0 Then Exit Sub
            
            If Not MainTimer.Check(TimersIndex.Arrows, False) Then Exit Sub 'Check if arrows interval has finished.
            If Not MainTimer.Check(TimersIndex.CastSpell, False) Then 'Check if spells interval has finished.
                If Not MainTimer.Check(TimersIndex.CastAttack) Then Exit Sub 'Corto intervalo Golpe-Hechizo
            Else
                If Not MainTimer.Check(TimersIndex.Attack) Or UserDescansar Or UserMeditar Then Exit Sub
            End If
            
            If TrainingMacro.Enabled Then DesactivarMacroHechizos
            If macrotrabajo.Enabled Then DesactivarMacroTrabajo
            Call WriteAttack
        
        Case CustomKeys.BindedKey(eKeyType.mKeyTalk)
            If SendCMSTXT.Visible Then Exit Sub
            
            If (Not frmComerciar.Visible) And (Not frmComerciarUsu.Visible) And _
              (Not frmBancoObj.Visible) And (Not frmSkills3.Visible) And _
              (Not frmMSG.Visible) And _
              (Not frmEstadisticas.Visible) And (Not frmCantidad.Visible) Then
                SendTxt.Visible = True
                SendTxt.SetFocus
            End If
    End Select
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MouseBoton = Button
    MouseShift = Shift
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If prgRun = True Then
        prgRun = False
        Cancel = 1
    End If
End Sub

Private Sub Macro_Timer()
    PuedeMacrear = True
End Sub

Private Sub macrotrabajo_Timer()
    If Inventario.SelectedItem = 0 Then
        DesactivarMacroTrabajo
        Exit Sub
    End If
    
    'Macros are disabled if not using Argentum!
    If Not Application.IsAppActive() Then
        DesactivarMacroTrabajo
        Exit Sub
    End If
    
    If UsingSkill = eSkill.Pesca Or UsingSkill = eSkill.Talar Or UsingSkill = eSkill.Mineria Or UsingSkill = FundirMetal Or (UsingSkill = eSkill.Herreria And Not frmHerrero.Visible) Then
        Call WriteWorkLeftClick(tX, tY, UsingSkill)
        UsingSkill = 0
    End If
    
    'If Inventario.OBJType(Inventario.SelectedItem) = eObjType.otWeapon Then
     If Not (frmCarp.Visible = True) Then Call UsarItem
End Sub

Public Sub ActivarMacroTrabajo()
    macrotrabajo.Interval = INT_MACRO_TRABAJO
    macrotrabajo.Enabled = True
    Call AddtoRichTextBox(frmMain.RecTxt, "Macro Trabajo ACTIVADO", 0, 200, 200, False, True, False)
End Sub

Public Sub DesactivarMacroTrabajo()
    macrotrabajo.Enabled = False
    MacroBltIndex = 0
    UsingSkill = 0
    MousePointer = vbDefault
    Call AddtoRichTextBox(frmMain.RecTxt, "Macro Trabajo DESACTIVADO", 0, 200, 200, False, True, False)
End Sub


Private Sub mnuEquipar_Click()
    Call EquiparItem
End Sub

Private Sub mnuNPCComerciar_Click()
    Call WriteLeftClick(tX, tY)
    Call WriteCommerceStart
End Sub

Private Sub mnuNpcDesc_Click()
    Call WriteLeftClick(tX, tY)
End Sub

Private Sub mnuTirar_Click()
    Call TirarItem
End Sub

Private Sub mnuUsar_Click()
    Call UsarItem
End Sub

Private Sub PicMH_Click()
    AddtoRichTextBox frmMain.RecTxt, "Auto lanzar hechizos. Utiliza esta habilidad para entrenar únicamente. Para activarlo/desactivarlo utiliza F7.", 255, 255, 255, False, False, False
End Sub

Private Sub PicSeg_Click()
    AddtoRichTextBox frmMain.RecTxt, "El dibujo de la llave indica que tienes activado el seguro, esto evitará que por accidente ataques a un ciudadano y te conviertas en criminal. Para activarlo o desactivarlo utiliza la tecla '*' (asterisco)", 255, 255, 255, False, False, False
End Sub

Private Sub Coord_Click()
    AddtoRichTextBox frmMain.RecTxt, "Estas coordenadas son tu ubicación en el mapa. Utiliza la letra L para corregirla si esta no se corresponde con la del servidor por efecto del Lag.", 255, 255, 255, False, False, False
End Sub

Private Sub renderer_Click()
Call Form_Click
End Sub

Private Sub renderer_DblClick()
Call Form_DblClick
End Sub

Private Sub renderer_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MouseBoton = Button
    MouseShift = Shift
End Sub

Private Sub renderer_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MouseX = X
    MouseY = Y
End Sub

Private Sub SendTxt_KeyUp(KeyCode As Integer, Shift As Integer)
    'Send text
    If KeyCode = vbKeyReturn Then
        If LenB(SendTxt.Text) <> 0 Then Call ParseUserCommand(SendTxt.Text)
        
        SendTxt.Text = ""
        KeyCode = 0
        SendTxt.Visible = False
    End If
End Sub

'[END]'

''''''''''''''''''''''''''''''''''''''
'     ITEM CONTROL                   '
''''''''''''''''''''''''''''''''''''''

Private Sub TirarItem()
    If (Inventario.SelectedItem > 0 And Inventario.SelectedItem < MAX_INVENTORY_SLOTS + 1) Or (Inventario.SelectedItem = FLAGORO) Then
        If Inventario.Amount(Inventario.SelectedItem) = 1 Then
            Call WriteDrop(Inventario.SelectedItem, 1)
        Else
           If Inventario.Amount(Inventario.SelectedItem) > 1 Then
                frmCantidad.Show , frmMain
           End If
        End If
    End If
End Sub

Private Sub AgarrarItem()
    Call WritePickUp
End Sub

Private Sub UsarItem()
    If TrainingMacro.Enabled Then DesactivarMacroHechizos
    
    If (Inventario.SelectedItem > 0) And (Inventario.SelectedItem < MAX_INVENTORY_SLOTS + 1) Then _
        Call WriteUseItem(Inventario.SelectedItem)
End Sub

Private Sub EquiparItem()
    If (Inventario.SelectedItem > 0) And (Inventario.SelectedItem < MAX_INVENTORY_SLOTS + 1) Then _
        Call WriteEquipItem(Inventario.SelectedItem)
End Sub

''''''''''''''''''''''''''''''''''''''
'     HECHIZOS CONTROL               '
''''''''''''''''''''''''''''''''''''''

Private Sub TrainingMacro_Timer()
    If Not hlst.Visible Then
        DesactivarMacroHechizos
        Exit Sub
    End If
    
    'Macros are disabled if focus is not on Argentum!
    If Not Application.IsAppActive() Then
        DesactivarMacroHechizos
        Exit Sub
    End If
    
    If Comerciando Then Exit Sub
    
    If hlst.List(hlst.ListIndex) <> "(None)" And MainTimer.Check(TimersIndex.CastSpell, False) Then
        Call WriteCastSpell(hlst.ListIndex + 1)
        Call WriteWork(eSkill.Magia)
    End If
    
    Call ConvertCPtoTP(MouseX, MouseY, tX, tY)
    
    If UsingSkill = Magia And Not MainTimer.Check(TimersIndex.CastSpell) Then Exit Sub
    
    If UsingSkill = Proyectiles And Not MainTimer.Check(TimersIndex.Attack) Then Exit Sub
    
    Call WriteWorkLeftClick(tX, tY, UsingSkill)
    UsingSkill = 0
End Sub

Private Sub cmdLanzar_Click()
    If hlst.List(hlst.ListIndex) <> "(None)" And MainTimer.Check(TimersIndex.Work, False) Then
        If Not UserCombate Then
            Call ShowConsoleMsg("Debes estar en modo de combate para lanzar este hechizo.", FontTypeNames.FONTTYPE_INFO)
            Exit Sub
        End If

        If UserEstado = 1 Then
            Call ShowConsoleMsg("¡¡Estás muerto!!", FONTTYPE_INFO)
        Else
            Call WriteCastSpell(hlst.ListIndex + 1)
            Call WriteWork(eSkill.Magia)
            UsaMacro = True
        End If
    End If
End Sub

Private Sub CmdLanzar_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    UsaMacro = False
    CnTd = 0
End Sub

Private Sub cmdINFO_Click()
    If hlst.ListIndex <> -1 Then
        Call WriteSpellInfo(hlst.ListIndex + 1)
    End If
End Sub

Private Sub DespInv_Click(index As Integer)
    Inventario.ScrollInventory (index = 0)
End Sub

Private Sub Form_Click()

    If Not Comerciando Then
        Call ConvertCPtoTP(MouseX, MouseY, tX, tY)

        
        If MouseShift = 0 Then
            If MouseBoton <> vbRightButton Then
                '[ybarra]
                If UsaMacro Then
                    CnTd = CnTd + 1
                    If CnTd = 3 Then
                        Call WriteUseSpellMacro
                        CnTd = 0
                    End If
                    UsaMacro = False
                End If
                '[/ybarra]
                If UsingSkill = 0 Then
                    Call WriteLeftClick(tX, tY)
                Else
                
                    If TrainingMacro.Enabled Then DesactivarMacroHechizos
                    If macrotrabajo.Enabled Then DesactivarMacroTrabajo
                    
                    If Not MainTimer.Check(TimersIndex.Arrows, False) Then 'Check if arrows interval has finished.
                        frmMain.MousePointer = vbDefault
                        UsingSkill = 0
                        With FontTypes(FontTypeNames.FONTTYPE_TALK)
                            Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar flechas tan rapido.", .red, .green, .blue, .bold, .italic)
                        End With
                        Exit Sub
                    End If
                    
                    'Splitted because VB isn't lazy!
                    If UsingSkill = Proyectiles Then
                        If Not MainTimer.Check(TimersIndex.Arrows) Then
                            frmMain.MousePointer = vbDefault
                            UsingSkill = 0
                            With FontTypes(FontTypeNames.FONTTYPE_TALK)
                                Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar flechas tan rapido.", .red, .green, .blue, .bold, .italic)
                            End With
                            Exit Sub
                        End If
                    End If
                    
                    'Splitted because VB isn't lazy!
                    If UsingSkill = Magia Then
                        If Not MainTimer.Check(TimersIndex.Attack, False) Then 'Check if attack interval has finished.
                            If Not MainTimer.Check(TimersIndex.CastAttack) Then 'Corto intervalo de Golpe-Magia
                                frmMain.MousePointer = vbDefault
                                UsingSkill = 0
                                With FontTypes(FontTypeNames.FONTTYPE_TALK)
                                    Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar hechizos tan rapido.", .red, .green, .blue, .bold, .italic)
                                End With
                                Exit Sub
                            End If
                        Else
                            If Not MainTimer.Check(TimersIndex.CastSpell) Then 'Check if spells interval has finished.
                                frmMain.MousePointer = vbDefault
                                UsingSkill = 0
                                With FontTypes(FontTypeNames.FONTTYPE_TALK)
                                    Call AddtoRichTextBox(frmMain.RecTxt, "No podés lanzar hechizos tan rapido.", .red, .green, .blue, .bold, .italic)
                                End With
                                Exit Sub
                            End If
                        End If
                    End If
                    
                    'Splitted because VB isn't lazy!
                    If (UsingSkill = Pesca Or UsingSkill = Robar Or UsingSkill = Talar Or UsingSkill = Mineria Or UsingSkill = FundirMetal) Then
                        If Not MainTimer.Check(TimersIndex.Work) Then
                            frmMain.MousePointer = vbDefault
                            UsingSkill = 0
                            Exit Sub
                        End If
                    End If
                    
                    If frmMain.MousePointer <> 2 Then Exit Sub 'Parcheo porque a veces tira el hechizo sin tener el cursor (NicoNZ)
                    
                    frmMain.MousePointer = vbDefault
                    Call WriteWorkLeftClick(tX, tY, UsingSkill)
                    UsingSkill = 0
                End If
            End If
        ElseIf (MouseShift And 1) = 1 Then
            If Not CustomKeys.KeyAssigned(KeyCodeConstants.vbKeyShift) Then
                If MouseBoton = vbLeftButton Then
                    Call WriteWarpChar("YO", UserMap, tX, tY)
                End If
            End If
        End If
    End If
End Sub

Private Sub Form_DblClick()
'**************************************************************
'Author: Unknown
'Last Modify Date: 12/27/2007
'12/28/2007: ByVal - Chequea que la ventana de comercio y boveda no este abierta al hacer doble clic a un comerciante, sobrecarga la lista de items.
'**************************************************************
    If Not frmComerciar.Visible And Not frmBancoObj.Visible Then
        Call WriteDoubleClick(tX, tY)
    End If
End Sub

Private Sub Form_Load()
    
    
    frmMain.Caption = "Argentum Online" & " V " & App.Major & "." & _
    App.Minor & "." & App.Revision
    PanelDer.Picture = LoadPicture(App.Path & _
    "\Graficos\Principalnuevo_sin_energia.jpg")
    
    InvEqu.Picture = LoadPicture(App.Path & _
    "\Graficos\Centronuevoinventario.jpg")
    
   Me.Left = 0
   Me.Top = 0
End Sub

Private Sub hlst_KeyDown(KeyCode As Integer, Shift As Integer)
       KeyCode = 0
End Sub

Private Sub hlst_KeyPress(KeyAscii As Integer)
       KeyAscii = 0
End Sub

Private Sub hlst_KeyUp(KeyCode As Integer, Shift As Integer)
        KeyCode = 0
End Sub

Private Sub Image1_Click(index As Integer)
    Call modEngine_Audio.PlayInterface(SND_CLICK)

    Select Case index
        Case 0
            Call frmOpciones.Show(vbModeless, frmMain)
            
        Case 1
            Call WriteRequestAtributes
            Call WriteRequestSkills
            Call WriteRequestMiniStats
            Call WriteRequestFame

            frmEstadisticas.Iniciar_Labels
            frmEstadisticas.Show , frmMain

        Case 2
            If frmGuildLeader.Visible Then Unload frmGuildLeader
            
            Call WriteRequestGuildLeaderInfo
    End Select
End Sub

Private Sub Image3_Click(index As Integer)
    Select Case index
        Case 0
            Inventario.SelectGold
            If UserGLD > 0 Then
                frmCantidad.Show , frmMain
            End If
    End Select
End Sub

Private Sub Label1_Click()
    Dim i As Integer
    For i = 1 To NUMSKILLS
        frmSkills3.Text1(i).Caption = UserSkills(i)
    Next i
    Alocados = SkillPoints
    frmSkills3.Puntos.Caption = "Puntos:" & SkillPoints
    frmSkills3.Show , frmMain
End Sub

Private Sub Label4_Click()
    Call modEngine_Audio.PlayInterface(SND_CLICK)

    InvEqu.Picture = LoadPicture(App.Path & "\Graficos\Centronuevoinventario.jpg")

    'DespInv(0).Visible = True
    'DespInv(1).Visible = True
    picInv.Visible = True

    hlst.Visible = False
    cmdINFO.Visible = False
    CmdLanzar.Visible = False
    
    cmdMoverHechi(0).Visible = True
    cmdMoverHechi(1).Visible = True
    
    cmdMoverHechi(0).Enabled = False
    cmdMoverHechi(1).Enabled = False
End Sub

Private Sub Label7_Click()
    Call modEngine_Audio.PlayInterface(SND_CLICK)

    InvEqu.Picture = LoadPicture(App.Path & "\Graficos\Centronuevohechizos.jpg")
    '%%%%%%OCULTAMOS EL INV&&&&&&&&&&&&
    'DespInv(0).Visible = False
    'DespInv(1).Visible = False
    picInv.Visible = False
    hlst.Visible = True
    cmdINFO.Visible = True
    CmdLanzar.Visible = True
    
    cmdMoverHechi(0).Visible = True
    cmdMoverHechi(1).Visible = True
    
    cmdMoverHechi(0).Enabled = True
    cmdMoverHechi(1).Enabled = True
End Sub

Private Sub picInv_DblClick()
    If frmCarp.Visible Or frmHerrero.Visible Then Exit Sub
    
    If Not MainTimer.Check(TimersIndex.UseItemWithDblClick) Then Exit Sub
    
    If macrotrabajo.Enabled Then _
                     DesactivarMacroTrabajo
    
    Call UsarItem
End Sub

Private Sub picInv_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call modEngine_Audio.PlayInterface(SND_CLICK)
End Sub

Private Sub RecTxt_Change()
On Error Resume Next  'el .SetFocus causaba errores al salir y volver a entrar
    If Not Application.IsAppActive() Then Exit Sub
    
    If SendTxt.Visible Then
        SendTxt.SetFocus
    ElseIf Me.SendCMSTXT.Visible Then
        SendCMSTXT.SetFocus
    ElseIf (Not frmComerciar.Visible) And (Not frmComerciarUsu.Visible) And _
      (Not frmBancoObj.Visible) And (Not frmSkills3.Visible) And _
      (Not frmMSG.Visible) And _
      (Not frmEstadisticas.Visible) And (Not frmCantidad.Visible) And (picInv.Visible) Then
        picInv.SetFocus
    End If
End Sub

Private Sub RecTxt_KeyDown(KeyCode As Integer, Shift As Integer)
    If picInv.Visible Then
        picInv.SetFocus
    Else
        hlst.SetFocus
    End If
End Sub

Private Sub SendTxt_KeyPress(KeyAscii As Integer)
    If Not (KeyAscii = vbKeyBack) And _
       Not (KeyAscii >= vbKeySpace And KeyAscii <= 250) Then _
        KeyAscii = 0
End Sub

Private Sub SendCMSTXT_KeyUp(KeyCode As Integer, Shift As Integer)
    'Send text
    If KeyCode = vbKeyReturn Then
        'Say
        If SendCMSTXT.Text <> "" Then
            Call ParseUserCommand("/CMSG " & SendCMSTXT.Text)
        End If

        SendCMSTXT.Text = ""
        KeyCode = 0
        Me.SendCMSTXT.Visible = False
    End If
End Sub

Private Sub SendCMSTXT_KeyPress(KeyAscii As Integer)
    If Not (KeyAscii = vbKeyBack) And _
       Not (KeyAscii >= vbKeySpace And KeyAscii <= 250) Then _
        KeyAscii = 0
End Sub
