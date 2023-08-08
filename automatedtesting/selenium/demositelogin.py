# #!/usr/bin/env python
import time
import datetime
from selenium import webdriver
#from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

# Initiate the chromedriver with code to run headless and remove logging errors
options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument('--disable-dev-shm-usage')
options.add_experimental_option('excludeSwitches', ['enable-logging'])
driver = webdriver.Chrome(options=options)

# Print date and time
current_datetime = datetime.datetime.now()
print("Current date and time:", current_datetime)

# Maximize the window
driver.maximize_window()

# Navigate to the demo 'https://www.saucedemo.com'website
URL = 'https://www.saucedemo.com'
print('Navigating to the ' + URL + ' demo website.')
driver.get(URL)

print('Entering standard_user user sign-in credentials.')

# Find the username field, clear it and enter the demo www.saucedemo.com 'standard_user' username
username_field = driver.find_element(By.ID, 'user-name')
username_field.clear()
username_field.send_keys('standard_user')

# Find the password field, clear it and enter the demo www.saucedemo.com 'secret_sauce' password
password_field = driver.find_element(By.ID, 'password')
password_field.clear()
password_field.send_keys('secret_sauce')

# Pause for 2 second to verify credentials input
time.sleep(2)

# Find the login button and click it
login_button = driver.find_element(By.ID, 'login-button')
login_button.click()

print('Adding 6 shopping items to the shopping cart.')

# Loop: add each of the 6 shoping items to the shopping cart with a one second pause for each
items = [
    'add-to-cart-sauce-labs-backpack',
    'add-to-cart-sauce-labs-bolt-t-shirt',
    'add-to-cart-sauce-labs-onesie',
    'add-to-cart-sauce-labs-bike-light',
    'add-to-cart-sauce-labs-fleece-jacket',
    'add-to-cart-test.allthethings()-t-shirt-(red)'
]

for item in items:
    add_to_cart_button = driver.find_element(By.ID, item)
    print(item)
    time.sleep(1)
    add_to_cart_button.click()

# Pause for 2 second to simulate and verify user input response
time.sleep(2)

print('Removing the 6 shoping items from the shopping cart.')

# Loop: remove each of the 6 shoping items from the shopping cart with a one second pause for each
remove_items = [
    'remove-sauce-labs-backpack',
    'remove-sauce-labs-bolt-t-shirt',
    'remove-sauce-labs-onesie',
    'remove-sauce-labs-bike-light',
    'remove-sauce-labs-fleece-jacket',
    'remove-test.allthethings()-t-shirt-(red)'
]

for remove_item in remove_items:
    remove_from_cart_button = driver.find_element(By.ID, remove_item)
    print(remove_item)
    time.sleep(1)
    remove_from_cart_button.click()

# Pause for 1 second to simulate and verify user input response
time.sleep(1)

print('Closing the browser window.')

# Close the driver
driver.quit()
