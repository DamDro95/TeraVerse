extends CharacterWeapon

const ATTACK_DURATION: float = 0.6

func attack() -> void:
	body.animation_player.play("Player/Melee_1H_Attack_Chop")
