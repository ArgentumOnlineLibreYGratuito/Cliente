Attribute VB_Name = "Application"
'**************************************************************************
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
'**************************************************************************

Option Explicit

Private Const ERROR_ALREADY_EXISTS = 183&
Private Const WAIT_ABANDONED = &H80

Private Declare Function GetActiveWindow Lib "user32" () As Long
Private Declare Function CreateMutex Lib "kernel32" Alias "CreateMutexA" (ByRef lpMutexAttributes As SECURITY_ATTRIBUTES, ByVal bInitialOwner As Long, ByVal lpName As String) As Long
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
  
Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Private MutexID_ As Long

''
' Checks if this is the active (foreground) application or not.
'
' @return   True if any of the app's windows are the foreground window, false otherwise.

Public Function IsAppActive() As Boolean

    IsAppActive = (GetActiveWindow <> 0)
    
End Function

''
' Checks if there's another instance of the app running, returns True if there is or False otherwise.

Public Function IsAppRunning() As Boolean

    Dim Attributes As SECURITY_ATTRIBUTES
    
    With Attributes
        .bInheritHandle = 0
        .lpSecurityDescriptor = 0
        .nLength = LenB(Attributes)
    End With
    
    MutexID_ = CreateMutex(Attributes, False, "Global\" & App.ProductName)

    If (Err.LastDllError = ERROR_ALREADY_EXISTS) Then
        IsAppRunning = True
        
        If (WaitForSingleObject(MutexID_, 100) = WAIT_ABANDONED) Then
            MutexID_ = CreateMutex(Attributes, True, "Global\" & App.ProductName)   ' Takes ownership as the mutex has been abandoned
        
            IsAppRunning = False
        End If
    Else
        IsAppRunning = False
    End If

End Function

''
' Checks if the application is running in the IDE, returns True if it is or False otherwise.

Public Function IsAppDebug() As Boolean

    IsAppDebug = CBool(App.LogMode = 0)
    
End Function
