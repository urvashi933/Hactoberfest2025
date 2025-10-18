import pywhatkit as kit
import pyautogui
import keyboard
import time

# Replace with your number and adjust time at least 2 minutes ahead
phone_number = "+91XXXXXXXXXX"
message = "Automated test message"
hour = 18        # 24-hour format
minute = 10      # send at 6:10 PM

try:
    # Send message via pywhatkit (opens WhatsApp Web)
    kit.sendwhatmsg(phone_number, message, hour, minute, wait_time=30, tab_close=False)

    # Wait for browser to load WhatsApp Web
    time.sleep(10)

    # Click the center of the screen to activate the message box (optional adjust coords)
    pyautogui.click(1050, 950)

    # Small delay before pressing Enter
    time.sleep(2)

    # Press Enter to send the message
    keyboard.press_and_release('enter')

    print("Message sent successfully!")

except Exception as e:
    print("Error:", e)
