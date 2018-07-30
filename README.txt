-----------------------------------------------------------------------------------------

Fast compressive sensing for discrete single-molecule FRET data analysis

Coded in MATLAB R2013a

Bo Shuang
Landes Research Group
Rice University
Department of Chemistry

July 2014

For review of the manuscript:

Bo Shuang, David Cooper, Nick Taylor, Lydia Kisley, Jixin Chen, Wenxiao Wang, Chun Biu Li, Tamiki Komatsuzaki, Christy F. Landes
"Fast compressive sensing for discrete single-molecule FRET data analysis"

-----------------------------------------------------------------------------------------
Instructions for installation:

If you are using the MATLAB source, extract to any directory you like. 
Before its first use, add the directory to the MATLAB path. We recommend to change the folder under the program directory. The main function is STaSI.m

----------------------------------------------------------------------------------------
Instructions for use:

To run, simply install and type 'STaSI' at the MATLAB prompt.
Click "Run StaSI" button to load and analyze your data.
You can control the analysis visualization window by specify the "left position" and the "range" of the data shown in the window.
You can see the results of other number of states.
Click "Save" button to save your analysis.

Prepare your data in matlab format (.mat). Your data should be a structure with a raw_data element, which is a one dimensional vector recording the FRET efficiency data. Please see the "test_binned_data.mat" and "test_raw_data.mat" as examples.

-------------------------------------------------------------------------------------------
functions:

StaSI.m (main function with GUI)
	Run_StaSI.m (loading data)
	w1_noise.m (calculating the global noise level)
	change_point_detection.m (step transition detection)
	clustering_GCP.m (grouping segments into states)
	MDL_piecewise.m (calculating MDL)

Others:
test_binned_data.mat and test_raw_data.mat are data used in figure 2 for program testing.

-------------------------------------------------------------------------------------------