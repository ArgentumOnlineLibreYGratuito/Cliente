VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsTexManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Type TEXT_DB_ENTRY
    FileName As Integer
    UltimoAcceso As Long
    texture As Direct3DTexture8
    Dimension As Long
    size As Long
End Type

Private mGraficos() As TEXT_DB_ENTRY
Private mD3D As D3DX8
Private device As Direct3DDevice8

Private mMaxEntries As Integer
Private mCantidadGraficos As Integer
Private mFreeMemoryBytes As Long

Private GrhPath As String

Private Declare Function GetTickCount Lib "kernel32" () As Long

Private Sub Class_Terminate()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'
'**************************************************************
On Error Resume Next
    Dim i As Long
    
    For i = 1 To mCantidadGraficos
        Set mGraficos(i).texture = Nothing
    Next i
    
    Erase mGraficos
    
End Sub

Public Property Let path(ByVal inString As String)
    GrhPath = inString
End Property

Public Function GetTexture(ByVal FileName As Integer, ByRef Dimension As Long) As Direct3DTexture8
If FileName = 0 Then
Debug.Print "0 GRH ATMPT TO BE LOADED"
Exit Function
End If
    Dim index As Integer

    If ObtenerIndice(FileName) <> 0 Then
        With mGraficos(ObtenerIndice(FileName))
            'Ultimo acceso
            .UltimoAcceso = GetTickCount
            'Devuelvo una texture con el grafico cargado
            Dimension = .Dimension
            Set GetTexture = .texture
        End With
    Else    'Gráfico no cargado
        'Vemos si puedo agregar uno a la lista
        If mMaxEntries = mCantidadGraficos Then
            'Sacamos el que hace más que no usamos, y utilizamos el slot
            index = CrearGrafico(FileName, BorraMenosUsado())
            Dimension = mGraficos(index).Dimension
            Set GetTexture = mGraficos(index).texture
        Else
            'Agrego una textura nueva a la lista
            index = CrearGrafico(FileName)
            Dimension = mGraficos(index).Dimension
            Set GetTexture = mGraficos(index).texture
        End If
    End If
End Function

Private Function ObtenerIndice(ByVal FileName As Integer) As Integer
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Busqueda binaria para hallar la texture deseada
'**************************************************************
    Dim max As Integer  'Max index
    Dim min As Integer  'Min index
    Dim mid As Integer  'Middle index
    
    min = 1
    max = mCantidadGraficos
    Do While min <= max
        mid = (min + max) / 2
        If FileName < mGraficos(mid).FileName Then
            'El índice no existe
            If max = mid Then
                max = max - 1
            Else
                max = mid
            End If
        ElseIf FileName > mGraficos(mid).FileName Then
            'El índice no existe
            If min = mid Then
                min = min + 1
            Else
                min = mid
            End If
        Else
            ObtenerIndice = mid
            Exit Function
        End If
    Loop
End Function

Public Function Init(ByRef D3D8 As D3DX8, ByRef d3d_device As Direct3DDevice8, ByVal MaxMemory As Long, ByVal MaxEntries As Long) As Boolean
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'
'**************************************************************
    
    mMaxEntries = MaxEntries
    
    If mMaxEntries < 1 Then 'por lo menos 1 gráfico
        Exit Function
    End If
    
    mCantidadGraficos = 0
    
    'Seteamos el objeto
    Set mD3D = D3D8
    Set device = d3d_device
    mFreeMemoryBytes = MaxMemory
    
    Init = True
End Function

Public Sub BorrarTodo()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Vacia la lista de graficos
'**************************************************************
    Dim i As Long
    
    For i = 1 To mCantidadGraficos
        Set mGraficos(i).texture = Nothing
    Next i
    
    ReDim mGraficos(0)
    mCantidadGraficos = 0
End Sub

Public Function Borrar(ByVal FileName As Integer) As Integer
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Borra un grafico
'**************************************************************
    Dim indice As Long
    
    'Obtenemos el ìndice
    indice = ObtenerIndice(FileName)
    
    'Lo eliminamos
    With mGraficos(indice)
        Set .texture = Nothing
        .Dimension = 0
        mFreeMemoryBytes = mFreeMemoryBytes + .size
        .size = 0
    End With
    
    'Actualizamos el número de gráficos
    mCantidadGraficos = mCantidadGraficos - 1
    
    'Movemos para atrás el resto de la lista
    For indice = indice To mCantidadGraficos
        mGraficos(indice) = mGraficos(indice + 1)
    Next indice
    
    'Redimencionamos la lista
    ReDim Preserve mGraficos(1 To mCantidadGraficos)
