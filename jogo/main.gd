extends Node

var equilibrio := 50  # Começa equilibrado (Rompedor 50, Meninas 50)

func set_equilibrio(valor: int) -> void:
	equilibrio = clamp(valor, 0, 100)

	$UI/EquilibrioBarContainer/BarraRompedor.value = equilibrio
	$UI/EquilibrioBarContainer/BarraMeninas.value = 100 - equilibrio
