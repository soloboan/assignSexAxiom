
deterSexintensitybased <- function(Axiomfile,intensitythresh=NA,outname){
  options(warn=-1)
  if(!file.exists(paste(Axiomfile))){cat('\n ... file not in folder ...\n')}
  cat('\n... Preliminary data import ....\n')
  IDs <- read.table(paste(Axiomfile),skip=1,nrow=1,header=F)
  ncoldat <- ncol(IDs)
  colClasses <- c('character',rep("NULL",ncoldat-1))
  datchrY <- read.table(paste(Axiomfile),header=F,colClasses=colClasses,fill=T,comment.char ='\\')
  datchrY <- grep(x = tolower(datchrY[,1]),pattern = 'chry')
  datchrYskip <- head(datchrY,1)
  colClasses <- c('character',rep("numeric",ncoldat-1))
  cat('... Final data import ....\n')
  datchrY <- read.table(paste(Axiomfile),skip=datchrYskip-1,colClasses=colClasses,header=F)
  colnames(datchrY) <- gsub(x=as.vector(t(IDs[1,1:ncoldat])),pattern='.CEL',replacement='')
  cat('... computing means of chr-Y based intensity scores ....\n')
  datchrYmeans <- as.numeric(colMeans(datchrY[,-1]))
  datchrYmeans <- cbind.data.frame(IID=colnames(datchrY[,-1]),chrYintensity=datchrYmeans)
  datchrYdist <- density(datchrYmeans$chrYintensity)
  find_modes<- function(x,modes=NULL){
    for ( i in 2:(length(x)-1) ){
      if ((x[i]>x[i-1]) & (x[i]>x[i+1])){modes <- c(modes,i)}}
    if ( length(modes) == 0 ){modes = 'This is a monotonic distribution'}
    return(modes)
  }
  cat('... Determine the modes of the distribution (cut-off point for males and females) ....\n')
  modevals <- find_modes(datchrYdist$y)
  if(is.na(intensitythresh)==T){
    SexF <- round(min(datchrYmeans[modevals,'chrYintensity'])+1*min(datchrYmeans[modevals,'chrYintensity']),0)
  } else{SexF <- intensitythresh}
  cat('... Sex of samples assigned ....\n\n')
  datchrYmeans$intensitybasedSex <- ifelse(datchrYmeans$chrYintensity>=SexF,'M','F')
  
  cat('Number of Males =',length(which(datchrYmeans$intensitybasedSex=='M')),
      ' --',round(length(which(datchrYmeans$intensitybasedSex=='M'))/nrow(datchrYmeans),3)*100,
      '% of total number of samples \n')
  cat('Number of Females =',length(which(datchrYmeans$intensitybasedSex=='F')),
      ' --',round(length(which(datchrYmeans$intensitybasedSex=='F'))/nrow(datchrYmeans),3)*100,
      '% of total number of samples \n')
  
  ######## ploting some statistics
  cat('... plots of the intensity scores ....\n')
  outfile=paste(outname,'.tiff',sep="")
  dpi=300;width.cm<-20;height.cm<-12;width.in<-width.cm/2.54;height.in<-height.cm/2.54
  tiff(file=outfile,width=width.in*dpi,height=height.in*dpi,units="px",
       res=dpi,compress="lzw",pointsize=8)
  layout(matrix(1:2,1,2,byrow =T),widths = c(1.2,1))
  plot(y=datchrYmeans$chrYintensity,x=rownames(datchrYmeans),pch=20,col='grey',
       xlab='Samples',ylab='average Chr-Y based intensity',main='Chr-Y based intensity',
       cex.main=0.8)
  SexMales <- datchrYmeans[which(datchrYmeans$chrYintensity>=SexF),]
  SexFemales <- datchrYmeans[which(datchrYmeans$chrYintensity<SexF),]
  points(SexMales$chrYintensity,x=rownames(SexMales),pch=20,col='blue')
  points(SexFemales$chrYintensity,x=rownames(SexFemales),pch=20,col='cyan')
  abline(h=SexF,lwd=2,lty=2,col='red')
  plot(datchrYdist,xlab='Average Chr-Y based intensity',
       main='Distribution of Chr-Y Probeset based intensity',cex.main=0.8)
  
  dev.off()
  
  write.table(datchrYmeans,paste(outname,'.txt',sep=''),quote = F,row.names = F,col.names = F)
  cat('... Sex assignment information written to ',paste(outname,'.txt',sep=''),'....\n')
  return(datchrYmeans)
}