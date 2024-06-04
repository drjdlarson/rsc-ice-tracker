# WARNING: THIS CODE IS EXPERIMENTAL AND IN NO WAY REFLECTS THE POTENTIAL IMPLEMENTATION

This repo implements the JGLMB implementation by Vo-Vo to internal ice layer tracking application. 

## The directories and subdirectories are as follows: 
| Directory | Description | 
| ----- | --- |
| layer-detector |			Used for collecting measured data and formatting into a cell for use with the tracker. |
| layer-tracker |			Houses all subfolders used in tracking. |
| layer-tracker/_common |		Contains files used in different JGLMB implementations. If the tracker is ran the command line, this folder must be added to the path. |
| layer-tracker/ekf |			Contains the files that are used for tuning and implementing the JGLMB. |

## The script used for tuning: 
| Script | Description | 
| ----- | --- |
| gen_model.m	|			This script generates varying parameters that affect the performance of the filter. It also dictates the dynamics model. |

## The following dynamics models are what were attempted:
**Note: Since all dynamic models attempted are linear, the model returned by gen_model.m is used to specify the F, G, and H matrices and further passed into all prediction, observation, and correction functions.** 
| Model | Description | 
| ----- | --- |
| "Jerk" | 				A random variable on the jerk of the target. Tracks position, velocity, and acceleration. |
| "MarkovAcceleration" |		A damped oscillation model that tracks position, velocity, acceleration, and jerk. Uses an oscillatory acceleration autocorrelation function. |
| "WienerAcceleration" |		A zero-mean white noise jerk model that tracks position, velocity, and acceleration. |
| "WhiteAcceleration" | 		A zero-mean white noise acceleration model that tracks position and velocity only. |
| "SingerAcceleration" |		An exponential autocorrelation acceleration model with an exponential decay parameter to tune. Tracks position, velocity, and acceleration. |
| "SingerJerk"	| 			Takes the Singer model for acceleration but the jerk has the random variable. Tracks position, velocity, and acceleration. |

## The scripts for running the filter: 
| Script | Description | 
| ----- | --- |
| run_filter.m | 			Implements the JGLMB filter on the data set that is provided. |
| detection_and_tracking.m |		If the data is already in a cell structure, then it simply passes to the run_filter.m script. However, if it's not in the cell format then it 									formats the data correctly and then passes it to the run_filter.m script. |
| main.m |				Operates everything in a parallelized manner so that the user can define numerous dynamical models after tuning to attempt. It also saves all 									tracks and the models in a .mat file with the file name in the format struct-MM-dd-yy-HH-mm. |

# The scripts for plotting everything: 
| Script | Description | 
| ----- | --- |
| plot_result_recursive.m |		Not used if there's any parallel computing involved, but it shows the tracks in real time and creates a .gif file from it. |
| plot_results.m |			Plots all tracks on top of the data. Puts everything in a subplot if parallel computing was involved. |
| plot_results_together.m |		Plots all tracks of all models from parallel computing on top of the data. |
| compare_results.m |			Replots structures saved from main.m. |
