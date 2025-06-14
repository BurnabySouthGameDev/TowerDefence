extends Node3D

const MAX_PLAYERS = 8
var audio_players := []

func _ready():
	for i in range(MAX_PLAYERS):
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

func play_sound(stream: AudioStream):
	for player in audio_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return
