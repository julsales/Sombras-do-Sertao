extends Node

var equilibrium := 50 # Valor inicial da barra (Luz 50 / Sombras 50)

func _ready():
	set_equilibrium(equilibrium)

# Atualiza as barras na tela com base no valor de equilibrium
func set_equilibrium(value: int) -> void:
	equilibrium = clamp(value, 0, 100)
	$UI/BalanceBarContainer/HarmonyBar.value = equilibrium
	$UI/BalanceBarContainer/BreakerBar.value = 100 - equilibrium

# Aplica o efeito da carta na barra, dependendo do lado
func apply_card_effect(card_data: Dictionary, is_light_card: bool) -> void:
	var effect_value = card_data.value
	var card_type = card_data.type

	# Defesa encerra o jogo
	if card_type == "defesa":
		end_game()
		return

	# Coringa: aplicar efeito normalmente (pode adicionar lógica extra depois)
	if card_type == "coringa":
		pass

	# Purificar/Infectar afeta diretamente o equilíbrio
	if card_type == "purificar" or card_type == "infectar":
		if is_light_card:
			equilibrium += effect_value
		else:
			equilibrium -= effect_value
	else:
		# Para ataque, cura, imobilização
		if is_light_card:
			equilibrium += effect_value
		else:
			equilibrium -= effect_value

	# Atualiza as barras com o novo equilíbrio
	set_equilibrium(equilibrium)

# (Exemplo de função para encerrar o jogo)
func end_game():
	print("Fim do jogo! A última carta foi uma de defesa.")
