VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Consola"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private p_CANTIDADDIALOGOS As Byte

Private Type jojo
texto As String
color As Long
End Type

Private p_Dialogos() As jojo
Private p_Activo As Boolean

Private usedFont As StdFont

Public Property Let CantidadDialogos(ByVal v As Byte)
    If v > 0 Then
        ReDim Preserve p_Dialogos(1 To v) As jojo
    End If
    p_CANTIDADDIALOGOS = v
End Property

''
' Removes all dialogs from screen.

Public Sub RemoveDialogs()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/02/07
'Removes all dialogs
'***************************************************
    Dim i As Long
    
    For i = 1 To p_CANTIDADDIALOGOS
        p_Dialogos(i).texto = vbNullString
    Next i
End Sub

''
' Retrieves the number of dialogs to be displayed on screen.
'
' @return   The number of dialogs to be displayed on screen.

Public Property Get CantidadDialogos() As Byte
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/01/07
'Retrieves the number of dialogs to be displayed on screen
'***************************************************
    CantidadDialogos = p_CANTIDADDIALOGOS
End Property


Private Sub Class_Initialize()
    p_CANTIDADDIALOGOS = 7
    ReDim p_Dialogos(1 To p_CANTIDADDIALOGOS) As jojo
    p_Activo = True
End Sub

Public Sub Draw(x As Integer, y As Integer)
Dim i As Byte

    For i = 1 To p_CANTIDADDIALOGOS
        If Trim$(p_Dialogos(i).texto) <> vbNullString Then
            Call engine.Text_Render_ext(p_Dialogos(i).texto, ((i - 1) * 10) + 10 + y, 10 + x, 539, 12, p_Dialogos(i).color)
        End If
    Next i
End Sub

''
' Splits dialogs into lines fitting properly the render area and inserts them

Public Sub PushBackText(ByVal s As String, ByVal color As Long)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 04/07/08
'Splits dialogs into lines fitting properly the render area and inserts them
'***************************************************
On Error Resume Next
    Dim str As String
    Dim tmp As Integer
    
    str = s
    
    ' If it's too long to fit, split it
    Do While frmMain.TextWidth(str) > 500
        tmp = InStrRev(str, " ")
        
        If tmp = 0 Then Exit Do
        
        str = left$(str, tmp - 1)
    Loop
    
    'Show message and continue with the rest
    Call RealPushBackText(str, color)
    
    If LenB(str) <> LenB(s) Then
        Call PushBackText(Right$(s, Len(s) - tmp), color)
    End If
End Sub

Private Sub RealPushBackText(ByVal s As String, ByVal color As Long)
Dim i As Byte
Dim Vacio As Boolean

If p_CANTIDADDIALOGOS > 0 Then
    i = p_CANTIDADDIALOGOS
    Vacio = True
    While i > 0 And Vacio
        Vacio = p_Dialogos(i).texto = vbNullString
        If Vacio Then i = i - 1
    Wend
    If i = p_CANTIDADDIALOGOS Then
        'hay q scrollear, estamos llenos
        i = 1
        While i < p_CANTIDADDIALOGOS
            p_Dialogos(i) = p_Dialogos(i + 1)
            i = i + 1
        Wend
        p_Dialogos(i).texto = s
        p_Dialogos(i).color = color
    Else
        p_Dialogos(i + 1).texto = s
        p_Dialogos(i + 1).color = color
    End If
End If

End Sub
