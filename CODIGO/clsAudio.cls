VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsAudio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'**************************************************************
' clsAudio.cls - Controls all audio using DirectSound and DirectMusic
'
' Designed and implemented by Juan Martín Sotuyo Dodero (Maraxus)
' (juansotuyo@hotmail.com)
'**************************************************************

'**************************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the GNU General Public License as published by
'the Free Software Foundation; either version 2 of the License, or
'(at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'**************************************************************************

'16/03/2004 - Juan Martín Sotuyo Dodero (Maraxus) - (juansotuyo@gmail.com)
'   - First Release
'
'03/03/2007 - Juan Martín Sotuyo Dodero (Maraxus) - (juansotuyo@gmail.com)
'   - Add: Sound and Music activation / deactivation from within the class.
'   - Add: Documentation
'   - Change: Volume is no longer the dB amplification / atenuation to be
'           applied but a percentage for easier interaction with user.
'
'30/03/2008 - Juan Martín Sotuyo Dodero (Maraxus) - (juansotuyo@gmail.com)
'   - Add: 3D-like sound effects by altering frequency to emulate Doppler effect,
'           volume to emulate distance and panning for position.


''
' Controls all audio using DirectSound and DirectMusic 7.
'
' @file     clsAudio.cls
' @author   Juan Martín Sotuyo Dodero (Maraxus) juansotuyo@gmail.com
' @version  1.2.0
' @date     20070303

Option Explicit
 
''
' Maximum number of sound buffers to hold in memory at any time.
Private Const NumSoundBuffers As Byte = 30
 
''
' The distance at which the sound is inaudible.
Private Const MAX_DISTANCE_TO_SOURCE As Integer = 150
 
''
' The frequency variation coefficient for Doppler effect simulation.
Private Const DELTA_FQ As Integer = 600
 
''
' Custom sound buffer structure.
'
' @param    FileName    The name of the file loaded in this buffer
' @param    looping     Set to true if the sound will loop until stopped
' @param    X           The X position of the sound in map coordinates
' @param    Y           The Y position of the sound in map coordinates
' @param    normalFq    The frequency of the sound when not affected by Doppler effect.
' @param    Buffer      The DirectSoundBuffer object to wich the file is loaded
Private Type SoundBuffer
    FileName As String
    looping As Boolean
    X As Byte
    y As Byte
    normalFq As Long
    Buffer As DirectSoundSecondaryBuffer8
End Type
''
' States how to set a sound's looping state.
'
' @param    Default     If wave is in memory use it's looping setting, otherwise false
' @param    Disabled    Never loop
' @param    Enabled     Loop until stopped
Public Enum LoopStyle
    Default = 0
    Disabled = 1
    Enabled = 2
End Enum
 
''
' Set to true once the object is created to prevent multiple initializations of the same object.
Dim inited As Boolean
 
 
''
'Directory from which to load sound files by default
Dim SoundPath As String
 
''
'The volume for sounds (FXs)
Dim SndVolume As Long
 
''
'States wether music is supported by hardware or not
Dim Music As Boolean
 
''
'Directory from which to load music files by default
Dim MusicPath As String
 
''
'Last loaded music file. Used to be able to load it when music gets activated
Dim CurrentMusicFile As String
 
''
'States wether music is currently activated or not
Dim mActivated As Boolean
 
''
'States wether sound is currently activated or not
Dim sActivated As Boolean
 
''
'States the last position where the listener was in the X axis
Dim lastPosX As Integer
 
''
'States the last position where the listener was in the Y axis
Dim lastPosY As Integer
 
''
'States wether sound effects are currently activated or not
Dim sEffectsActivated As Boolean
 
'**** Direct Sound ********
 
Private Dx As DirectX8
Private Sound_Buffer() As DirectSoundSecondaryBuffer8
Private DS As DirectSound8
Private DS_Enum As DirectSoundEnum8
 
'**** Direct Music ********
''
'DirectMusic's Performance object
Private Performance As DirectMusicPerformance8
 
''
'Currently loaded segment
Private Segment As DirectMusicSegment8
 
''
'The one and only DirectMusic Loader
Private Loader As DirectMusicLoader8
 
''
'State of the currently loaded segment
Private SegState As DirectMusicSegmentState8
 
