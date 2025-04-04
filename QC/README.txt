proto.m:

step 1: change the path to your computer configuration L.637

step 2: choose which seismic phase you want to plot
    load sac data
        choose time window, filtering and click on << Update Data >>
        visualize stations location if needed
step 3: align traces: Data Analysis > Align Traces
step 4: choose STATIONS to keep according to time residual and correlation coefficient

save TmpSTATIONS file: File > Save STATIONS File

(OUTSIDE OF THE INTERFACE step 5: calculate synthetic seismograms using any method you want
you can use the pushbutton to launch the hybrid method axisem-specfem matlab interface)

step 6: load synthetics
  you can choose the time window and click on << Update Synthetics >>
step 7: align synthetics

step 8: deconvolution
step 9: convolution

step 10: check for the amplitude residual and update your selection if needed

step 11: Update TmpSTATIONS File if you change your selection
         Save Results: File > Save Results

You can choose to save the Z selection using the << Save Param >> button in the menu

step 12: launch the interface for the analysis of the other components by clicking on << ZNE /ZRT Analysis >>
