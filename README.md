## Asynchronous FIFO Design

fifo_test tests the when the flags change is correct. send_data is a brute
force test that makes sure the data can be sent across clock domains
without any data getting lost.

Full and empty flags are set immediately on write or read, but cleared
late to synchronize. 

Potential issue:
I didn't have time to test the almost flags in the r_empty and w_full
tests individually, but it is tested in fifo_test.
I don't think my tests are exhuastive since I was trying to make tests
based only on clock edges. If I selected one set of clock periods, and
hand calculated everything I could check better that everything happens
exactly when it should be overlapping clock edges make it hard to
test reading and writing at the same time.

#### Delays

- almost_full and full flags lag behind by 3 w_clk cycles from when read happens
- almost_empty and empty flags lag behind by 3 r_clk cycles from when write happens


## TODO
[x] Parameterize everything
[ ] make almost full and almost empty flags based on parameters
[ ] ifdef to customize memory
[x] comment
    - 1 per block
    - 1 per module
[ ] synthesize