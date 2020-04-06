class SmartCTFPlayerReplicationInfo expands ReplicationInfo;

// Replicated
var int Captures, Assists, Grabs, Covers, Seals, FlagKills, DefKills;
var int Frags, HeadShots, ShieldBelts, Amps, Combos, InsaneCombos;

var string CountryPrefix; // for IpToCountry
var string RankingStatus;

// Server side
var NexgenSharedDataContainer statsData;
var NexgenClient client;
var float LastKillTime;
var int MultiLevel;
var int FragSpree, CoverSpree, SealSpree, SpawnKillSpree;
var float SpawnTime;
var bool bHadFirstSpawn;

// Client side
var bool bViewingStats;
var bool bEndStats;
var float IndicatorStartShow;
var byte IndicatorVisibility;

var Actor IpToCountry;
var bool bIpToCountry;
var bool bRankingStatusCleared;

replication
{
  // Stats
  reliable if( Role == ROLE_Authority )
    Captures, Assists, Grabs, Covers, Seals, FlagKills, DefKills,
    Frags, HeadShots, ShieldBelts, Amps, Combos, InsaneCombos, CountryPrefix, RankingStatus;

  // Toggle stats functions
  reliable if( Role == ROLE_Authority )
    ToggleStats, ShowStats;
}

function PostBeginPlay()
{
  local Actor A;

  super.PostBeginPlay();

  SetTimer( 0.5, True );
}

function Timer()
{
  local string temp;
  local PlayerPawn P;
  local int i;
    
  if( Owner == None )
  {
    SetTimer( 0.0, False );
    Destroy();
    return;
  }
  if(bIpToCountry)
  {
     if(CountryPrefix == "")
     {
	   if(Owner.Owner.IsA('PlayerPawn'))
	   {
          P=PlayerPawn(Owner.Owner);
	      if(NetConnection(P.Player) != None)
	      {
             temp=P.GetPlayerNetworkAddress();
             temp=Left(temp, InStr(temp, ":"));
             temp=IpToCountry.GetItemName(temp);
             if(temp == "!Disabled") /* after this return, iptocountry won't resolve anything anyway */
                bIpToCountry=False;
             else if(Left(temp, 1) != "!") /* good response */
             {
                CountryPrefix=SelElem(temp, 5);
                if(CountryPrefix=="") /* the country is probably unknown(maybe LAN), so as the prefix */
                  bIpToCountry=False;
             }
	      }
	      else
	         bIpToCountry=False;
	    }
	    else
	       bIpToCountry=False;
      }
      else
         bIpToCountry=False;
  }
  
  // Try to locate stats data
  if(statsData == none) {
    forEach AllActors(class'NexgenSharedDataContainer', statsData) {
      if(statsData.containerID == "NexgenUTStatsDC") break;
      else statsData = none;
    }
  }
  
  // Try to locate Nexgen Client
  if(client == none) {
    forEach AllActors(class'NexgenClient', client) {
      if(client.player == PlayerPawn(Owner.Owner)) break;
      else client = none;
    }
  }
  
  // Set ranking status
  if(statsData != none && client != none && client.playerID != "" && !bRankingStatusCleared) {        
    bRankingStatusCleared = true;
    
    // Check whether in top3
    for(i=0; i<statsData.getArraySize("topPlayers"); i++) {
      if(InStr(statsData.getString("topPlayers", i), client.playerID) != -1) {
        RankingStatus="top"$i;
        return;
      }
    }
    
    // Check whether in best 3 attCTF
    for(i=0; i<statsData.getArraySize("bestAttCTF"); i++) {
      if(InStr(statsData.getString("bestAttCTF", i), client.playerID) != -1) {
        RankingStatus="attctf"$i;
        return;
      }
    }

    // Check whether in best 3 defCTF
    for(i=0; i<statsData.getArraySize("bestDefCTF"); i++) {
      if(InStr(statsData.getString("bestDefCTF", i), client.playerID) != -1) {
        RankingStatus="defctf"$i;
        return;
      }
    }            
     
    // Check whether most time
    if(InStr(statsData.getString("mostTime"), client.playerID) != -1) { 
      RankingStatus="mosttime";
      return;
    }
    
    // Check whether most covers
    if(InStr(statsData.getString("mostCovers"), client.playerID) != -1) { 
      RankingStatus="mostcovers";
      return;
    }
    
    // Check whether most kills
    if(InStr(statsData.getString("mostKills"), client.playerID) != -1) { 
      RankingStatus="mostkills";
      return;
    }
  }
}

static final function string SelElem(string Str, int Elem)
{
	local int pos;
	while(Elem-->1)
		Str=Mid(Str, InStr(Str,":")+1);
	pos=InStr(Str, ":");
	if(pos != -1)
    	Str=Left(Str, pos);
    return Str;
}

// Called on the server, executed on the client
simulated function ToggleStats()
{
  local PlayerPawn P;

  if( Owner == None ) return;
  P = PlayerPawn( Owner.Owner );
  if( P == None ) return;

  if( P.Scoring != None && !P.Scoring.IsA( 'SmartCTFScoreBoard' ) )
  {
    P.ClientMessage( "Problem loading the SmartCTF ScoreBoard..." );
  }
  else
  {
    bViewingStats = !bViewingStats;
    IndicatorStartShow = Level.TimeSeconds;
    IndicatorVisibility = 255;
    P.bShowScores = True;
  }
}

// Called on the client
simulated function ShowStats(optional bool bHide)
{
  local PlayerPawn P;

  if( Owner == None ) return;
  P = PlayerPawn( Owner.Owner );
  if( P == None ) return;

  if( P.Scoring != None && !P.Scoring.IsA( 'SmartCTFScoreBoard' ) )
  {
    P.ClientMessage( "Problem loading the SmartCTF ScoreBoard..." );
  }
  else
  {
    bViewingStats = True;
    if(!bHide) P.bShowScores = True;
  }
}

function ClearStats()
{
  Captures = 0;
  Assists = 0;
  Grabs = 0;
  Covers = 0;
  Seals = 0;
  DefKills = 0;
  FlagKills = 0;
  Frags = 0;
  HeadShots = 0;
  ShieldBelts = 0;
  Amps = 0;
  Combos = 0;
  InsaneCombos = 0;
  
  FragSpree = 0;
  CoverSpree = 0;
  SealSpree = 0;
  SpawnKillSpree = 0;
  SpawnTime = 0;

  LastKillTime = 0;
  MultiLevel = 0;
}

defaultproperties
{
}
