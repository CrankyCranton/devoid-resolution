class_name PlayerHUD extends CanvasLayer


@onready var corruption_bar: TextureProgressBar = %CorruptionBar
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var adrenaline_hud: Label = %AdrenalineHUD
@onready var warmth_hud: Label = %WarmthHUD


func set_corruption(corruption: int) -> void:
	corruption_bar.value = corruption


func set_health(health: int) -> void:
	health_bar.value = health


func set_max_health(max_health: int) -> void:
	health_bar.max_value = max_health


func set_adrenaline(adrenaline: int) -> void:
	adrenaline_hud.text = "Adrenaline: " + str(adrenaline) + "%"
