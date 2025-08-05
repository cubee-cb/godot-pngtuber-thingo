extends Node2D

var origin = Vector2.ZERO;
var offset = Vector2.ZERO;
var velocity = Vector2.ZERO;
var gravity = 50;
var impulse = 400;
var talkTimeout = 30;
var talkTimer = 0;
var dbThreshold = -45;

var visemeIndex = 0;
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origin = position;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# update velocity
	velocity.y += gravity;

	# enter talking state when there is audio input
	#todo: somehow detect visemes from audio device stream
	var recordBus = AudioServer.get_bus_index("Record");
	var volume = AudioServer.get_bus_peak_volume_left_db(recordBus, 0)
	if (volume > dbThreshold):
		# only bounce in the beginning
		if (talkTimer == 0):
			jump();
		talkTimer = talkTimeout;

	# update node position
	offset += velocity * delta;
	position = origin + offset;
	
	# land at 0 offset
	if (offset.y >= 0):
		offset.y = 0;
		velocity.y = 0;

	# animate sprite
	var pngTuberSprite = $PNGTuberSprite;
	if (talkTimer > 0): # talking
		pngTuberSprite.frame = 1 + visemeIndex;
	else: # idle
		pngTuberSprite.frame = 0;

	talkTimer = max(talkTimer - 1, 0);	
	pass

func jump():
	if (offset == Vector2.ZERO):
		velocity.y = -impulse;

		# order of 0-6 AA CH MM OO UU RR
		# for now, just use the first one
		#visemeIndex = random.randi() % 6
		visemeIndex = 0
