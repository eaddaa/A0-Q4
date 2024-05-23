# A0-Q4
Game: Treasure Hunt


Credentials and game tokens 
```
local CRED = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc" --Credential definition
local GAME = "tm1jYBC0F2gTZ0EuUQKq5q_esxITDFkAG6QEpLbpI9I" --Game token definition
```

Instructions: 
1. Enter your process ID. 
2. Make sure you have correctly entered the following information:   
```
CRED = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc" 
GAME = "tm1jYBC0F2gTZ0EuUQKq5q_esxITDFkAG6QEpLbpI9I"
```
3. Start the game using the following code:
```
Send({Target = CRED, Action = "Transfer", Quantity = "10", Recipient = GAME})
```
3. Enjoy and good luck!


Game Rules: 
- It's a simple game where players race to find the treasure. 
- Each player transfers a certain amount of cred before the game starts. 
- Players search for the treasure by moving randomly on the map. 
- When the treasure is found, the first player earns a 50% bonus cred.
