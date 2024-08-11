Attribute VB_Name = "modEngine_Protocol"
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


Private Enum ServerPacketID
    logged                                       ' LOGGED
    RemoveDialogs                                ' QTDL
    RemoveCharDialog                             ' QDL
    NavigateToggle                               ' NAVEG
    Disconnect                                   ' FINOK
    CommerceEnd                                  ' FINCOMOK
    BankEnd                                      ' FINBANOK
    CommerceInit                                 ' INITCOM
    BankInit                                     ' INITBANCO
    UserCommerceInit                             ' INITCOMUSU
    UserCommerceEnd                              ' FINCOMUSUOK
    ShowBlacksmithForm                           ' SFH
    ShowCarpenterForm                            ' SFC
    NPCSwing                                     ' N1
    NPCKillUser                                  ' 6
    BlockedWithShieldUser                        ' 7
    BlockedWithShieldOther                       ' 8
    UserSwing                                    ' U1
    SafeModeOn                                   ' SEGON
    SafeModeOff                                  ' SEGOFF
    ResuscitationSafeOn
    ResuscitationSafeOff
    NobilityLost                                 ' PN
    CantUseWhileMeditating                       ' M!
    UpdateSta                                    ' ASS
    UpdateMana                                   ' ASM
    UpdateHP                                     ' ASH
    UpdateGold                                   ' ASG
    UpdateExp                                    ' ASE
    ChangeMap                                    ' CM
    PosUpdate                                    ' PU
    NPCHitUser                                   ' N2
    UserHitNPC                                   ' U2
    UserAttackedSwing                            ' U3
    UserHittedByUser                             ' N4
    UserHittedUser                               ' N5
    ChatOverHead                                 ' ||
    ConsoleMsg                                   ' || - Beware!! its the same as above, but it was properly splitted
    GuildChat                                    ' |+
    ShowMessageBox                               ' !!
    UserIndexInServer                            ' IU
    UserCharIndexInServer                        ' IP
    CharacterCreate                              ' CC
    CharacterRemove                              ' BP
    CharacterMove                                ' MP, +, * and _ '
    CharacterChange                              ' CP
    ObjectCreate                                 ' HO
    ObjectDelete                                 ' BO
    BlockPosition                                ' BQ
    PlayMIDI                                     ' TM
    PlayWave                                     ' TW
    guildList                                    ' GL
    AreaChanged                                  ' CA
    PauseToggle                                  ' BKW
    RainToggle                                   ' LLU
    CreateFX                                     ' CFX
    UpdateUserStats                              ' EST
    WorkRequestTarget                            ' T01
    ChangeInventorySlot                          ' CSI
    ChangeBankSlot                               ' SBO
    ChangeSpellSlot                              ' SHS
    Atributes                                    ' ATR
    BlacksmithWeapons                            ' LAH
    BlacksmithArmors                             ' LAR
    CarpenterObjects                             ' OBR
    RestOK                                       ' DOK
    ErrorMsg                                     ' ERR
    Blind                                        ' CEGU
    Dumb                                         ' DUMB
    ChangeNPCInventorySlot                       ' NPCI
    UpdateHungerAndThirst                        ' EHYS
    Fame                                         ' FAMA
    MiniStats                                    ' MEST
    LevelUp                                      ' SUNI
    SetInvisible                                 ' NOVER
    DiceRoll                                     ' DADOS
    MeditateToggle                               ' MEDOK
    BlindNoMore                                  ' NSEGUE
    DumbNoMore                                   ' NESTUP
    SendSkills                                   ' SKILLS
    TrainerCreatureList                          ' LSTCRI
    guildNews                                    ' GUILDNE
    OfferDetails                                 ' PEACEDE & ALLIEDE
    AlianceProposalsList                         ' ALLIEPR
    PeaceProposalsList                           ' PEACEPR
    CharacterInfo                                ' CHRINFO
    GuildLeaderInfo                              ' LEADERI
    GuildDetails                                 ' CLANDET
    ShowGuildFundationForm                       ' SHOWFUN
    ParalizeOK                                   ' PARADOK
    ShowUserRequest                              ' PETICIO
    TradeOK                                      ' TRANSOK
    BankOK                                       ' BANCOOK
    ChangeUserTradeSlot                          ' COMUSUINV
    SendNight                                    ' NOC
    Pong
    UpdateTagAndStatus
    
    'GM messages
    SpawnList                                    ' SPL
    ShowSOSForm                                  ' MSOS
    ShowMOTDEditionForm                          ' ZMOTD
    ShowGMPanelForm                              ' ABPANEL
    UserNameList                                 ' LISTUSU
End Enum

Private Enum ClientPacketID
    LoginExistingChar                            'OLOGIN
    ThrowDices                                   'TIRDAD
    LoginNewChar                                 'NLOGIN
    Talk                                         ';
    Yell                                         '-
    Whisper                                      '\
    Walk                                         'M
    RequestPositionUpdate                        'RPU
    Attack                                       'AT
    PickUp                                       'AG
    CombatModeToggle                             'TAB        - SHOULD BE HANLDED JUST BY THE CLIENT!!
    SafeToggle                                   '/SEG & SEG  (SEG's behaviour has to be coded in the client)
    ResuscitationSafeToggle
    RequestGuildLeaderInfo                       'GLINFO
    RequestAtributes                             'ATR
    RequestFame                                  'FAMA
    RequestSkills                                'ESKI
    RequestMiniStats                             'FEST
    CommerceEnd                                  'FINCOM
    UserCommerceEnd                              'FINCOMUSU
    BankEnd                                      'FINBAN
    UserCommerceOk                               'COMUSUOK
    UserCommerceReject                           'COMUSUNO
    Drop                                         'TI
    CastSpell                                    'LH
    LeftClick                                    'LC
    DoubleClick                                  'RC
    Work                                         'UK
    UseSpellMacro                                'UMH
    UseItem                                      'USA
    CraftBlacksmith                              'CNS
    CraftCarpenter                               'CNC
    WorkLeftClick                                'WLC
    CreateNewGuild                               'CIG
    SpellInfo                                    'INFS
    EquipItem                                    'EQUI
    ChangeHeading                                'CHEA
    ModifySkills                                 'SKSE
    Train                                        'ENTR
    CommerceBuy                                  'COMP
    BankExtractItem                              'RETI
    CommerceSell                                 'VEND
    BankDeposit                                  'DEPO
    ForumPost                                    'DEMSG
    MoveSpell                                    'DESPHE
    ClanCodexUpdate                              'DESCOD
    UserCommerceOffer                            'OFRECER
    GuildAcceptPeace                             'ACEPPEAT
    GuildRejectAlliance                          'RECPALIA
    GuildRejectPeace                             'RECPPEAT
    GuildAcceptAlliance                          'ACEPALIA
    GuildOfferPeace                              'PEACEOFF
    GuildOfferAlliance                           'ALLIEOFF
    GuildAllianceDetails                         'ALLIEDET
    GuildPeaceDetails                            'PEACEDET
    GuildRequestJoinerInfo                       'ENVCOMEN
    GuildAlliancePropList                        'ENVALPRO
    GuildPeacePropList                           'ENVPROPP
    GuildDeclareWar                              'DECGUERR
    GuildNewWebsite                              'NEWWEBSI
    GuildAcceptNewMember                         'ACEPTARI
    GuildRejectNewMember                         'RECHAZAR
    GuildKickMember                              'ECHARCLA
    GuildUpdateNews                              'ACTGNEWS
    GuildMemberInfo                              '1HRINFO<
    GuildOpenElections                           'ABREELEC
    GuildRequestMembership                       'SOLICITUD
    GuildRequestDetails                          'CLANDETAILS
    Online                                       '/ONLINE
    Quit                                         '/SALIR
    GuildLeave                                   '/SALIRCLAN
    RequestAccountState                          '/BALANCE
    PetStand                                     '/QUIETO
    PetFollow                                    '/ACOMPAÑAR
    TrainList                                    '/ENTRENAR
    Rest                                         '/DESCANSAR
    Meditate                                     '/MEDITAR
    Resucitate                                   '/RESUCITAR
    Heal                                         '/CURAR
    Help                                         '/AYUDA
    RequestStats                                 '/EST
    CommerceStart                                '/COMERCIAR
    BankStart                                    '/BOVEDA
    Enlist                                       '/ENLISTAR
    Information                                  '/INFORMACION
    Reward                                       '/RECOMPENSA
    RequestMOTD                                  '/MOTD
    Uptime                                       '/UPTIME
    PartyLeave                                   '/SALIRPARTY
    PartyCreate                                  '/CREARPARTY
    PartyJoin                                    '/PARTY
    Inquiry                                      '/ENCUESTA ( params )
    GuildMessage                                 '/CMSG
    PartyMessage                                 '/PMSG
    CentinelReport                               '/CENTINELA
    GuildOnline                                  '/ONLINECLAN
    PartyOnline                                  '/ONLINEPARTY
    CouncilMessage                               '/BMSG
    RoleMasterRequest                            '/ROL
    GMRequest                                    '/GM
    bugReport                                    '/_BUG
    ChangeDescription                            '/DESC
    GuildVote                                    '/VOTO
    Punishments                                  '/PENAS
    ChangePassword                               '/CONTRASEÑA
    Gamble                                       '/APOSTAR
    InquiryVote                                  '/ENCUESTA ( with parameters )
    LeaveFaction                                 '/RETIRAR ( with no arguments )
    BankExtractGold                              '/RETIRAR ( with arguments )
    BankDepositGold                              '/DEPOSITAR
    Denounce                                     '/DENUNCIAR
    GuildFundate                                 '/FUNDARCLAN
    PartyKick                                    '/ECHARPARTY
    PartySetLeader                               '/PARTYLIDER
    PartyAcceptMember                            '/ACCEPTPARTY
    Ping                                         '/PING
    
    'GM messages
    GMMessage                                    '/GMSG
    showName                                     '/SHOWNAME
    OnlineRoyalArmy                              '/ONLINEREAL
    OnlineChaosLegion                            '/ONLINECAOS
    GoNearby                                     '/IRCERCA
    comment                                      '/REM
    serverTime                                   '/HORA
    Where                                        '/DONDE
    CreaturesInMap                               '/NENE
    WarpMeToTarget                               '/TELEPLOC
    WarpChar                                     '/TELEP
    Silence                                      '/SILENCIAR
    SOSShowList                                  '/SHOW SOS
    SOSRemove                                    'SOSDONE
    GoToChar                                     '/IRA
    invisible                                    '/INVISIBLE
    GMPanel                                      '/PANELGM
    RequestUserList                              'LISTUSU
    Working                                      '/TRABAJANDO
    Hiding                                       '/OCULTANDO
    Jail                                         '/CARCEL
    KillNPC                                      '/RMATA
    WarnUser                                     '/ADVERTENCIA
    EditChar                                     '/MOD
    RequestCharInfo                              '/INFO
    RequestCharStats                             '/STAT
    RequestCharGold                              '/BAL
    RequestCharInventory                         '/INV
    RequestCharBank                              '/BOV
    RequestCharSkills                            '/SKILLS
    ReviveChar                                   '/REVIVIR
    OnlineGM                                     '/ONLINEGM
    OnlineMap                                    '/ONLINEMAP
    Forgive                                      '/PERDON
    Kick                                         '/ECHAR
    Execute                                      '/EJECUTAR
    BanChar                                      '/BAN
    UnbanChar                                    '/UNBAN
    NPCFollow                                    '/SEGUIR
    SummonChar                                   '/SUM
    SpawnListRequest                             '/CC
    SpawnCreature                                'SPA
    ResetNPCInventory                            '/RESETINV
    CleanWorld                                   '/LIMPIAR
    ServerMessage                                '/RMSG
    NickToIP                                     '/NICK2IP
    IPToNick                                     '/IP2NICK
    GuildOnlineMembers                           '/ONCLAN
    TeleportCreate                               '/CT
    TeleportDestroy                              '/DT
    RainToggle                                   '/LLUVIA
    SetCharDescription                           '/SETDESC
    ForceMIDIToMap                               '/FORCEMIDIMAP
    ForceWAVEToMap                               '/FORCEWAVMAP
    RoyalArmyMessage                             '/REALMSG
    ChaosLegionMessage                           '/CAOSMSG
    CitizenMessage                               '/CIUMSG
    CriminalMessage                              '/CRIMSG
    TalkAsNPC                                    '/TALKAS
    DestroyAllItemsInArea                        '/MASSDEST
    AcceptRoyalCouncilMember                     '/ACEPTCONSE
    AcceptChaosCouncilMember                     '/ACEPTCONSECAOS
    ItemsInTheFloor                              '/PISO
    MakeDumb                                     '/ESTUPIDO
    MakeDumbNoMore                               '/NOESTUPIDO
    DumpIPTables                                 '/DUMPSECURITY
    CouncilKick                                  '/KICKCONSE
    SetTrigger                                   '/TRIGGER
    AskTrigger                                   '/TRIGGER with no arguments
    BannedIPList                                 '/BANIPLIST
    BannedIPReload                               '/BANIPRELOAD
    GuildMemberList                              '/MIEMBROSCLAN
    GuildBan                                     '/BANCLAN
    BanIP                                        '/BANIP
    UnbanIP                                      '/UNBANIP
    CreateItem                                   '/CI
    DestroyItems                                 '/DEST
    ChaosLegionKick                              '/NOCAOS
    RoyalArmyKick                                '/NOREAL
    ForceMIDIAll                                 '/FORCEMIDI
    ForceWAVEAll                                 '/FORCEWAV
    RemovePunishment                             '/BORRARPENA
    TileBlockedToggle                            '/BLOQ
    KillNPCNoRespawn                             '/MATA
    KillAllNearbyNPCs                            '/MASSKILL
    LastIP                                       '/LASTIP
    ChangeMOTD                                   '/MOTDCAMBIA
    SetMOTD                                      'ZMOTD
    SystemMessage                                '/SMSG
    CreateNPC                                    '/ACC
    CreateNPCWithRespawn                         '/RACC
    ImperialArmour                               '/AI1 - 4
    ChaosArmour                                  '/AC1 - 4
    NavigateToggle                               '/NAVE
    ServerOpenToUsersToggle                      '/HABILITAR
    TurnOffServer                                '/APAGAR
    TurnCriminal                                 '/CONDEN
    ResetFactions                                '/RAJAR
    RemoveCharFromGuild                          '/RAJARCLAN
    RequestCharMail                              '/LASTEMAIL
    AlterPassword                                '/APASS
    AlterMail                                    '/AEMAIL
    AlterName                                    '/ANAME
    ToggleCentinelActivated                      '/CENTINELAACTIVADO
    DoBackUp                                     '/DOBACKUP
    ShowGuildMessages                            '/SHOWCMSG
    SaveMap                                      '/GUARDAMAPA
    ChangeMapInfoPK                              '/MODMAPINFO PK
    ChangeMapInfoBackup                          '/MODMAPINFO BACKUP
    ChangeMapInfoRestricted                      '/MODMAPINFO RESTRINGIR
    ChangeMapInfoNoMagic                         '/MODMAPINFO MAGIASINEFECTO
    ChangeMapInfoNoInvi                          '/MODMAPINFO INVISINEFECTO
    ChangeMapInfoNoResu                          '/MODMAPINFO RESUSINEFECTO
    ChangeMapInfoLand                            '/MODMAPINFO TERRENO
    ChangeMapInfoZone                            '/MODMAPINFO ZONA
    SaveChars                                    '/GRABAR
    CleanSOS                                     '/BORRAR SOS
    ShowServerForm                               '/SHOW INT
    night                                        '/NOCHE
    KickAllChars                                 '/ECHARTODOSPJS
    ReloadNPCs                                   '/RELOADNPCS
    ReloadServerIni                              '/RELOADSINI
    ReloadSpells                                 '/RELOADHECHIZOS
    ReloadObjects                                '/RELOADOBJ
    Restart                                      '/REINICIAR
    ChatColor                                    '/CHATCOLOR
    Ignored                                      '/IGNORADO
    CheckSlot                                    '/SLOT
