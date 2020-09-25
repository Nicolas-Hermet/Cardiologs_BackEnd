# Cardiologs_BackEnd


## Challenge description

**Holter Record Summary**

A normal heartbeat produces three entities on the ECG — a P wave, a QRS complex, a T wave.
[See Electrocardiography theory here.](https://en.wikipedia.org/wiki/Electrocardiography#Theory)

Identifying those entities in a signal is called delineation. [Here are CSV of
an algorithm output for a 24h ECG.](https://cardiologs-public.s3.amazonaws.com/python-interview/record.csv)

Rows have the following fields:
   - Wave type: P, QRS, T or INV (invalid)
   - Wave onset: Start of the wave in ms
   - Wave offset: End of the wave in ms
- Optionally, a list of wave tags

Write a simple HTTP server that provides the following measurements to a physician when a delineation file is sent to `POST /delineation`:
- The number of P waves tagged "premature" as well as the number of QRS complexes tagged "premature"
- The mean heart rate of the recording (Frequency at which QRS complexes appear).
- The minimum and maximum heart rate, each with the time at which they happened. As the date and the time of the recording are not included in the file, the client should be able to set them.

Cardiologs should be able to recover your work, understand it, trust it easily, maintain it, make changes to it, etc

**Bonus question**: We want to efficiently host delineations online and be able to quickly request a range of it (e.g.,the record between 2 and 3 pm on the third day). How would you achieve that?


## How to...

### ...run this repo ?

1. Clone this repo
2. `cd Cardiologs_BackEnd`
3. `bundle install`
4. `shotgun -p 4567` or just `shotgun`
5. Open your favorite browser at `http://localhost:4567/`

### ...play with the app ?

You should have redirected to `http://localhost:4567/delineation/new`.
In the page a `Choose file` button should be present. It'll allow you to choose a CSV file from your personnal data.
You can use the file in the Challenge description part.
Pressing `Upload` will execute the delineation on your data and display the results on the same page.

## Notes on my solutions

### Assumptions

### Known limitations