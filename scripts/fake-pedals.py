# /// script
# dependencies = [
#   "mido",
#   "python-rtmidi",
# ]
# ///

import mido
import time
import sys


def get_keyboard_name():
    """Finds the physical Keystation, ignoring Through/Transport ports."""
    inputs = mido.get_input_names()
    return next(
        (n for n in inputs if "Through" not in n and "Transport" not in n), None
    )


def wait_for_keyboard():
    """Waits only for the physical hardware to be plugged in."""
    print("Waiting for physical Keystation to connect", end="")
    while True:
        keyboard = get_keyboard_name()
        if keyboard:
            print(f"\nConnected to: {keyboard}")
            return keyboard

        sys.stdout.write(".")
        sys.stdout.flush()
        time.sleep(2)


def run_pedal_script():
    # 1. Wait for physical keyboard
    keyboard_name = wait_for_keyboard()

    PEDAL_CHANNEL = 1  # MIDI Channel 2
    DEBOUNCE_DELAY = 0.04

    print("\n[SUCCESS] Creating standalone MIDI Device: 'Virtual Bass Pedals'")
    print(
        "You can now open and close GrandOrgue safely. This script will stay running.\n"
    )

    try:
        # THE FIX: Open the output with virtual=True.
        # We no longer look for GrandOrgue. We ARE the device now.
        with (
            mido.open_input(keyboard_name) as inport,
            mido.open_output("Virtual Bass Pedals", virtual=True) as outport,
        ):
            active_notes = []
            current_sent_note = None
            target_pedal = None
            last_change_time = 0

            while True:
                for msg in inport.iter_pending():
                    if msg.type == "note_on" and msg.velocity > 0:
                        if msg.note not in active_notes:
                            active_notes.append(msg.note)
                    elif msg.type == "note_off" or (
                        msg.type == "note_on" and msg.velocity == 0
                    ):
                        if msg.note in active_notes:
                            active_notes.remove(msg.note)

                new_lowest = min(active_notes) if active_notes else None

                if new_lowest != target_pedal:
                    target_pedal = new_lowest
                    last_change_time = time.time()

                if (
                    target_pedal != current_sent_note
                    and (time.time() - last_change_time) >= DEBOUNCE_DELAY
                ):
                    if current_sent_note is not None:
                        outport.send(
                            mido.Message(
                                "note_off",
                                note=current_sent_note,
                                velocity=0,
                                channel=PEDAL_CHANNEL,
                            )
                        )

                    if target_pedal is not None:
                        outport.send(
                            mido.Message(
                                "note_on",
                                note=target_pedal,
                                velocity=64,
                                channel=PEDAL_CHANNEL,
                            )
                        )
                        print(f"Pedal Triggered: {target_pedal}")

                    current_sent_note = target_pedal

                time.sleep(0.005)

    except KeyboardInterrupt:
        print("\nStopping safely...")
        # Emergency All-Notes-Off
        try:
            with mido.open_output("Virtual Bass Pedals", virtual=True) as outport:
                for note in range(128):
                    outport.send(
                        mido.Message(
                            "note_off", note=note, velocity=0, channel=PEDAL_CHANNEL
                        )
                    )
        except:
            pass


if __name__ == "__main__":
    run_pedal_script()