End Enum

Private Writer_ As BinaryWriter

Public Sub Initialize()

    Set Writer_ = New BinaryWriter
    
End Sub

Public Sub OnConnect()
    Select Case EstadoLogin
    Case E_MODO.CrearNuevoPj
        Call WriteLoginNewChar


    Case E_MODO.Normal
        Call WriteLoginExistingChar

    Case E_MODO.Dados
            
        frmCrearPersonaje.Show
    End Select
    
End Sub

Public Sub OnClose()
    Dim i As Long
    
    frmMain.Second.Enabled = False
    Connected = False

    frmConnect.MousePointer = vbNormal
    
    If Not frmPasswd.Visible And Not frmCrearPersonaje.Visible Then
        frmConnect.Visible = True
    End If
    
    On Local Error Resume Next
    For i = 0 To Forms.Count - 1
        If Forms(i).Name <> frmMain.Name And Forms(i).Name <> frmConnect.Name And Forms(i).Name <> frmOldPersonaje.Name And Forms(i).Name <> frmCrearPersonaje.Name And Forms(i).Name <> frmPasswd.Name Then
            Unload Forms(i)
        End If
    Next i
    On Local Error GoTo 0
    
    frmMain.Visible = False

    pausa = False
    UserMeditar = False

    UserClase = 0
    UserSexo = 0
    UserRaza = 0
    UserHogar = 0
    UserEmail = ""
    
    For i = 1 To NUMSKILLS
        UserSkills(i) = 0
    Next i

    For i = 1 To NUMATRIBUTOS
        UserAtributos(i) = 0
    Next i

    SkillPoints = 0
    Alocados = 0

    Set Dialogos = New clsDialogs
    
End Sub

Public Sub Encode(ByVal Message As BinaryReader)

    ' Here goes encode function
    
End Sub

Public Sub Decode(ByVal Message As BinaryReader)

    ' Here goes decode function
    
End Sub

Public Sub handle(ByVal Message As BinaryReader)

    While (Message.GetAvailable() > 0)
    
        Select Case Message.ReadInt()
        
        Case ServerPacketID.logged               ' LOGGED
            Call HandleLogged(Message)
                
        Case ServerPacketID.RemoveDialogs        ' QTDL
            Call HandleRemoveDialogs(Message)
                
        Case ServerPacketID.RemoveCharDialog     ' QDL
            Call HandleRemoveCharDialog(Message)
                
        Case ServerPacketID.NavigateToggle       ' NAVEG
            Call HandleNavigateToggle(Message)
                
        Case ServerPacketID.Disconnect           ' FINOK
            Call HandleDisconnect(Message)
                
        Case ServerPacketID.CommerceEnd          ' FINCOMOK
            Call HandleCommerceEnd(Message)
            
        Case ServerPacketID.BankEnd              ' FINBANOK
            Call HandleBankEnd(Message)
            
        Case ServerPacketID.CommerceInit         ' INITCOM
            Call HandleCommerceInit(Message)
            
        Case ServerPacketID.BankInit             ' INITBANCO
            Call HandleBankInit(Message)
            
        Case ServerPacketID.UserCommerceInit     ' INITCOMUSU
            Call HandleUserCommerceInit(Message)
            
        Case ServerPacketID.UserCommerceEnd      ' FINCOMUSUOK
            Call HandleUserCommerceEnd(Message)
            
        Case ServerPacketID.ShowBlacksmithForm   ' SFH
            Call HandleShowBlacksmithForm(Message)
            
        Case ServerPacketID.ShowCarpenterForm    ' SFC
            Call HandleShowCarpenterForm(Message)
            
        Case ServerPacketID.NPCSwing             ' N1
            Call HandleNPCSwing(Message)
            
        Case ServerPacketID.NPCKillUser          ' 6
            Call HandleNPCKillUser(Message)
            
        Case ServerPacketID.BlockedWithShieldUser ' 7
            Call HandleBlockedWithShieldUser(Message)
            
        Case ServerPacketID.BlockedWithShieldOther ' 8
            Call HandleBlockedWithShieldOther(Message)
            
        Case ServerPacketID.UserSwing            ' U1
            Call HandleUserSwing(Message)

        Case ServerPacketID.SafeModeOn           ' SEGON
            Call HandleSafeModeOn(Message)
            
        Case ServerPacketID.SafeModeOff          ' SEGOFF
            Call HandleSafeModeOff(Message)
                
        Case ServerPacketID.ResuscitationSafeOff
            Call HandleResuscitationSafeOff(Message)
            
        Case ServerPacketID.ResuscitationSafeOn
            Call HandleResuscitationSafeOn(Message)
            
        Case ServerPacketID.NobilityLost         ' PN
            Call HandleNobilityLost(Message)
            
        Case ServerPacketID.CantUseWhileMeditating ' M!
            Call HandleCantUseWhileMeditating(Message)
            
        Case ServerPacketID.UpdateSta            ' ASS
            Call HandleUpdateSta(Message)
            
        Case ServerPacketID.UpdateMana           ' ASM
            Call HandleUpdateMana(Message)
            
        Case ServerPacketID.UpdateHP             ' ASH
            Call HandleUpdateHP(Message)
            
        Case ServerPacketID.UpdateGold           ' ASG
            Call HandleUpdateGold(Message)
            
        Case ServerPacketID.UpdateExp            ' ASE
            Call HandleUpdateExp(Message)
            
        Case ServerPacketID.ChangeMap            ' CM
            Call HandleChangeMap(Message)
            
        Case ServerPacketID.PosUpdate            ' PU
            Call HandlePosUpdate(Message)
            
        Case ServerPacketID.NPCHitUser           ' N2
            Call HandleNPCHitUser(Message)
            
        Case ServerPacketID.UserHitNPC           ' U2
            Call HandleUserHitNPC(Message)
            
        Case ServerPacketID.UserAttackedSwing    ' U3
            Call HandleUserAttackedSwing(Message)
            
        Case ServerPacketID.UserHittedByUser     ' N4
            Call HandleUserHittedByUser(Message)
            
        Case ServerPacketID.UserHittedUser       ' N5
            Call HandleUserHittedUser(Message)
            
        Case ServerPacketID.ChatOverHead         ' ||
            Call HandleChatOverHead(Message)
            
        Case ServerPacketID.ConsoleMsg           ' || - Beware!! its the same as above, but it was properly splitted
            Call HandleConsoleMessage(Message)
            
        Case ServerPacketID.GuildChat            ' |+
            Call HandleGuildChat(Message)
            
        Case ServerPacketID.ShowMessageBox       ' !!
            Call HandleShowMessageBox(Message)
            
        Case ServerPacketID.UserIndexInServer    ' IU
            Call HandleUserIndexInServer(Message)
            
        Case ServerPacketID.UserCharIndexInServer ' IP
            Call HandleUserCharIndexInServer(Message)
            
        Case ServerPacketID.CharacterCreate      ' CC
            Call HandleCharacterCreate(Message)
            
        Case ServerPacketID.CharacterRemove      ' BP
            Call HandleCharacterRemove(Message)
            
        Case ServerPacketID.CharacterMove        ' MP, +, * and _ '
            Call HandleCharacterMove(Message)
            
        Case ServerPacketID.CharacterChange      ' CP
            Call HandleCharacterChange(Message)
            
        Case ServerPacketID.ObjectCreate         ' HO
            Call HandleObjectCreate(Message)
            
        Case ServerPacketID.ObjectDelete         ' BO
            Call HandleObjectDelete(Message)
            
        Case ServerPacketID.BlockPosition        ' BQ
            Call HandleBlockPosition(Message)
            
        Case ServerPacketID.PlayMIDI             ' TM
            Call HandlePlayMIDI(Message)
            
        Case ServerPacketID.PlayWave             ' TW
            Call HandlePlayWave(Message)
            
        Case ServerPacketID.guildList            ' GL
            Call HandleGuildList(Message)
            
        Case ServerPacketID.AreaChanged          ' CA
            Call HandleAreaChanged(Message)
            
        Case ServerPacketID.PauseToggle          ' BKW
            Call HandlePauseToggle(Message)
            
        Case ServerPacketID.RainToggle           ' LLU
            Call HandleRainToggle(Message)
            
        Case ServerPacketID.CreateFX             ' CFX
            Call HandleCreateFX(Message)
            
        Case ServerPacketID.UpdateUserStats      ' EST
            Call HandleUpdateUserStats(Message)
            
        Case ServerPacketID.WorkRequestTarget    ' T01
            Call HandleWorkRequestTarget(Message)
            
        Case ServerPacketID.ChangeInventorySlot  ' CSI
            Call HandleChangeInventorySlot(Message)
            
        Case ServerPacketID.ChangeBankSlot       ' SBO
            Call HandleChangeBankSlot(Message)
            
        Case ServerPacketID.ChangeSpellSlot      ' SHS
            Call HandleChangeSpellSlot(Message)
            
        Case ServerPacketID.Atributes            ' ATR
            Call HandleAtributes(Message)
            
        Case ServerPacketID.BlacksmithWeapons    ' LAH
            Call HandleBlacksmithWeapons(Message)
            
        Case ServerPacketID.BlacksmithArmors     ' LAR
            Call HandleBlacksmithArmors(Message)
            
        Case ServerPacketID.CarpenterObjects     ' OBR
            Call HandleCarpenterObjects(Message)
            
        Case ServerPacketID.RestOK               ' DOK
            Call HandleRestOK(Message)
            
        Case ServerPacketID.ErrorMsg             ' ERR
            Call HandleErrorMessage(Message)
            
        Case ServerPacketID.Blind                ' CEGU
            Call HandleBlind(Message)
            
        Case ServerPacketID.Dumb                 ' DUMB
            Call HandleDumb(Message)
       
        Case ServerPacketID.ChangeNPCInventorySlot ' NPCI
            Call HandleChangeNPCInventorySlot(Message)
            
        Case ServerPacketID.UpdateHungerAndThirst ' EHYS
            Call HandleUpdateHungerAndThirst(Message)
            
        Case ServerPacketID.Fame                 ' FAMA
            Call HandleFame(Message)
            
        Case ServerPacketID.MiniStats            ' MEST
            Call HandleMiniStats(Message)
            
        Case ServerPacketID.LevelUp              ' SUNI
            Call HandleLevelUp(Message)

        Case ServerPacketID.SetInvisible         ' NOVER
            Call HandleSetInvisible(Message)
            
        Case ServerPacketID.DiceRoll             ' DADOS
            Call HandleDiceRoll(Message)
            
        Case ServerPacketID.MeditateToggle       ' MEDOK
            Call HandleMeditateToggle(Message)
            
        Case ServerPacketID.BlindNoMore          ' NSEGUE
            Call HandleBlindNoMore(Message)
            
        Case ServerPacketID.DumbNoMore           ' NESTUP
            Call HandleDumbNoMore(Message)
            
        Case ServerPacketID.SendSkills           ' SKILLS
            Call HandleSendSkills(Message)
            
        Case ServerPacketID.TrainerCreatureList  ' LSTCRI
            Call HandleTrainerCreatureList(Message)
            
        Case ServerPacketID.guildNews            ' GUILDNE
            Call HandleGuildNews(Message)
            
        Case ServerPacketID.OfferDetails         ' PEACEDE and ALLIEDE
            Call HandleOfferDetails(Message)
            
        Case ServerPacketID.AlianceProposalsList ' ALLIEPR
            Call HandleAlianceProposalsList(Message)
            
        Case ServerPacketID.PeaceProposalsList   ' PEACEPR
            Call HandlePeaceProposalsList(Message)
            
        Case ServerPacketID.CharacterInfo        ' CHRINFO
            Call HandleCharacterInfo(Message)
            
        Case ServerPacketID.GuildLeaderInfo      ' LEADERI
            Call HandleGuildLeaderInfo(Message)
            
        Case ServerPacketID.GuildDetails         ' CLANDET
            Call HandleGuildDetails(Message)
            
        Case ServerPacketID.ShowGuildFundationForm ' SHOWFUN
            Call HandleShowGuildFundationForm(Message)
            
        Case ServerPacketID.ParalizeOK           ' PARADOK
            Call HandleParalizeOK(Message)
            
        Case ServerPacketID.ShowUserRequest      ' PETICIO
            Call HandleShowUserRequest(Message)
            
        Case ServerPacketID.TradeOK              ' TRANSOK
            Call HandleTradeOK(Message)
            
        Case ServerPacketID.BankOK               ' BANCOOK
            Call HandleBankOK(Message)
            
        Case ServerPacketID.ChangeUserTradeSlot  ' COMUSUINV
            Call HandleChangeUserTradeSlot(Message)
                
        Case ServerPacketID.SendNight            ' NOC
            Call HandleSendNight(Message)
            
        Case ServerPacketID.Pong
            Call HandlePong(Message)
            
        Case ServerPacketID.UpdateTagAndStatus
            Call HandleUpdateTagAndStatus(Message)

        Case ServerPacketID.SpawnList            ' SPL
            Call HandleSpawnList(Message)
            
        Case ServerPacketID.ShowSOSForm          ' RSOS and MSOS
            Call HandleShowSOSForm(Message)
            
        Case ServerPacketID.ShowMOTDEditionForm  ' ZMOTD
            Call HandleShowMOTDEditionForm(Message)
            
        Case ServerPacketID.ShowGMPanelForm      ' ABPANEL
            Call HandleShowGMPanelForm(Message)
            
        Case ServerPacketID.UserNameList         ' LISTUSU
            Call HandleUserNameList(Message)
    
        Case Else
            Exit Sub

        End Select
    
    Wend

