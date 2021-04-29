# Benny - Garmin Circular Analog Face Watch 

<img src="screenshots/main.png" width="150px">

Get it from Garmin's [store](https://apps.garmin.com/en-US/apps/8588857b-4b29-4d07-b156-a255d6432e00).

## Description
Analog watch-face with low battery usage and various data widgets:

- steps count and progress arc.
- floors count and progress arc.
- weekly activity minutes arc. 
- current heart-beat and graph of the last hour.
- phone status: disconnected/notifications.
- watch status: low-battery/charging.
- alarm icon.
- date and day.
- Do-Not-Disturb limited view (digital watch and date, alarm, disconnected-phone, and battery statue)

## Performance
Watch-faces are always-on and have very limited RAM available. They need to be very effiecent.
I will target the peak-memory to be less than 92kb (Vivoactive3 limit), and as battery efficient as possible - 3% or less battery usage at night.

## Battery usage

- `Normal usage` - smart watch usage: notifications and acting on them, checking widgets from time to time. Might include walking activity.
- `activity` - any sport activity. Does not include GPS usage if not explicitly specified.
- `GPS` - GPS was used. Probably during an activity.

| Time        | Start level | Usage                     | End level |
| :------     |    :---:    | :------                   |   :---:   |
| 5pm->11pm   | 81%         | Normal usage              | 73% (-8%) |
| 11pm->7am   | 73%         | Sleep, Do-not-disturb     | 69% (-4%) |
| 7am->11pm   | 69%         | 1h activity               |           |