End Function

Private Function CrearGrafico(ByVal Archivo As Integer, Optional ByVal index As Integer = -1, Optional ByVal Extraido As Boolean = False) As Integer
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'
'**************************************************************
On Error GoTo ErrHandler
    Dim surface_desc As D3DSURFACE_DESC
      
    If index = -1 Then
        'Agregamos al final de la lista
        index = mCantidadGraficos + 1
        ReDim Preserve mGraficos(1 To index)
    End If
    
    'Call GetTextureHeader(GrhPath & Archivo & ".bmp", BMPInfo)  'para alto y ancho de la texture
            
    With mGraficos(index)
        'Nombre
        .FileName = Archivo
        
        'Ultimo acceso
        .UltimoAcceso = GetTickCount
#If debuging <> 1 Then
        If Not Extraido Then
            If Extract_File(Graphics, GrhPath, LTrim(str(Archivo)) & ".bmp", Windows_Temp_Dir, False) Then
                'Cargamos el gráfico y seteamos la Color Key
                Set .texture = mD3D.CreateTextureFromFileEx(device, Windows_Temp_Dir & LTrim(str(Archivo)) & ".bmp", _
                    D3DX_DEFAULT, D3DX_DEFAULT, 1, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_FILTER_NONE, _
                    D3DX_FILTER_NONE, &HFF000000, ByVal 0, ByVal 0)
                        
                .texture.GetLevelDesc 0, surface_desc
                .Dimension = surface_desc.Width
                .size = surface_desc.size
                
                mFreeMemoryBytes = mFreeMemoryBytes - surface_desc.size
                
                Delete_File (Windows_Temp_Dir & LTrim(str(Archivo)) & ".bmp")
                
            End If
        Else

            'Cargamos el gráfico y seteamos la Color Key
            Set .texture = mD3D.CreateTextureFromFileEx(device, Windows_Temp_Dir & LTrim(str(Archivo)) & ".bmp", _
                D3DX_DEFAULT, D3DX_DEFAULT, 1, 0, D3DFMT_UNKNOWN, D3DPOOL_MANAGED, D3DX_FILTER_NONE, _
                D3DX_FILTER_NONE, &HFF000000, ByVal 0, ByVal 0)
#Else
Debug.Print "Cargado "; LTrim(str(Archivo)) & ".bmp"

                Set .texture = mD3D.CreateTextureFromFileEx(device, App.path & "\GRAFICOS\" & LTrim(str(Archivo)) & ".bmp", _
                D3DX_DEFAULT, D3DX_DEFAULT, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED, D3DX_FILTER_NONE, _
                D3DX_FILTER_NONE, &HFF000000, ByVal 0, ByVal 0)
#End If
            .texture.GetLevelDesc 0, surface_desc
            .Dimension = surface_desc.Width
            .size = surface_desc.size
            
            mFreeMemoryBytes = mFreeMemoryBytes - surface_desc.size
#If debuging <> 1 Then
            Delete_File (Windows_Temp_Dir & LTrim(str(Archivo)) & ".bmp")
        End If
#End If

    End With
    
    'Aumentamos la cantidad de gráficos
    mCantidadGraficos = mCantidadGraficos + 1
        
    'Ordenamos la lista (al estar agregando de a un item no es mucho trabajo, y se compensa con la velocidad de busqueda)
    Call OrdenarGraficos(1, mCantidadGraficos)
    
    'Devolvemos el ìndice en que lo cargamos
    CrearGrafico = ObtenerIndice(Archivo)
Exit Function

ErrHandler:
    'Ocurrió un error, la causa más probable es que el archivo no exista
#If debuging <> 1 Then
    If General_File_Exists(Windows_Temp_Dir & Archivo & ".bmp", vbNormal) Then
        Delete_File Windows_Temp_Dir & Archivo & ".bmp"
    End If
#Else
Debug.Print "ERROR EN GRHLOAD>" & Archivo & ".bmp"
#End If

End Function