''
'Array of all existing sound buffers
Dim DSBuffers(1 To NumSoundBuffers) As SoundBuffer
 
''
'Constructor. Performs no action at all.
 
Private Sub Class_Initialize()
 
End Sub
 
''
'Destructor. Releases all created objects assuring no memory-leaks.
 
Private Sub Class_Terminate()
On Local Error Resume Next
    Dim loopc As Long
   
    'Stop every channel being used and destroy the buffer
    For loopc = 1 To NumSoundBuffers
        Call DSBuffers(loopc).Buffer.Stop
        Set DSBuffers(loopc).Buffer = Nothing
    Next loopc
   
    'Stop music
    Call Performance.StopEx(Segment, 0, DMUS_SEGF_DEFAULT)
   
    Call Performance.CloseDown
   
    Set Segment = Nothing
    Set Performance = Nothing
    Set Loader = Nothing
   
    inited = False
End Sub
 
''
'Initializes the clsAudio object.
Public Function Initialize(ByVal hWnd As Long, ByVal sound_path As String, ByVal music_path As String) As Boolean
On Error GoTo ErrHandler
   
    ' Prevent multiple creations
    If inited Then Exit Function
   
     'Cargamos
    Set Dx = New DirectX8
   
    'Validate DX object
    If Dx Is Nothing Then GoTo ErrHandler
   
    'Set sound path
    SoundPath = sound_path
   
    'Set default volume
    SndVolume = 0
   
    Set DS_Enum = Dx.GetDSEnum
    Set DS = Dx.DirectSoundCreate(DS_Enum.GetGuid(1))
 
    DS.SetCooperativeLevel hWnd, DSSCL_PRIORITY
   
    'Initialize DirectMusic
    Music = InitializedirectMusic(Dx, hWnd)
   
    'Set music path
    MusicPath = music_path
   
    mActivated = True
    sActivated = True
   
    CurrentMusicFile = vbNullString
   
    'Set tempo to 0 and volume of music
    MusicTempo = 0
    Call Performance.SetMasterVolume(200)
   
    inited = True
   
    Initialize = True
Exit Function
 
ErrHandler:
End Function
 
''
' Creates and configures all DirectMusic objects.
 
Private Function InitializedirectMusic(ByRef Dx As DirectX8, ByVal hWnd As Long) As Boolean
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modification: 16/03/04
'Initialize DM. Returns false if music isn't supported by HW
'***************************************************
On Error GoTo ErrHandler
    Dim mus_Params As DMUS_AUDIOPARAMS
    Set Loader = Dx.DirectMusicLoaderCreate()
   
    Set Performance = Dx.DirectMusicPerformanceCreate()
    Call Performance.InitAudio(hWnd, DMUS_AUDIOF_ALL, mus_Params, Nothing, DMUS_APATH_DYNAMIC_STEREO, 128)
    Call Performance.SetMasterAutoDownload(True)        'Enable auto download of instruments
   
    Performance.SetMasterTempo 1
    Performance.SetMasterVolume 1
   
    InitializedirectMusic = True
Exit Function
 
ErrHandler:
End Function
 
''
' Plays a new WAVE file.
 
Public Function PlayWave(ByVal FileName As String, Optional ByVal srcX As Byte = 0, Optional ByVal srcY As Byte = 0, Optional ByVal LoopSound As LoopStyle = LoopStyle.Default) As Long
On Error GoTo ErrHandler
    Dim bufferIndex As Long
   
    If Not SoundActivated Then Exit Function
   
    'Get the buffer index were wave was loaded
    bufferIndex = LoadWave(FileName, LoopSound)
    If bufferIndex = 0 Then Exit Function   'If an error ocurred abort
   
    With DSBuffers(bufferIndex)
        If .looping Then
            .Buffer.Play DSBPLAY_LOOPING
        Else
            .Buffer.Play DSBPLAY_DEFAULT
        End If
       
        'Apply volume
        Call .Buffer.SetVolume(SndVolume)
       
        'Store position
        .X = srcX
        .y = srcY
       
        'Get standard frequency
        .normalFq = .Buffer.GetFrequency()
    End With
   
    PlayWave = bufferIndex
   
    If sEffectsActivated Then
        If srcX <> 0 And srcY <> 0 Then
            Call Update3DSound(bufferIndex, 0, 0)
        End If
    End If
