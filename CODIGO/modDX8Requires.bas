Attribute VB_Name = "modDX8Requires"
Option Explicit

Public vertList(3) As TLVERTEX

Public SurfaceDB As clsTexManager

Public Type D3D8Textures
    Texture As Direct3DTexture8
    texwidth As Long
    texheight As Long
End Type

Public dX As DirectX8
Public D3D As Direct3D8
Public D3DDevice As Direct3DDevice8
Public D3DX As D3DX8

Public Type TLVERTEX
    x As Single
    y As Single
    Z As Single
    rhw As Single
    color As Long
    Specular As Long
    tu As Single
    tv As Single
End Type

Public Type TLVERTEX2
    x As Single
    y As Single
    Z As Single
    rhw As Single
    color As Long
    Specular As Long
    tu1 As Single
    tv1 As Single
    tu2 As Single
    tv2 As Single
End Type

Public Const PI As Single = 3.14159265358979
Public base_light As Long
Public day_r_old As Byte
Public day_g_old As Byte
Public day_b_old As Byte
Type luzxhora
    r As Long
    g As Long
    b As Long
End Type
Public luz_dia(0 To 24) As luzxhora '¬¬ la hora 24 dura 1 minuto entre las 24 y las 0

'JOJOJO
Public engine As New clsDX8Engine
'JOJOJO

'To get free bytes in drive
Private Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceExA" (ByVal lpRootPathName As String, FreeBytesToCaller As Currency, BytesTotal As Currency, FreeBytesTotal As Currency) As Long

'To get free bytes in RAM

Private pUdtMemStatus As MEMORYSTATUS

Private Type MEMORYSTATUS
    dwLength As Long
    dwMemoryLoad As Long
    dwTotalPhys As Long
    dwAvailPhys As Long
    dwTotalPageFile As Long
    dwAvailPageFile As Long
    dwTotalVirtual As Long
    dwAvailVirtual As Long
End Type

Private Declare Sub GlobalMemoryStatus Lib "kernel32" (lpBuffer As MEMORYSTATUS)

Public Function General_Bytes_To_Megabytes(Bytes As Double) As Double
Dim dblAns As Double
dblAns = (Bytes / 1024) / 1024
General_Bytes_To_Megabytes = format(dblAns, "###,###,##0.00")
End Function

Public Function General_Get_Free_Ram() As Double
    'Return Value in Megabytes
    Dim dblAns As Double
    GlobalMemoryStatus pUdtMemStatus
    dblAns = pUdtMemStatus.dwAvailPhys
    General_Get_Free_Ram = General_Bytes_To_Megabytes(dblAns)
End Function

Public Function General_Get_Free_Ram_Bytes() As Long
    GlobalMemoryStatus pUdtMemStatus
    General_Get_Free_Ram_Bytes = pUdtMemStatus.dwAvailPhys
End Function

Sub jojoparticulas()
     'engine.Particle_Group_Make 1, 0, 50, 70, 0, 100, 100, 0, 20, 20, 20, 0, 20, 0, 0, 100, 0, 609, 32, 250
    'Engine.Particle_Group_Make 1, 0, 50, 49, 0, 20, 1, 255, 200, 80, 0, 10, 40, 40, 40, 200, -10, 609, 30, 100
    'engine.Particle_Group_Make 2, 0, 44, 45, 0, 2, 2, 0, 255, 255, 0, 10, 255, 255, 255, 50, -10, 12725, 30, 500
    engine.Light_Create 50, 50, &HFFCCCCCC, 10
    engine.Light_Create 50, 70, &HFFFFFFFF, 5
    engine.Light_Create 54, 62, &HFFFF0033, 1
    Actual = frmMain.Text1
    engine.Light_Create 28, 45, &HFFCCCCCC, 1
    engine.Particle_Group_Make Actual, 1, 28, 44, Particula(Actual).VarZ, Particula(Actual).VarX, Particula(Actual).VarY, Particula(Actual).AlphaInicial, Particula(Actual).RedInicial, Particula(Actual).GreenInicial, _
    Particula(Actual).BlueInicial, Particula(Actual).AlphaFinal, Particula(Actual).RedFinal, Particula(Actual).GreenFinal, Particula(Actual).BlueFinal, Particula(Actual).NumOfParticles, Particula(Actual).Gravity, Particula(Actual).Texture, Particula(Actual).Zize, Particula(Actual).Life
    'engine.Particle_Group_Make 2, 0, 55, 7, 0, 13, 19, 255, 255, 255, 255, 40, 40, 40, 40, 700, -10, 609, 6, 500
    engine.Light_Render_All
End Sub

Public Function ARGB(ByVal r As Long, ByVal g As Long, ByVal b As Long, ByVal A As Long) As Long
        
    Dim c As Long
        
    If A > 127 Then
        A = A - 128
        c = A * 2 ^ 24 Or &H80000000
        c = c Or r * 2 ^ 16
        c = c Or g * 2 ^ 8
        c = c Or b
    Else
        c = A * 2 ^ 24
        c = c Or r * 2 ^ 16
        c = c Or g * 2 ^ 8
        c = c Or b
    End If
    
    ARGB = c

End Function
