VERSION 5.00
Begin VB.Form frmGuildSol 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Ingreso"
   ClientHeight    =   3495
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3495
   ScaleWidth      =   4680
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command2 
      Cancel          =   -1  'True
      Caption         =   "Cancelar"
      Height          =   495
      Left            =   240
      MouseIcon       =   "frmSolicitud.frx":0000
      MousePointer    =   99  'Custom
      TabIndex        =   3
      Top             =   2880
      Width           =   855
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Enviar"
      Height          =   495
      Left            =   3360
      MouseIcon       =   "frmSolicitud.frx":0152
      MousePointer    =   99  'Custom
      TabIndex        =   2
      Top             =   2880
      Width           =   975
   End
   Begin VB.TextBox Text1 
      Height          =   1215
      Left            =   240
      MaxLength       =   400
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   1440
      Width           =   4095
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   $"frmSolicitud.frx":02A4
      Height          =   1215
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   3975
   End
End
Attribute VB_Name = "frmGuildSol"
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

Dim CName As String

Private Sub Command1_Click()
    Call WriteGuildRequestMembership(CName, Replace(Replace(Text1.Text, ",", ";"), vbCrLf, "º"))

    Unload Me
End Sub

Private Sub Command2_Click()
    Unload Me
End Sub

Public Sub RecieveSolicitud(ByVal GuildName As String)

    CName = GuildName

End Sub

