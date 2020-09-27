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
- Timestamps are given in milliseconds.
- A rate between two waves is computed as following : 

'|' : represent a qrs wave
'-' : a time unit

```
- | - - - | - - - - | - | - - - - | - - - - | - - - - | - - - - |
- t0<-dt->t1
```

here, rate is computed by : 1 / dt  = 1 / (t1-t0)

But how to have t1 and t0 when all we know is a signal like this : 


```
     ___      
    / | \     
   /  |  \    
__/   |   \___
  |   |    |  
 ts   |   te   which are given
      |       
      tw       which is not given.
```


So first I computed `current_qrs_time` which is = ts + (te-ts)/2
then `compute_rate` takes these new timestamps and compute rates between them as mentionned earlier.

- mean rate is the average of all rates. I could have also count the total amount of QRS waves and divid this by the total amount of time of the file, but it didn't feel right at the time.
Let's give an example.
again :  
'|' : represent a qrs wave
'-' : an ellapsed second

```
0               10seconds
-|-|-|-|-|------|
```

the five first 5 seconds see 5 qrs waves. But nothing after in the 5 next seconds.
that leads us with 6 qrs waves in 10 seconds. If we take these figures it a 0.6 beat per second (bps) rate.

If we take my assumption we have a rate of 1 bps during the 5 first seconds, and a rate of 0.2 bps during the last 5 seconds.
So it is : (4x1 + 0.2x1) / 5 (number of computed rates)  = 0.84 bps

The result can then be really different.

:warning: This assumption must absolutely be clarified by a cardiologist before going into production !:warning: 


### Known limitations and possible improvements: 
- Reading of input_test.csv file should be centralized across the spec files
- changing date and time is given with a possible 1ms of error.
It appears that adding milliseconds to DateTime object is tough and can lead to imprecision on the last digit. I don't have any clue why yet.
- Params are not sanitized hence leading to security breach I guess.
- I didn't succeed to correctly test the controller.rb. I wanted to test that file can be uploaded correctly, and date correctly set by the user. I'll have to investigate further on this.
- Rubocop is not happy with my ECGAnalysis.parse_data method. And I agree with it. That was the only I found so far to parse the data only once without having a bunch of 'from-the-death-methods' that deal with too many input arguments. I think a refactoring with a helper module could be better.