Private Sub OrdenarGraficos(ByVal primero As Integer, ByVal ultimo As Integer)
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Ordenamos los gráficos por nombre usando QuickSort
'**************************************************************
    Dim min As Integer      'Primer item de la lista
    Dim max As Integer      'Ultimo item de la lista
    Dim Comp As Integer     'Item usado para comparar
    Dim temp As TEXT_DB_ENTRY
    
    min = primero
    max = ultimo
    
    Comp = mGraficos((min + max) / 2).FileName
    
    Do While min <= max
        Do While mGraficos(min).FileName < Comp And min < ultimo
            min = min + 1
        Loop
        Do While mGraficos(max).FileName > Comp And max > primero
            max = max - 1
        Loop
        If min <= max Then
            temp = mGraficos(min)
            mGraficos(min) = mGraficos(max)
            mGraficos(max) = temp
            min = min + 1
            max = max - 1
        End If
    Loop
    If primero < max Then OrdenarGraficos primero, max
    If min < ultimo Then OrdenarGraficos min, ultimo
End Sub

Private Function BorraMenosUsado() As Integer
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Borra el grafico menos usado. Devuelve el index del borrado para ser reutilizado
'NO redimenciona la lista, estamos forzando a sacar uno para meter otro en su lugar
'**************************************************************
    Dim Valor As Long
    Dim i As Long
    
    'Inicializamos todo
    Valor = mGraficos(1).UltimoAcceso
    BorraMenosUsado = 1
    
    'Buscamos cual es el que lleva más tiempo sin ser utilizado
    For i = 1 To mCantidadGraficos
        If mGraficos(i).UltimoAcceso < Valor Then
            Valor = mGraficos(i).UltimoAcceso
            BorraMenosUsado = i
        End If
    Next i
    
    'Disminuimos el contador
    mCantidadGraficos = mCantidadGraficos - 1
    
    'Borramos la texture
    Set mGraficos(BorraMenosUsado).texture = Nothing
    mGraficos(BorraMenosUsado).Dimension = 0
    mFreeMemoryBytes = mFreeMemoryBytes + mGraficos(BorraMenosUsado).size
    mGraficos(BorraMenosUsado).size = 0
    
End Function

Public Property Get MaxEntries() As Integer
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'
'**************************************************************
    MaxEntries = mMaxEntries
End Property

Public Property Let MaxEntries(ByVal vNewValue As Integer)
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'
'**************************************************************
    mMaxEntries = vNewValue
End Property

Public Property Get CantidadGraficos() As Integer
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'
'**************************************************************
    CantidadGraficos = mCantidadGraficos
End Property

Public Sub BorraTimer()
'**************************************************************
'Author: Juan Martín Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Cada un minuto revisamos que texturas se pueden eliminar
'**************************************************************
    Dim loopc As Long
    Dim offset As Integer
    Dim TiempoActual As Long
    
    'Barrin: we delete only if we have less than 10 MB of free memory
    If mFreeMemoryBytes > 10485760 Then Exit Sub
    
    TiempoActual = GetTickCount
    
    For loopc = 1 To mCantidadGraficos
        'Revisar cuales usamos
        If (mGraficos(loopc).Dimension <= 32) Or (mGraficos(loopc).UltimoAcceso > TiempoActual - 60000) Then
            'Si el offset está seteado, movemos para atrás la lista
            If offset Then
                mGraficos(loopc - offset) = mGraficos(loopc)
            End If
        Else
            'Eliminar de memoria
            Set mGraficos(loopc).texture = Nothing
            mGraficos(loopc).Dimension = 0
            mFreeMemoryBytes = mFreeMemoryBytes + mGraficos(loopc).size
            mGraficos(loopc).size = 0
            offset = offset + 1
        End If
    Next loopc
    
    'Actualizar el número de gráficos
    mCantidadGraficos = mCantidadGraficos - offset
End Sub

Public Function CargarGrafico(ByVal FileName As Integer) As Boolean
'**************************************************************
'Author: Augusto José Rando
'Last Modify Date: 8/17/2005
'
'**************************************************************

    Dim index As Integer
    
    If FileName <= 0 Then Exit Function

    If ObtenerIndice(FileName) <> 0 Then
        CargarGrafico = False
    Else    'Gráfico no cargado
        'Vemos si puedo agregar uno a la lista
        If mMaxEntries = mCantidadGraficos Then
            'Sacamos el que hace más que no usamos, y utilizamos el slot
            Call CrearGrafico(FileName, BorraMenosUsado())
            CargarGrafico = True
        Else
            'Agrego una textura nueva a la lista
            Call CrearGrafico(FileName)
            CargarGrafico = True
        End If
    End If
End Function