Exit Function
 
ErrHandler:
End Function
 
Private Sub Update3DSound(ByVal bufferIndex As Long, ByVal deltaX As Integer, ByVal deltaY As Integer)
    Dim linearDistanceOld As Single
    Dim linearDistanceNew As Single
    Dim deltaDistance As Single
    Dim distanceXOld As Integer
    Dim distanceYOld As Integer
    Dim distanceXNew As Integer
    Dim distanceYNew As Integer
    Dim perceivedFq As Long
   
    With DSBuffers(bufferIndex)
        distanceXOld = .X - lastPosX
        distanceYOld = .y - lastPosY
       
        distanceXNew = distanceXOld + deltaX
        distanceYNew = distanceYOld + deltaY
       
        linearDistanceOld = Sqr(distanceXOld * distanceXOld + distanceYOld * distanceYOld)
        linearDistanceNew = Sqr(distanceXNew * distanceXNew + distanceYNew * distanceYNew)
       
        deltaDistance = linearDistanceNew - linearDistanceOld
       
        'Update frequency emulating Doppler effect
        perceivedFq = .normalFq - deltaDistance * DELTA_FQ
        If perceivedFq < DSBFREQUENCY_MIN Then perceivedFq = DSBFREQUENCY_MIN
       
        Call .Buffer.SetFrequency(perceivedFq)
       
        'Set volumen amortiguation according to distance
        Call .Buffer.SetVolume(SndVolume * (1 - linearDistanceNew / MAX_DISTANCE_TO_SOURCE))
       
        'Prevent division by zero
        If linearDistanceNew = 0 Then linearDistanceNew = 1
       
        'Set panning according to relative position of the source to the listener
        Call .Buffer.SetPan((distanceXNew / linearDistanceNew) * DSBPAN_RIGHT)
    End With
End Sub
 
''
' Updates 3D sounds based on the movement of the listener.
 
Public Sub MoveListener(ByVal X As Integer, ByVal y As Integer)
    Dim I As Long
    Dim deltaX As Integer
    Dim deltaY As Integer
   
    If Not sEffectsActivated Then Exit Sub
   
    deltaX = X - lastPosX
    deltaY = y - lastPosY
   
    For I = 1 To NumSoundBuffers
        If Not DSBuffers(I).Buffer Is Nothing Then
            If DSBuffers(I).Buffer.GetStatus And DSBSTATUS_PLAYING Then
                If DSBuffers(I).X <> 0 And DSBuffers(I).y <> 0 Then
                    Call Update3DSound(I, deltaX, deltaY)
                End If
            End If
        End If
    Next I
   
    lastPosX = X
    lastPosY = y
End Sub
 
''
' Loads a new WAVE file.
 
