#!/usr/bin/python3

import signal
import sys
import subprocess
from time import sleep

from gpiozero import PWMLED


LED_VOLDOWN = PWMLED(26)
LED_PREV = PWMLED(19)
LED_PLAY = PWMLED(13)
LED_NEXT = PWMLED(16)
LED_VOLUP = PWMLED(20)

def sigterm_handler(*_):
    LED_VOLDOWN.off()
    LED_VOLUP.off()
    LED_VOLDOWN.close()
    LED_VOLUP.close()
    sleep(0.1)
    LED_PREV.off()
    LED_NEXT.off()
    LED_PREV.close()
    LED_NEXT.close()
    sleep(0.1)
    LED_PLAY.off()
    LED_PLAY.close()
    sys.exit(0)


def getshell():
    process = subprocess.Popen("echo -e status\\nclose | nc -w 1 localhost 6600 | grep 'OK MPD'", shell=True, stdout=subprocess.PIPE).communicate()[0].decode('utf-8').strip()
    return process


def initiate_animation():
    process = ""
    pos = 1
    direction = 0
    while process == "":
        print(process)
        if pos == 1:
            LED_PLAY.pulse(n=1, fade_in_time=0.2, fade_out_time=0.8)
            sleep(0.2)
        elif pos == 2:
            LED_PREV.pulse(n=1, fade_in_time=0.2, fade_out_time=0.8)
            LED_NEXT.pulse(n=1, fade_in_time=0.2, fade_out_time=0.8)
            sleep(0.2)
        elif pos == 3:
            LED_VOLUP.pulse(n=1, fade_in_time=0.2, fade_out_time=0.8)
            LED_VOLDOWN.pulse(n=1, fade_in_time=0.2, fade_out_time=0.8)
            process = getshell()
            sleep(0.8)
            pos=0
        pos += 1
        sleep(0.04)

def leds_on():
    LED_PLAY.on()
    sleep(0.1)
    LED_PREV.on()
    LED_NEXT.on()
    sleep(0.1)
    LED_VOLDOWN.on()
    LED_VOLUP.on()

def leds_off():
    LED_VOLDOWN.off()
    LED_VOLUP.off()
    sleep(1)
    LED_PREV.off()
    LED_NEXT.off()

def main():
    dummy = ""
    while dummy == "":
        sleep(5)


if __name__ == "__main__":
    initiate_animation()
    leds_on()
    leds_off()
    signal.signal(signal.SIGTERM, sigterm_handler)
    main()
