// This is a fix to be able to get certain sounds to play. Certain sounds like Assist and Capture only
// work on the client. By simply sending this message instead of ClientPlaySound on the server we don't need
// to include the sounds in the pack.

#exec AUDIO IMPORT NAME=denied FILE=sounds\denied.wav
#exec AUDIO IMPORT NAME=holyShit FILE=sounds\holyShit.wav
#exec AUDIO IMPORT NAME=wickedSick FILE=sounds\wickedSick.wav
#exec AUDIO IMPORT NAME=impressive FILE=sounds\impressive.wav
#exec AUDIO IMPORT NAME=excellent FILE=sounds\excellent.wav
#exec AUDIO IMPORT NAME=outstanding FILE=sounds\outstanding.wav
#exec AUDIO IMPORT NAME=unreal FILE=sounds\unreal.wav

class SmartCTFAudioMsg expands LocalMessagePlus;

static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
  return "";
}

static simulated function ClientReceive( PlayerPawn P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
  super.ClientReceive( P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );

  switch( Switch )
  {
    case 0:  P.ClientPlaySound( sound'Announcer.capture', , true );
       break;
    case 1:  P.ClientPlaySound( sound'Announcer.assist', , true );
       break;
    case 2:  P.ClientPlaySound( sound'Announcer.nicecatch', , true );
       break;
    case 3:  P.ClientPlaySound( sound'Announcer.takenlead', , true );
       break;
    case 4:  P.ClientPlaySound( sound'Announcer.lostlead', , true );
       break;
    case 8:  P.ClientPlaySound( sound'denied', , true );
       break;
    case 11:  P.ClientPlaySound( sound'holyShit', , true );
       break;
    case 15:  P.ClientPlaySound( sound'wickedSick', , true );
       break;
    case 20:  P.ClientPlaySound( sound'impressive', , true );
       break;
    case 25:  P.ClientPlaySound( sound'excellent', , true );
       break;
    case 30:  P.ClientPlaySound( sound'outstanding', , true );
       break;
    case 35:  P.ClientPlaySound( sound'unreal', , true );
       break;
  }
}

defaultproperties
{
     bIsConsoleMessage=False
     Lifetime=0
}
