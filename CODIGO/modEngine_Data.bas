Attribute VB_Name = "modEngine_Data"
'**************************************************************************
' This program is free software; you can redistribute it and/or modify
' it under the terms of the Affero General Public License;
' either version 1 of the License, or any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' Affero General Public License for more details.
'
' You should have received a copy of the Affero General Public License
' along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'**************************************************************************

Option Explicit

' TODO (Wolftein): Improve structures, specially Graphics.ind

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
            Dim Index As Long
            Index = Reader.ReadInt32()
            
            With GrhData(Index)
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
                
                    .Frames(1) = Index
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
        
        For Y = YMinMapSize To YMaxMapSize
            For X = XMinMapSize To XMaxMapSize
                Dim ByFlags As Long
                ByFlags = Reader.ReadInt8()
                    
                With MapData(X, Y)
                    .Blocked = (ByFlags And 1)
                    
                    'Layer 1
                    .Graphic(1).grhindex = Reader.ReadInt16()
                    Call InitGrh(.Graphic(1), .Graphic(1).grhindex)

                    'Layer 2 used?
                    If ByFlags And 2 Then
                        .Graphic(2).grhindex = Reader.ReadInt16()
                        Call InitGrh(.Graphic(2), .Graphic(2).grhindex)
                    Else
                        .Graphic(2).grhindex = 0
                    End If
                        
                    'Layer 3 used?
                    If ByFlags And 4 Then
                        .Graphic(3).grhindex = Reader.ReadInt16()
                        Call InitGrh(.Graphic(3), .Graphic(3).grhindex)
                    Else
                        .Graphic(3).grhindex = 0
                    End If
                        
                    'Layer 4 used?
                    If ByFlags And 8 Then
                        .Graphic(4).grhindex = Reader.ReadInt16()
                        Call InitGrh(.Graphic(4), .Graphic(4).grhindex)
                    Else
                        .Graphic(4).grhindex = 0
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
                    .ObjGrh.grhindex = 0
                End With
            Next X
        Next Y
 
        LoadMap = True
    Else
        LoadMap = False
        
    End If
    
End Function



