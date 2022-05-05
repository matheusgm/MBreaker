extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "user://mbreaker.db"

func _ready():
	var dir = Directory.new() 
	if not dir.file_exists("user://mbreaker.db"):
		dir.copy("res://DataStore/mbreaker.db","user://mbreaker.db" )
	db = SQLite.new()
	db.path = db_name
	pass
	
func getBullets():
	db.open_db()
	var tableName = "Bullet"
	db.query("SELECT * FROM "+tableName+";")
	var results = db.query_result
	db.close_db()
	return results
	
func insertNewBullet(id):
	db.open_db()
	var tableName = "Bullet"
	var dict : Dictionary = Dictionary()
	dict["json_id"] = str(id)
	db.insert_row(tableName,dict)
	var results = db.query_result
	db.close_db()
	return results

func getStatistics():
	db.open_db()
	var tableName = "Statistic"
	db.query("SELECT * FROM "+tableName+";")
	var results = db.query_result
	db.close_db()
	return results
	
func getTopLevel():
	db.open_db()
	var tableName = "Rankboard"
	db.query("SELECT * FROM "+tableName+" ORDER BY level DESC LIMIT 1;")
	var results = db.query_result
	db.close_db()
	return results

func insertRankboard(currentLevel):
	db.open_db()
	var tableName = "Rankboard"
	var dict : Dictionary = Dictionary()
	dict["level"] = str(currentLevel)
	var time = OS.get_datetime()
	dict["date"] = "%d-%02d-%02d" % [time.year, time.month, time.day];
	db.insert_row(tableName,dict)
	var results = db.query_result
	db.close_db()
	return results


func updateStatistics(topLevel, block_destroyed):
	db.open_db()
	var tableName = "Statistic"
	db.query("UPDATE "+tableName+" SET top_level = '"+topLevel+"'," + 
	"played_times = played_times + 1, blocks_destroyed = blocks_destroyed + "+block_destroyed+""+
	" WHERE statistic_id = '1';")
	var results = db.query_result
	db.close_db()
	return results

#func insertScore(value):
#	db.open_db()
#	var tableName = "Score"
#	var dict : Dictionary = Dictionary()
#	dict["value"] = value
#	db.insert_row(tableName,dict)
#	db.close_db()
#
#func getScores():
#	db.open_db()
#	var tableName = "Score"
#	db.query("SELECT * FROM "+tableName+" ORDER BY value DESC;")
#	var results = db.query_result
#	db.close_db()
#	print(results)
#	return results
