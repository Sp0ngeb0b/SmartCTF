// Above all other messages.

#exec AUDIO IMPORT NAME=comboWhore FILE=sounds\comboWhore.wav
#exec AUDIO IMPORT NAME=comboKing FILE=sounds\comboKing.wav
#exec AUDIO IMPORT NAME=comboManiac FILE=sounds\maniac.wav

class SmartCTFMessage extends LocalMessagePlus;

var string CoveredMsg, YouCoveredMsg;
var string CoverSpreeMsg, YouCoverSpreeMsg;
var string UltraCoverMsg, YouUltraCoverMsg;
var string SealMsg, YouSealMsg;
var string ComboWhoreMsg, YouComboWhoreMsg;
var string ComboKingMsg, YouComboKingMsg;
var string ComboManiacMsg, YouComboManiacMsg;
var string SavedMsg, YouSavedMsg;
var string DeniedMsg, YouDeniedMsg;
var string SpawnKillMsg;
var color comboWhoreColor;

static function float GetOffset( int Switch, float YL, float ClipY )
{
  return ( default.YPos / 768.0 ) * ClipY - 3 * YL;
}

static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
  if (RelatedPRI_1 == None) return "";

  switch( Switch )
  {
    case 0: // Cover FC
      return RelatedPRI_1.PlayerName @ default.CoveredMsg;
    case 1: // Seal base
      return RelatedPRI_1.PlayerName @ default.SealMsg;
    case 4: // Ultra cover
      return RelatedPRI_1.PlayerName @ default.UltraCoverMsg;
    case 5: // Cover spree
      return RelatedPRI_1.PlayerName @ default.CoverSpreeMsg;
    case 7: // Saved by ...
      return default.SavedMsg @ RelatedPRI_1.PlayerName $ "!";
    case 8: // Denied by ...
      return default.DeniedMsg @ RelatedPRI_1.PlayerName $ "!";
    case 10: // Spawnkilling
      return RelatedPRI_1.PlayerName @ default.SpawnKillMsg;
    case 12: // Combowhore
      return RelatedPRI_1.PlayerName @ default.ComboWhoreMsg;
    case 13: // Comboking
      return RelatedPRI_1.PlayerName @ default.ComboKingMsg;
    case 14: // Combomaniac
      return RelatedPRI_1.PlayerName @ default.ComboManiacMsg;
    case 0 + 64:
      return default.YouCoveredMsg;
    case 1 + 64:
      return default.YouSealMsg;
    case 4 + 64:
      return default.YouUltraCoverMsg;
    case 5 + 64:
      return default.YouCoverSpreeMsg;
    case 7 + 64:
      return default.YouSavedMsg;
    case 8 + 64:
      return default.YouDeniedMsg;
    case 12 + 64:
      return default.YouComboWhoreMsg;
    case 13 + 64:
      return default.YouComboKingMsg;
    case 14 + 64:
      return default.YouComboManiacMsg;
  }
  return "";
}

static simulated function ClientReceive( PlayerPawn P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
  super.ClientReceive( P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );

  switch( Switch )
  {
    case 5: // Cover spree - guitarsound for player, spreesound for all
      if( RelatedPRI_1 == P.PlayerReplicationInfo ) P.ClientPlaySound( sound'CaptureSound', , true );
      else P.PlaySound( sound'SpreeSound', , 4.0 );
      break;
      
    case 12: // Combowhore spree - Combowhore sound for player, spreesound for all
      if( RelatedPRI_1 == P.PlayerReplicationInfo ) P.ClientPlaySound( sound'comboWhore', , true );
      else P.PlaySound( sound'SpreeSound', , 4.0 );
      break;
      
    case 13: // Comboking spree - Comboking sound for player, spreesound for all
      if( RelatedPRI_1 == P.PlayerReplicationInfo ) P.ClientPlaySound( sound'comboKing', , true );
      else P.PlaySound( sound'SpreeSound', , 4.0 );
      break;
      
    case 14: // Combomaniac spree - Combomaniac sound for player, spreesound for all
      if( RelatedPRI_1 == P.PlayerReplicationInfo ) P.ClientPlaySound( sound'comboManiac', , true );
      else P.PlaySound( sound'SpreeSound', , 4.0 );
      break;
  }
}

static function Color GetColor( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2 )
{
  switch( Switch )
  {
    case 12:
    case 13: 
    case 14: return default.comboWhoreColor;
  }
  return default.DrawColor;
}

defaultproperties
{
     CoveredMsg="covered the flagcarrier!"
     YouCoveredMsg="You covered the flagcarrier!"
     CoverSpreeMsg="is on a cover spree!"
     YouCoverSpreeMsg="You are on a cover spree!"
     UltraCoverMsg="got a multi cover!"
     YouUltraCoverMsg="You got a multi cover!"
     SealMsg="is sealing off the base!"
     YouSealMsg="You are sealing off the base!"
     SavedMsg="Saved By"
     YouSavedMsg="Close save!!"
     DeniedMsg="Denied By"
     YouDeniedMsg="Denied!!"
     ComboWhoreMsg="is a COMBO WHORE!"
     YouComboWhoreMsg="You are a COMBO WHORE!"
     ComboKingMsg="is a COMBO KING!"
     YouComboKingMsg="You are a COMBO KING!"
     ComboManiacMsg="is a COMBO MANIAC!"
     YouComboManiacMsg="You are a COMBO MANIAC!"     
     SpawnKillMsg="is a spawnkilling lamer!"
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(R=24,G=192,B=24)
     comboWhoreColor=(R=245,G=79,B=232)
     YPos=196.000000
     bCenter=True
}
