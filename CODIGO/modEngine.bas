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
' [Engine::Network]
' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Private NetConnection_ As Network_Client
Private NetProtocol_   As Network_Protocol

' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
' [Engine::Main]
' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Public Sub Initialize()

    Dim Configuration As Kernel_Properties
    Configuration.WindowWidth = 800
    Configuration.WindowHeight = 600
    Configuration.WindowTitle = "Argentum Online v12.1"
    
    Call Kernel.Initialize(eKernelModeClient, Configuration)

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

Public Sub NetWrite(ByVal Message As BinaryWriter, Optional ByVal Clear As Boolean = True)
    
    If (Not NetConnection_ Is Nothing) Then
    
        Call NetConnection_.Write(Message)
        
        If (Clear) Then
        
            Call Message.Clear
        
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
    
    Call modEngine_Protocol.Decode(Message)
    Call modEngine_Protocol.handle(Message)
    
End Sub

Private Sub Network_OnSend(ByVal Connection As Network_Client, ByVal Message As BinaryReader)
    
    Call modEngine_Protocol.Encode(Message)
    
End Sub

Private Sub Network_OnError(ByVal Connection As Network_Client, ByVal Error As Long, ByVal Description As String)

    ' TODO: Log.Error(...)
    
End Sub

