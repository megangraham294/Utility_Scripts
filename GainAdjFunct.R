#-----Add adjustment value to offset gain 
#11-13-25


#gainAdj = function(x,output) {
 # x + 6.3
  #RMSEnergy = x[1]
  r#eturn(RMSEnergy + 1)
#}

# Source - https://stackoverflow.com/a
# Posted by Gaurav Bansal, modified by community. See post 'Timeline' for change history
# Retrieved 2025-11-13, License - CC BY-SA 3.0

#Ac <- data.frame(b1$Ac)
#b1$q <- apply(Ac, 1, function(x) prod((R-x-Sfi)/(R-Sfi)))


gainAdj = function(x,output) {
 mydata$rmsEnergy <- mydata$rmsEnergy + 6.3
}