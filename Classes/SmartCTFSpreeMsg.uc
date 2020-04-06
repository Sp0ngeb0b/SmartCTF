class SmartCTFSpreeMsg expands KillingSpreeMessage;

var color afterGodlikeColor;

static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
  if( RelatedPRI_1 != None )
  {
    if( Switch == 5 ) return default.SpreeNote[Switch] @ RelatedPRI_1.PlayerName $ "!";
    if( Switch == 6 ) return RelatedPRI_1.PlayerName @ class'TournamentPlayer'.default.SpreeNote[3];
  }
  return "";
}

static function color GetColor(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
  switch(Switch) {
    case 5:
    case 6: return Default.afterGodlikeColor;
    default: return Default.DrawColor;
  }
}

defaultproperties
{
     afterGodlikeColor=(R=128,G=128,B=0)
     spreenote(5)="This is just TOO EASY for"
     SpreeSound(5)=Sound'Botpack.ChatSound.SpreeSound'
     SpreeSound(6)=Sound'Botpack.ChatSound.SpreeSound'
}
