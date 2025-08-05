extends Node2D

var origin = Vector2.ZERO;
var offset = Vector2.ZERO;
var velocity = Vector2.ZERO;
var gravity = 50;
var impulse = 400;
var talkTimeout = 60;
var talkTimer = 0;

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

	# bounce the node
	#todo: trigger this based on volume/viseme detection
	#todo: extract visemes from audio device stream
	if (Input.is_action_pressed("ui_accept")):
		jump();

	# move the offset
	offset += velocity * delta;
	
	# snap to origin position
	position = origin + offset;
	
	# land at 0 offset
	if (offset.y >= 0):
		offset.y = 0;
		velocity.y = 0;

	# animate sprite
	var pngTuberSprite = $PNGTuberSprite;
	if (talkTimer > 0):
		pngTuberSprite.frame = 1 + visemeIndex;
	else:
		pngTuberSprite.frame = 0;

	talkTimer = max(talkTimer - 1, 0);	
	pass

func jump():
	if (offset == Vector2.ZERO):
		velocity.y = -impulse;
		talkTimer = talkTimeout;
		
		# order of 0-6 AA CH MM OO UU RR
		visemeIndex = random.randi() % 6