Private Function LoadWave(ByVal FileName As String, ByVal looping As LoopStyle) As Long
On Error GoTo ErrHandler
    Dim bufferDesc As DSBUFFERDESC
    Dim waveFormat As WAVEFORMATEX
    Dim I As Long
   
    FileName = UCase$(FileName)
   
    If Not FileExist(SoundPath & FileName, vbArchive) Then _
        Exit Function
   
    'Check if the buffer is in memory and not playing
    For I = 1 To NumSoundBuffers
        If DSBuffers(I).FileName = FileName Then
            If DSBuffers(I).Buffer.GetStatus = 0 Or DSBuffers(I).Buffer.GetStatus() = DSBSTATUS_BUFFERLOST Then
                'Found it!!! We just play this one :)
                LoadWave = I
               
                'Set looping if needed
                If looping <> LoopStyle.Default Then DSBuffers(I).looping = (looping = LoopStyle.Enabled)
               
                Exit Function
            End If
        End If
    Next I
   
    'Not in memory, search for an empty buffer
    For I = 1 To NumSoundBuffers
        If DSBuffers(I).Buffer Is Nothing Then
            Exit For
        End If
    Next I
   
    'No empty buffers?? Search for one not being played and use that slot
    If I > NumSoundBuffers Then
        For I = 1 To NumSoundBuffers
            If DSBuffers(I).Buffer.GetStatus() = DSBSTATUS_BUFFERLOST Or DSBuffers(I).Buffer.GetStatus() = 0 Then
                Exit For
            End If
        Next I
    End If
   
    'Still no free buffers?? Get the first non-looping sound
    If I > NumSoundBuffers Then
        For I = 1 To NumSoundBuffers
            If Not (DSBuffers(I).Buffer.GetStatus() And DSBSTATUS_LOOPING) Then
                Call DSBuffers(I).Buffer.Stop
                Exit For
            End If
        Next I
    End If
   
    'If every sound is looping, just ignore new sound unless it's looping too (in which case we set it at the first slot by default)
    If I > NumSoundBuffers Then
        If Not looping Then Exit Function
        I = 1
    End If
   
    'Create new sound
    bufferDesc.lFlags = DSBCAPS_CTRLFREQUENCY Or DSBCAPS_CTRLPAN Or DSBCAPS_CTRLVOLUME Or DSBCAPS_STATIC
   
    waveFormat.nFormatTag = WAVE_FORMAT_PCM
    waveFormat.nChannels = 2
    waveFormat.lSamplesPerSec = 22050
    waveFormat.nBitsPerSample = 32
    waveFormat.nBlockAlign = waveFormat.nBitsPerSample / 8 * waveFormat.nChannels
    waveFormat.lAvgBytesPerSec = waveFormat.lSamplesPerSec * waveFormat.nBlockAlign
   
    With DSBuffers(I)
        Set .Buffer = Nothing   'Get rid of any previous data
       
        .FileName = FileName
        .looping = (looping = LoopStyle.Enabled)
       
        Set .Buffer = DS.CreateSoundBufferFromFile(SoundPath & FileName, bufferDesc) ' waveFormat
    End With
   
    LoadWave = I
Exit Function
 
ErrHandler:
End Function
 
''
' Stops a given sound or all of them.
 
Public Sub StopWave(Optional ByVal bufferIndex As Long = 0)
    If bufferIndex > 0 And bufferIndex <= NumSoundBuffers Then
        If DSBuffers(bufferIndex).Buffer.GetStatus() And DSBSTATUS_PLAYING Then
            Call DSBuffers(bufferIndex).Buffer.Stop
        End If
    ElseIf bufferIndex = 0 Then
        Dim I As Long
        For I = 1 To NumSoundBuffers
            If Not DSBuffers(I).Buffer Is Nothing Then
                If DSBuffers(I).Buffer.GetStatus() <> 0 And DSBuffers(I).Buffer.GetStatus() <> DSBSTATUS_BUFFERLOST Then
                    Call DSBuffers(I).Buffer.Stop
                End If
            End If
        Next I
    End If
End Sub
 
''
' Retrieves wether there are sounds currentyl playing or not.
 
Public Property Get PlayingSound() As Boolean
    Dim I As Long
   
    For I = 1 To NumSoundBuffers
        If DSBuffers(I).Buffer.GetStatus() And DSBSTATUS_PLAYING Then
            PlayingSound = True
            Exit Property
        End If
    Next I
End Property
 
''
' Sets the volume of sound.
 
Public Property Let SoundVolume(ByVal Volume As Byte)
    Dim I As Long
   
    If Volume > 100 Then Exit Property
   
    'Take percentage to actual value
    SndVolume = Volume * (DSBVOLUME_MAX - DSBVOLUME_MIN) / 100 + DSBVOLUME_MIN
   
    For I = 1 To NumSoundBuffers
        If Not DSBuffers(I).Buffer Is Nothing Then
            If DSBuffers(I).Buffer.GetStatus And DSBSTATUS_PLAYING Then
                Call DSBuffers(I).Buffer.SetVolume(SndVolume)
            End If
        End If
    Next I
End Property
 
''
' Gets the volume of sound.
 
Public Property Get SoundVolume() As Byte
    SoundVolume = CByte((SndVolume - DSBVOLUME_MIN) * 100 / (DSBVOLUME_MAX - DSBVOLUME_MIN))
End Property
 
''
' Plays a new MIDI file.
 
