Attribute VB_Name = "ModLadder"
Public Particula(1 To 500) As Stream
Public TotalStreams As Long
Public Actual As Byte

Public Type Stream
    Name As String
    MapeZ As Integer
    VarZ As Integer
    MapX As Integer
    Mapy As Integer
    VarX As Single
    VarY As Single
    AlphaInicial As Byte
    RedInicial As Byte
    GreenInicial As Byte
    BlueInicial As Byte
    AlphaFinal As Byte
    RedFinal As Byte
    GreenFinal As Byte
    BlueFinal As Byte
    NumOfParticles As Integer
    Gravity As Single
    Texture As Long
    Zize As Single
    Life As Integer
End Type
Sub CargarParticulas()
StreamFile = App.path & "\Particles.ini"
TotalStreams = Val(General_Var_Get(StreamFile, "INIT", "Total"))

For loopc = 1 To TotalStreams
    Particula(loopc).Name = General_Var_Get(StreamFile, Val(loopc), "Name")
    Particula(loopc).VarX = General_Var_Get(StreamFile, Val(loopc), "VarX")
    Particula(loopc).VarY = General_Var_Get(StreamFile, Val(loopc), "VarY")
    Particula(loopc).VarZ = General_Var_Get(StreamFile, Val(loopc), "VarZ")
    Particula(loopc).AlphaInicial = General_Var_Get(StreamFile, Val(loopc), "AlphaInicial")
    Particula(loopc).RedInicial = General_Var_Get(StreamFile, Val(loopc), "RedInicial")
    Particula(loopc).GreenInicial = General_Var_Get(StreamFile, Val(loopc), "GreenInicial")
    Particula(loopc).BlueInicial = General_Var_Get(StreamFile, Val(loopc), "BlueInicial")
    Particula(loopc).AlphaFinal = General_Var_Get(StreamFile, Val(loopc), "AlphaFinal")
    Particula(loopc).RedFinal = General_Var_Get(StreamFile, Val(loopc), "RedFinal")
    Particula(loopc).GreenFinal = General_Var_Get(StreamFile, Val(loopc), "GreenFinal")
    Particula(loopc).BlueFinal = General_Var_Get(StreamFile, Val(loopc), "BlueFinal")
    Particula(loopc).NumOfParticles = General_Var_Get(StreamFile, Val(loopc), "NumOfParticles")
    Particula(loopc).Gravity = General_Var_Get(StreamFile, Val(loopc), "Gravity")
    Particula(loopc).Texture = General_Var_Get(StreamFile, Val(loopc), "texture")
    Particula(loopc).Zize = General_Var_Get(StreamFile, Val(loopc), "Zize")
    Particula(loopc).Life = General_Var_Get(StreamFile, Val(loopc), "Life")
 
Next loopc
End Sub
Public Sub General_Var_Write(ByVal file As String, ByVal Main As String, ByVal var As String, ByVal value As String)
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Writes a var to a text file
'*****************************************************************
    writeprivateprofilestring Main, var, value, file
End Sub

Public Function General_Var_Get(ByVal file As String, ByVal Main As String, ByVal var As String) As String
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 10/07/2002
'Get a var to from a text file
'*****************************************************************
    Dim l As Long
    Dim char As String
    Dim sSpaces As String 'Input that the program will retrieve
    Dim szReturn As String 'Default value if the string is not found
    
    szReturn = ""
    
    sSpaces = Space$(5000)
    
    getprivateprofilestring Main, var, szReturn, sSpaces, Len(sSpaces), file
    
    General_Var_Get = RTrim$(sSpaces)
    General_Var_Get = Left$(General_Var_Get, Len(General_Var_Get) - 1)
End Function
