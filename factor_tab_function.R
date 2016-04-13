factor_tab<-function(tg_df,factor_name){  #input the name of a top_genes dataframe and the desired column name
  
  al<-table(tg_df[,which(colnames(tg_df)==factor_name)],useNA="always")
  
  #gather expression direction data
  updwn<-as.data.frame(table(tg_df[,which(colnames(tg_df)==factor_name)],tg_df[,2]>0,useNA="always"))
  up<-updwn[which(updwn$Var2==TRUE),]
  dwn<-updwn[which(updwn$Var2==FALSE),]
  
  gf1<-table(gdf[,which(colnames(gdf)==factor_name)],useNA="always")
  
  
  al2<-cbind.data.frame(al,as.numeric(gf1[match(names(al),names(gf1))]))
  #al2<-al2[,-3]
  levels(al2[,1])<-c(levels(al2[,1]),"no assignment")
  al2[which(is.na(al2[,1])),3]<-NA
  al2[which(is.na(al2[,1])),1]<-"no assignment"
  colnames(al2)<-c(factor_name,"DEGs","all_in_cat")
  
  al3<-mutate(al2, perc = signif(DEGs/all_in_cat,digits = 3))
  
  al4<-cbind.data.frame(al3,up[match(up$Var1,al3[,1]),3],dwn[match(dwn$Var1,al3[,1]),3])
  colnames(al4)[5:6]<-c("Up","Dwn")
  al5<-arrange(al4,desc(perc))
  al6<-al5[which(al5$DEGs>0),]
  return(al6)
}