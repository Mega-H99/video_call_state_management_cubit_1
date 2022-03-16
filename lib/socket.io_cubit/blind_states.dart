abstract class BlindStates {}

// Initializing Blind Side States

class BlindInitialState extends BlindStates {}
class BlindFullInitializedState extends BlindStates {}

// Call Feature States

class BlindChangeMuteState extends BlindStates {}
class BlindChangeDeafenState extends BlindStates {}
class BlindChangeCameraState extends BlindStates {}
class BlindChangeVideoState extends BlindStates {}
class BlindCloseCallState extends BlindStates {}

// Call Handling States

class BlindReceivingNoVolunteerFoundState extends BlindStates {}
class BlindReceivingVolunteerRemoteInfo extends BlindStates {}
class BlindReceivingACloseCall extends BlindStates {}
class BlindCallingAnsweredState extends BlindStates {}
class BlindCallingTimeoutState extends BlindStates {}
class BlindRingingState extends BlindStates {}

// Call Setting Local & Remote Description States

class BlindCreatesOfferState extends BlindStates {}
class BlindSettingRemoteDescriptionState extends BlindStates {}
class BlindSettingLocalDescriptionState extends BlindStates {}

// Sound System States

class BlindPlayerStateChangedState extends BlindStates {}
class BlindPlayMusicState extends BlindStates {}
class BlindPauseMusicState extends BlindStates {}
class BlindTtsSpeakingState extends BlindStates {}

// Releasing the resources and destroying objects
class BlindDisposeState extends BlindStates {}

