abstract class VolunteerStates {}

// Initializing Volunteer Side States

class VolunteerInitialState extends VolunteerStates {}
class VolunteerFullInitializedState extends VolunteerStates {}

// Call Feature States

class VolunteerChangeMuteState extends VolunteerStates {}
class VolunteerChangeDeafenState extends VolunteerStates {}
class VolunteerChangeCameraState extends VolunteerStates {}
class VolunteerChangeVideoState extends VolunteerStates {}
class VolunteerCloseCallState extends VolunteerStates {}

// Call Handling States

// class BlindClosedCallState extends VolunteerStates {}
class VolunteerReceivingBlindRemoteInfo extends VolunteerStates {}
class VolunteerReceivingACloseCall extends VolunteerStates {}
class VolunteerCallingAnsweredState extends VolunteerStates {}
class VolunteerCallingTimeoutState extends VolunteerStates {}
class VolunteerReceivingCall extends VolunteerStates {}

class VolunteerSettingRemoteDescriptionState extends VolunteerStates {}
class VolunteerSettingLocalDescriptionState extends VolunteerStates {}
class VolunteerCreateAnswerState extends VolunteerStates {}

class VolunteerPlayerStateChangedState extends VolunteerStates {}
class VolunteerPlayMusicState extends VolunteerStates {}
class VolunteerPauseMusicState extends VolunteerStates {}
class VolunteerTtsSpeakingState extends VolunteerStates {}
class VolunteerDisposeState extends VolunteerStates {}
