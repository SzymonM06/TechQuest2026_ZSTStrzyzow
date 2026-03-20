extends Node2D

var selection = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label3.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selection == 1:
		$Label2.text = "Bojowy Wóz Piechoty BORSUK"
		$Label.text = "Nowy bojowy, pływający wóz piechoty, 
		kryptonim „Borsuk” jest w stanie pokonywać szerokie 
		przeszkody wodne, ma dużą zwrotność i może być używany 
		w różnych warunkach terenowych i pogodowych. 
		Pojazd przeznaczony jest do transportu i ochrony załogi 
		i żołnierzy piechoty przed ostrzałem z broni strzeleckiej,
		 granatników przeciwpancernych i IED."
	elif selection == 2:
		$Label2.text = "155 mm samobieżna haubica KRAB"
		$Label.text = "Typowym zadaniem taktycznym dla 155 mm haubicy samobieżnej KRAB jest obezwładnianie i niszczeniecelów znajdujących się daleko na tyłach wroga – konstrukcja KRABa pozwala jednak haubicy na prowadzenie także ognia „na wprost”. Połączenie nowoczesnej i doskonale wyposażonej wieży haubicy ze sprawdzonym w boju podwoziem pozwoliło stworzyć produkt charakteryzujący się zarówno wysoką wydajnością, jak i niezawodnością, przy jednoczesnym zachowaniu najwyższych parametrów ergonomii obsługi i standardów bezpieczeństwa. Krab jest autonomiczną haubicą – wyposażoną w system łączności, dowodzenia i kierowania ogniem C4i TOPAZ. Ma także charakter modułowy: wieżę można zastosować na dowolnym innym podwoziu gąsienicowym o odpowiednich parametrach."
	else:
		$Label2.text = "Wybierz pojazd"
		$Label.text = "Wybierz pojazd by dowiedzieć się więcej."
		
	if selection != 0:
		$StartButton.visible = true
	else:
		$StartButton.visible = false

func _on_button_pressed() -> void:
	selection = 1


func _on_button_2_pressed() -> void:
	selection = 2


func _on_start_button_pressed() -> void:
	
	if selection == 1:
		$Label3.visible = true
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://level.tscn")
		
