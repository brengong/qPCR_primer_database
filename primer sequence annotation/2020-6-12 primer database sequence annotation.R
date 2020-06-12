

#############################################################################################################
#### Thus script annotates a compiled data base of primer sequences that can be used in qPCR experiments ####
#### The primer sequences can be found here: https://biodb.swu.edu.cn/qprimerdb/ ############################
#############################################################################################################
library("biomaRt")
library(data.table)
homedir <- "C:/Users/breng/Desktop/primer sequence annotation"
setwd(homedir)

#######################
#### Human primers ####
#######################
human <- fread("Homo_sapiens.best.qPDB.download.txt")
colnames(human)[2] <- "ensembl_transcript_id"
human$ensembl_transcript_id <- gsub("\\..*", "", human$ensembl_transcript_id)
Values <- human$ensembl_transcript_id
listMarts() # To choose BioMart database
myMart <- useMart("ENSEMBL_MART_ENSEMBL");
# listDatasets(myMart)
myMart <- useMart("ENSEMBL_MART_ENSEMBL", dataset="hsapiens_gene_ensembl")
listAttributes(myMart)[1:200,] # Choose data types you want to download
# myMart <- useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl", mirror = "useast") # use if biomart sever is down.
go <- getBM(attributes=c("wikigene_name", "wikigene_description", "ensembl_transcript_id", "ensembl_gene_id"), mart=myMart, values = Values, filters = 'ensembl_transcript_id')#'ensembl_gene_id'
write.table(go, file="BioMart annotations human.xls", sep="\t", quote=FALSE, row.names=FALSE)

go <- fread("BioMart annotations human.xls")
mer <- merge(go, human, by = "ensembl_transcript_id")
write.table(mer, file="human annotated primers.xls", sep="\t", quote=FALSE, row.names=FALSE)


#######################
#### mouse primers ####
#######################
mouse <- fread("Mus_musculus.best.qPDB.download.txt")
colnames(mouse)[2] <- "ensembl_transcript_id"
mouse$ensembl_transcript_id <- gsub("\\..*", "", mouse$ensembl_transcript_id)
Values <- mouse$ensembl_transcript_id
listMarts() # To choose BioMart database
myMart <- useMart("ENSEMBL_MART_ENSEMBL");
# listDatasets(myMart)
myMart <- useMart("ENSEMBL_MART_ENSEMBL", dataset="mmusculus_gene_ensembl")
# listAttributes(myMart)[1:200,] # Choose data types you want to download
go <- getBM(attributes=c("wikigene_name", "wikigene_description", "ensembl_transcript_id", "ensembl_gene_id"), mart=myMart, values = Values, filters = 'ensembl_transcript_id')#'ensembl_gene_id'
write.table(go, file="BioMart annotations mouse.xls", sep="\t", quote=FALSE, row.names=FALSE)

go <- fread("BioMart annotations mouse.xls")
mer <- merge(go, mouse, by = "ensembl_transcript_id")
write.table(mer, file="mouse annotated primers.xls", sep="\t", quote=FALSE, row.names=FALSE)
