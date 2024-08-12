Attribute VB_Name = "modEngine_Properties"
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

Private Const kConfigurationFilename As String = "Configuration.toml"

Private Type Settings
    Audio_MusicEnabled     As Boolean
    Audio_MusicVolume      As Long
    Audio_EffectEnabled    As Boolean
    Audio_EffectVolume     As Long
    Audio_InterfaceEnabled As Boolean
    Audio_InterfaceVolume  As Long
    
    Graphics_Fullscreen    As Boolean
End Type

Public Configuration As Settings

Public Sub LoadProperties()

    
    Dim Content As String
    
    If (FileExist(kConfigurationFilename, vbNormal)) Then
        
        Open kConfigurationFilename For Input Access Read As #1
            Content = Input$(LOF(1), #1)
        Close #1
    
    End If
    
    Dim Parser As TOMLParser
    Set Parser = New TOMLParser
    Call Parser.Load(Content)
    
    Call LoadAudioProperties(Parser.GetSection("Audio"))
    Call LoadGraphicProperties(Parser.GetSection("Graphics"))
    
End Sub

Private Sub LoadAudioProperties(ByVal Section As TOMLSection)
    
    Configuration.Audio_MusicEnabled = Section.GetBool("MusicEnabled")
    Configuration.Audio_MusicVolume = Section.GetInt32("MusicVolume")
    Configuration.Audio_EffectEnabled = Section.GetBool("EffectEnabled")
    Configuration.Audio_EffectVolume = Section.GetInt32("EffectVolume")
    Configuration.Audio_InterfaceEnabled = Section.GetBool("InterfaceEnabled")
    Configuration.Audio_InterfaceVolume = Section.GetInt32("InterfaceVolume")
    
End Sub

Private Sub LoadGraphicProperties(ByVal Section As TOMLSection)

    Configuration.Graphics_Fullscreen = Section.GetBool("Fullscreen")
    
End Sub

Public Sub SaveProperties()
    
    Dim Parser As TOMLParser
    Set Parser = New TOMLParser
        
    Call SaveAudioProperties(Parser.GetSection("Audio"))
    Call SaveGraphicProperties(Parser.GetSection("Graphics"))
    
    Open kConfigurationFilename For Binary Access Write As #1
        Put #1, , Parser.Dump()
    Close #1

End Sub

Private Sub SaveAudioProperties(ByVal Section As TOMLSection)
    
    Call Section.SetBool("MusicEnabled", Configuration.Audio_MusicEnabled)
    Call Section.SetInt32("MusicVolume", Configuration.Audio_MusicVolume)
    Call Section.SetBool("EffectEnabled", Configuration.Audio_EffectEnabled)
    Call Section.SetInt32("EffectVolume", Configuration.Audio_EffectVolume)
    Call Section.SetBool("InterfaceEnabled", Configuration.Audio_InterfaceEnabled)
    Call Section.SetInt32("InterfaceVolume", Configuration.Audio_InterfaceVolume)

End Sub

Private Sub SaveGraphicProperties(ByVal Section As TOMLSection)

    Call Section.SetBool("Fullscreen", Configuration.Graphics_Fullscreen)
    
End Sub


