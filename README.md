## Assign sex to genotyped samples - ** Atlantic salmon **
This script import an Axiom (Affymetrix) intensity data for 87 sex probes and assigns sex to the genotyped samples for Atlantic salmon

### input data
       - The Probe intensity information from the Axiom analysis suite 

### Arguments for runing the R-function
       - inpgenofile            :: The names of the input Axiom analysis intensity score file  
       - intensitythresh        :: The intensity threshold you want to use. THIS IS OPTIONAL
       - outname                :: The prefix of the output file name
       
### How to run the script
       ################################################################################################################
       ##### source the R-function
         source('deterSexintensitybased.R')
       
       ##### run the script to generate the results
         Sexassigned <- deterSexintensitybased(Axiomfile='AxiomGT.summary.txt',outname='example')
       
       ##### if you want to use your own threshold then run the script as follows
         Sexassigned2 <- deterSexintensitybased(Axiomfile='AxiomGT.summary.txt',intensitythresh=600,outname='example2')
       ##################################################################################################################
       
### The output files  
        - Assigned sex of each sample (ID, intensity score, Sex[M,F])
        - Plot of the intensity scores (distrbition and the average score per sample) - outname.tiff 
            Note that: the plot can be used to determine the intensity threshold to use
            
##### The script was written in collaboration and discussions with 
         - Matthew Baranski (matt.baranski@marineharvest.com)
