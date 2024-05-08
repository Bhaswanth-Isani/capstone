#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
WiFiClient client;

// Replace these with your WiFi network settings
const char* ssid = "Nikhil";
const char* password = "nikhil1234";

// Ultrasonic Sensor Pins
const int triggerPin = 12;
const int echoPin = 14;

// URL to ping
const String serverUrl = "http://34.93.31.115:5179/";
const String shelfID = "shelf_8a44eb1d-d7ab-46aa-9b72-d0a174fdde09";

// Interval at which to ping the server (milliseconds)
const long interval = 60000; // 1 minute

// Variable to store the time of the last ping
unsigned long previousMillis = 0;

// Variable to store the last distance measured
long lastDistance = 0;

void setup() {
  Serial.begin(115200);
  pinMode(triggerPin, OUTPUT);
  pinMode(echoPin, INPUT);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
}

void loop() {
  unsigned long currentMillis = millis();

  // Check if it's time to ping the server
  if (currentMillis - previousMillis >= interval) {
    // Save the last ping time
    previousMillis = currentMillis;

    // Measure distance
    long distance = measureDistance();

    if (distance == 0) {
      Serial.println("Sensor malfunctioned. Pinging server...");
      malfunctionPingServer();
    } else {
      // Check if there's a significant change in distance
      if (abs(distance - lastDistance) > 2) { // Change threshold is 2cm
        Serial.println("Distance changed significantly. Pinging server...");
        changePingServer(distance);
        lastDistance = distance;
      }
    }
  }
}

long measureDistance() {
  // Clears the triggerPin
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);

  // Sets the triggerPin on HIGH state for 10 microseconds
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);

  // Reads the echoPin, returns the sound wave travel time in microseconds
  long duration = pulseIn(echoPin, HIGH);

  // Calculating the distance
  long distance = duration * 0.034 / 2; // Speed of sound wave divided by 2 (go and back)
  Serial.println(duration);

  return distance; // Add the missing return statement
}


void malfunctionPingServer() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(client, (serverUrl + "logs/" + shelfID).c_str()); 
    http.addHeader("Content-Type", "application/json");// Corrected API usage
    int httpCode = http.POST("");
    Serial.println(httpCode);


    if (httpCode > 0) {
      String payload = http.getString();
      Serial.println("Server response: " + payload);
    } else {
      Serial.println("Error in HTTP request");
    }
    http.end();
  } else {
    Serial.println("WiFi not connected");
  }
}

void changePingServer(long distance) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(client, (serverUrl + "change/" + shelfID).c_str()); // Corrected API usage
    http.addHeader("Content-Type", "application/json");
    
    int httpCode = http.POST("{\"quantity\": " + String(distance) + ", \"type\":\"distance\"}");

    if (httpCode > 0) {
      String payload = http.getString();
      Serial.println("Server response: " + payload);
    } else {
      Serial.println("Error in HTTP request");
    }
    http.end();
  } else {
    Serial.println("WiFi not connected");
    }
}