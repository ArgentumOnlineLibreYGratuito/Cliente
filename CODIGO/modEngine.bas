Attribute VB_Name = "modEngine"
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


' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' [Engine::Services]
' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Public Aurora_Audio    As Audio_Service
Public Aurora_Content  As Content_Service
Public Aurora_Graphic  As Graphic_Service
Public Aurora_Renderer As Graphic_Renderer

' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' [Engine::Network]
' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Private NetConnection_ As Network_Client
Private NetProtocol_   As Network_Protocol

' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' [Engine::Main]
' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Public Sub Initialize()

    Dim Configuration As Kernel_Properties
    Configuration.WindowHandle = frmMain.renderer.hWnd
    Configuration.WindowWidth = frmMain.renderer.ScaleWidth
    Configuration.WindowHeight = frmMain.renderer.ScaleHeight
    Configuration.WindowTitle = "Argentum Online v12.1"
    
    Call Kernel.Initialize(eKernelModeClient, Configuration)

    Set Aurora_Audio = Kernel.Audio
    
    Set Aurora_Content = Kernel.Content
    Call Aurora_Content.AddSystemLocator("Resources", "Resources")

    Set Aurora_Graphic = Kernel.Graphics
    Set Aurora_Renderer = Kernel.renderer
    
End Sub

Public Sub Tick()

    Call Kernel.Tick
    
End Sub

' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' [Engine::Network]
' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Public Sub NetConnect(ByVal Address As String, ByVal Port As Long)
    
    Set NetProtocol_ = New Network_Protocol
    Call NetProtocol_.Attach(AddressOf Network_OnAttach, AddressOf Network_OnDetach, AddressOf Network_OnRecv, AddressOf Network_OnSend, AddressOf Network_OnError)
    
    Set NetConnection_ = Kernel.Network.Connect(Address, Port)
    Call NetConnection_.SetProtocol(NetProtocol_)

    Call modEngine_Protocol.Initialize
    
End Sub

Public Sub NetClose(Optional ByVal Forcibly As Boolean = False)
    
    If (Not NetConnection_ Is Nothing) Then
    
        Call NetConnection_.Close(Forcibly)
        
    End If
    
End Sub

Public Sub NetWrite(ByVal Message As BinaryWriter, Optional ByVal Immediately As Boolean = False)
    
    If (Not NetConnection_ Is Nothing) Then
    
        Call NetConnection_.Write(Message)
        Call Message.Clear
        
        If (Immediately) Then
            Call NetConnection_.Flush
        End If
        
    End If
    
End Sub

Public Sub NetFlush()
    
    If (Not NetConnection_ Is Nothing) Then
    
        Call NetConnection_.Flush
        
    End If

End Sub

Private Sub Network_OnAttach(ByVal Connection As Network_Client)
    
    Call modEngine_Protocol.OnConnect
    
End Sub

Private Sub Network_OnDetach(ByVal Connection As Network_Client)
    
    Call modEngine_Protocol.OnClose
    
End Sub

Private Sub Network_OnRecv(ByVal Connection As Network_Client, ByVal Message As BinaryReader)
    
        
    While (Message.GetAvailable() > 0)
    
        Call modEngine_Protocol.Decode(Message)
        Call modEngine_Protocol.handle(Message)
    
    Wend

End Sub

Private Sub Network_OnSend(ByVal Connection As Network_Client, ByVal Message As BinaryReader)
    
    Call modEngine_Protocol.Encode(Message)

End Sub

Private Sub Network_OnError(ByVal Connection As Network_Client, ByVal Error As Long, ByVal Description As String)

    ' TODO: Log.Error(...)
    
End Sub