End Sub

Private Sub HandleLogged(ByVal Message As BinaryReader)
    
    ' Variable initialization
    UserCiego = False
    EngineRun = True
    IScombate = False
    UserDescansar = False
    Nombres = True
    
    'Set connected state
    Call SetConnected

End Sub

Private Sub HandleRemoveDialogs(ByVal Message As BinaryReader)
    
    Call Dialogos.RemoveAllDialogs
End Sub

Private Sub HandleRemoveCharDialog(ByVal Message As BinaryReader)
    
    'Check if the packet is complete
    
    Call Dialogos.RemoveDialog(Message.ReadInt())
End Sub

Private Sub HandleNavigateToggle(ByVal Message As BinaryReader)
    
    UserNavegando = Not UserNavegando
End Sub

Private Sub HandleDisconnect(ByVal Message As BinaryReader)
    
    Dim i           As Long
    
    'Hide main form
    frmMain.Visible = False
    frmMain.Label1.Visible = False
    
    'Stop audio
    Call Audio.StopWave
    frmMain.IsPlaying = PlayLoop.plNone
    
    'Show connection form
    frmConnect.Visible = True
    
    'Reset global vars
    UserParalizado = False
    IScombate = False
    pausa = False
    UserMeditar = False
    UserDescansar = False
    UserNavegando = False
    bRain = False
    bFogata = False
    SkillPoints = 0
    
    'Delete all kind of dialogs
    Call CleanDialogs
    
    'Reset some char variables...
    For i = 1 To LastChar
        charlist(i).invisible = False
    Next i
    
    'Unload all forms except frmMain and frmConnect
    Dim frm         As Form
    
    For Each frm In Forms
        If frm.Name <> frmMain.Name And frm.Name <> frmConnect.Name Then
            Unload frm
        End If
    Next
    
End Sub

Private Sub HandleCommerceEnd(ByVal Message As BinaryReader)
    
    'Clear item's list
    frmComerciar.List1(0).Clear
    frmComerciar.List1(1).Clear
    
    'Reset vars
    Comerciando = False
    
    'Hide form
    Unload frmComerciar
End Sub

Private Sub HandleBankEnd(ByVal Message As BinaryReader)
    
    frmBancoObj.List1(0).Clear
    frmBancoObj.List1(1).Clear
    
    Unload frmBancoObj
    Comerciando = False
End Sub

Private Sub HandleCommerceInit(ByVal Message As BinaryReader)
    
    Dim i           As Long
    
    'Fill our inventory list
    For i = 1 To MAX_INVENTORY_SLOTS
        If Inventario.OBJIndex(i) <> 0 Then
            frmComerciar.List1(1).AddItem Inventario.ItemName(i)
        Else
            frmComerciar.List1(1).AddItem ""
        End If
    Next i
    
    'Set state and show form
    Comerciando = True
    frmComerciar.Show , frmMain
End Sub

Private Sub HandleBankInit(ByVal Message As BinaryReader)
    
    Dim i           As Long
    
    Call frmBancoObj.List1(1).Clear
    
    'Fill the inventory list
    For i = 1 To MAX_INVENTORY_SLOTS
        If Inventario.OBJIndex(i) <> 0 Then
            frmBancoObj.List1(1).AddItem Inventario.ItemName(i)
        Else
            frmBancoObj.List1(1).AddItem ""
        End If
    Next i
    
    Call frmBancoObj.List1(0).Clear
    
    'Fill the bank list
    For i = 1 To MAX_BANCOINVENTORY_SLOTS
        If UserBancoInventory(i).OBJIndex <> 0 Then
            frmBancoObj.List1(0).AddItem UserBancoInventory(i).Name
        Else
            frmBancoObj.List1(0).AddItem ""
        End If
    Next i
    
    'Set state and show form
    Comerciando = True
    frmBancoObj.Show , frmMain
End Sub

Private Sub HandleUserCommerceInit(ByVal Message As BinaryReader)
    
    Dim i           As Long
    
    'Clears lists if necessary
    If frmComerciarUsu.List1.ListCount > 0 Then frmComerciarUsu.List1.Clear
    If frmComerciarUsu.List2.ListCount > 0 Then frmComerciarUsu.List2.Clear
    
    'Fill inventory list
    For i = 1 To MAX_INVENTORY_SLOTS
        If Inventario.OBJIndex(i) <> 0 Then
            frmComerciarUsu.List1.AddItem Inventario.ItemName(i)
            frmComerciarUsu.List1.ItemData(frmComerciarUsu.List1.NewIndex) = Inventario.Amount(i)
        Else
            frmComerciarUsu.List1.AddItem ""
            frmComerciarUsu.List1.ItemData(frmComerciarUsu.List1.NewIndex) = 0
        End If
    Next i
    
    'Set state and show form
    Comerciando = True
    frmComerciarUsu.Show , frmMain
End Sub

Private Sub HandleUserCommerceEnd(ByVal Message As BinaryReader)
    
    'Clear the lists
    frmComerciarUsu.List1.Clear
    frmComerciarUsu.List2.Clear
    
    'Destroy the form and reset the state
    Unload frmComerciarUsu
    Comerciando = False
End Sub

Private Sub HandleShowBlacksmithForm(ByVal Message As BinaryReader)
    
    If frmMain.macrotrabajo.Enabled And (MacroBltIndex > 0) Then
        Call WriteCraftBlacksmith(MacroBltIndex)
    Else
        frmHerrero.Show , frmMain
    End If
End Sub

Private Sub HandleShowCarpenterForm(ByVal Message As BinaryReader)
    
    If frmMain.macrotrabajo.Enabled And (MacroBltIndex > 0) Then
        Call WriteCraftCarpenter(MacroBltIndex)
    Else
        frmCarp.Show , frmMain
    End If
End Sub

Private Sub HandleNPCSwing(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_CRIATURA_FALLA_GOLPE, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleNPCKillUser(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_CRIATURA_MATADO, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleBlockedWithShieldUser(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_RECHAZO_ATAQUE_ESCUDO, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleBlockedWithShieldOther(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_USUARIO_RECHAZO_ATAQUE_ESCUDO, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleUserSwing(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_FALLADO_GOLPE, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleSafeModeOn(ByVal Message As BinaryReader)
    
    Call frmMain.DibujarSeguro
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_SEGURO_ACTIVADO, 0, 255, 0, True, False, False)
End Sub

Private Sub HandleSafeModeOff(ByVal Message As BinaryReader)
    
    Call frmMain.DesDibujarSeguro
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_SEGURO_DESACTIVADO, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleResuscitationSafeOff(ByVal Message As BinaryReader)
    
    Call frmMain.ControlSeguroResu(False)
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_SEGURO_RESU_OFF, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleResuscitationSafeOn(ByVal Message As BinaryReader)
    Call frmMain.ControlSeguroResu(True)
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_SEGURO_RESU_ON, 0, 255, 0, True, False, False)
End Sub

Private Sub HandleNobilityLost(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PIERDE_NOBLEZA, 255, 0, 0, False, False, False)
End Sub

Private Sub HandleCantUseWhileMeditating(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_USAR_MEDITANDO, 255, 0, 0, False, False, False)
End Sub

Private Sub HandleUpdateSta(ByVal Message As BinaryReader)
    
    'Get data and update form
    UserMinSTA = Message.ReadInt()
    frmMain.STAShp.Width = (((UserMinSTA / 100) / (UserMaxSTA / 100)) * 94)
End Sub

Private Sub HandleUpdateMana(ByVal Message As BinaryReader)
    
    'Get data and update form
    UserMinMAN = Message.ReadInt()
    
    If UserMaxMAN > 0 Then
        frmMain.MANShp.Width = (((UserMinMAN + 1 / 100) / (UserMaxMAN + 1 / 100)) * 94)
    Else
        frmMain.MANShp.Width = 0
    End If
End Sub

Private Sub HandleUpdateHP(ByVal Message As BinaryReader)
    
    'Get data and update form
    UserMinHP = Message.ReadInt()
    frmMain.Hpshp.Width = (((UserMinHP / 100) / (UserMaxHP / 100)) * 94)
    
    'Is the user alive
    If UserMinHP = 0 Then
        UserEstado = 1
    Else
        UserEstado = 0
    End If
End Sub

Private Sub HandleUpdateGold(ByVal Message As BinaryReader)
    
    'Get data and update form
    UserGLD = Message.ReadInt()
    
    If UserGLD >= CLng(UserLvl) * 10000 Then
        'Changes color
        frmMain.GldLbl.ForeColor = &HFF&         'Red
    Else
        'Changes color
        frmMain.GldLbl.ForeColor = &HFFFF&       'Yellow
    End If
    
    frmMain.GldLbl.Caption = UserGLD
End Sub

Private Sub HandleUpdateExp(ByVal Message As BinaryReader)
    
    'Get data and update form
    UserExp = Message.ReadInt()
    frmMain.exp.Caption = "Exp: " & UserExp & "/" & UserPasarNivel
    frmMain.lblPorcLvl.Caption = "[" & Round(CDbl(UserExp) * CDbl(100) / CDbl(UserPasarNivel), 2) & "%]"
End Sub

Private Sub HandleChangeMap(ByVal Message As BinaryReader)
    
    UserMap = Message.ReadInt()
    
    'TODO: Once on-the-fly editor is implemented check for map version before loading....
    'For now we just drop it
    Call Message.ReadInt
    
    If FileExist(DirMapas & "Mapa" & UserMap & ".map", vbNormal) Then
        Call SwitchMap(UserMap)
        If bLluvia(UserMap) = 0 Then
            If bRain Then
                Call Audio.StopWave(RainBufferIndex)
                RainBufferIndex = 0
                frmMain.IsPlaying = PlayLoop.plNone
            End If
        End If
    Else
        'no encontramos el mapa en el hd
        MsgBox "Error en los mapas, algún archivo ha sido modificado o esta dañado."
        
        Call CloseClient
    End If
End Sub

Private Sub HandlePosUpdate(ByVal Message As BinaryReader)
    
    'Remove char from old position
    If MapData(UserPos.x, UserPos.y).CharIndex = UserCharIndex Then
        MapData(UserPos.x, UserPos.y).CharIndex = 0
    End If
    
    'Set new pos
    UserPos.x = Message.ReadInt()
    UserPos.y = Message.ReadInt()
    
    'Set char
    MapData(UserPos.x, UserPos.y).CharIndex = UserCharIndex
    charlist(UserCharIndex).Pos = UserPos
    
    'Are we under a roof
    bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
                 MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
                 MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
    
    'Update pos label
    frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
End Sub

Private Sub HandleNPCHitUser(ByVal Message As BinaryReader)
    
    Select Case Message.ReadInt()
    Case bCabeza
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_CABEZA & CStr(Message.ReadInt()), 255, 0, 0, True, False, False)
    Case bBrazoIzquierdo
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_BRAZO_IZQ & CStr(Message.ReadInt()), 255, 0, 0, True, False, False)
    Case bBrazoDerecho
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_BRAZO_DER & CStr(Message.ReadInt()), 255, 0, 0, True, False, False)
    Case bPiernaIzquierda
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_PIERNA_IZQ & CStr(Message.ReadInt()), 255, 0, 0, True, False, False)
    Case bPiernaDerecha
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_PIERNA_DER & CStr(Message.ReadInt()), 255, 0, 0, True, False, False)
    Case bTorso
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_TORSO & CStr(Message.ReadInt()), 255, 0, 0, True, False, False)
    End Select
