Attribute VB_Name = "modEngine_Audio"
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

Private Const CHANNEL_MUSIC     As Long = 0
Private Const CHANNEL_EFFECT    As Long = 1
Private Const CHANNEL_INTERFACE As Long = 2

Private MasterEnabled_    As Boolean
Private MasterVolume_     As Long

Private MusicEnabled_     As Boolean
Private MusicID_          As Long
Private MusicVolume_      As Long

Private EffectEnabled_    As Boolean
Private EffectVolume_     As Long

Private InterfaceEnabled_ As Boolean
Private InterfaceVolume_  As Long

Public Sub Initialize()
    
    Set Aurora_Content = Kernel.Content
    
End Sub

Public Sub Update(ByVal Tick As Long, ByVal CoordinatesX As Single, ByVal CoordinatesY As Single)
    
    Call Aurora_Audio.SetListener(CoordinatesX, 0#, CoordinatesY)

End Sub

Public Sub Halt()
    
    Call Aurora_Audio.Halt(CHANNEL_EFFECT)
    
End Sub

Public Function CreateEmitter(ByVal X As Single, ByVal Y As Single) As Audio_Emitter
    Const DEFAULT_INNER_RADIUS       As Single = 2#
    Const DEFAULT_INNER_RADIUS_ANGLE As Single = 3.14 / 4#
    Const DEFAULT_ATTENUATION        As Single = 12.25

    Set CreateEmitter = New Audio_Emitter
    
    With CreateEmitter
        Call .SetPosition(X, 0#, Y)
        Call .SetVelocity(0#, 0#, 0#)
        Call .SetInnerRadius(DEFAULT_INNER_RADIUS)
        Call .SetInnerRadiusAngle(DEFAULT_INNER_RADIUS_ANGLE)
        Call .SetAttenuation(DEFAULT_ATTENUATION)
    End With

End Function

Public Sub UpdateEmitter(ByVal Emitter As Audio_Emitter, ByVal X As Single, ByVal Y As Single)

    If (Not Emitter Is Nothing) Then
        Call Emitter.SetPosition(X, 0#, Y)
    End If

End Sub

Public Sub DeleteEmitter(ByRef Emitter As Audio_Emitter, ByVal Immediately As Boolean)

    If (Not Emitter Is Nothing) Then
        Call Aurora_Audio.StopByEmitter(Emitter, Immediately)
    End If

    Set Emitter = Nothing
    
End Sub

Public Sub PlayMusic(ByVal Filename As String, Optional ByVal Repeat As Boolean = True, Optional ByVal Fade As Boolean = True)
    
    If (Not MusicEnabled_) Then Exit Sub
    
    Call Cancel(MusicID_)

    Dim Music As Audio_Sound
    Set Music = Aurora_Content.Load("Resources://Music/" & Filename, eResourceTypeSound)
    
    If (Music.GetStatus = eResourceStatusLoaded) Then
        MusicID_ = Aurora_Audio.Play(CHANNEL_MUSIC, Music, Nothing, Repeat)
        
        If (MusicID_ <> 0) Then
            Call Aurora_Audio.Start(MusicID_)
        End If
    End If

End Sub

Public Function PlayEffect(ByVal Filename As String, Optional ByVal Emitter As Audio_Emitter = Nothing, Optional ByVal Repeat As Boolean = False) As Long

    If Not EffectEnabled_ Then Exit Function

    PlayEffect = Play(CHANNEL_EFFECT, Filename, Emitter, Repeat)
    
End Function

Public Function PlayInterface(ByVal Filename As String) As Long

    If Not InterfaceEnabled_ Then Exit Function

    PlayInterface = Play(CHANNEL_INTERFACE, Filename, Nothing, False)
    
End Function

Public Sub Cancel(ByRef InstanceID As Long, Optional ByVal Immediately As Boolean = True)

    If (InstanceID <> 0) Then
        Call Aurora_Audio.StopByID(InstanceID, Immediately)
    End If
    
    InstanceID = 0

End Sub

Public Property Get MasterEnabled() As Boolean

    MasterEnabled = MasterEnabled_
    
End Property

Public Property Let MasterEnabled(ByVal Activate As Boolean)

    If MasterEnabled_ = Activate Then Exit Property

    MasterEnabled_ = Activate

    If Activate Then
        Call Aurora_Audio.SetMasterVolume(MasterVolume_ * 0.01)
    Else
        Call Aurora_Audio.SetMasterVolume(0)
    End If
    
End Property

Public Property Let MasterVolume(ByVal Volume As Long)

    If Volume < 0 Or Volume > 100 Then Exit Property

    Call Aurora_Audio.SetMasterVolume(Volume * 0.01)
    
    MasterVolume_ = Volume
    
End Property

Public Property Get MasterVolume() As Long

    MasterVolume_ = Aurora_Audio.GetMasterVolume() * 100
    
End Property

Public Property Get MusicEnabled() As Boolean

    MusicEnabled = MasterEnabled_
    
End Property

Public Property Let MusicEnabled(ByVal Activate As Boolean)

    If MusicEnabled_ = Activate Then Exit Property

    MusicEnabled_ = Activate
    
    If Activate Then
        Call Aurora_Audio.SetSubmixVolume(CHANNEL_MUSIC, MusicVolume_ * 0.01)
        
        If (MusicID_ <> 0) Then
            Call Aurora_Audio.Start(MusicID_)
        End If
    Else
        Call Aurora_Audio.SetSubmixVolume(CHANNEL_MUSIC, 0)
            
        If (MusicID_ <> 0) Then
            Call Aurora_Audio.Pause(MusicID_)
        End If
    End If

End Property

Public Property Let MusicVolume(ByVal Volume As Long)

    If Volume < 0 Or Volume > 100 Then Exit Property

    Call Aurora_Audio.SetSubmixVolume(CHANNEL_MUSIC, Volume * 0.01)
    
    MusicVolume_ = Volume
    
End Property

Public Property Get MusicVolume() As Long

    MusicVolume_ = Aurora_Audio.GetSubmixVolume(CHANNEL_MUSIC) * 100
    
End Property

Public Property Get EffectEnabled() As Boolean

    EffectEnabled = EffectEnabled_
    
End Property

Public Property Let EffectEnabled(ByVal Activate As Boolean)

    If EffectEnabled_ = Activate Then Exit Property

    EffectEnabled_ = Activate

    If Activate Then
        Call Aurora_Audio.SetSubmixVolume(CHANNEL_EFFECT, EffectVolume_ * 0.01)
    Else
        Call Aurora_Audio.SetSubmixVolume(CHANNEL_EFFECT, 0)
    End If
    
End Property

Public Property Let EffectVolume(ByVal Volume As Long)

    If Volume < 0 Or Volume > 100 Then Exit Property

    Call Aurora_Audio.SetSubmixVolume(CHANNEL_EFFECT, Volume * 0.01)

    EffectVolume_ = Volume
    
End Property

Public Property Get EffectVolume() As Long

    EffectVolume = Aurora_Audio.GetSubmixVolume(CHANNEL_EFFECT) * 100

End Property

Public Property Get InterfaceEnabled() As Boolean

    InterfaceEnabled = InterfaceEnabled_
    
End Property

Public Property Let InterfaceEnabled(ByVal Activate As Boolean)

    If InterfaceEnabled_ = Activate Then Exit Property

    InterfaceEnabled_ = Activate

    If Activate Then
        Call Aurora_Audio.SetSubmixVolume(CHANNEL_INTERFACE, InterfaceVolume_ * 0.01)
    Else
        Call Aurora_Audio.SetSubmixVolume(CHANNEL_INTERFACE, 0)
    End If
    
End Property

Public Property Let InterfaceVolume(ByVal Volume As Long)

    If Volume < 0 Or Volume > 100 Then Exit Property

    Call Aurora_Audio.SetSubmixVolume(CHANNEL_INTERFACE, Volume * 0.01)

    InterfaceVolume_ = Volume
    
End Property

Public Property Get InterfaceVolume() As Long

    InterfaceVolume = Aurora_Audio.GetSubmixVolume(CHANNEL_INTERFACE) * 100
    
End Property

Private Function Play(ByVal Channel As Long, ByVal Filename As String, ByVal Emitter As Audio_Emitter, ByVal Repeat As Boolean) As Long

    Dim Effect As Audio_Sound
    Set Effect = Aurora_Content.Load("Resources://Sound/" & Filename, eResourceTypeSound)
    
    If (Effect.GetStatus = eResourceStatusLoaded) Then
        Play = Aurora_Audio.Play(Channel, Effect, Emitter, Repeat)
        
        If (Play <> 0) Then
            Call Aurora_Audio.Start(Play)
        End If
    End If
    
End Function
