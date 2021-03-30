extends "res://addons/gut/test.gd"



func test_clicker_upgrade_static_upgrade_case1():
	var base_coins = 1
	var clicker_upgrade = ClickerUpgrade.new(0, 10)
	
	var actual_coins = clicker_upgrade.get_calculated_coins(base_coins)
	var expected_coins = 11
	assert_eq(actual_coins, expected_coins)
	
func test_clicker_upgrade_static_upgrade_case2():
	var base_coins = 1
	var clicker_upgrade = ClickerUpgrade.new(0, 100)
	
	var actual_coins = clicker_upgrade.get_calculated_coins(base_coins)
	var expected_coins = 101
	assert_eq(actual_coins, expected_coins)
	
	
func test_clicker_upgrade_multiplier_upgrade_case1():
	var base_coins = 10
	var clicker_upgrade = ClickerUpgrade.new(0.6, 0)
	
	var actual_coins = clicker_upgrade.get_calculated_coins(base_coins)
	var expected_coins = 16
	assert_eq(actual_coins, expected_coins)
	
func test_clicker_upgrade_multiplier_upgrade_case2():
	var base_coins = 1
	var clicker_upgrade = ClickerUpgrade.new(12, 0)
	
	var actual_coins = clicker_upgrade.get_calculated_coins(base_coins)
	var expected_coins = 13
	assert_eq(actual_coins, expected_coins)
	

func test_clicker_upgrade_combined_upgrade_case1():
	var base_coins = 10
	var clicker_upgrade = ClickerUpgrade.new(0.5, 5)
	
	var actual_coins = clicker_upgrade.get_calculated_coins(base_coins)
	var expected_coins = 20
	assert_eq(actual_coins, expected_coins)


func test_clicker_upgrade_combined_upgrade_case2():
	var base_coins = 1
	var clicker_upgrade = ClickerUpgrade.new(12, 5)
	
	var actual_coins = clicker_upgrade.get_calculated_coins(base_coins)
	var expected_coins = 18
	assert_eq(actual_coins, expected_coins)