End Sub

Private Sub HandleUserHitNPC(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_GOLPE_CRIATURA_1 & CStr(Message.ReadInt()) & MENSAJE_2, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleUserAttackedSwing(ByVal Message As BinaryReader)
    
    Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & charlist(Message.ReadInt()).Nombre & MENSAJE_ATAQUE_FALLO, 255, 0, 0, True, False, False)
End Sub

Private Sub HandleUserHittedByUser(ByVal Message As BinaryReader)
    
    Dim attacker    As String
    
    attacker = charlist(Message.ReadInt()).Nombre
    
    Select Case Message.ReadInt
    Case bCabeza
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_CABEZA & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bBrazoIzquierdo
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_BRAZO_IZQ & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bBrazoDerecho
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_BRAZO_DER & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bPiernaIzquierda
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_PIERNA_IZQ & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bPiernaDerecha
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_PIERNA_DER & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bTorso
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_1 & attacker & MENSAJE_RECIVE_IMPACTO_TORSO & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    End Select
End Sub

Private Sub HandleUserHittedUser(ByVal Message As BinaryReader)
    
    Dim victim      As String
    
    victim = charlist(Message.ReadInt()).Nombre
    
    Select Case Message.ReadInt
    Case bCabeza
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_CABEZA & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bBrazoIzquierdo
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_BRAZO_IZQ & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bBrazoDerecho
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_BRAZO_DER & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bPiernaIzquierda
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_PIERNA_IZQ & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bPiernaDerecha
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_PIERNA_DER & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    Case bTorso
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_PRODUCE_IMPACTO_1 & victim & MENSAJE_PRODUCE_IMPACTO_TORSO & CStr(Message.ReadInt() & MENSAJE_2), 255, 0, 0, True, False, False)
    End Select
End Sub

Private Sub HandleChatOverHead(ByVal Message As BinaryReader)
    
    Dim chat        As String
    Dim CharIndex   As Integer
    Dim r           As Byte
    Dim g           As Byte
    Dim b           As Byte

    chat = Message.ReadString16()
    CharIndex = Message.ReadInt()
    
    r = Message.ReadInt()
    g = Message.ReadInt()
    b = Message.ReadInt()
    
    'Only add the chat if the character exists (a CharacterRemove may have been sent to the PC / NPC area before the buffer was flushed)
    If charlist(CharIndex).active Then _
       Call Dialogos.CreateDialog(chat, CharIndex, D3DColorXRGB(r, g, b))

End Sub

Private Sub HandleConsoleMessage(ByVal Message As BinaryReader)
    
    Dim chat        As String
    Dim fontIndex   As Integer
    Dim str         As String
    Dim r           As Byte
    Dim g           As Byte
    Dim b           As Byte
    
    chat = Message.ReadString16()
    fontIndex = Message.ReadInt()
    
    If InStr(1, chat, "~") Then
        str = ReadField(2, chat, 126)
        If Val(str) > 255 Then
            r = 255
        Else
            r = Val(str)
        End If
        
        str = ReadField(3, chat, 126)
        If Val(str) > 255 Then
            g = 255
        Else
            g = Val(str)
        End If
        
        str = ReadField(4, chat, 126)
        If Val(str) > 255 Then
            b = 255
        Else
            b = Val(str)
        End If
        
        Call AddtoRichTextBox(frmMain.RecTxt, Left$(chat, InStr(1, chat, "~") - 1), r, g, b, Val(ReadField(5, chat, 126)) <> 0, Val(ReadField(6, chat, 126)) <> 0)
    Else
        With FontTypes(fontIndex)
            Call AddtoRichTextBox(frmMain.RecTxt, chat, .red, .green, .blue, .bold, .italic)
        End With
    End If
    
End Sub

Private Sub HandleGuildChat(ByVal Message As BinaryReader)
    
    Dim chat        As String
    Dim str         As String
    Dim r           As Byte
    Dim g           As Byte
    Dim b           As Byte
    Dim tmp         As Integer
    Dim Cont        As Integer
    
    chat = Message.ReadString16()
    
    If Not DialogosClanes.Activo Then
        If InStr(1, chat, "~") Then
            str = ReadField(2, chat, 126)
            If Val(str) > 255 Then
                r = 255
            Else
                r = Val(str)
            End If
            
            str = ReadField(3, chat, 126)
            If Val(str) > 255 Then
                g = 255
            Else
                g = Val(str)
            End If
            
            str = ReadField(4, chat, 126)
            If Val(str) > 255 Then
                b = 255
            Else
                b = Val(str)
            End If
            
            Call AddtoRichTextBox(frmMain.RecTxt, Left$(chat, InStr(1, chat, "~") - 1), r, g, b, Val(ReadField(5, chat, 126)) <> 0, Val(ReadField(6, chat, 126)) <> 0)
        Else
            With FontTypes(FontTypeNames.FONTTYPE_GUILDMSG)
                Call AddtoRichTextBox(frmMain.RecTxt, chat, .red, .green, .blue, .bold, .italic)
            End With
        End If
    Else
        Call DialogosClanes.PushBackText(ReadField(1, chat, 126))
    End If
    
End Sub

Private Sub HandleShowMessageBox(ByVal Message As BinaryReader)
    
    frmMensaje.msg.Caption = Message.ReadString16()
    frmMensaje.Show
    
End Sub

Private Sub HandleUserIndexInServer(ByVal Message As BinaryReader)
    
    UserIndex = Message.ReadInt()
End Sub

Private Sub HandleUserCharIndexInServer(ByVal Message As BinaryReader)
    
    UserCharIndex = Message.ReadInt()
    UserPos = charlist(UserCharIndex).Pos
    
    'Are we under a roof
    bTecho = IIf(MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
                 MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
                 MapData(UserPos.x, UserPos.y).Trigger = 4, True, False)
    
    frmMain.Coord.Caption = "(" & UserMap & "," & UserPos.x & "," & UserPos.y & ")"
End Sub

Private Sub HandleCharacterCreate(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    Dim Body        As Integer
    Dim Head        As Integer
    Dim Heading     As E_Heading
    Dim x           As Byte
    Dim y           As Byte
    Dim weapon      As Integer
    Dim shield      As Integer
    Dim helmet      As Integer
    Dim privs       As Integer
    
    CharIndex = Message.ReadInt()
    Body = Message.ReadInt()
    Head = Message.ReadInt()
    Heading = Message.ReadInt()
    x = Message.ReadInt()
    y = Message.ReadInt()
    weapon = Message.ReadInt()
    shield = Message.ReadInt()
    helmet = Message.ReadInt()
    

    With charlist(CharIndex)
        Call SetCharacterFx(CharIndex, Message.ReadInt(), Message.ReadInt())
        
        .Nombre = Message.ReadString16()
        .Criminal = Message.ReadInt()
        
        privs = Message.ReadInt()
        
        If privs <> 0 Then
            'If the player belongs to a council AND is an admin, only whos as an admin
            If (privs And PlayerType.ChaosCouncil) <> 0 And (privs And PlayerType.User) = 0 Then
                privs = privs Xor PlayerType.ChaosCouncil
            End If
            
            If (privs And PlayerType.RoyalCouncil) <> 0 And (privs And PlayerType.User) = 0 Then
                privs = privs Xor PlayerType.RoyalCouncil
            End If
            
            'If the player is a RM, ignore other flags
            If privs And PlayerType.RoleMaster Then
                privs = PlayerType.RoleMaster
            End If
            
            'Log2 of the bit flags sent by the server gives our numbers ^^
            .priv = Log(privs) / Log(2)
        Else
            .priv = 0
        End If
    End With
    
    Call MakeChar(CharIndex, Body, Head, Heading, x, y, weapon, shield, helmet)
    
    Call RefreshAllChars
    
End Sub

Private Sub HandleCharacterRemove(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    
    CharIndex = Message.ReadInt()
    
    Call EraseChar(CharIndex)
    Call RefreshAllChars
End Sub

Private Sub HandleCharacterMove(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    Dim x           As Byte
    Dim y           As Byte
    
    CharIndex = Message.ReadInt()
    x = Message.ReadInt()
    y = Message.ReadInt()
    
    With charlist(CharIndex)
        If .FxIndex >= 40 And .FxIndex <= 49 Then 'If it's meditating, we remove the FX
            .FxIndex = 0
        End If
        
        ' Play steps sounds if the user is not an admin of any kind
        If .priv <> 1 And .priv <> 2 And .priv <> 3 And .priv <> 5 And .priv <> 25 Then
            Call DoPasosFx(CharIndex)
        End If
    End With
    
    Call engine.Char_Move_by_Pos(CharIndex, x, y)

    Call RefreshAllChars
End Sub

Private Sub HandleCharacterChange(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    Dim tempint     As Integer
    Dim headIndex   As Integer
    
    CharIndex = Message.ReadInt()
    
    With charlist(CharIndex)
        tempint = Message.ReadInt()
        
        If tempint < LBound(BodyData()) Or tempint > UBound(BodyData()) Then
            .Body = BodyData(0)
        Else
            .Body = BodyData(tempint)
        End If
        
        headIndex = Message.ReadInt()
        
        If tempint < LBound(HeadData()) Or tempint > UBound(HeadData()) Then
            .Head = HeadData(0)
        Else
            .Head = HeadData(headIndex)
        End If
        
        .muerto = (headIndex = CASPER_HEAD)
        
        .Heading = Message.ReadInt()
        
        tempint = Message.ReadInt()
        If tempint <> 0 Then .Arma = WeaponAnimData(tempint)
        
        tempint = Message.ReadInt()
        If tempint <> 0 Then .Escudo = ShieldAnimData(tempint)
        
        tempint = Message.ReadInt()
        If tempint <> 0 Then .Casco = CascoAnimData(tempint)
        
        Call SetCharacterFx(CharIndex, Message.ReadInt(), Message.ReadInt())
    End With
    
    Call RefreshAllChars
End Sub

Private Sub HandleObjectCreate(ByVal Message As BinaryReader)
    
    Dim x           As Byte
    Dim y           As Byte
    
    x = Message.ReadInt()
    y = Message.ReadInt()
    
    MapData(x, y).ObjGrh.grhindex = Message.ReadInt()
    
    Call InitGrh(MapData(x, y).ObjGrh, MapData(x, y).ObjGrh.grhindex)
End Sub

Private Sub HandleObjectDelete(ByVal Message As BinaryReader)
    
    Dim x           As Byte
    Dim y           As Byte
    
    x = Message.ReadInt()
    y = Message.ReadInt()
    MapData(x, y).ObjGrh.grhindex = 0
End Sub

Private Sub HandleBlockPosition(ByVal Message As BinaryReader)
    
    Dim x           As Byte
    Dim y           As Byte
    
    x = Message.ReadInt()
    y = Message.ReadInt()
    
    If Message.ReadBool() Then
        MapData(x, y).Blocked = 1
    Else
        MapData(x, y).Blocked = 0
    End If
End Sub

Private Sub HandlePlayMIDI(ByVal Message As BinaryReader)
    
    Dim currentMidi As Byte
    
    currentMidi = Message.ReadInt()
    
    If currentMidi Then
        Call Audio.PlayMIDI(CStr(currentMidi) & ".mid", Message.ReadInt())
    Else
        'Remove the bytes to prevent errors
        Call Message.ReadInt
    End If
End Sub

Private Sub HandlePlayWave(ByVal Message As BinaryReader)
    
    'Autor: Juan Martín Sotuyo Dodero (Maraxus)
    'Last Modification: 08/14/07
    'Last Modified by: Rapsodius
    'Added support for 3D Sounds.
    
    
    Dim wave        As Byte
    Dim srcX        As Byte
    Dim srcY        As Byte
    
    wave = Message.ReadInt()
    srcX = Message.ReadInt()
    srcY = Message.ReadInt()
    
    Call Audio.PlayWave(CStr(wave) & ".wav", srcX, srcY)
End Sub

Private Sub HandleGuildList(ByVal Message As BinaryReader)
    
    'Clear guild's list
    frmGuildAdm.guildslist.Clear
    
    Dim guilds()    As String
    guilds = Split(Message.ReadString16(), SEPARATOR)
    
    Dim i           As Long
    For i = 0 To UBound(guilds())
        Call frmGuildAdm.guildslist.AddItem(guilds(i))
    Next i
    
    frmGuildAdm.Show vbModeless, frmMain
    
End Sub

Private Sub HandleAreaChanged(ByVal Message As BinaryReader)
    
    Dim x           As Byte
    Dim y           As Byte
    
    x = Message.ReadInt()
    y = Message.ReadInt()
    
    Call CambioDeArea(x, y)
End Sub

Private Sub HandlePauseToggle(ByVal Message As BinaryReader)
    
    pausa = Not pausa
End Sub

Private Sub HandleRainToggle(ByVal Message As BinaryReader)
    
    If Not InMapBounds(UserPos.x, UserPos.y) Then Exit Sub
    
    bTecho = (MapData(UserPos.x, UserPos.y).Trigger = 1 Or _
              MapData(UserPos.x, UserPos.y).Trigger = 2 Or _
              MapData(UserPos.x, UserPos.y).Trigger = 4)
    If bRain Then
        If bLluvia(UserMap) Then
            'Stop playing the rain sound
            Call Audio.StopWave(RainBufferIndex)
            RainBufferIndex = 0
            If bTecho Then
                Call Audio.PlayWave("lluviainend.wav", 0, 0, LoopStyle.Disabled)
            Else
                Call Audio.PlayWave("lluviaoutend.wav", 0, 0, LoopStyle.Disabled)
            End If
            frmMain.IsPlaying = PlayLoop.plNone
        End If
    End If
    
    bRain = Not bRain
End Sub

Private Sub HandleCreateFX(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    Dim fX          As Integer
    Dim Loops       As Integer
    
    CharIndex = Message.ReadInt()
    fX = Message.ReadInt()
    Loops = Message.ReadInt()
    
    Call SetCharacterFx(CharIndex, fX, Loops)
End Sub

Private Sub HandleUpdateUserStats(ByVal Message As BinaryReader)
    
    UserMaxHP = Message.ReadInt()
    UserMinHP = Message.ReadInt()
    UserMaxMAN = Message.ReadInt()
    UserMinMAN = Message.ReadInt()
    UserMaxSTA = Message.ReadInt()
    UserMinSTA = Message.ReadInt()
    UserGLD = Message.ReadInt()
    UserLvl = Message.ReadInt()
    UserPasarNivel = Message.ReadInt()
    UserExp = Message.ReadInt()
    
    frmMain.exp.Caption = "Exp: " & UserExp & "/" & UserPasarNivel
    
    If UserPasarNivel > 0 Then
        frmMain.lblPorcLvl.Caption = "[" & Round(CDbl(UserExp) * CDbl(100) / CDbl(UserPasarNivel), 2) & "%]"
    Else
        frmMain.lblPorcLvl.Caption = "[N/A]"
    End If
    
    frmMain.Hpshp.Width = (((UserMinHP / 100) / (UserMaxHP / 100)) * 94)
    
    If UserMaxMAN > 0 Then
        frmMain.MANShp.Width = (((UserMinMAN + 1 / 100) / (UserMaxMAN + 1 / 100)) * 94)
    Else
        frmMain.MANShp.Width = 0
    End If
    
    frmMain.STAShp.Width = (((UserMinSTA / 100) / (UserMaxSTA / 100)) * 94)
    
    frmMain.GldLbl.Caption = UserGLD
    frmMain.LvlLbl.Caption = UserLvl
    
    If UserMinHP = 0 Then
        UserEstado = 1
    Else
        UserEstado = 0
    End If
    
    If UserGLD >= CLng(UserLvl) * 10000 Then
        'Changes color
        frmMain.GldLbl.ForeColor = &HFF&         'Red
    Else
        'Changes color
        frmMain.GldLbl.ForeColor = &HFFFF&       'Yellow
    End If
End Sub

Private Sub HandleWorkRequestTarget(ByVal Message As BinaryReader)
    
    UsingSkill = Message.ReadInt()
    
    frmMain.MousePointer = 2
    
    Select Case UsingSkill
    Case Magia
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_MAGIA, 100, 100, 120, 0, 0)
    Case Pesca
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_PESCA, 100, 100, 120, 0, 0)
    Case Robar
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_ROBAR, 100, 100, 120, 0, 0)
    Case Talar
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_TALAR, 100, 100, 120, 0, 0)
    Case Mineria
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_MINERIA, 100, 100, 120, 0, 0)
    Case FundirMetal
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_FUNDIRMETAL, 100, 100, 120, 0, 0)
    Case Proyectiles
        Call AddtoRichTextBox(frmMain.RecTxt, MENSAJE_TRABAJO_PROYECTILES, 100, 100, 120, 0, 0)
    End Select
