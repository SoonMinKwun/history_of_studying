import json 
import pyrebase
import threading
import time

while True:
	print("start")

	config = {
 	   "apiKey": "AIzaSyA38FmjrgV7zsOFAU1B8zXiFeSolrHSMdw",
  	  "authDomain": "meonji-6fb27.firebaseapp.com",
 	   "databaseURL": "https://meonji-6fb27-default-rtdb.asia-southeast1.firebasedatabase.app",
	    "projectId": "meonji-6fb27",
	    "storageBucket": "meonji-6fb27.appspot.com",
	    "messagingSenderId": "733080420270",
	    "appId": "1:733080420270:web:25e8c9f8e96ced42e8523f",
	    "measurementId": "G-0CYC9PX0G2"
	}

	file_path = "./aqi.json"

	with open(file_path, "r") as json_file:
	    json_data = json.load(json_file)


	firebase = pyrebase.initialize_app(config)

	db = firebase.database()

	db.child("pm").child("pm").update((json_data[-1]))
	print("end")
	time.sleep(60)