Public Function PlayMIDI(Optional ByVal file As String = "", Optional ByVal Loops As Long = -1) As Boolean
On Error GoTo ErrHandler
    If LenB(file) > 0 Then _
        CurrentMusicFile = file
   
    If Not MusicActivated Then Exit Function
   
    If Not Music Then Exit Function
   
    If PlayingMusic Then StopMidi
   
    If LenB(file) > 0 Then
        If Not LoadMidi(file) Then Exit Function
    Else
        'Make sure we have a loaded segment
        If Segment Is Nothing Then Exit Function
    End If
   
    'Play it
    Call Segment.SetRepeats(Loops)
   
    Set SegState = Performance.PlaySegmentEx(Segment, DMUS_SEGF_DEFAULT, 0)
   
    PlayMIDI = True
Exit Function
 
ErrHandler:
End Function
 
''
' Loads a new MIDI file.
 
Private Function LoadMidi(ByVal file As String) As Boolean
On Error GoTo ErrHandler
    If Not FileExist(MusicPath & file, vbArchive) Then Exit Function
   
    Call StopMidi
   
    'Destroy old object
    Set Segment = Nothing
   
    Set Segment = Loader.LoadSegment(MusicPath & file)
   
    If Segment Is Nothing Then
        Exit Function
    End If
   
    Call Segment.SetStandardMidiFile
   
    LoadMidi = True
Exit Function
 
ErrHandler:
End Function
 
''
' Stops playing the currently loaded MIDI file.
 
Public Sub StopMidi()
On Error GoTo ErrHandler
    If PlayingMusic Then
        Call Performance.StopEx(Segment, 0, DMUS_SEGF_DEFAULT)
    End If
Exit Sub
 
ErrHandler:
End Sub
 
''
' Sets the music's tempo.
 
Public Property Let MusicTempo(ByVal Tempo As Single)
    If Not Music Then Exit Property
   
    If Tempo < 0.25 Or Tempo > 2# Then Exit Property
   
    Call Performance.SetMasterTempo(Tempo)
End Property
 
''
' Sets the music's volume.
 
Public Property Let MusicVolume(ByVal Volume As Long)
    If Not Music Then Exit Property
   
    If Volume < 0 Or Volume > 100 Then Exit Property
   
    ' Volume ranges from -10000 to 10000
    Call Performance.SetMasterVolume(Volume * 200 - 10000)
End Property
 
''
' Gets the music's tempo.
 
Public Property Get MusicTempo() As Single
    If Not Music Then Exit Property
   
    MusicTempo = Performance.GetMasterTempo()
End Property
 
''
' Gets the music's volume.
 
Public Property Get MusicVolume() As Long
    If Not Music Then Exit Property
   
    MusicVolume = (Performance.GetMasterVolume() + 10000) / 200
End Property
 
''
' Checks wether there is music currently playing.
 
Public Property Get PlayingMusic() As Boolean
    If Not Music Or Segment Is Nothing Then Exit Property
   
    PlayingMusic = Performance.IsPlaying(Segment, SegState)
End Property
 
''
' Retrieves the music's length.
 
Public Property Get MusicLenght() As Long
    If Not Music Then Exit Property
   
    MusicLenght = Segment.GetLength()
End Property
 
''
' Retrieves wether music is activated or not.
 
Public Property Get MusicActivated() As Boolean
    MusicActivated = mActivated
End Property
 
''
' Sets wether music is activated or not.
 
Public Property Let MusicActivated(ByVal nValue As Boolean)
    If mActivated = nValue Then Exit Property
   
    mActivated = nValue
   
    If nValue Then
        Call PlayMIDI(CurrentMusicFile)
    Else
        Call StopMidi
    End If
End Property
 
''
' Retrieves wether sound is activated or not.
 
Public Property Get SoundActivated() As Boolean
    SoundActivated = sActivated
End Property
 
''
' Sets wether sound is activated or not.
 
Public Property Let SoundActivated(ByVal nValue As Boolean)
    If sActivated = nValue Then Exit Property
   
    sActivated = nValue
   
    If Not nValue Then
        Call StopWave
    End If
End Property
 
''
' Sets wether sound effects are activated or not.
 
Public Property Let SoundEffectsActivated(ByVal nValue As Boolean)
    sEffectsActivated = nValue
End Property
 
''
' Retrieves wether sound effects are activated or not.
 
Public Property Get SoundEffectsActivated() As Boolean
    SoundEffectsActivated = sEffectsActivated
End Property