End Sub

Private Sub HandleChangeInventorySlot(ByVal Message As BinaryReader)
    
    Dim slot        As Byte
    Dim OBJIndex    As Integer
    Dim Name        As String
    Dim Amount      As Integer
    Dim Equipped    As Boolean
    Dim grhindex    As Integer
    Dim OBJType     As Byte
    Dim MaxHit      As Integer
    Dim MinHit      As Integer
    Dim defense     As Integer
    Dim value       As Long
    
    slot = Message.ReadInt()
    OBJIndex = Message.ReadInt()
    Name = Message.ReadString16()
    Amount = Message.ReadInt()
    Equipped = Message.ReadBool()
    grhindex = Message.ReadInt()
    OBJType = Message.ReadInt()
    MaxHit = Message.ReadInt()
    MinHit = Message.ReadInt()
    defense = Message.ReadInt()
    value = Message.ReadReal32()
    
    Call Inventario.SetItem(slot, OBJIndex, Amount, Equipped, grhindex, OBJType, MaxHit, MinHit, defense, value, Name)
    
End Sub

Private Sub HandleChangeBankSlot(ByVal Message As BinaryReader)
    
    Dim slot        As Byte
    slot = Message.ReadInt()
    
    With UserBancoInventory(slot)
        
        .OBJIndex = Message.ReadInt()
        .Name = Message.ReadString16()
        .Amount = Message.ReadInt()
        .grhindex = Message.ReadInt()
        .OBJType = Message.ReadInt()
        .MaxHit = Message.ReadInt()
        .MinHit = Message.ReadInt()
        .Def = Message.ReadInt()
        .Valor = Message.ReadInt()
    End With
    
    If frmBancoObj.List1(0).ListCount >= slot Then _
       Call frmBancoObj.List1(0).RemoveItem(slot - 1)
    
    Call frmBancoObj.List1(0).AddItem(UserBancoInventory(slot).Name, slot - 1)
    
End Sub

Private Sub HandleChangeSpellSlot(ByVal Message As BinaryReader)
    
    Dim slot        As Byte
    slot = Message.ReadInt()
    
    UserHechizos(slot) = Message.ReadInt()
    
    If slot <= frmMain.hlst.ListCount Then
        frmMain.hlst.List(slot - 1) = Message.ReadString16()
    Else
        Call frmMain.hlst.AddItem(Message.ReadString16())
    End If
    
End Sub

Private Sub HandleAtributes(ByVal Message As BinaryReader)

    Dim i           As Long
    
    For i = 1 To NUMATRIBUTES
        UserAtributos(i) = Message.ReadInt()
    Next i
    
    'Show them in character creation
    If EstadoLogin = E_MODO.Dados Then
        With frmCrearPersonaje
            If .Visible Then
                .lbFuerza.Caption = UserAtributos(1)
                .lbAgilidad.Caption = UserAtributos(2)
                .lbInteligencia.Caption = UserAtributos(3)
                .lbCarisma.Caption = UserAtributos(4)
                .lbConstitucion.Caption = UserAtributos(5)
            End If
        End With
    End If
End Sub

Private Sub HandleBlacksmithWeapons(ByVal Message As BinaryReader)
    
    Dim Count       As Integer
    Dim i           As Long
    Dim tmp         As String
    
    Count = Message.ReadInt()
    
    Call frmHerrero.lstArmas.Clear
    
    For i = 1 To Count
        tmp = Message.ReadString16() & " ("      'Get the object's name
        tmp = tmp & CStr(Message.ReadInt()) & "," 'The iron needed
        tmp = tmp & CStr(Message.ReadInt()) & "," 'The silver needed
        tmp = tmp & CStr(Message.ReadInt()) & ")" 'The gold needed
        
        Call frmHerrero.lstArmas.AddItem(tmp)
        ArmasHerrero(i) = Message.ReadInt()
    Next i
    
    For i = i To UBound(ArmasHerrero())
        ArmasHerrero(i) = 0
    Next i
    
End Sub

Private Sub HandleBlacksmithArmors(ByVal Message As BinaryReader)
    
    Dim Count       As Integer
    Dim i           As Long
    Dim tmp         As String
    
    Count = Message.ReadInt()
    
    Call frmHerrero.lstArmaduras.Clear
    
    For i = 1 To Count
        tmp = Message.ReadString16() & " ("      'Get the object's name
        tmp = tmp & CStr(Message.ReadInt()) & "," 'The iron needed
        tmp = tmp & CStr(Message.ReadInt()) & "," 'The silver needed
        tmp = tmp & CStr(Message.ReadInt()) & ")" 'The gold needed
        
        Call frmHerrero.lstArmaduras.AddItem(tmp)
        ArmadurasHerrero(i) = Message.ReadInt()
    Next i
    
    For i = i To UBound(ArmadurasHerrero())
        ArmadurasHerrero(i) = 0
    Next i
    
End Sub

Private Sub HandleCarpenterObjects(ByVal Message As BinaryReader)
    
    Dim Count       As Integer
    Dim i           As Long
    Dim tmp         As String
    
    Count = Message.ReadInt()
    
    Call frmCarp.lstArmas.Clear
    
    For i = 1 To Count
        tmp = Message.ReadString16() & " ("      'Get the object's name
        tmp = tmp & CStr(Message.ReadInt()) & ")" 'The wood needed
        
        Call frmCarp.lstArmas.AddItem(tmp)
        ObjCarpintero(i) = Message.ReadInt()
    Next i
    
    For i = i To UBound(ObjCarpintero())
        ObjCarpintero(i) = 0
    Next i
    
End Sub

Private Sub HandleRestOK(ByVal Message As BinaryReader)
    
    UserDescansar = Not UserDescansar
    UserAvisado = False
End Sub

Private Sub HandleErrorMessage(ByVal Message As BinaryReader)
    
    Call MsgBox(Message.ReadString16())
    
    frmOldPersonaje.MousePointer = 1
    frmPasswd.MousePointer = 1

    
End Sub

Private Sub HandleBlind(ByVal Message As BinaryReader)
    
    UserCiego = True
End Sub

Private Sub HandleDumb(ByVal Message As BinaryReader)
    
    UserEstupido = True
End Sub

Private Sub HandleChangeNPCInventorySlot(ByVal Message As BinaryReader)
    
    Dim slot        As Byte
    slot = Message.ReadInt()
    
    With NPCInventory(slot)
        
        .Name = Message.ReadString16()
        .Amount = Message.ReadInt()
        .Valor = Message.ReadReal32()
        .grhindex = Message.ReadInt()
        .OBJIndex = Message.ReadInt()
        .OBJType = Message.ReadInt()
        .MaxHit = Message.ReadInt()
        .MinHit = Message.ReadInt()
        .Def = Message.ReadInt()
        
    End With
    
    If frmComerciar.List1(0).ListCount >= slot Then _
       Call frmComerciar.List1(0).RemoveItem(slot - 1)
    
    Call frmComerciar.List1(0).AddItem(NPCInventory(slot).Name, slot - 1)
    
End Sub

Private Sub HandleUpdateHungerAndThirst(ByVal Message As BinaryReader)
    
    UserMaxAGU = Message.ReadInt()
    UserMinAGU = Message.ReadInt()
    UserMaxHAM = Message.ReadInt()
    UserMinHAM = Message.ReadInt()
    frmMain.AGUAsp.Width = (((UserMinAGU / 100) / (UserMaxAGU / 100)) * 94)
    frmMain.COMIDAsp.Width = (((UserMinHAM / 100) / (UserMaxHAM / 100)) * 94)
End Sub

Private Sub HandleFame(ByVal Message As BinaryReader)
    With UserReputacion
        .AsesinoRep = Message.ReadInt()
        .BandidoRep = Message.ReadInt()
        .BurguesRep = Message.ReadInt()
        .LadronesRep = Message.ReadInt()
        .NobleRep = Message.ReadInt()
        .PlebeRep = Message.ReadInt()
        .Promedio = Message.ReadInt()
    End With
    
End Sub

Private Sub HandleMiniStats(ByVal Message As BinaryReader)
    With UserEstadisticas
        .CiudadanosMatados = Message.ReadInt()
        .CriminalesMatados = Message.ReadInt()
        .UsuariosMatados = Message.ReadInt()
        .NpcsMatados = Message.ReadInt()
        .Clase = ListaClases(Message.ReadInt())
        .PenaCarcel = Message.ReadInt()
    End With
End Sub

Private Sub HandleLevelUp(ByVal Message As BinaryReader)
    
    SkillPoints = SkillPoints + Message.ReadInt()
    frmMain.Label1.Visible = True
End Sub

