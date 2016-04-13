top_genes<-function(res_dat,num){  #num is the number of genes you want included in list
  
  #order res_dat based on padj and remove padj>0.05
  res_ord<-res_dat[order(res_dat$padj),]
  res_top<-res_ord[which(res_ord$padj<0.05),]
  
  #match gene name to gdf info, add functional annotation (from SubtiWiki)
  gdf_index<-sapply(rownames(res_top),function(x){match(x,gdf$Locus)})
  
  res_anot<-cbind(res_top,gdf[gdf_index,c(13,8,26,15:20)])
  
  #Rockhopper identifies many predicted RNAs not listed in gdf, so come up as "NA"
  # Replace "NA" in all FuncName columns in res_anot with 'pred_RNA'
  prna<-grep("pred_RNA_",rownames(res_anot))
  
  for(i in 10:13){
    colnm<-colnames(res_anot)[i]
    FN<-as.character(res_anot[,i])
    FN[prna]<-"pred_RNA"
    res_anot[,i]<-as.factor(FN)
    colnames(res_anot)[i]<-colnm
  }
  
  if(length(prna)>0){
    #look up gene pred_RNA is within or nearest to
    x<-rownames(res_anot)[prna]  #list of row names
    
    descript<-NULL
    
    for(i in 1:length(prna)){
      xi<-strsplit(x,split=NULL)[[i]]
      
      #extract nucleotide position of RNA
      bp<-grep("b",xi) #find position of "b" in string
      pos1<-as.integer(substr(x[i],10,bp-1))  #extract nucleotide position of RNA
      
      
      #strand RNA belongs to
      sign1<-ifelse(xi[length(xi)]=="r","-","+")  #strand RNA is on
      
      
      #lookup closest gene to pred_RNA
      gene<-which(gdf$Stop>pos1)[1]
      position<-ifelse(gdf[gene,3]<pos1,paste0("within_",gdf[gene,7]),"intergenic")
      if(position=="intergenic"){
        d_gene<-gdf$Start[gene]-pos1
        d_gene_up<-pos1-gdf$Stop[gene-1]
        position<-ifelse(d_gene<d_gene_up,paste0("upstrm_",gdf[gene,7]),paste0("downstrm_",gdf[(gene-1),7]))
      }
      
      #same strand?
      if(substr(position,1,3)=="wit"|substr(position,1,2)=="up"){
        s_std<-ifelse(gdf[gene,5]==sign1,"same_strand","opp_strand")
        in_set<-ifelse(is.na(match(gdf[gene,8],res_anot[,8])),"",paste0("difexp ",gdf[gene,8]))
      }else if(substr(position,1,3)=="dow"){
        s_std<-ifelse(gdf[(gene-1),5]==sign1,"same_strnd","opp_strnd")
        in_set<-ifelse(is.na(match(gdf[gene-1,8],res_anot[,8])),"",paste0("difexp ",gdf[gene-1,8]))
      }
      
      descrpt1<-paste0(position,": ",s_std," ",in_set)
      descript<-c(descript,descrpt1)
      #May want to optimize this more at some point - ie, more logic functions to assign intergenic RNAs based on which gene it is downstream of, etc etc
      
    }#end of pred_RNA description generator
    
    #replace "Protein.name" entries in res_anot with pred_RNA descriptions
    nm<-colnames(res_anot)[7]
    PN<-as.character(res_anot$Protein.name)
    PN[prna]<-descript
    res_anot[,7]<-PN
    colnames(res_anot)[7]<-nm
  }
  
  #only return up to 'num' lines of genes if many are significant
  if(nrow(res_anot)<11){ return(res_anot)
  }else{print(paste0(nrow(res_anot)," genes found with padj<0.05"))
    return(res_anot[1:num,])}
  
}