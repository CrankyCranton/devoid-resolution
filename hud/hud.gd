extends CanvasLayer


@onready var corruption_bar: ProgressBar = %CorruptionBar


func set_corruption(corruption: int) -> void:
	corruption_bar.value = corruption
