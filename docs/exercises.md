# Operation RedTrace – Training Exercises

This file outlines optional hands-on tasks for participants after deploying the lab environment. The exercises draw inspiration from the [`cyberrangecz/library-junior-hacker`](https://github.com/cyberrangecz/library-junior-hacker) project but are designed specifically for the RedTrace scenario.

## 1. Launching a Caldera Operation

1. Log in to the **Audit-Control-01** Kali VM where MITRE Caldera is installed.
2. Create a simple operation using the built-in "Sandcat" agent profile.
3. Execute the operation against the Windows File Server target.
4. Observe the stages as the agent beacons back and the payload executes.

## 2. Detecting the Attack with Wazuh

1. Switch to the **SIEM-Node** VM running Wazuh.
2. Open the Wazuh dashboard and navigate to **Security Events**.
3. Filter events by the File Server's IP address (172.25.0.30).
4. Identify alerts related to the Caldera operation such as suspicious PowerShell execution or file modifications.

## 3. Analyzing Log Events

1. Within Wazuh, inspect the raw log entries for one of the detected alerts.
2. Determine which detection rule triggered the alert and why.
3. Correlate the timestamp with the Caldera operation timeline to validate the detection.

## 4. Exploring Lateral Movement

1. From the File Server, attempt a lateral move using the credentials harvested by Caldera.
2. Use a basic tool such as `psexec` or the Caldera lateral movement ability.
3. Confirm whether Wazuh generates additional alerts for the attempted lateral movement.

## 5. Cleanup and Reflection

1. Stop the Caldera operation and remove any test artifacts from the Windows host.
2. Review which detections were most valuable and consider tuning Wazuh rules for future exercises.

These exercises provide a starting point for exploring attacker and defender workflows. Feel free to expand on them or create your own scenarios using the provided infrastructure.