Private Sub HandleSetInvisible(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    
    CharIndex = Message.ReadInt()
    charlist(CharIndex).invisible = Message.ReadBool()
    
End Sub

Private Sub HandleDiceRoll(ByVal Message As BinaryReader)
    
    UserAtributos(eAtributos.Fuerza) = Message.ReadInt()
    UserAtributos(eAtributos.Agilidad) = Message.ReadInt()
    UserAtributos(eAtributos.Inteligencia) = Message.ReadInt()
    UserAtributos(eAtributos.Carisma) = Message.ReadInt()
    UserAtributos(eAtributos.Constitucion) = Message.ReadInt()
    
    frmCrearPersonaje.lbFuerza = UserAtributos(eAtributos.Fuerza)
    frmCrearPersonaje.lbAgilidad = UserAtributos(eAtributos.Agilidad)
    frmCrearPersonaje.lbInteligencia = UserAtributos(eAtributos.Inteligencia)
    frmCrearPersonaje.lbCarisma = UserAtributos(eAtributos.Carisma)
    frmCrearPersonaje.lbConstitucion = UserAtributos(eAtributos.Constitucion)
End Sub

Private Sub HandleMeditateToggle(ByVal Message As BinaryReader)
    
    UserMeditar = Not UserMeditar
    UserAvisado = False
End Sub

Private Sub HandleBlindNoMore(ByVal Message As BinaryReader)
    
    UserCiego = False
End Sub

Private Sub HandleDumbNoMore(ByVal Message As BinaryReader)
    
    UserEstupido = False
End Sub

Private Sub HandleSendSkills(ByVal Message As BinaryReader)

    Dim i           As Long
    
    For i = 1 To NUMSKILLS
        UserSkills(i) = Message.ReadInt()
    Next i
End Sub

Private Sub HandleTrainerCreatureList(ByVal Message As BinaryReader)
    
    Dim creatures() As String
    Dim i           As Long
    
    creatures = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(creatures())
        Call frmEntrenador.lstCriaturas.AddItem(creatures(i))
    Next i
    frmEntrenador.Show , frmMain
    
End Sub

Private Sub HandleGuildNews(ByVal Message As BinaryReader)
    
    Dim guildList() As String
    Dim i           As Long
    
    'Get news' string
    frmGuildNews.news = Message.ReadString16()
    
    'Get Enemy guilds list
    guildList = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(guildList)
        Call frmGuildNews.guerra.AddItem(guildList(i))
    Next i
    
    'Get Allied guilds list
    guildList = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(guildList)
        Call frmGuildNews.aliados.AddItem(guildList(i))
    Next i
    
    frmGuildNews.Show vbModeless, frmMain
    
End Sub

Private Sub HandleOfferDetails(ByVal Message As BinaryReader)
    
    Call frmUserRequest.recievePeticion(Message.ReadString16())
    
End Sub

Private Sub HandleAlianceProposalsList(ByVal Message As BinaryReader)
    
    Dim guildList() As String
    Dim i           As Long
    
    guildList = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(guildList())
        Call frmPeaceProp.lista.AddItem(guildList(i))
    Next i
    
    frmPeaceProp.ProposalType = TIPO_PROPUESTA.ALIANZA
    Call frmPeaceProp.Show(vbModeless, frmMain)
    
End Sub

Private Sub HandlePeaceProposalsList(ByVal Message As BinaryReader)
    
    Dim guildList() As String
    Dim i           As Long
    
    guildList = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(guildList())
        Call frmPeaceProp.lista.AddItem(guildList(i))
    Next i
    
    frmPeaceProp.ProposalType = TIPO_PROPUESTA.PAZ
    Call frmPeaceProp.Show(vbModeless, frmMain)
    
End Sub

Private Sub HandleCharacterInfo(ByVal Message As BinaryReader)
        
    With frmCharInfo
        If .frmType = CharInfoFrmType.frmMembers Then
            .Rechazar.Visible = False
            .Aceptar.Visible = False
            .Echar.Visible = True
            .desc.Visible = False
        Else
            .Rechazar.Visible = True
            .Aceptar.Visible = True
            .Echar.Visible = False
            .desc.Visible = True
        End If
        
        .Nombre.Caption = "Nombre: " & Message.ReadString16()
        .Raza.Caption = "Raza: " & ListaRazas(Message.ReadInt())
        .Clase.Caption = "Clase: " & ListaClases(Message.ReadInt())
        
        If Message.ReadInt() = 1 Then
            .Genero.Caption = "Genero: Hombre"
        Else
            .Genero.Caption = "Genero: Mujer"
        End If
        
        .Nivel.Caption = "Nivel: " & Message.ReadInt()
        .Oro.Caption = "Oro: " & Message.ReadInt()
        .Banco.Caption = "Banco: " & Message.ReadInt()
        
        Dim reputation As Long
        reputation = Message.ReadInt()
        
        .reputacion.Caption = "Reputación: " & reputation
        
        .txtPeticiones.Text = Message.ReadString16()
        .guildactual.Caption = "Clan: " & Message.ReadString16()
        .txtMiembro.Text = Message.ReadString16()
        
        Dim armada  As Boolean
        Dim caos    As Boolean
        
        armada = Message.ReadBool()
        caos = Message.ReadBool()
        
        If armada Then
            .ejercito.Caption = "Ejército: Armada Real"
        ElseIf caos Then
            .ejercito.Caption = "Ejército: Legión Oscura"
        End If
        
        .Ciudadanos.Caption = "Ciudadanos asesinados: " & CStr(Message.ReadInt())
        .criminales.Caption = "Criminales asesinados: " & CStr(Message.ReadInt())
        
        If reputation > 0 Then
            .status.Caption = " (Ciudadano)"
            .status.ForeColor = vbBlue
        Else
            .status.Caption = " (Criminal)"
            .status.ForeColor = vbRed
        End If
        
        Call .Show(vbModeless, frmMain)
    End With
End Sub

Private Sub HandleGuildLeaderInfo(ByVal Message As BinaryReader)
    
    Dim List()      As String
    Dim i           As Long
    
    With frmGuildLeader
        'Get list of existing guilds
        List = Split(Message.ReadString16(), SEPARATOR)
        
        'Empty the list
        Call .guildslist.Clear
        
        For i = 0 To UBound(List())
            Call .guildslist.AddItem(List(i))
        Next i
        
        'Get list of guild's members
        List = Split(Message.ReadString16(), SEPARATOR)
        .Miembros.Caption = "El clan cuenta con " & CStr(UBound(List()) + 1) & " miembros."
        
        'Empty the list
        Call .members.Clear
        
        For i = 0 To UBound(List())
            Call .members.AddItem(List(i))
        Next i
        
        .txtguildnews = Message.ReadString16()
        
        'Get list of join requests
        List = Split(Message.ReadString16(), SEPARATOR)
        
        'Empty the list
        Call .solicitudes.Clear
        
        For i = 0 To UBound(List())
            Call .solicitudes.AddItem(List(i))
        Next i
        
        .Show , frmMain
    End With

End Sub

Private Sub HandleGuildDetails(ByVal Message As BinaryReader)
    With frmGuildBrief
        If Not .EsLeader Then
            .guerra.Visible = False
            .aliado.Visible = False
            .Command3.Visible = False
        Else
            .guerra.Visible = True
            .aliado.Visible = True
            .Command3.Visible = True
        End If
        
        .Nombre.Caption = "Nombre:" & Message.ReadString16()
        .fundador.Caption = "Fundador:" & Message.ReadString16()
        .creacion.Caption = "Fecha de creacion:" & Message.ReadString16()
        .lider.Caption = "Líder:" & Message.ReadString16()
        .web.Caption = "Web site:" & Message.ReadString16()
        .Miembros.Caption = "Miembros:" & Message.ReadInt()
        
        If Message.ReadBool() Then
            .eleccion.Caption = "Elección de líder: ABIERTA"
        Else
            .eleccion.Caption = "Elección de líder: CERRADA"
        End If
        
        .lblAlineacion.Caption = "Alineación: " & Message.ReadString16()
        .Enemigos.Caption = "Clanes enemigos:" & Message.ReadInt()
        .aliados.Caption = "Clanes aliados:" & Message.ReadInt()
        .antifaccion.Caption = "Puntos Antifaccion: " & Message.ReadString16()
        
        Dim codexStr() As String
        Dim i       As Long
        
        codexStr = Split(Message.ReadString16(), SEPARATOR)
        
        For i = 0 To 7
            .Codex(i).Caption = codexStr(i)
        Next i
        
        .desc.Text = Message.ReadString16()
    End With

    frmGuildBrief.Show vbModeless, frmMain
    
End Sub

Private Sub HandleShowGuildFundationForm(ByVal Message As BinaryReader)
    
    CreandoClan = True
    frmGuildFoundation.Show , frmMain
End Sub

Private Sub HandleParalizeOK(ByVal Message As BinaryReader)
    
    UserParalizado = Not UserParalizado
End Sub

Private Sub HandleShowUserRequest(ByVal Message As BinaryReader)
    
    Call frmUserRequest.recievePeticion(Message.ReadString16())
    Call frmUserRequest.Show(vbModeless, frmMain)
    
End Sub

Private Sub HandleTradeOK(ByVal Message As BinaryReader)
    
    If frmComerciar.Visible Then
        Dim i       As Long
        
        Call frmComerciar.List1(1).Clear
        
        For i = 1 To MAX_INVENTORY_SLOTS
            If Inventario.OBJIndex(i) <> 0 Then
                Call frmComerciar.List1(1).AddItem(Inventario.ItemName(i))
            Else
                Call frmComerciar.List1(1).AddItem("")
            End If
        Next i
        
        'Alter order according to if we bought or sold so the labels and grh remain the same
        If frmComerciar.LasActionBuy Then
            frmComerciar.List1(1).ListIndex = frmComerciar.LastIndex2
            frmComerciar.List1(0).ListIndex = frmComerciar.LastIndex1
        Else
            frmComerciar.List1(0).ListIndex = frmComerciar.LastIndex1
            frmComerciar.List1(1).ListIndex = frmComerciar.LastIndex2
        End If
    End If
End Sub

Private Sub HandleBankOK(ByVal Message As BinaryReader)
    
    Dim i           As Long
    
    If frmBancoObj.Visible Then
        
        Call frmBancoObj.List1(1).Clear
        
        For i = 1 To MAX_INVENTORY_SLOTS
            If Inventario.OBJIndex(i) <> 0 Then
                Call frmBancoObj.List1(1).AddItem(Inventario.ItemName(i))
            Else
                Call frmBancoObj.List1(1).AddItem("")
            End If
        Next i
        
        'Alter order according to if we bought or sold so the labels and grh remain the same
        If frmBancoObj.LasActionBuy Then
            frmBancoObj.List1(1).ListIndex = frmBancoObj.LastIndex2
            frmBancoObj.List1(0).ListIndex = frmBancoObj.LastIndex1
        Else
            frmBancoObj.List1(0).ListIndex = frmBancoObj.LastIndex1
            frmBancoObj.List1(1).ListIndex = frmBancoObj.LastIndex2
        End If
    End If
End Sub

Private Sub HandleChangeUserTradeSlot(ByVal Message As BinaryReader)

    With OtroInventario(1)
        
        .OBJIndex = Message.ReadInt()
        .Name = Message.ReadString16()
        .Amount = Message.ReadInt()
        .grhindex = Message.ReadInt()
        .OBJType = Message.ReadInt()
        .MaxHit = Message.ReadInt()
        .MinHit = Message.ReadInt()
        .Def = Message.ReadInt()
        .Valor = Message.ReadInt()
        
        frmComerciarUsu.List2.Clear
        
        Call frmComerciarUsu.List2.AddItem(.Name)
        frmComerciarUsu.List2.ItemData(frmComerciarUsu.List2.NewIndex) = .Amount
        
        frmComerciarUsu.lblEstadoResp.Visible = False
    End With
    
End Sub

Private Sub HandleSendNight(ByVal Message As BinaryReader)
    
    Dim tBool       As Boolean                   'CHECK, este handle no hace nada con lo que recibe.. porque, ehmm.. no hay noche?.. o si
    tBool = Message.ReadBool()
End Sub

Private Sub HandleSpawnList(ByVal Message As BinaryReader)
    
    Dim creatureList() As String
    Dim i           As Long
    
    creatureList = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(creatureList())
        Call frmSpawnList.lstCriaturas.AddItem(creatureList(i))
    Next i
    frmSpawnList.Show , frmMain
    
End Sub

Private Sub HandleShowSOSForm(ByVal Message As BinaryReader)
    
    Dim sosList()   As String
    Dim i           As Long
    
    sosList = Split(Message.ReadString16(), SEPARATOR)
    
    For i = 0 To UBound(sosList())
        Call frmMSG.List1.AddItem(sosList(i))
    Next i
    
    frmMSG.Show , frmMain
    
End Sub

Private Sub HandleShowMOTDEditionForm(ByVal Message As BinaryReader)
    
    frmCambiaMotd.txtMotd.Text = Message.ReadString16()
    frmCambiaMotd.Show , frmMain
    
End Sub

Private Sub HandleShowGMPanelForm(ByVal Message As BinaryReader)
    
    frmPanelGm.Show vbModeless, frmMain
End Sub

Private Sub HandleUserNameList(ByVal Message As BinaryReader)
    
    Dim userList()  As String
    Dim i           As Long
    
    userList = Split(Message.ReadString16(), SEPARATOR)
    
    If frmPanelGm.Visible Then
        frmPanelGm.cboListaUsus.Clear
        For i = 0 To UBound(userList())
            Call frmPanelGm.cboListaUsus.AddItem(userList(i))
        Next i
        If frmPanelGm.cboListaUsus.ListCount > 0 Then frmPanelGm.cboListaUsus.ListIndex = 0
    End If
    
End Sub

Private Sub HandlePong(ByVal Message As BinaryReader)
    
    Call Message.ReadInt
    
    Call AddtoRichTextBox(frmMain.RecTxt, "El ping es " & (GetTickCount - pingTime) & " ms.", 255, 0, 0, True, False, False)
    
    pingTime = 0
End Sub

Private Sub HandleUpdateTagAndStatus(ByVal Message As BinaryReader)
    
    Dim CharIndex   As Integer
    Dim Criminal    As Boolean
    Dim userTag     As String
    
    CharIndex = Message.ReadInt()
    Criminal = Message.ReadBool()
    userTag = Message.ReadString16()
    
    'Update char status adn tag!
    With charlist(CharIndex)
        
        If Criminal Then
            .Criminal = 1
        Else
            .Criminal = 0
        End If
        
        .Nombre = userTag
    End With
    
End Sub

Public Sub WriteLoginExistingChar()
    
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.LoginExistingChar)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(UserPassword)
    
    Call Writer_.WriteInt(App.Major)
    Call Writer_.WriteInt(App.Minor)
    Call Writer_.WriteInt(App.Revision)

    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteThrowDices()
    
    Call Writer_.WriteInt(ClientPacketID.ThrowDices)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteLoginNewChar()
    
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.LoginNewChar)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(UserPassword)
    
    Call Writer_.WriteInt(App.Major)
    Call Writer_.WriteInt(App.Minor)
    Call Writer_.WriteInt(App.Revision)

    Call Writer_.WriteInt(UserRaza)
    Call Writer_.WriteInt(UserSexo)
    Call Writer_.WriteInt(UserClase)
    
    For i = 1 To NUMSKILLS
        Call Writer_.WriteInt(UserSkills(i))
    Next i
    
    Call Writer_.WriteString16(UserEmail)
    
    Call Writer_.WriteInt(UserHogar)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTalk(ByVal chat As String)
    
    Call Writer_.WriteInt(ClientPacketID.Talk)
    
    Call Writer_.WriteString16(chat)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteYell(ByVal chat As String)
    
    Call Writer_.WriteInt(ClientPacketID.Yell)
    
    Call Writer_.WriteString16(chat)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWhisper(ByVal CharIndex As Integer, ByVal chat As String)
    
    Call Writer_.WriteInt(ClientPacketID.Whisper)
    
    Call Writer_.WriteInt(CharIndex)
    
    Call Writer_.WriteString16(chat)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWalk(ByVal Heading As E_Heading)
    
    Call Writer_.WriteInt(ClientPacketID.Walk)
    
    Call Writer_.WriteInt(Heading)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestPositionUpdate()
    
    Call Writer_.WriteInt(ClientPacketID.RequestPositionUpdate)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAttack()
    
    Call Writer_.WriteInt(ClientPacketID.Attack)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePickUp()
    
    Call Writer_.WriteInt(ClientPacketID.PickUp)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCombatModeToggle()
    
    Call Writer_.WriteInt(ClientPacketID.CombatModeToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSafeToggle()
    
    Call Writer_.WriteInt(ClientPacketID.SafeToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteResuscitationToggle()
    Call Writer_.WriteInt(ClientPacketID.ResuscitationSafeToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestGuildLeaderInfo()
    
    Call Writer_.WriteInt(ClientPacketID.RequestGuildLeaderInfo)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestAtributes()
    
    Call Writer_.WriteInt(ClientPacketID.RequestAtributes)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestFame()
    
    Call Writer_.WriteInt(ClientPacketID.RequestFame)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestSkills()
    
    Call Writer_.WriteInt(ClientPacketID.RequestSkills)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestMiniStats()
    
    Call Writer_.WriteInt(ClientPacketID.RequestMiniStats)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCommerceEnd()
    
    Call Writer_.WriteInt(ClientPacketID.CommerceEnd)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUserCommerceEnd()
    
    Call Writer_.WriteInt(ClientPacketID.UserCommerceEnd)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBankEnd()
    
    Call Writer_.WriteInt(ClientPacketID.BankEnd)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUserCommerceOk()
    
    Call Writer_.WriteInt(ClientPacketID.UserCommerceOk)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUserCommerceReject()
    
    Call Writer_.WriteInt(ClientPacketID.UserCommerceReject)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDrop(ByVal slot As Byte, ByVal Amount As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.Drop)
    
    Call Writer_.WriteInt(slot)
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCastSpell(ByVal slot As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.CastSpell)
    
    Call Writer_.WriteInt(slot)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteLeftClick(ByVal x As Byte, ByVal y As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.LeftClick)
    
    Call Writer_.WriteInt(x)
    Call Writer_.WriteInt(y)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDoubleClick(ByVal x As Byte, ByVal y As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.DoubleClick)
    
    Call Writer_.WriteInt(x)
    Call Writer_.WriteInt(y)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWork(ByVal Skill As eSkill)
    
    Call Writer_.WriteInt(ClientPacketID.Work)
    
    Call Writer_.WriteInt(Skill)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUseSpellMacro()
    
    Call Writer_.WriteInt(ClientPacketID.UseSpellMacro)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUseItem(ByVal slot As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.UseItem)
    
    Call Writer_.WriteInt(slot)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCraftBlacksmith(ByVal Item As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CraftBlacksmith)
    
    Call Writer_.WriteInt(Item)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCraftCarpenter(ByVal Item As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CraftCarpenter)
    
    Call Writer_.WriteInt(Item)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWorkLeftClick(ByVal x As Byte, ByVal y As Byte, ByVal Skill As eSkill)
    
    Call Writer_.WriteInt(ClientPacketID.WorkLeftClick)
    
    Call Writer_.WriteInt(x)
    Call Writer_.WriteInt(y)
    
    Call Writer_.WriteInt(Skill)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCreateNewGuild(ByVal desc As String, ByVal Name As String, ByVal Site As String, ByRef Codex() As String)
    
    Dim temp        As String
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.CreateNewGuild)
    
    Call Writer_.WriteString16(desc)
    Call Writer_.WriteString16(Name)
    Call Writer_.WriteString16(Site)
    
    For i = LBound(Codex()) To UBound(Codex())
        temp = temp & Codex(i) & SEPARATOR
    Next i
    
    If Len(temp) Then _
       temp = Left$(temp, Len(temp) - 1)
    
    Call Writer_.WriteString16(temp)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSpellInfo(ByVal slot As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.SpellInfo)
    
    Call Writer_.WriteInt(slot)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteEquipItem(ByVal slot As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.EquipItem)
    
    Call Writer_.WriteInt(slot)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeHeading(ByVal Heading As E_Heading)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeHeading)
    
    Call Writer_.WriteInt(Heading)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteModifySkills(ByRef skillEdt() As Byte)
    
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.ModifySkills)
    
    For i = 1 To NUMSKILLS
        Call Writer_.WriteInt(skillEdt(i))
    Next i
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTrain(ByVal creature As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.Train)
    
    Call Writer_.WriteInt(creature)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCommerceBuy(ByVal slot As Byte, ByVal Amount As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CommerceBuy)
    
    Call Writer_.WriteInt(slot)
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBankExtractItem(ByVal slot As Byte, ByVal Amount As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.BankExtractItem)
    
    Call Writer_.WriteInt(slot)
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCommerceSell(ByVal slot As Byte, ByVal Amount As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CommerceSell)
    
    Call Writer_.WriteInt(slot)
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBankDeposit(ByVal slot As Byte, ByVal Amount As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.BankDeposit)
    
    Call Writer_.WriteInt(slot)
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteForumPost(ByVal Title As String, ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.ForumPost)
    
    Call Writer_.WriteString16(Title)
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteMoveSpell(ByVal upwards As Boolean, ByVal slot As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.MoveSpell)
    
    Call Writer_.WriteBool(upwards)
    Call Writer_.WriteInt(slot)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteClanCodexUpdate(ByVal desc As String, ByRef Codex() As String)
    
    Dim temp        As String
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.ClanCodexUpdate)
    
    Call Writer_.WriteString16(desc)
    
    For i = LBound(Codex()) To UBound(Codex())
        temp = temp & Codex(i) & SEPARATOR
    Next i
    
    If Len(temp) Then _
       temp = Left$(temp, Len(temp) - 1)
    
    Call Writer_.WriteString16(temp)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUserCommerceOffer(ByVal slot As Byte, ByVal Amount As Long)
    
    Call Writer_.WriteInt(ClientPacketID.UserCommerceOffer)
    
    Call Writer_.WriteInt(slot)
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildAcceptPeace(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildAcceptPeace)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildRejectAlliance(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildRejectAlliance)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildRejectPeace(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildRejectPeace)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildAcceptAlliance(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildAcceptAlliance)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildOfferPeace(ByVal guild As String, ByVal proposal As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildOfferPeace)
    
    Call Writer_.WriteString16(guild)
    Call Writer_.WriteString16(proposal)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildOfferAlliance(ByVal guild As String, ByVal proposal As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildOfferAlliance)
    
    Call Writer_.WriteString16(guild)
    Call Writer_.WriteString16(proposal)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildAllianceDetails(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildAllianceDetails)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildPeaceDetails(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildPeaceDetails)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildRequestJoinerInfo(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildRequestJoinerInfo)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildAlliancePropList()
    
    Call Writer_.WriteInt(ClientPacketID.GuildAlliancePropList)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildPeacePropList()
    
    Call Writer_.WriteInt(ClientPacketID.GuildPeacePropList)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildDeclareWar(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildDeclareWar)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildNewWebsite(ByVal url As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildNewWebsite)
    
    Call Writer_.WriteString16(url)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildAcceptNewMember(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildAcceptNewMember)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildRejectNewMember(ByVal UserName As String, ByVal reason As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildRejectNewMember)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(reason)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildKickMember(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildKickMember)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildUpdateNews(ByVal news As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildUpdateNews)
    
    Call Writer_.WriteString16(news)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildMemberInfo(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildMemberInfo)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildOpenElections()
    
    Call Writer_.WriteInt(ClientPacketID.GuildOpenElections)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildRequestMembership(ByVal guild As String, ByVal Application As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildRequestMembership)
    
    Call Writer_.WriteString16(guild)
    Call Writer_.WriteString16(Application)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildRequestDetails(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildRequestDetails)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteOnline()
    
    Call Writer_.WriteInt(ClientPacketID.Online)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteQuit()
    
    Call Writer_.WriteInt(ClientPacketID.Quit)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildLeave()
    
    Call Writer_.WriteInt(ClientPacketID.GuildLeave)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestAccountState()
    
    Call Writer_.WriteInt(ClientPacketID.RequestAccountState)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePetStand()
    
    Call Writer_.WriteInt(ClientPacketID.PetStand)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePetFollow()
    
    Call Writer_.WriteInt(ClientPacketID.PetFollow)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTrainList()
    
    Call Writer_.WriteInt(ClientPacketID.TrainList)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRest()
    
    Call Writer_.WriteInt(ClientPacketID.Rest)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteMeditate()
    
    Call Writer_.WriteInt(ClientPacketID.Meditate)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteResucitate()
    
    Call Writer_.WriteInt(ClientPacketID.Resucitate)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteHeal()
    
    Call Writer_.WriteInt(ClientPacketID.Heal)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteHelp()
    
    Call Writer_.WriteInt(ClientPacketID.Help)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestStats()
    
    Call Writer_.WriteInt(ClientPacketID.RequestStats)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCommerceStart()
    
    Call Writer_.WriteInt(ClientPacketID.CommerceStart)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBankStart()
    
    Call Writer_.WriteInt(ClientPacketID.BankStart)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteEnlist()
    
    Call Writer_.WriteInt(ClientPacketID.Enlist)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteInformation()
    
    Call Writer_.WriteInt(ClientPacketID.Information)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteReward()
    
    Call Writer_.WriteInt(ClientPacketID.Reward)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestMOTD()
    
    Call Writer_.WriteInt(ClientPacketID.RequestMOTD)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUpTime()
    
    Call Writer_.WriteInt(ClientPacketID.Uptime)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyLeave()
    
    Call Writer_.WriteInt(ClientPacketID.PartyLeave)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyCreate()
    
    Call Writer_.WriteInt(ClientPacketID.PartyCreate)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyJoin()
    
    Call Writer_.WriteInt(ClientPacketID.PartyJoin)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteInquiry()
    
    Call Writer_.WriteInt(ClientPacketID.Inquiry)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.PartyMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCentinelReport(ByVal number As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CentinelReport)
    
    Call Writer_.WriteInt(number)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildOnline()
    
    Call Writer_.WriteInt(ClientPacketID.GuildOnline)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyOnline()
    
    Call Writer_.WriteInt(ClientPacketID.PartyOnline)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCouncilMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.CouncilMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRoleMasterRequest(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.RoleMasterRequest)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGMRequest()
    
    Call Writer_.WriteInt(ClientPacketID.GMRequest)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBugReport(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.bugReport)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeDescription(ByVal desc As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeDescription)
    
    Call Writer_.WriteString16(desc)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildVote(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildVote)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePunishments(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.Punishments)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangePassword(ByRef oldPass As String, ByRef newPass As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChangePassword)
    
    Call Writer_.WriteString16(oldPass)
    Call Writer_.WriteString16(newPass)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGamble(ByVal Amount As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.Gamble)
    
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteInquiryVote(ByVal opt As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.InquiryVote)
    
    Call Writer_.WriteInt(opt)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteLeaveFaction()
    
    Call Writer_.WriteInt(ClientPacketID.LeaveFaction)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBankExtractGold(ByVal Amount As Long)
    
    Call Writer_.WriteInt(ClientPacketID.BankExtractGold)
    
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBankDepositGold(ByVal Amount As Long)
    
    Call Writer_.WriteInt(ClientPacketID.BankDepositGold)
    
    Call Writer_.WriteInt(Amount)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDenounce(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.Denounce)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildFundate(ByVal clanType As eClanType)
    
    Call Writer_.WriteInt(ClientPacketID.GuildFundate)
    
    Call Writer_.WriteInt(clanType)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyKick(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.PartyKick)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartySetLeader(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.PartySetLeader)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WritePartyAcceptMember(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.PartyAcceptMember)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildMemberList(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildMemberList)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGMMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.GMMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteShowName()
    
    Call Writer_.WriteInt(ClientPacketID.showName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteOnlineRoyalArmy()
    
    Call Writer_.WriteInt(ClientPacketID.OnlineRoyalArmy)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteOnlineChaosLegion()
    
    Call Writer_.WriteInt(ClientPacketID.OnlineChaosLegion)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGoNearby(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GoNearby)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteComment(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.comment)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteServerTime()
    
    Call Writer_.WriteInt(ClientPacketID.serverTime)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWhere(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.Where)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCreaturesInMap(ByVal map As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CreaturesInMap)
    
    Call Writer_.WriteInt(map)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWarpMeToTarget()
    
    Call Writer_.WriteInt(ClientPacketID.WarpMeToTarget)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWarpChar(ByVal UserName As String, ByVal map As Integer, ByVal x As Byte, ByVal y As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.WarpChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call Writer_.WriteInt(map)
    
    Call Writer_.WriteInt(x)
    Call Writer_.WriteInt(y)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSilence(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.Silence)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSOSShowList()
    
    Call Writer_.WriteInt(ClientPacketID.SOSShowList)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSOSRemove(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.SOSRemove)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGoToChar(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.GoToChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteInvisible()
    
    Call Writer_.WriteInt(ClientPacketID.invisible)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGMPanel()
    
    Call Writer_.WriteInt(ClientPacketID.GMPanel)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestUserList()
    
    Call Writer_.WriteInt(ClientPacketID.RequestUserList)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWorking()
    
    Call Writer_.WriteInt(ClientPacketID.Working)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteHiding()
    
    Call Writer_.WriteInt(ClientPacketID.Hiding)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteJail(ByVal UserName As String, ByVal reason As String, ByVal time As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.Jail)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(reason)
    
    Call Writer_.WriteInt(time)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteKillNPC()
    
    Call Writer_.WriteInt(ClientPacketID.KillNPC)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteWarnUser(ByVal UserName As String, ByVal reason As String)
    
    Call Writer_.WriteInt(ClientPacketID.WarnUser)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(reason)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteEditChar(ByVal UserName As String, ByVal editOption As eEditOptions, ByVal arg1 As String, ByVal arg2 As String)
    
    Call Writer_.WriteInt(ClientPacketID.EditChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call Writer_.WriteInt(editOption)
    
    Call Writer_.WriteString16(arg1)
    Call Writer_.WriteString16(arg2)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharInfo(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharInfo)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharStats(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharStats)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharGold(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharGold)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharInventory(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharInventory)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharBank(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharBank)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharSkills(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharSkills)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteReviveChar(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.ReviveChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteOnlineGM()
    
    Call Writer_.WriteInt(ClientPacketID.OnlineGM)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteOnlineMap()
    
    Call Writer_.WriteInt(ClientPacketID.OnlineMap)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteForgive(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.Forgive)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteKick(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.Kick)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteExecute(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.Execute)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBanChar(ByVal UserName As String, ByVal reason As String)
    
    Call Writer_.WriteInt(ClientPacketID.BanChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call Writer_.WriteString16(reason)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUnbanChar(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.UnbanChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteNPCFollow()
    
    Call Writer_.WriteInt(ClientPacketID.NPCFollow)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSummonChar(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.SummonChar)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSpawnListRequest()
    
    Call Writer_.WriteInt(ClientPacketID.SpawnListRequest)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSpawnCreature(ByVal creatureIndex As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.SpawnCreature)
    
    Call Writer_.WriteInt(creatureIndex)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteResetNPCInventory()
    
    Call Writer_.WriteInt(ClientPacketID.ResetNPCInventory)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCleanWorld()
    
    Call Writer_.WriteInt(ClientPacketID.CleanWorld)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteServerMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.ServerMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteNickToIP(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.NickToIP)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteIPToNick(ByRef Ip() As Byte)
    
    If UBound(Ip()) - LBound(Ip()) + 1 <> 4 Then Exit Sub 'Invalid IP
    
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.IPToNick)
    
    For i = LBound(Ip()) To UBound(Ip())
        Call Writer_.WriteInt(Ip(i))
    Next i
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildOnlineMembers(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildOnlineMembers)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTeleportCreate(ByVal map As Integer, ByVal x As Byte, ByVal y As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.TeleportCreate)
    
    Call Writer_.WriteInt(map)
    
    Call Writer_.WriteInt(x)
    Call Writer_.WriteInt(y)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTeleportDestroy()
    
    Call Writer_.WriteInt(ClientPacketID.TeleportDestroy)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRainToggle()
    
    Call Writer_.WriteInt(ClientPacketID.RainToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSetCharDescription(ByVal desc As String)
    
    Call Writer_.WriteInt(ClientPacketID.SetCharDescription)
    
    Call Writer_.WriteString16(desc)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteForceMIDIToMap(ByVal midiID As Byte, ByVal map As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.ForceMIDIToMap)
    
    Call Writer_.WriteInt(midiID)
    
    Call Writer_.WriteInt(map)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteForceWAVEToMap(ByVal waveID As Byte, ByVal map As Integer, ByVal x As Byte, ByVal y As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.ForceWAVEToMap)
    
    Call Writer_.WriteInt(waveID)
    
    Call Writer_.WriteInt(map)
    
    Call Writer_.WriteInt(x)
    Call Writer_.WriteInt(y)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRoyalArmyMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.RoyalArmyMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChaosLegionMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChaosLegionMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCitizenMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.CitizenMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCriminalMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.CriminalMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTalkAsNPC(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.TalkAsNPC)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDestroyAllItemsInArea()
    
    Call Writer_.WriteInt(ClientPacketID.DestroyAllItemsInArea)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAcceptRoyalCouncilMember(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.AcceptRoyalCouncilMember)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAcceptChaosCouncilMember(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.AcceptChaosCouncilMember)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteItemsInTheFloor()
    
    Call Writer_.WriteInt(ClientPacketID.ItemsInTheFloor)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteMakeDumb(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.MakeDumb)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteMakeDumbNoMore(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.MakeDumbNoMore)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDumpIPTables()
    
    Call Writer_.WriteInt(ClientPacketID.DumpIPTables)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCouncilKick(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.CouncilKick)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSetTrigger(ByVal Trigger As eTrigger)
    
    Call Writer_.WriteInt(ClientPacketID.SetTrigger)
    
    Call Writer_.WriteInt(Trigger)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAskTrigger()
    
    Call Writer_.WriteInt(ClientPacketID.AskTrigger)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBannedIPList()
    
    Call Writer_.WriteInt(ClientPacketID.BannedIPList)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBannedIPReload()
    
    Call Writer_.WriteInt(ClientPacketID.BannedIPReload)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteGuildBan(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.GuildBan)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteBanIP(ByVal byIp As Boolean, ByRef Ip() As Byte, ByVal nick As String, ByVal reason As String)
    
    If byIp And UBound(Ip()) - LBound(Ip()) + 1 <> 4 Then Exit Sub 'Invalid IP
    
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.BanIP)
    
    Call Writer_.WriteBool(byIp)
    
    If byIp Then
        For i = LBound(Ip()) To UBound(Ip())
            Call Writer_.WriteInt(Ip(i))
        Next i
    Else
        Call Writer_.WriteString16(nick)
    End If
    
    Call Writer_.WriteString16(reason)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteUnbanIP(ByRef Ip() As Byte)
    
    If UBound(Ip()) - LBound(Ip()) + 1 <> 4 Then Exit Sub 'Invalid IP
    
    Dim i           As Long
    
    Call Writer_.WriteInt(ClientPacketID.UnbanIP)
    
    For i = LBound(Ip()) To UBound(Ip())
        Call Writer_.WriteInt(Ip(i))
    Next i
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCreateItem(ByVal itemIndex As Long)
    
    Call Writer_.WriteInt(ClientPacketID.CreateItem)
    
    Call Writer_.WriteInt(itemIndex)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDestroyItems()
    
    Call Writer_.WriteInt(ClientPacketID.DestroyItems)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChaosLegionKick(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChaosLegionKick)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRoyalArmyKick(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RoyalArmyKick)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteForceMIDIAll(ByVal midiID As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.ForceMIDIAll)
    
    Call Writer_.WriteInt(midiID)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteForceWAVEAll(ByVal waveID As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.ForceWAVEAll)
    
    Call Writer_.WriteInt(waveID)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRemovePunishment(ByVal UserName As String, ByVal punishment As Byte, ByVal NewText As String)
    
    Call Writer_.WriteInt(ClientPacketID.RemovePunishment)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteInt(punishment)
    Call Writer_.WriteString16(NewText)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTileBlockedToggle()
    
    Call Writer_.WriteInt(ClientPacketID.TileBlockedToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteKillNPCNoRespawn()
    
    Call Writer_.WriteInt(ClientPacketID.KillNPCNoRespawn)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteKillAllNearbyNPCs()
    
    Call Writer_.WriteInt(ClientPacketID.KillAllNearbyNPCs)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteLastIP(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.LastIP)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMOTD()
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMOTD)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSetMOTD(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.SetMOTD)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSystemMessage(ByVal Message As String)
    
    Call Writer_.WriteInt(ClientPacketID.SystemMessage)
    
    Call Writer_.WriteString16(Message)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCreateNPC(ByVal NPCIndex As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CreateNPC)
    
    Call Writer_.WriteInt(NPCIndex)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCreateNPCWithRespawn(ByVal NPCIndex As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.CreateNPCWithRespawn)
    
    Call Writer_.WriteInt(NPCIndex)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteImperialArmour(ByVal armourIndex As Byte, ByVal objectIndex As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.ImperialArmour)
    
    Call Writer_.WriteInt(armourIndex)
    
    Call Writer_.WriteInt(objectIndex)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChaosArmour(ByVal armourIndex As Byte, ByVal objectIndex As Integer)
    
    Call Writer_.WriteInt(ClientPacketID.ChaosArmour)
    
    Call Writer_.WriteInt(armourIndex)
    
    Call Writer_.WriteInt(objectIndex)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteNavigateToggle()
    
    Call Writer_.WriteInt(ClientPacketID.NavigateToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteServerOpenToUsersToggle()
    
    Call Writer_.WriteInt(ClientPacketID.ServerOpenToUsersToggle)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTurnOffServer()
    
    Call Writer_.WriteInt(ClientPacketID.TurnOffServer)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteTurnCriminal(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.TurnCriminal)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteResetFactions(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.ResetFactions)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRemoveCharFromGuild(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RemoveCharFromGuild)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteRequestCharMail(ByVal UserName As String)
    
    Call Writer_.WriteInt(ClientPacketID.RequestCharMail)
    
    Call Writer_.WriteString16(UserName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAlterPassword(ByVal UserName As String, ByVal CopyFrom As String)
    
    Call Writer_.WriteInt(ClientPacketID.AlterPassword)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(CopyFrom)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAlterMail(ByVal UserName As String, ByVal newMail As String)
    
    Call Writer_.WriteInt(ClientPacketID.AlterMail)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(newMail)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteAlterName(ByVal UserName As String, ByVal newName As String)
    
    Call Writer_.WriteInt(ClientPacketID.AlterName)
    
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteString16(newName)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteToggleCentinelActivated()
    
    Call Writer_.WriteInt(ClientPacketID.ToggleCentinelActivated)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteDoBackup()
    
    Call Writer_.WriteInt(ClientPacketID.DoBackUp)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteShowGuildMessages(ByVal guild As String)
    
    Call Writer_.WriteInt(ClientPacketID.ShowGuildMessages)
    
    Call Writer_.WriteString16(guild)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSaveMap()
    
    Call Writer_.WriteInt(ClientPacketID.SaveMap)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoPK(ByVal isPK As Boolean)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoPK)
    
    Call Writer_.WriteBool(isPK)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoBackup(ByVal backup As Boolean)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoBackup)
    
    Call Writer_.WriteBool(backup)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoRestricted(ByVal restrict As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoRestricted)
    
    Call Writer_.WriteString16(restrict)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoNoMagic(ByVal nomagic As Boolean)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoNoMagic)
    
    Call Writer_.WriteBool(nomagic)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoNoInvi(ByVal noinvi As Boolean)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoNoInvi)
    
    Call Writer_.WriteBool(noinvi)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoNoResu(ByVal noresu As Boolean)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoNoResu)
    
    Call Writer_.WriteBool(noresu)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoLand(ByVal land As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoLand)
    
    Call Writer_.WriteString16(land)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteChangeMapInfoZone(ByVal zone As String)
    
    Call Writer_.WriteInt(ClientPacketID.ChangeMapInfoZone)
    
    Call Writer_.WriteString16(zone)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteSaveChars()
    
    Call Writer_.WriteInt(ClientPacketID.SaveChars)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteCleanSOS()
    
    Call Writer_.WriteInt(ClientPacketID.CleanSOS)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteShowServerForm()
    
    Call Writer_.WriteInt(ClientPacketID.ShowServerForm)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteNight()
    
    Call Writer_.WriteInt(ClientPacketID.night)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteKickAllChars()
    
    Call Writer_.WriteInt(ClientPacketID.KickAllChars)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteReloadNPCs()
    
    Call Writer_.WriteInt(ClientPacketID.ReloadNPCs)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteReloadServerIni()
    
    Call Writer_.WriteInt(ClientPacketID.ReloadServerIni)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteReloadSpells()
    
    Call Writer_.WriteInt(ClientPacketID.ReloadSpells)
    
    Call modEngine.NetWrite(Writer_)
End Sub

Public Sub WriteReloadObjects()
    
    Call Writer_.WriteInt(ClientPacketID.ReloadObjects)
    
    Call modEngine.NetWrite(Writer_)
    
End Sub

Public Sub WriteRestart()
    
    Call Writer_.WriteInt(ClientPacketID.Restart)
    
    Call modEngine.NetWrite(Writer_)
    
End Sub

Public Sub WriteChatColor(ByVal r As Byte, ByVal g As Byte, ByVal b As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.ChatColor)
    Call Writer_.WriteInt(r)
    Call Writer_.WriteInt(g)
    Call Writer_.WriteInt(b)
    
    Call modEngine.NetWrite(Writer_)
    
End Sub

Public Sub WriteIgnored()
    
    Call Writer_.WriteInt(ClientPacketID.Ignored)
    
    Call modEngine.NetWrite(Writer_)
    
End Sub

Public Sub WriteCheckSlot(ByVal UserName As String, ByVal slot As Byte)
    
    Call Writer_.WriteInt(ClientPacketID.CheckSlot)
    Call Writer_.WriteString16(UserName)
    Call Writer_.WriteInt(slot)
    
    Call modEngine.NetWrite(Writer_)
    
End Sub

Public Sub WritePing()

    Call Writer_.WriteInt(ClientPacketID.Ping)
    Call Writer_.WriteInt(GetTickCount())
    
    Call modEngine.NetWrite(Writer_)
    Call modEngine.NetFlush
    
End Sub


